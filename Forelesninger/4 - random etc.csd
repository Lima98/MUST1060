<CsoundSynthesizer>

<CsOptions>
-odac   ;-M0 -b128   -B256
</CsOptions>

<CsInstruments>
; ########## CONFIG ##########
sr      = 44100 ; sample rate
kr      = 4410 ; control rate
nchnls  = 2 ; number of channels
0dbfs   = 1 ; maximum amplitude (0dB)
; ########## CONFIG ##########

; --------------------/// INSTR 0 ///--------------------
;name   opcode  num tim siz gen
giPenta ftgen   0,  0,  6,  -2,  0,  2,  4,  7,  9
; negative disables normalization
; --------------------/// INSTR 0 ///--------------------
; ################################################################################
instr 1
; --------------------/// NOISE ///--------------------
; White noise
aRand rand .1
; Pink noise
aRand pinker ; no input
;aRand fractalnoise ; 0 1 2, hvit rosa brun
; --------------------/// NOISE ///--------------------
; ################################################################################
; --------------------/// RANDOM ///--------------------
;kRand random  kmin,   kmaks
;kRand randomh kmin,   kmaks,  kcps
;kRand randomi kmin,   kmaks,  kcps

kRand   random  200,    400
kRand   randomh 200,    1200,   10
kRand   randomi 200,    400,    2

;kRand   rspline 

aOsc    poscil  .1, kRand
; --------------------/// RANDOM ///--------------------
; ################################################################################
; --------------------/// MIDI-controlled ///--------------------
iCps    cpsmidi
iAmp    ampmidi .1

kRand   randomi iCps * 0.96,    iCps * 1.04,    4

aOsc    poscil  iAmp,   iCps
aRand   poscil  iAmp,   iCps + kRand
; --------------------/// MIDI-controlled ///--------------------
; ################################################################################
; --------------------/// SCALE control ///--------------------
iCps    cpsmidi
iAmp    ampmidi .1

;kIndex  ctrl7   1,  1,  0,  4   ;   Pentatone scale

kIndex  rspline 0,  4.99,   2,  4 
kTone   table   kIndex, giPenta  

printk2 kTone
printk2 kIndex, 50  ; Pushes output to the right to read easier

kRand   randomi iCps * 0.96,    iCps * 1.04,    4

aOsc    poscil  iAmp,   iCps * semitone(kTone) ; semitones to scaling factor
aOsc    vco2    iAmp,   iCps * semitone(kTone), 6

aFilt   butlp   aOsc,   iCps * semitone(kTone) * 4 ; filter adapted to tone
aFilt   buthp   aOsc,   800                         ; highpass
aFilt   butbp   aOsc,   800                         ; bandpass
aFilt   butbr   aOsc,   800                         ; band-reject

aRand   poscil  iAmp,   iCps + kRand
; --------------------/// Filtering ///--------------------
aFilt   butlp   aOsc,   iCps * semitone(kTone) * 4 ; filter adapted to tone
aFilt   buthp   aOsc,   800                         ; highpass
aFilt   butbp   aOsc,   800                         ; bandpass
aFilt   butbr   aOsc,   800                         ; band-reject

aNoise  rand    iAmp

aFilt   butbp   aNoise, iCps,   iCps * 0.05
aFilt   butbp   aFilt,  iCps,   iCps * 0.05 ; double filtering to make narrow filter

aFilt   butbr   aNoise, iCps,   iCps * 0.3

aBal    balance aFilt,  aNoise  ; scale arg1 to reference signal arg2
; --------------------/// Filtering ///--------------------
; ################################################################################
; --------------------/// Resonant filters ///--------------------

kCO     ctrl7   1,  1,  1,  16  ; cut-off
kRes    ctrl7   1,  2,  0,  1   ; resonance
kDist   ctrl7   1,  3,  0,  1   ; distortion

kCO     port    kCO,    0.05    ; portamento filtering, to remove hittering control

aOsc    vco2    iAmp,   iCps * semitone(kTone), 6

aADSR       madsr   0.05,   0.1,    .5, .3
aFiltADSR   madsr   0.2,    0.1,    0.3,    0.3

aFilt   moogladder  aOsc,   iCps * kCO,  kRes 
aFilt   lpf18       aOsc * aADSR,   iCps * kCO * aFiltADSR,  kRes, kDist
; --------------------/// Resonant filters ///--------------------

; @@@@@@@@@ GLOBAL SEND @@@@@@@@@ 
gaSend += aOsc

endin


instr   10

aRevL,  aRevR   reverb  gaSend, gaSend, 0.8,    8000

kMix    =   0.4
aL      =   (1 - kMix) * gaSend + kMix * aRevL
aR      =   (1 - kMix) * gaSend + kMix * aRevR

outs    aL, aR

gaSend  =   0 

endin


</CsInstruments>

<CsScore>
i10 0   z
</CsScore>

</CsoundSynthesizer>
