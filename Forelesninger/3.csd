<CsoundSynthesizer>

<CsOptions>
-odac   ;-M0 -b128   -B256
</CsOptions>
; ########## INSTR 0 ########## 

;var    opcode  tabnr   start   str     GEN arg1...
giSine  ftgen   0,      0,      4096,   10, 1   

;Tab.nr
gisag   ftgen   1,      0,      4096,   10, 1,  0,  1/3; etc... 
giSinus ftgen   2,      0,      4096,   10, 1 

; ########## INSTR 0 ########## 

<CsInstruments>
; ########## CONFIG ##########
sr      = 44100 ; sample rate
kr      = 4410 ; control rate
nchnls  = 2 ; number of channels
0dbfs   = 1 ; maximum amplitude (0dB)
; ########## CONFIG ##########

instr 1

    kFrek   cpsmidib
    iAmp    ampmidi .1

    iTab    ctrl7   1,  71,  0,  2

    aEnv    madsr   .1, .1, .4, .5

    aLyd    poscil  iAmp * aEnv,   kFrek,   iTab 

    gaSend  +=  aLyd

endin

;   Global klang + master ut
instr 10

    ;aoutL  aoutR   reverbsc    aLyd,  aLyd,   kfblvl, kfco
    aRevL,  aRevR,  reverbsc    gaSend, gaSend, 0.8,    8000
    
    aoutL = gaSend  *    0.3    +   aRevL   *   0.3
    aoutR = gaSend  *    0.7    +   aRevR   *   0.3

    outs    aoutL,  aoutR 
    
    fout    "./TestForel3.wav",   8,  aoutL,  aoutR

    gaSend  =   0
    ;   Send til utgang

endin

</CsInstruments>

<CsScore>
    i10 0   z   
</CsScore>

</CsoundSynthesizer>
