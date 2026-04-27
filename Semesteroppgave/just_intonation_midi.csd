<CsoundSynthesizer>
  <CsOptions>
    ; Offline render setup:
    ; -F reads a standard MIDI file
    ; -o writes the rendered audio file
    ; -W selects WAV output
    ; -T stops the render when the MIDI file ends
    ; This file assumes the MIDI file itself is authored at 60 BPM.
    ; Replace "TTBB.mid" with your own MIDI filename before rendering.
    -o HeyrHimnaSaw2.wav -W -d -m0 -T -F TTBBadj.mid
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
    ; - Instrument 1: Control instrument
    ; - Instrument 2: Just intonation voice
    ; - Instrument 100: Master out


    ;********************************************************************************
    ; Header
    ;********************************************************************************
    sr        = 48000   ; Sample rate
    ksmps     = 32      ; Samples per control period
    nchnls    = 2       ; Number of output channels
    0dbfs     = 1       ; Reference amplitude


    ;********************************************************************************
    ; Global variables
    ;********************************************************************************


    ; %%%%% TUNING
    ; Cent offsets that move each chromatic interval from equal temperament
    ; into a just intonation version above the current root.
    giAdjustments[] fillarray   0,    12,   4,   16,  -14,  -2,   -10,   2,  14, -16, -31,  -12
    ; Index 0-11:             uni,    m2,  M2,   m3,   M3,  P4,    TT,  P5,  m6,  M6,  m7,   M7

    ; %%%%% SOUND SETTINGS
    ; Fixed settings for offline rendering.
    ; 0 = sine, 1 = square, 2 = saw.
    gkSoundMode   init 2
    ; This render file is locked to cent-adjusted just intonation.
    gkTemperMode  init 1

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
    gaMixL          init 0
    gaMixR          init 0


    ;********************************************************************************
    ; Tables
    ;********************************************************************************
    ; A basic sine table is used by the direct oscillator modes.
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
    ; Instrument 1: Control instrument
    ;********************************************************************************


    ; This instrument continuously checks the held-note state,
    ; updates the current root note, and prints the table when needed.
    instr 1
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
    ; Instrument 100: Master out
    ;********************************************************************************

    ; This instrument collects the note signals and writes them to file.
    instr 100
      outs gaMixL, gaMixR
      clear gaMixL, gaMixR
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
      ; That interval is then used as an index into giAdjustments.
      if gkFundamental >= 0 then
        kRootPitchClass = gkFundamental % 12
        kInterval = (12 + iPitchClass - kRootPitchClass) % 12
        kAdjustment = cent(giAdjustments[kInterval])
      else
        kAdjustment = 1
        kInterval = 0
      endif

      ; %%%%% DEBUG DATA
      ; Store the current tuning values so the debug table can display them.
      gkIntervals[iNote] = kInterval
      gkCents[iNote] = giAdjustments[kInterval]
      gkFactors[iNote] = kAdjustment
      kFreq = cpsmidinn(iNote) * kAdjustment
      gkFrequencies[iNote] = kFreq

      ; %%%%% ENVELOPE
      aEnv linsegr 0, 0.005, 1, 0.05, 0

      ; %%%%% SOUND GENERATION
      if gkSoundMode == 0 then
        ; Simple reference sound for hearing the tuning clearly.
        aSig poscil aEnv * kAmp, kFreq, giSine
        gaMixL += aSig
        gaMixR += aSig
      elseif gkSoundMode == 1 then
        ; Square wave mode built from a few odd harmonics.
        aSig1 poscil aEnv * kAmp * 1/1, kFreq * 1, giSine
        aSig2 poscil aEnv * kAmp * 1/3, kFreq * 3, giSine
        aSig3 poscil aEnv * kAmp * 1/5, kFreq * 5, giSine
        aSig4 poscil aEnv * kAmp * 1/7, kFreq * 7, giSine
        aSig = aSig1 + aSig2 + aSig3 + aSig4
        gaMixL += aSig
        gaMixR += aSig
      elseif gkSoundMode == 2 then
        ; Saw wave mode built from a short harmonic series.
        aSig1 poscil aEnv * kAmp * 1/1, kFreq * 1, giSine
        aSig2 poscil aEnv * kAmp * 1/2, kFreq * 2, giSine
        aSig3 poscil aEnv * kAmp * 1/3, kFreq * 3, giSine
        aSig4 poscil aEnv * kAmp * 1/4, kFreq * 4, giSine
        aSig5 poscil aEnv * kAmp * 1/5, kFreq * 5, giSine
        aSig6 poscil aEnv * kAmp * 1/6, kFreq * 6, giSine
        aSig = aSig1 + aSig2 + aSig3 + aSig4 + aSig5 + aSig6
        gaMixL += aSig
        gaMixR += aSig
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
    i100 0 z
    f0 z
  </CsScore>
</CsoundSynthesizer>
