<Cabbage>
form caption("Untitled") size(400, 300), guiMode("queue") pluginId("def1")
rslider bounds(296, 162, 100, 100), channel("gain"), range(0, 1, 0.5, 1, .01), text("Gain"), trackerColour("lime"), outlineColour(0, 0, 0, 50), textColour("black")
rslider bounds(100,100,100,100) channel("delaytime") range(0, 1, 0.1, 1, 0.001) text("Delay Time") trackerColour("lime"), outlineColour(0, 0, 0, 50), textColour("black")
rslider bounds(10,10,100,100) channel("depth") range(0, 1, 0.2, 1, 0.001) text("Depth") trackerColour("lime"), outlineColour(0, 0, 0, 50), textColour("black")
rslider bounds(200,10,100,100) channel("rate") range(0, 20, 5, 1, 0.001) text("Rate") trackerColour("lime"), outlineColour(0, 0, 0, 50), textColour("black")

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-odac -n -d -+rtmidi=NULL -M0 --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
ksmps = 32
nchnls = 2
0dbfs = 1

instr 1
kGain chnget "gain"

a1 inch 1
a2 inch 2

kDelTime  chnget  "delaytime"
kDepth    chnget  "depth"
kRate     chnget  "rate"

a1, a2  diskin2 "Pizz.wav", 1

kDelTime  port kDelTime, 0.05
aDelTime  = a(kDelTime)       ; built in interpolation

iDepth    = 50
aDelTime  poscil  kDepth * 50, kRate ; modulate delay time with an LFO
iOffset   = iDepth
aDelTime  = aDelTime + iOffset + 0.1 ; add a small offset to avoid zero delay time


; This uses milliseconds for delay time
iMaxDel = 1000 ; max delay time in ms
aDelay  vdelay3 a1, kDelTime*1000, iMaxDel

; This uses seconds for delay time
;aDelay  comb  a1, 1,  kDelTime, 1

aMiks   = a1 + aDelay

outs aMiks*kGain, aMiks*kGain
endin

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z
;starts instrument 1 and runs it for a week
i1 0 [60*60*24*7] 
</CsScore>
</CsoundSynthesizer>
