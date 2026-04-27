<CsoundSynthesizer>
  <CsOptions>
    ; -m0 removes runtime messages to keep the console clean for table printing.
    ; -iadc enables microphone input for the vocoder.
    -odac -iadc -d -m0 -+rtmidi=portmidi -M0
  </CsOptions>

  <CsInstruments>
    ;********************************************************************************
    ; CsInstruments - Contents
    ;********************************************************************************

    ; - Contents
    ; - Header
    ; - Global variables
    ; - Tables
    ; - MIDI routing
    ; - Opcode: FindOldestHeldNote
    ; - Opcode: PrintHeldNotesTable
    ; - Instrument 10: Vocoder output
    ; - Instrument 1: Control instrument
    ; - Instrument 2: Just intonation voice


    ;********************************************************************************
    ; Header
    ;********************************************************************************
    sr        = 48000    ; Sample rate
    ksmps     = 32       ; Samples per control period
    nchnls    = 2        ; Number of output channels
    nchnls_i  = 1        ; Number of input channels
    0dbfs     = 1        ; Reference amplitude
    giMidiChnlSound  = 1 ; MIDI channel for controlling sound mode
    giMidiChnlTemper = 2 ; MIDI channel for controlling temperament mode


    ;********************************************************************************
    ; Global variables
    ;********************************************************************************


    ; %%%%% TUNING
    ; Cent offsets that move each chromatic interval from equal temperament
    ; into a just intonation version above the current root.
    giAdjustments[] fillarray   0,    12,   4,   16,  -14,  -2,   -10,   2,  14, -16, -31,  -12
    giRatios[]      fillarray 1/1, 16/15, 9/8,  6/5,  5/4, 4/3, 45/32, 3/2, 8/5, 5/3, 7/4, 15/8
    ; Index 0-11:             uni,    m2,  M2,   m3,   M3,  P4,    TT,  P5,  m6,  M6,  m7,   M7

    ; %%%%% SOUND SETTINGS
    ; MIDI CC 1 selects the sound engine:
    ; 0 = sine, 1 = square, 2 = saw, 3 = vocoder.
    gkSoundMode   init 0
    ; Temperament mode:
    ; 0 = equal temperament, 1 = cent-adjusted just intonation, 2 = ratio tuning.
    gkTemperMode  init 1
    gkVocoderDepth init 1
    gkMicGain      init 3.5

    ; %%%%% NOTE STATE
    ; These globals store which MIDI notes are currently held, which note is
    ; the active root, and the tuning data attached to each note number.
    gkHeldNotes[]   init 128
    gkFundamental   init -1
    gkPressCounter  init 0
    gkPressOrder[]  init 128
    gkActiveVoice[] init 128
    gkIntervals[]   init 128
    gkCents[]       init 128
    gkFactors[]     init 128
    gkFrequencies[] init 128
    gkPrintedHeld[] init 128
    gkPrintedRoot   init -2
    gkLastWaveKnob  init -1
    gkLastTemperKnob init -1
    gaCarrierBus    init 0


    ;********************************************************************************
    ; Tables
    ;********************************************************************************


    ; FFT settings for the vocoder. Larger sizes improve frequency resolution,
    ; but they also increase latency and make fast changes respond more slowly.
    giFftSize  = 1024
    giOverlap  = giFftSize / 4
    giWinSize  = giFftSize
    giWinShape = 1

    ; A basic sine table is still useful for the sine mode
    ; and parts of the vocoder carrier.
    giSine ftgen 0, 0, 16384, 10, 1


    ;********************************************************************************
    ; MIDI routing
    ;********************************************************************************


    ; Send all incoming MIDI note events to instrument 2.
    massign 0, 2


    ;********************************************************************************
    ; Opcode: FindOldestHeldNote
    ;********************************************************************************


    ; This opcode finds the oldest note that is still held.
    ; That note becomes the current root, so inversions work as long as
    ; the intended root is pressed first.
    opcode FindOldestHeldNote, k, 0

      ; %%%%% VARIABLES
      kIndex     = 0
      kRoot      = -1
      kBestOrder = 0

      ; %%%%% SEARCH
      while kIndex < lenarray(gkHeldNotes) do
        if gkHeldNotes[kIndex] > 0 && gkPressOrder[kIndex] > 0 then
          if kRoot == -1 || gkPressOrder[kIndex] < kBestOrder then
            kRoot = kIndex
            kBestOrder = gkPressOrder[kIndex]
          endif
        endif
        kIndex += 1
      od

      xout kRoot
    endop

    ;********************************************************************************
    ; Opcode: PrintHeldNotesTable
    ;********************************************************************************


    ; This opcode prints the current note state as a table so it is easier
    ; to see which note is acting as root and how the others are being tuned.
    opcode PrintHeldNotesTable, 0, 0
      ; %%%%% VARIABLES
      kIndex = 0

      ; %%%%% CONSOLE CLEARING
      ; Print many blank lines first so the newest table visually replaces the old one.
      printks "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", 1

      ; %%%%% TABLE BUILDING
      Smsg sprintfk "%s", "\n+------+------+-------+-----+-------+---------+-----------+\n"
      Sline sprintfk "%s", "| Root | Note | Count | Int | Cents | Factor  | Frequency |\n"
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

      ; %%%%% PRINT
      printf "%s", 1, Smsg
    endop


    ;********************************************************************************
    ; Instrument 10: Vocoder output
    ;********************************************************************************


    ; This instrument handles the vocoder output.
    ; The keyboard notes build a bright carrier in gaCarrierBus,
    ; and the microphone shapes that carrier spectrally.
    instr 10
      ; %%%%% VOCODER MODE
      if gkSoundMode == 3 then

        ; %%%%% MICROPHONE INPUT
        ; Read the microphone and clean it up so low rumble and sharp
        ; top-end energy do not dominate the vocoder response.
        aMic      inch 1
        aMic      = aMic * gkMicGain
        aMic      buthp aMic, 90
        aMic      tone aMic, 7000

        ; %%%%% CARRIER INPUT
        ; This is the summed carrier built by all active keyboard notes.
        aCarrier  = gaCarrierBus
        aCarrier  buthp aCarrier, 80

        ; %%%%% SPECTRAL PROCESSING
        ; Analyse both signals, let the microphone shape the carrier,
        ; then transform the result back into audio.
        fMic      pvsanal aMic, giFftSize, giOverlap, giWinSize, giWinShape
        fCarrier  pvsanal aCarrier, giFftSize, giOverlap, giWinSize, giWinShape
        fVocode   pvsfilter fCarrier, fMic, gkVocoderDepth, 1
        aVocode   pvsynth fVocode

        ; %%%%% OUTPUT
        ; balance keeps the output level closer to the useful range
        ; of the original carrier signal.
        aVocode   balance aVocode, aCarrier + 0.0001
        outs aVocode * 0.8, aVocode * 0.8
      endif

      ; %%%%% BUS RESET
      ; Clear the carrier bus every control pass so active notes rebuild it
      ; fresh instead of letting old signal accumulate endlessly.
      clear gaCarrierBus
    endin


    ;********************************************************************************
    ; Instrument 1: Control instrument
    ;********************************************************************************


    ; This instrument continuously checks the held-note state,
    ; updates the current root note, and prints the table when needed.
    instr 1
      ; %%%%% MIDI KNOBS
      ; CC giMidiChnlSound selects the sound engine.
      ; CC giMidiChnlTemper toggles temperament by rotation direction.
      kWaveKnobRaw ctrl7 1, giMidiChnlSound, 0, 127
      kTemperKnobRaw ctrl7 1, giMidiChnlTemper, 0, 127

      ; %%%%% SOUND MODE SELECTION
      kWaveKnob = int(kWaveKnobRaw + 0.5)
      if kWaveKnob != gkLastWaveKnob then
        gkSoundMode = int((kWaveKnob * 4) / 128)
        if gkSoundMode > 3 then
          gkSoundMode = 3
        endif
        gkLastWaveKnob = kWaveKnob
      endif

      ; %%%%% TEMPERAMENT SELECTION
      ; Turning CC 2 upward steps through:
      ; equal temperament -> just intonation -> ratios.
      ; Turning it downward steps back through the same list.
      kTemperKnob = int(kTemperKnobRaw + 0.5)
      if gkLastTemperKnob < 0 then
        gkLastTemperKnob = kTemperKnob
      elseif kTemperKnob > gkLastTemperKnob then
        gkTemperMode = min(gkTemperMode + 1, 2)
        gkLastTemperKnob = kTemperKnob
      elseif kTemperKnob < gkLastTemperKnob then
        gkTemperMode = max(gkTemperMode - 1, 0)
        gkLastTemperKnob = kTemperKnob
      endif

      ; %%%%% ROOT DETECTION
      gkFundamental = FindOldestHeldNote()

      ; %%%%% CHANGE DETECTION
      ; Compare the current state to the last printed state.
      ; If anything changed, the table should be printed again.
      kIndex = 0
      kChanged = (gkFundamental != gkPrintedRoot ? 1 : 0)
      while kIndex < lenarray(gkHeldNotes) do
        if gkHeldNotes[kIndex] != gkPrintedHeld[kIndex] then
          kChanged = 1
        endif
        kIndex += 1
      od

      ; %%%%% STATE SNAPSHOT
      ; Save the current state after a change so we only reprint
      ; when something new actually happens.
      if kChanged == 1 then
        PrintHeldNotesTable
        gkPrintedRoot = gkFundamental
        kIndex = 0
        while kIndex < lenarray(gkHeldNotes) do
          gkPrintedHeld[kIndex] = gkHeldNotes[kIndex]
          kIndex += 1
        od
      endif
    endin


    ;********************************************************************************
    ; Instrument 2: Just intonation voice
    ;********************************************************************************


    ; This instrument responds to MIDI note input, finds the interval
    ; above the current root, applies the just intonation adjustment,
    ; and then sends the tuned note either to a sine tone or a vocoder carrier.
    instr 2
      ; %%%%% NOTE INPUT
      iNote       notnum
      iVelocity   veloc 0, 1
      iPitchClass = iNote % 12

      ; %%%%% VARIABLES
      ; These are per-voice values for the currently sounding note.
      kRootPitchClass  init 0
      kInterval        init 0
      kAdjustment      init 1
      kFreq            init 0
      kStarted         init 0
      kReleased        init 0
      kAmp             = max(iVelocity, 0.05) * 0.15

      ; %%%%% NOTE REGISTRATION
      ; Run this once when the note starts.
      ; If the note was not already held, assign it a press order
      ; so the system can identify which active note is oldest.
      if kStarted == 0 then
        if gkHeldNotes[iNote] == 0 then
          gkPressCounter = gkPressCounter + 1
          gkPressOrder[iNote] = gkPressCounter
        endif
        gkHeldNotes[iNote] = gkHeldNotes[iNote] + 1
        gkActiveVoice[iNote] = 1
        kStarted = 1
        PrintHeldNotesTable
      endif

      ; %%%%% TUNING
      ; Work out the interval relative to the current root note.
      ; That interval is then used as an index into giAdjustments or giRatios.
      if gkFundamental >= 0 then
        kRootPitchClass = gkFundamental % 12
        kInterval = (12 + iPitchClass - kRootPitchClass) % 12
        if gkTemperMode == 1 then
          kAdjustment = cent(giAdjustments[kInterval])
        elseif gkTemperMode == 2 then
          kAdjustment = giRatios[kInterval] / semitone(kInterval)
        else
          kAdjustment = 1
        endif
      else
        kAdjustment = 1
        kInterval = 0
      endif

      ; %%%%% DEBUG DATA
      ; Store the current tuning values so the debug table can display them.
      gkIntervals[iNote] = kInterval
      if gkTemperMode == 1 then
        gkCents[iNote] = giAdjustments[kInterval]
      elseif gkTemperMode == 2 then
        gkCents[iNote] = (1200 * log(giRatios[kInterval]) / log(2)) - (kInterval * 100)
      else
        gkCents[iNote] = 0
      endif
      gkFactors[iNote] = kAdjustment
      kFreq = cpsmidinn(iNote) * kAdjustment
      gkFrequencies[iNote] = kFreq

      ; %%%%% ENVELOPE
      aEnv linsegr 0, 0.005, 1, 0.05, 0

      ; %%%%% SOUND GENERATION
      if gkSoundMode == 0 then
        ; Simple reference sound for hearing the tuning clearly.
        aSig poscil aEnv * kAmp, kFreq, giSine
        outs aSig, aSig
      elseif gkSoundMode == 1 then
        ; Square wave mode built from a few odd harmonics.
        aSig1 poscil aEnv * kAmp * 1/1, kFreq * 1, giSine
        aSig2 poscil aEnv * kAmp * 1/3, kFreq * 3, giSine
        aSig3 poscil aEnv * kAmp * 1/5, kFreq * 5, giSine
        aSig4 poscil aEnv * kAmp * 1/7, kFreq * 7, giSine
        aSig = aSig1 + aSig2 + aSig3 + aSig4
        outs aSig, aSig
      elseif gkSoundMode == 2 then
        ; Saw wave mode built from a short harmonic series.
        aSig1 poscil aEnv * kAmp * 1/1, kFreq * 1, giSine
        aSig2 poscil aEnv * kAmp * 1/2, kFreq * 2, giSine
        aSig3 poscil aEnv * kAmp * 1/3, kFreq * 3, giSine
        aSig4 poscil aEnv * kAmp * 1/4, kFreq * 4, giSine
        aSig5 poscil aEnv * kAmp * 1/5, kFreq * 5, giSine
        aSig6 poscil aEnv * kAmp * 1/6, kFreq * 6, giSine
        aSig = aSig1 + aSig2 + aSig3 + aSig4 + aSig5 + aSig6
        outs aSig, aSig
      else
        ; A brighter carrier gives the microphone more harmonic material
        ; to shape, which makes the vocoder more intelligible.
        aCarrier1 buzz aEnv * kAmp * 0.55, kFreq, 18, giSine
        aCarrier2 buzz aEnv * kAmp * 0.30, kFreq * 2, 10, giSine
        aCarrier3 poscil aEnv * kAmp * 0.15, kFreq * 0.5, giSine
        gaCarrierBus = gaCarrierBus + aCarrier1 + aCarrier2 + aCarrier3
      endif

      ; %%%%% NOTE RELEASE
      ; When the note is released, remove it from the held-note state.
      ; If that note was the root, the next oldest held note will become root.
      if release() == 1 && kReleased == 0 then
        gkHeldNotes[iNote] = max(gkHeldNotes[iNote] - 1, 0)
        if gkHeldNotes[iNote] == 0 then
          gkPressOrder[iNote] = 0
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
