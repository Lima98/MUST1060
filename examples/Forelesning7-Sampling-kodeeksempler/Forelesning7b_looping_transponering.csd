<Cabbage>
form caption("EnkelSampler") size(500, 250), guiMode("queue"), pluginId("Smpl")
keyboard bounds(8, 158, 481, 85)
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
ksmps = 32
nchnls = 2
0dbfs = 1

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;       GLOBALE TABELLER
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; Vi trenger ikke å angi filbane hvis lydfilene ligger i samme
; mappe som .csd.
; Hvis lydfilene ligger i en mappe og .csd og mappa er i samme mappe
; kan du bruke relativ filbane: "Undermappe/Filnavn.wav"
; For å være helt sikker på at Csound skal finne fila di kan
; du alternativt oppgi full filbane
giTab1  ftgen 1, 0, 0, -1, "Trompet/E3_forte.wav", 0, 0, 0
giTab2  ftgen 2, 0, 0, -1, "Trompet/E3_pianissimo.wav", 0, 0, 0
giTab3  ftgen 3, 0, 0, -1, "Trompet/Gs3_forte.wav", 0, 0, 0
giTab4  ftgen 4, 0, 0, -1, "Trompet/Gs3_pianissimo.wav", 0, 0, 0
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

; *******************************************************
;       Notespillende instrument
; *******************************************************
instr  1
iVel ampmidi 1
iNote notnum        ; Les inn MIDI-notenummer (enstrøken C = 60)

; Velger riktig sample for noteverdi og veliocity
; E3 forte
if iVel > 0.5 && iNote < 66 then
 iAmp = 0.2
 iTab = 1
 iRef = 64
elseif iVel < 0.5 && iNote < 66 then
 iAmp = 0.3
 iTab = 2
 iRef = 64
elseif iVel > 0.5 && iNote > 66 then
 iAmp = 0.2
 iTab = 3
 iRef = 68
elseif iVel < 0.5 && iNote > 66 then
 iAmp = 0.3
 iTab = 4
 iRef = 68
endif

iDiff = iNote - iRef
iTransp = semitone(iDiff)
iChnls = ftchnls(iTab)
iMode = 1       ; Forover-looping
kcrossfade = 0.2
kloopstart = 0.368
kloopend = 1.273

; Bruk loscil eller flooper2 til sampleavspilling (kommenter ut det du ikke bruker)
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
f0 z
</CsScore>
</CsoundSynthesizer>
