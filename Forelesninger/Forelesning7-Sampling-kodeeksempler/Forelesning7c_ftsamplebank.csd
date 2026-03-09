<Cabbage>
form caption("Untitled") size(500, 500), guiMode("queue"), pluginId("def1")
;vslider bounds(10, 10, 30, 140) channel("transp"), text("Transp"), range(-12, 12, 0, 1, 1)

keyboard bounds(8, 158, 381, 95)
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

massign 1, 2

;giTab1  ftgen 1, 0, 0, -1, "Trompet/E3_forte.wav", 0, 0, 0
;giTab2  ftgen 2, 0, 0, -1, "Trompet/E3_pianissimo.wav", 0, 0, 0
;giTab3  ftgen 3, 0, 0, -1, "Trompet/Gs3_forte.wav", 0, 0, 0
;giTab4  ftgen 4, 0, 0, -1, "Trompet/Gs3_pianissimo.wav", 0, 0, 0

instr  1
iNumberOfFile ftsamplebank "/Users/andbe/Desktop/1060/1060-7-Sampleavspilling/Valthorn", 1, 0, 0, 0
print iNumberOfFile
endin


instr  2
iAmp ampmidi .2
iNote notnum

; Velger riktig sample for noteverdi og veliocity
; E3 forte
iRef = 44
iTab = iNote - iRef
iTransp = 1

iChnls = ftchnls(iTab)
iMode = 1       ; Forover-looping
kcrossfade = 0.2
kloopstart = 0.368
kloopend = 1.273

if iChnls == 1 then
 ;a1 loscil iAmp, iTransp, iTab, 1, iMode, 0.368*sr, 1.273*sr
 a1 flooper2 iAmp, iTransp, kloopstart, kloopend, kcrossfade, iTab
 a2 = a1
elseif iChnls == 2 then
 ;a1, a2 loscil iAmp, iTransp, iTab, 1, iMode, 0.368*sr, 1.273*sr
 a1, a2 flooper2 iAmp, iTransp, kloopstart, kloopend, kcrossfade, iTab
endif

outs a1, a2

endin

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
i1  0  z
</CsScore>
</CsoundSynthesizer>
