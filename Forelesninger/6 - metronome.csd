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

instr 1
    kMetro    metro     1       ; Set metronome interval in ms
    kCount    init      0       ; Initialize count variable
    kCount    += kMetro
    kFrek     = 880
    kAmp      = 0.2

    if kCount > 4 then
     kCount = 1
    endif

    if kCount = 1 then
     kAmp = .5
    else
     kAmp = .1
    endif

    if  kMetro == 1 then
     event "i", 2, 0, 0.2, kAmp, kFrek
    endif

    out a(kMetro) * kAmp
endin

instr 2
    kTime   timeinsts
    aTone poscil p4, p5
    out aTone

if kTime > 0.15 then
   turnoff
endif

endin

</CsInstruments>

<CsScore>
i1  0 100
</CsScore>

</CsoundSynthesizer>
