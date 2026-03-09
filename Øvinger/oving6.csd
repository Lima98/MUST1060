<Cabbage>
form caption("Arp") size(600, 500), guiMode("queue"), pluginId("arpg")
nslider bounds(46, 274, 436, 100) channel("Counter") range(0, 100, 0, 1, 0.01)
keyboard bounds(10, 400, 585, 95)

button bounds(90,  30, 50, 50) colour:1("Green") text("1") channel("step1") value(1)
button bounds(150, 30, 50, 50) colour:1("Green") text("2") channel("step2") value(1)
button bounds(210, 30, 50, 50) colour:1("Green") text("3") channel("step3") value(1)
button bounds(270, 30, 50, 50) colour:1("Green") text("4") channel("step4") value(1)
button bounds(330, 30, 50, 50) colour:1("Green") text("5") channel("step5") value(1)
button bounds(390, 30, 50, 50) colour:1("Green") text("6") channel("step6") value(1)
button bounds(450, 30, 50, 50) colour:1("Green") text("7") channel("step7") value(1)
button bounds(510, 30, 50, 50) colour:1("Green") text("8") channel("step8") value(1)

rslider bounds(14,  26, 60, 60) text("Tempo")   channel("tempo") range(60, 200, 0, 1, 1)
rslider bounds(14, 180, 60, 60) text("Duration")channel("dur")   range(0, 1, 0, 1, 0.001)
rslider bounds(515, 325, 60, 60)text("Reverb")  channel("rev")   range(0, 1, 0, 1, 0.001) 
rslider bounds(515, 255, 60, 60)text("Cutoff")  channel("cut")   range(20, 20000, 0, 1.5, 1) 
 
vslider bounds( 90, 90, 50, 150) channel("i1") range(0, 12, 0, 1, 1)
vslider bounds(150, 90, 50, 150) channel("i2") range(0, 12, 0, 1, 1)
vslider bounds(210, 90, 50, 150) channel("i3") range(0, 12, 0, 1, 1)
vslider bounds(270, 90, 50, 150) channel("i4") range(0, 12, 0, 1, 1)
vslider bounds(330, 90, 50, 150) channel("i5") range(0, 12, 0, 1, 1)
vslider bounds(390, 90, 50, 150) channel("i6") range(0, 12, 0, 1, 1)
vslider bounds(450, 90, 50, 150) channel("i7") range(0, 12, 0, 1, 1)
vslider bounds(510, 90, 50, 150) channel("i8") range(0, 12, 0, 1, 1)




</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
ksmps = 32
nchnls = 2
0dbfs = 1

gaSend  init    0

instr 1

    iSt1    chnget  "step1"
    iSt2    chnget  "step2"
    iSt3    chnget  "step3"
    iSt4    chnget  "step4"
    iSt5    chnget  "step5"
    iSt6    chnget  "step6"
    iSt7    chnget  "step7"
    iSt8    chnget  "step8"

    iP1     chnget  "i1"
    iP2     chnget  "i2"
    iP3     chnget  "i3"
    iP4     chnget  "i4"
    iP5     chnget  "i5"
    iP6     chnget  "i6"
    iP7     chnget  "i7"
    iP8     chnget  "i8"

    iStep   ftgentmp 0, 0, 8, -2, iSt1, iSt2, iSt3, iSt4, iSt5, iSt6, iSt7, iSt8
    iPitch  ftgentmp 0, 0, 8, -2, iP1, iP2, iP3, iP4, iP5, iP6, iP7, iP8
    
    kMetFq  chnget "tempo"
    kMetro  metro   kMetFq
    kCount  init    0
    kCount  +=      kMetro

    if  kCount > 8 then
        kCount = 1
    endif

    kStep   table   kCount-1,   iStep
    kSemi   table   kCount-1,   iPitch

    kDur    chnget "dur"

    if kStep == 1 && kMetro == 1 then
        event "i", 2, 0, kDur, p4 * semitone(kSemi), 0.1
    endif
    
    cabbageSetValue "Counter" kCount

endin

instr 2
    iFreq = p4
    iAmp = p5
    aEnv linseg 0, 0.01, 1, p3-0.01, 0
    aSig vco2 iAmp, iFreq
    gaSend += aSig * aEnv
endin

;   Global klang + master ut
instr 10
    kRev   chnget "rev"
    kCut   chnget "cut"

    ;aoutL  aoutR   reverbsc    aLyd,  aLyd,   kfblvl, kfco
    aRevL,  aRevR,  reverbsc    gaSend, gaSend, kRev, kCut

    aOutL = gaSend  *    0.3    +   aRevL   *   0.3
    aOutR = gaSend  *    0.7    +   aRevR   *   0.3

    outs    aOutL,  aOutR 

    gaSend  =   0

endin


</CsInstruments>
<CsScore>
i10 0   z
</CsScore>
</CsoundSynthesizer>
