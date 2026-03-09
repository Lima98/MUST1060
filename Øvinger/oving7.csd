<Cabbage>
form caption("MultiSampler") size(600,300), pluginId("mult")

keyboard bounds(10,150,580,120)

rslider bounds(20,20,80,80) channel("delayTime") range(0, 1, 0.1, 0.5, 0.00001)
rslider bounds(110,20,80,80) channel("delayFB") range(0,0.95,0.4)
rslider bounds(200,20,80,80) channel("reverbMix") range(0,1,0.3)

label bounds(20,100,80,20) text("Delay Time")
label bounds(110,100,80,20) text("Delay FB")
label bounds(200,100,80,20) text("Reverb Mix")
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>

<CsInstruments>

sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1

; Load samples into func. tables
giPluck ftgen 1, 0, 0, -1, "pluck.wav", 0, 0, 1
giVox   ftgen 2, 0, 0, -1, "vox.wav",   0, 0, 1
giHorn  ftgen 3, 0, 0, -1, "horn.wav",  0, 0, 1

; Global audio out
gaSendL init 0
gaSendR init 0

; Change sample based on pitch of midi note
instr 1
  iAmp  ampmidi .2
  iNote notnum
  iRef  = 60
  iDiff = iNote - iRef
  iTrsp = semitone(iDiff)

    if iNote < 60 then
        a1 flooper2 iAmp, iTrsp, 1, 2, 0.5 , giHorn
        a2 = a1
  elseif iNote >= 60 && iNote < 72 then
        a1 flooper2 iAmp, iTrsp, 1, 2, 0.5 , giVox
        a2 = a1
  elseif iNote >= 72 then
        a1 loscil iAmp, iTrsp, giPluck, 1
        a2 = a1
  endif

  gaSendL = gaSendL + a1
  gaSendR = gaSendR + a2
endin

; Delay effect
instr 10
  kDelTime chnget "delayTime"
  kDelFB   chnget "delayFB"
  
  ;aDelayL vcomb gaSendL, kDelTime, 0, 10
  ;aDelayR vcomb gaSendR, kDelTime, 1, 10 

  iMaxDel = 1
  aDelay init     0

  aMaxDel  delayr iMaxDel
  aDelay   deltap3 kDelTime
  delayw  gaSendL + aDelay * kDelFB
  
  gaSendL = gaSendL + (aDelay * kDelFB)
  gaSendR = gaSendR + (aDelay * kDelFB)
endin

; Reverb effect
instr 11
  
  kMix chnget "reverbMix"
  
  aRevL, aRevR reverbsc gaSendL, gaSendR, 0.85, 12000
  
  aOutL = gaSendL + (aRevL * kMix)
  aOutR = gaSendR + (aRevR * kMix)
  
  outs aOutL, aOutR
  fout    "../Lydfiler/Oving_7.wav",   8,  aOutL,  aOutR
  
  gaSendL = 0
  gaSendR = 0
endin

</CsInstruments>

<CsScore>

i10 0 z
i11 0 z
f0 z

</CsScore>
</CsoundSynthesizer>
