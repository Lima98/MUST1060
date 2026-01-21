<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
; --displays
-odac ; for real-time audio output
; -o waves.wav ; for file output, change per part
</CsOptions>

<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

gkSendReverb init 0

; 1a. Waves (filtered noise)
instr 1
  ; White noise
  aNoise rand 0.5
  ; Filter for wave sound (try bandpass or lowpass)
  kFreq linseg 200, p3/2, 400, p3/2, 200
  aFilt butbp aNoise, kFreq, 80
  outs aFilt, aFilt
  fout "./Lydfiler/waves.wav", 14, aFilt, aFilt
endin

; 1b. Wind (filtered noise)
instr 2
  aNoise rand 0.5
  kFreq rspline 500, 2000, 0.1, 0.5
  aFilt buthp aNoise, kFreq
  outs aFilt, aFilt
  fout "./Lydfiler/wind.wav", 14, aFilt, aFilt
endin

; 2. Drone
instr 3
  kFreq = cpsmidinn(36) ; C2
  kMod randomi 0.8, 1.2, 0.2
  aOsc vco2 0.3, kFreq * kMod
  aFilt moogladder aOsc, 200 + (kMod*100), 0.7
  outs aFilt, aFilt
  fout "./Lydfiler/drone.wav", 14, aFilt, aFilt
endin

; 3. Random tone sequences
; Example for one sequence, copy and modify for three
giScale ftgen 1, 0, -7, -2, 60, 62, 65, 67, 69, 72, 74

instr 4
  kIdx randomi 0, 6, 1
  kPitch table kIdx, giScale
  aEnv linseg 0, 0.01, 1, 0.2, 0
  aSig poscil aEnv*0.2, cpsmidinn(kPitch)
  outs aSig, aSig
  fout "./Lydfiler/seq1.wav", 14, aSig, aSig
endin

; Add more instruments for other sequences as needed

; Global reverb instrument (optional)
instr 10
  aIn = gkSendReverb
  aRevL, aRevR reverbsc aIn, aIn, 0.85, 12000
  outs aRevL*0.3 + aIn*0.7, aRevR*0.3 + aIn*0.7
  gkSendReverb = 0
endin

</CsInstruments>

<CsScore>
; Schedule each instrument for rendering
i1 0 30 ; waves
i2 0 30 ; wind
i3 0 60 ; drone
i4 0 30 ; random sequence 1
; Add more i-statements for other sequences

; Reverb instrument (if used)
i10 0 60
</CsScore>
</CsoundSynthesizer>
