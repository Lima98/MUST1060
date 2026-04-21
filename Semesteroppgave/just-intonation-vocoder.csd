<CsoundSynthesizer>
  <CsOptions>
    ; -m0 removes runtime messages to keep the console clean for table printing.
    ; -iadc enables the microphone input used by the vocoder mode.
    -odac -iadc -d -m0 -+rtmidi=portmidi -M0
  </CsOptions>

  <CsInstruments>
    sr        = 48000
    ksmps     = 32
    nchnls    = 2
    nchnls_i  = 1
    0dbfs     = 1

    ; Common 5-limit just intonation adjustments relative to 12-TET, in cents.
    ; Index 0-11 = unison, m2, M2, m3, M3, P4, tritone, P5, m6, M6, m7, M7
    giAdjustments[] fillarray 0, 12, 4, 16, -14, -2, -10, 2, 14, -16, -31, -12

    ; 0 = direct sine wave, 1 = mic-driven vocoder / talkbox-style output
    gkSoundMode     init 1
    gkVocoderDepth  init 1
    gkMicGain       init 3.5

    ; Global state tracking for held notes and tuning calculations
    gkHeldNotes[]   init 128
    gkFundamental   init -1
    gkActiveVoice[] init 128
    gkIntervals[]   init 128
    gkCents[]       init 128
    gkFactors[]     init 128
    gkFrequencies[] init 128
    gkPrintedHeld[] init 128
    gkPrintedRoot   init -2
    gaCarrierBus    init 0

    giFftSize  = 1024
    giOverlap  = giFftSize / 4
    giWinSize  = giFftSize
    giWinShape = 1

    giSine ftgen 0, 0, 16384, 10, 1

    massign 0, 2

    opcode FindLowestHeldNote, k, 0
      kIndex = 0
      kRoot  = -1
      while kIndex < lenarray(gkHeldNotes) do
        if gkHeldNotes[kIndex] > 0 then
          kRoot = kIndex
          kgoto done
        endif
        kIndex += 1
      od
      done:
        xout kRoot
    endop

    opcode PrintHeldNotesTable, 0, 0
      kIndex = 0
      Smsg sprintfk "%s", "\n+------+------+-------+-----+-------+---------+-----------+\n"
      Sline sprintfk "%s",  "| Root | Note | Count | Int | Cents | Factor  | Frequency |\n"
      Smsg strcatk Smsg, Sline
      Sline sprintfk "%s", "+------+------+-------+-----+-------+---------+-----------+\n"
      Smsg strcatk Smsg, Sline

      while kIndex < lenarray(gkHeldNotes) do
        if gkHeldNotes[kIndex] > 0 then
          Sroot sprintfk "%s", " "
          if kIndex == gkFundamental then
            Sroot sprintfk "%s", "*"
          endif

          Sline sprintfk "|  %s   | %3d  |   %2d  | %2d  | %+5.1f | %7.4f | %9.2f |\n", \
            Sroot, \
            kIndex, \
            gkHeldNotes[kIndex], \
            gkIntervals[kIndex], \
            gkCents[kIndex], \
            gkFactors[kIndex], \
            gkFrequencies[kIndex]
          Smsg strcatk Smsg, Sline
        endif
        kIndex += 1
      od

      Sline sprintfk "%s", "+------+------+-------+-----+-------+---------+-----------+\n"
      Smsg strcatk Smsg, Sline
      printf "%s", 1, Smsg
    endop

    instr 10
      if gkSoundMode == 1 then
        aMic      inch 1
        aMic      = aMic * gkMicGain
        aMic      buthp aMic, 90
        aMic      tone aMic, 7000

        aCarrier  = gaCarrierBus
        aCarrier  buthp aCarrier, 80

        fMic      pvsanal aMic, giFftSize, giOverlap, giWinSize, giWinShape
        fCarrier  pvsanal aCarrier, giFftSize, giOverlap, giWinSize, giWinShape
        fVocode   pvsfilter fCarrier, fMic, gkVocoderDepth, 1
        aVocode   pvsynth fVocode
        aVocode   balance aVocode, aCarrier + 0.0001
        outs aVocode * 0.8, aVocode * 0.8
      endif

      clear gaCarrierBus
    endin

    instr 1
      ; Re-evaluate the current root continuously so every key press/release
      ; can immediately retune the active voices.
      gkFundamental = FindLowestHeldNote()

      kIndex = 0
      kChanged = (gkFundamental != gkPrintedRoot ? 1 : 0)
      while kIndex < lenarray(gkHeldNotes) do
        if gkHeldNotes[kIndex] != gkPrintedHeld[kIndex] then
          kChanged = 1
        endif
        kIndex += 1
      od

      if kChanged == 1 then
        gkPrintedRoot = gkFundamental
        kIndex = 0
        while kIndex < lenarray(gkHeldNotes) do
          gkPrintedHeld[kIndex] = gkHeldNotes[kIndex]
          kIndex += 1
        od
      endif
    endin

    instr 2
      iNote      notnum
      iVelocity  veloc 0, 1
      iPitchClass = iNote % 12

      kRootPitchClass  init 0
      kInterval        init 0
      kAdjustment      init 1
      kFreq            init 0
      kStarted         init 0
      kReleased        init 0
      kAmp             = max(iVelocity, 0.05) * 0.15

      if kStarted == 0 then
        gkHeldNotes[iNote] = gkHeldNotes[iNote] + 1
        gkActiveVoice[iNote] = 1
        kStarted = 1
        PrintHeldNotesTable 
      endif

      if gkFundamental >= 0 then
        kRootPitchClass = gkFundamental % 12
        kInterval = (12 + iPitchClass - kRootPitchClass) % 12
        kAdjustment = cent(giAdjustments[kInterval])
      else
        kAdjustment = 1
      endif

      gkIntervals[iNote] = kInterval
      gkCents[iNote] = giAdjustments[kInterval]
      gkFactors[iNote] = kAdjustment
      kFreq = cpsmidinn(iNote) * kAdjustment
      gkFrequencies[iNote] = kFreq
      aEnv  linsegr 0, 0.005, 1, 0.05, 0

      if gkSoundMode == 0 then
        aSig poscil aEnv * kAmp, kFreq, giSine
        outs aSig, aSig
      else
        ; A brighter carrier gives the microphone more harmonic material to shape.
        aCarrier1 buzz aEnv * kAmp * 0.55, kFreq, 18, giSine
        aCarrier2 buzz aEnv * kAmp * 0.30, kFreq * 2, 10, giSine
        aCarrier3 poscil aEnv * kAmp * 0.15, kFreq * 0.5, giSine
        gaCarrierBus = gaCarrierBus + aCarrier1 + aCarrier2 + aCarrier3
      endif

      if release() == 1 && kReleased == 0 then
        gkHeldNotes[iNote] = max(gkHeldNotes[iNote] - 1, 0)
        if gkHeldNotes[iNote] == 0 then
          gkActiveVoice[iNote] = 0
          gkIntervals[iNote] = 0
          gkCents[iNote] = 0
          gkFactors[iNote] = 0
          gkFrequencies[iNote] = 0
        endif
        kReleased = 1
        PrintHeldNotesTable
      endif
    endin

  </CsInstruments>

  <CsScore>
    i1 0 z
    i10 0 z
    f0 z
  </CsScore>
</CsoundSynthesizer>
