jk<Cabbage>
form caption("Foreles9") size(400, 300), guiMode("queue"), pluginId("for9")
vmeter bounds(332, 16, 10, 160) channel("vu1") value(0) outlineColour(0, 0, 0), overlayColour(0, 0, 0) meterColour:0(255, 0, 0) meterColour:1(255, 255, 0) meterColour:2(0, 255, 0) outlineThickness(1) 
rslider bounds(100, 162, 70, 70) channel("thresh") range(0, 1, 0.1, 1, 0.001) text("Threshold") textColour("White")
rslider bounds(180, 162, 70, 70) channel("HT") range(0, 0.2, 0.05, 1, 0.0001) text("Smooth") textColour("White")
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d
</CsOptions>
<CsInstruments>
; Initialize the global variables.
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

instr 1
  ;kGain cabbageGetValue "gain"
  kThresh chnget  "thresh"
  kHalf   chnget  "HT"

  a1, a2  diskin2 "140_superjazzy-drum-odys.aif", 1, 0, 1

  kRMS    rms    a1

  kRMS_del  delayk  kRMS, 0.01

  kRMS_delta  = kRMS - kRMS_del

  kOnset  trigger kRMS_delta, kThresh, 0
  
  kWait init 0
  kOnset = kWait == 1? 0 : kOnset
  kWait trighold  kOnset, 0.1

  kDamp divz kThresh, kRMS, 1; divz is a safe division operator that returns p3 if the denominator is 0
  
  ;kGate   portk  kGate, kHalf

  if kRMS > kThresh then
  kSkal = kDamp
  else
  kSkal = 1
  endif

  kMetro metro 0

  kMetro  metro   20
  cabbageSetValue "vu1", kRMS, kMetro

  aL = a1 * kSkal
  aR = a2 * kSkal

  outs  aL, a(kOnset)
endin

</CsInstruments>
<CsScore>
; Play instrument 1 for 10 seconds.
f0  z
i1  0 9999
</CsScore>
</CsoundSynthesizer>
