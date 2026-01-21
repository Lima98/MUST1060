<CsoundSynthesizer>

<CsOptions>
-odac   -M0 -b128   -B256
</CsOptions>

<CsInstruments>
; #################### CONFIG #####################
; Technical configuration
sr      = 44100 ; sample rate
kr      = 4410 ; control rate
nchnls  = 2 ; number of channels
0dbfs   = 1 ; maximum amplitude (0dB)

; Define midi channels to be used
giMidi_1 = 1 ; B3-setting
giMidi_2 = 2 ; Reverb
giMidi_3 = 3 ; Sound without reverb
giMidi_4 = 4 ; Sound with reverb
; #################### CONFIG #####################

; #################### INSTR 0 #################### 

; Define B3 settings for next ftgen
ikB31 = 8
ikB32 = 8
ikB33 = 8
ikB34 = 0
ikB35 = 0
ikB36 = 0
ikB37 = 0
ikB38 = 0
ikB39 = 0
; Using B3 settings in ftgen
;name       opcode  tabnr   start   str     Gen arg1    arg2    arg3    arg4    arg6    arg8    arg10   arg12       arg16
giTab_1     ftgen   1,      0,      4096,   10, ikB31,  ikB32,  ikB33,  ikB34,0,ikB35,0,ikB36,0,ikB37,0,ikB38,0,0,0,ikB39

; Define B3 settings for next ftgen
ikB31 = 8
ikB32 = 8
ikB33 = 8
ikB34 = 8
ikB35 = 0
ikB36 = 0
ikB37 = 0
ikB38 = 0
ikB39 = 0
giTab_2     ftgen   2,      0,      4096,   10, ikB31,  ikB32,  ikB33,  ikB34,0,ikB35,0,ikB36,0,ikB37,0,ikB38,0,0,0,ikB39
; Define B3 settings for next ftgen
ikB31 = 8
ikB32 = 3
ikB33 = 0
ikB34 = 0
ikB35 = 0
ikB36 = 0
ikB37 = 3
ikB38 = 7
ikB39 = 8
giTab_3     ftgen   3,      0,      4096,   10, ikB31,  ikB32,  ikB33,  ikB34,0,ikB35,0,ikB36,0,ikB37,0,ikB38,0,0,0,ikB39
; Define B3 settings for next ftgen
ikB31 = 8
ikB32 = 0
ikB33 = 3
ikB34 = 6
ikB35 = 0
ikB36 = 0
ikB37 = 0
ikB38 = 0
ikB39 = 0
giTab_4     ftgen   4,      0,      4096,   10, ikB31,  ikB32,  ikB33,  ikB34,0,ikB35,0,ikB36,0,ikB37,0,ikB38,0,0,0,ikB39
; Define B3 settings for next ftgen
ikB31 = 6
ikB32 = 6
ikB33 = 8
ikB34 = 8
ikB35 = 4
ikB36 = 8
ikB37 = 5
ikB38 = 8
ikB39 = 8
giTab_5     ftgen   5,      0,      4096,   10, ikB31,  ikB32,  ikB33,  ikB34,0,ikB35,0,ikB36,0,ikB37,0,ikB38,0,0,0,ikB39
; Define B3 settings for next ftgen
ikB31 = 8
ikB32 = 8
ikB33 = 8
ikB34 = 0
ikB35 = 0
ikB36 = 0
ikB37 = 0
ikB38 = 0
ikB39 = 8
giTab_6     ftgen   6,      0,      4096,   10, ikB31,  ikB32,  ikB33,  ikB34,0,ikB35,0,ikB36,0,ikB37,0,ikB38,0,0,0,ikB39
; #################### INSTR 0 #################### 

instr 1
    ; Get midi note and amp
    iFrek   cpsmidib 7
    iAmp    ampmidi .1
    
    ; Create envelope
    aEnv    madsr   0.02, 0.1, 1, 0.02
    
    ; Choose B3 setting with midi controller
    iTabN   ctrl7   1,  giMidi_1, 1,  6
    
    ; Generate sound based on chosen B3-setting and midi note
    aLyd    poscil  iAmp,   iFrek,  iTabN
    
    ; VIBRATO
    ; Vibrato relative to midi tone  
    kLFO    lfo     6,   iFrek*0.065
    kVib    =       iFrek + kLFO
    
    ; Generate same sound but with vibrato
    aVib    poscil  iAmp,   iFrek+kLFO,   iTabN

    ; Control amp of clean and vib signal separately
    kLydCtrl    ctrl7   1,  giMidi_3, 0,  1
    kVibCtrl    ctrl7   1,  giMidi_4, 0,  1
    
    ; Mix and send to global send to use reverb
    gaSend += (aLyd*kLydCtrl + aVib*kVibCtrl) * aEnv

endin

;   Global reverb + master out
instr 10
    ; Mix and send to global send to use reverb0
    ;aoutL  aoutR   reverbsc    aLyd,   aLyd,   kfblvl, kfco
    aRevL,  aRevR  reverbsc    gaSend, gaSend, 0.8,    8000

    ; Control reverb amt with midi
    kRev   ctrl7   1,   giMidi_2,  0,  1
    ; Mix dry/wet using midi 
    aoutL = gaSend * (1-kRev) + aRevL * kRev 
    aoutR = gaSend * (1-kRev) + aRevR * kRev

    ; Send output
    outs    aoutL,  aoutR 

    ; Write to file in relative path 
    fout    "./Lydfiler/Oving_3.wav",   8,  aoutL,  aoutR

    ; Reset global send to avoid "feedback/overflow"
    gaSend  =   0
endin

</CsInstruments>

<CsScore>
; Play reverb instr from time 0 and snooze it(infinite duration)
i10 0   z
</CsScore>

</CsoundSynthesizer>
