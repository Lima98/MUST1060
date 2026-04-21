<Cabbage>
form caption("StereoChorus") size(400, 300), guiMode("queue") pluginId("ov85")]
image file("chorus-bg.jpg") bounds(0, 0, 400, 300) channel("background") alpha(0.4) 
rslider bounds(250, 148, 150, 150), channel("gain"), range(0, 1, 0.9, 1, 0.01), text("Gain"), trackerColour(255, 255, 255, 73), outlineColour(255, 255, 255, 255), textColour(255, 255, 255, 255)
;rslider bounds(100, 100, 100, 100), channel("delaytid"), range(0, 1, 0.01, 0.5, 0.00001), text("delaytid")
rslider bounds(10, 10, 100, 100), channel("dybde"), range(0, 0.5, 0.1, 1, 0.001), text("Depth") trackerColour(52, 0, 210, 255) textColour(255, 255, 255, 255) outlineColour(255, 255, 255, 255)
rslider bounds(114, 10, 100, 100), channel("frek"), range(0, 20, 0.2, 1, 0.001), text("Frequency") trackerColour(4, 210, 0, 255) outlineColour(255, 255, 255, 255) textColour(255, 255, 255, 255)
;rslider bounds(300, 10, 100, 100), channel("feedb"), range(0, 1, 0.5, 1, 0.001), text("Feedb")
rslider bounds(12, 188, 100, 100), channel("miks"), range(0, 1, 0.5, 1, 0.001), text("Wet/Dry") outlineColour(255, 255, 255, 255) trackerColour(255, 255, 255, 255) textColour(255, 255, 255, 255)
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
ksmps = 32
nchnls = 2
0dbfs = 1

giSinus ftgen 0, 0, 8192, 10, 1

instr 1
kGain cabbageGetValue "gain"

a1 inch 1
a2 inch 2

kDelTid chnget "delaytid"
kDybde chnget "dybde"
kFrek chnget "frek"
kMiks  chnget "miks"
;kFeedb chnget "feedb"


kDelTid port kDelTid, 0.05
aDelTid = a(kDelTid)*0.01

; To LFO-oscillatorer, den ene fasevendt
kDybde = kDybde * 3
aLFO   poscil  kDybde, kFrek
aLFO2  poscil  kDybde, kFrek, giSinus, 0.5
kOffset = 0.005
aDelTid  = aLFO + kOffset + 0.4
aDelTid2 = aLFO2 + kOffset + 0.4


;aDelTid = 0.2

; OBS! vdelay bruker ms
iMaxDel = 1000      
; Når vi skal lage vibrato/chorus trenger vi ikke feedback 
aDelay   vdelay3  a1, aDelTid, iMaxDel
aDelay2  vdelay3  a2, aDelTid2, iMaxDel

; OBS! Dette viste jeg ikke i forelesninga, men tørr/våt-miks har vi sett i andre sammenhenger
aMiksL = (1-kMiks) * a1 + aDelay * kMiks
aMiksR = (1-kMiks) * a2 + aDelay2 * kMiks

outs aMiksL*kGain, aMiksR*kGain
endin

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z
;starts instrument 1 and runs it for a week
i1 0 [60*60*24*7] 
</CsScore>
</CsoundSynthesizer>
