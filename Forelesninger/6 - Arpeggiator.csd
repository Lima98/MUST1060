<Cabbage>
form caption("Untitled") size(500, 500), guiMode("queue"), pluginId("Arpg")
nslider bounds(10, 10, 60, 40), channel("Teller")
button bounds(10, 50, 50, 50), channel("St1") text("1") colour:1("Green") value(1)
button bounds(70, 50, 50, 50), channel("St2") text("2") colour:1("Green") value(1)
button bounds(130, 50, 50, 50), channel("St3") text("3") colour:1("Green") value(1)
button bounds(190, 50, 50, 50), channel("St4") text("4") colour:1("Green") value(1)
button bounds(250, 50, 50, 50), channel("St5") text("5") colour:1("Green") value(1)
button bounds(310, 50, 50, 50), channel("St6") text("6") colour:1("Green") value(1)
button bounds(370, 50, 50, 50), channel("St7") text("7") colour:1("Green") value(1)
button bounds(430, 50, 50, 50), channel("St8") text("8") colour:1("Green") value(1)

vslider bounds(10, 120, 40, 150), channel("p1") range(0, 24, 0, 1, 1)
vslider bounds(70, 120, 40, 150), channel("p2") range(0, 24, 0, 1, 1)
vslider bounds(130, 120, 40, 150), channel("p3") range(0, 24, 0, 1, 1)
vslider bounds(190, 120, 40, 150), channel("p4") range(0, 24, 0, 1, 1)
vslider bounds(250, 120, 40, 150), channel("p5") range(0, 24, 0, 1, 1)
vslider bounds(310, 120, 40, 150), channel("p6") range(0, 24, 0, 1, 1)
vslider bounds(370, 120, 40, 150), channel("p7") range(0, 24, 0, 1, 1)
vslider bounds(430, 120, 40, 150), channel("p8") range(0, 24, 0, 1, 1)

rslider bounds(380, 280, 70, 70), channel("tempo"), range(0.5, 8, 2, 1, 0.01)
rslider bounds(300, 280, 70, 70), channel("lengde"), range(0.03, 1, 0.1, 0.6, 0.005)

keyboard bounds(8, 400, 480, 95)
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


gaSend init 0

instr 1
iSt1 chnget "St1"
iSt2 chnget "St2"
iSt3 chnget "St3"
iSt4 chnget "St4"
iSt5 chnget "St5"
iSt6 chnget "St6"
iSt7 chnget "St7"
iSt8 chnget "St8"

iP1 chnget "p1"
iP2 chnget "p2"
iP3 chnget "p3"
iP4 chnget "p4"
iP5 chnget "p5"
iP6 chnget "p6"
iP7 chnget "p7"
iP8 chnget "p8"

iSteg ftgentmp 0, 0, 8, -2, iSt1, iSt2, iSt3, iSt4, iSt5, iSt6, iSt7, iSt8
iPitch ftgentmp 0, 0, 8, -2, iP1, iP2, iP3, iP4, iP5, iP6, iP7, iP8

kMetroFrek chnget "tempo"

kMetro metro   kMetroFrek
kTeller init 0
kTeller += kMetro

if  kTeller > 8  then
 kTeller = 1
endif

kSteg   table   kTeller-1, iSteg
kSemi   table   kTeller-1, iPitch

kLengde chnget "lengde"

if kSteg == 1 && kMetro == 1 then
 event "i", 2, 0, kLengde, cpspch(8.00) * semitone(kSemi), 0.1
endif

cabbageSetValue "Teller" , kTeller

endin

;instrument will be triggered by keyboard widget
instr 2
print p4
aEnv linseg 0, 0.001, 1, p3-0.001-0.08, 1, .08, 0
aOut vco2 p5, p4
;outs aOut*kEnv, aOut*kEnv

gaSend += aOut * aEnv

endin


instr  3

aRevL, aRevR reverbsc  gaSend, gaSend, .8, 8000

outs gaSend + aRevL, gaSend + aRevR

gaSend = 0

endin

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...

i3  0  z
</CsScore>
</CsoundSynthesizer>
