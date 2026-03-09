<Cabbage>
form caption("Untitled") size(400, 300), guiMode("queue"), pluginId("def1")
keyboard bounds(8, 158, 381, 95)
vslider bounds(10, 10, 30, 140) channel("transp") text("Transp") range(-12, 12, 0, 1, 1)
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

giTab1  ftgen 0,  0,  0,  -1, "../Lydfiler/melody.wav", 0,  0,  0

; Read a file and play it on midi trigger
instr 1
  kPitch  chnget  "transp"
  a1, a2      diskin2 "samples/29012022.wav",  semitone(kPitch) 
  out     a1
endin

; Transponse when pressing midi keys
instr 2
  iAmp  ampmidi .2
  iNote notnum
  iRef  = 60
  iDiff = iNote - iRef
  iTrsp = semitone(iDiff)

  iChns = ftchnls(giTab1)

  if iChns ==  1 then
    a1 loscil iAmp, iTrsp, giTab1, 1
    a2 = a1
  elseif iChns == 2 then
    a1, a2 loscil iAmp, iTrsp, giTab1, 1
  endif

  outs a1, a2

endin

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z
i1 1000
i2 1000
</CsScore>
</CsoundSynthesizer>
