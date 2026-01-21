<CsoundSynthesizer>

<CsOptions>
-odac -M0 -b128 -B256
</CsOptions>

<CsInstruments>
sr = 44100 ; sample rate
kr = 4410 ; control rate
nchnls = 1 ; number of channels
0dbfs = 1 ; maximum amplitude (0dB)

instr 1
; midiin Får ut midisignalene for å finne kanalene
    iCps  cpsmidib  7; needs kCps for bend?
    iAmp  ampmidi 0.7

    kScal1  ctrl7   1,  76, 0,   0.4
    ;kScal2  ctrl7   2,  2, 0,   0.3 
    ;kScal3  ctrl7   2,  3, 0,   0.3 

    ;a1      vco2    iAmp, iCps,         0   ; sawtooth
    ;a1_2    vco2    iAmp, iCps*0.99,    0   ; detuned sawtooth

    a1      vco2    kScal1, iCps,         0   ; sawtooth
    a1_2    vco2    kScal1, iCps*0.99,    0   ; detuned sawtooth
    

    a2      vco2    iAmp, iCps*2,       10  ; square octave
    ;a2      vco2    kScal2, iCps*2,       10  ; square octave

    a3      vco2    iAmp, iCps*0.5,     12  ; triangle sub
    ;a3      vco2    kScal3, iCps*0.5,     12  ; triangle sub
    
    ;               att     dec     sus     rel
    kEnv2   madsr   0.1,    1,      iAmp,   1.2
    kEnv3   madsr   1,      2,      iAmp,   0


    out a1 + a1_2 + kEnv2 + a3*kEnv3

    ;out (a1+ a1_2)*kScal1 + a2*kEnv2*kScal2 + a3*kEnv3*kScal3
endin

instr 2 

kstatus, kchan, kdata1, kdata2 midiin

printk2 kstatus
printk2 kchan
printk2 kdata1
printk2 kdata2

endin

</CsInstruments>

<CsScore>

</CsScore>

</CsoundSynthesizer>

