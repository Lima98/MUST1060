<CsoundSynthesizer>

<CsOptions>
-odac   -M0 -b128   -B256
</CsOptions>

<CsInstruments>
; ########## CONFIG ##########
sr      = 44100 ; sample rate
kr      = 4410 ; control rate
nchnls  = 2 ; number of channels
0dbfs   = 1 ; maximum amplitude (0dB)
; ########## CONFIG ##########

; --------------------/// TASK 1 ///--------------------
; 1a --- Waves on a beach
instr 1

    aNoise  noise   .1, .8                          ; White noise base
    kFreq   rspline 0.05,   0.15,   0.1,    0.5     ; Randomize swell
    aLFO    lfo     0.7,  kFreq                     ; LFO to use for swell feeling

    aWave   =   aNoise  *   aLFO                    ; Make final wave signal 
    gaSend  =   aWave                               ; Send to reverb   

endin
; 1b --- Wind howling
instr 2

    aNoise  noise   .2, .8                          ; White noise base

   ;kCutoff randi   100,    0.5                     ; Random filter cuttof freq. 
    kCutoff rspline -50,    600,   0.1,    1        ; A bit more natural randomness
    kCutoff =   300 +   kCutoff                     ; Use random freq.

    aWind   reson   aNoise, kCutoff, kCutoff/10     ; Bandbass to make howling

    aWind   balance aWind,  aNoise                  ; Normalize volume

    gaSend  =   aWind

endin
; --------------------/// TASK 1 ///--------------------

; ######################################################

; --------------------/// TASK 2 ///--------------------
; 2 --- Living drone
instr 3
    aDrone  vco2    0.2,    cpspch(6.05)            ; Drone with texture
    aSub    oscils  1.0,    cpspch(5.05),   0       ; Sub-drone for oumph
    aDrone  butlp   aDrone, 3000                    ; Lowpass to calm down
    aDrone += aSub                                  ; Mix together

    aEnv    madsr   0.5,    0.1,    0.6,    3       ; Envelope
    
    aDrone = aDrone * aEnv                          ; Apply Envelope

    kLP     rspline 20,     2000,    0.05,   0.1    ;
    aDrone  butlp   aDrone, kLP 

;   out aDrone, aDrone 
    gaSend = aDrone
endin
; --------------------/// TASK 2 ///--------------------

; ######################################################

; --------------------/// TASK 3 ///--------------------
; 3 --- Tonal sequences
instr 4

    iRoot   =   cpspch(8.05)
    iAmp    =   0.6

    ;name   opcode  num tim siz gen tones...
    giPenta ftgen   0,  0,  0,  -2, -12, -10, -8, -5, -3, 0, 2, 4, 7, 9, 12

    kIndex  rspline 0,  11,   0.2, 2 
    kTone   table   kIndex, giPenta  

   ;kRand   randomi iCps * 0.96,    iCps * 1.04,    4

    aOsc    vco2    iAmp,   iRoot * semitone(kTone) ; semitones to scaling factor
    
   ;aOsc    vco2    iAmp,   iRoot * semitone(kTone), 6

    kFilCtr ctrl7   1,  2, 200,  10000          ; Control lowpass freq.

    aOsc    butlp   aOsc,   kFilCtr

    gaSend  =   aOsc
    
endin

instr 5

    iRoot   =   cpspch(8.05)
    iAmp    =   0.6

    ;name   opcode  num tim siz gen tones...
    giPenta ftgen   0,  0,  0,  -2, -10, -7, -1, 2, 5, 11

    kIndex  rspline 0,  11,   0.2, 2 
    kTone   table   kIndex, giPenta  

   ;kRand   randomi iCps * 0.96,    iCps * 1.04,    4

    aOsc    vco2    iAmp,   iRoot * semitone(kTone) ; semitones to scaling factor
    
   ;aOsc    vco2    iAmp,   iRoot * semitone(kTone), 6

    kFilCtr ctrl7   1,  2, 200,  10000          ; Control lowpass freq.

    aOsc    butlp   aOsc,   kFilCtr

    gaSend  =   aOsc
    
endin

instr 6

    iRoot   =   cpspch(8.05)
    iAmp    =   0.6

    ;name   opcode  num tim siz gen tones...
    giPenta ftgen   0,  0,  0,  -2, -12, -10, -8, -7, -5, -3, -1, 0, 2, 4, 5, 7, 9, 11, 12

    kIndex  rspline 0,  11,   0.2, 2 
    kTone   table   kIndex, giPenta  

   ;kRand   randomi iCps * 0.96,    iCps * 1.04,    4

    aOsc    vco2    iAmp,   iRoot * semitone(kTone) ; semitones to scaling factor
    
   ;aOsc    vco2    iAmp,   iRoot * semitone(kTone), 6

    kFilCtr ctrl7   1,  2, 200,  10000          ; Control lowpass freq.

    aOsc    butlp   aOsc,   kFilCtr

    gaSend  =   aOsc
    
endin
; --------------------/// TASK 3 ///--------------------





; --------------------/// Global Reverb ///--------------------
instr   10

    aRevL,  aRevR   reverbsc  gaSend, gaSend, 0.8,    8000  ; Apply reverb to received signal

    kMix            ctrl7   1,  1, 0,  1                 ; Control reverb amt

    aL      =   (1 - kMix) * gaSend + kMix * aRevL          ; Mix reverb and dry signal
    aR      =   (1 - kMix) * gaSend + kMix * aRevR

    outs    aL, aR

    fout    "./Lydfiler/drone.wav",   8,  aL,   aR           ; Enable and change name to record new file

    gaSend  =   0                                           ; Reset to handle feedback

endin
; --------------------/// Global Reverb ///--------------------


</CsInstruments>

<CsScore>
   ;i1  0   60          ; Wave sound
   ;i2  0   60          ; Howling wind
    i3  0   60          ; Drone
   ;i4  0   60          ; Melody Penta
   ;i5  0   60          ; Melody Tension
   ;i6  0   60          ; Melody Scale

    i10 0   60          ; Reverb
</CsScore>

</CsoundSynthesizer>
