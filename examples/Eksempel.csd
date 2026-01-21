<CsoundSynthesizer>


<CsOptions>
-odac	-M0	-b128	-B256	--displays	-Ma

</CsOptions>


<CsInstruments>
;********************************************************************************
; CsInstruments - Innholdsfortegnelse
;********************************************************************************

; - Innholdsfortegnelse
; - Header
; - Globale variabler
; - Instrument 1: Kontrollinstrument
; - Instrument 2: Filtrert støy
; - Instrument 3: Bassdrone
; - Instrument 4: Tilfeldige toner
; - Instrument 5: Master Out


;********************************************************************************
; Header
;********************************************************************************
sr	=	44100 	; Samplingrate
kr	=	4410 	; Kontrollrate
nchnls	=	2   ; Antall kanaler
0dbfs	=	1	; Referanseamplitude


;********************************************************************************
; Globale variabler
<CsoundSynthesizer>

<CsOptions>
-odac
-Ma; MIDI functionality, a changed to midi controller number 
-b128 -B256 ; lower bufferes, improve response times. 
            ; b is software, B is hardware
</CsOptions>

<CsInstruments>
sr = 44100 ; sample rate
kr = 1 ; control rate
nchnls = 2 ; number of channels
0dbfs = 1 ; maximum amplitude (0dB)

instr 1
iFrek cpsmidib 2 ; get note from midi intrument
              ;cpsmidib, enables bending
iAmp  ampmidi 0.2
aEnv  madsr   0.02, 0.1,  0.6,  0.5 

kLFO  poscil  iFrek * 0.03, 6; important to change 
kVib = iFrek + kLFO
a1  vco2  iAmp, kVib * 2

kGain1 = 0.4

aMiks = a1 * kGain1

  outs a1 * kGain1 
endin

</CsInstruments>

<CsScore>

</CsScore>

</CsoundSynthesizer>
;********************************************************************************
; %%%%% VARIABLER
gaMasterL	init	0
gaMasterR	init	0


; %%%%% TABELLER
giSek1	ftgen	1, 0, 10, -2,	10.00, 7.07, 7.01, 8.03, 9.06, 8.02, 7.06, 8.04
giSek2	ftgen	2, 0, 10, -2,	8.00, 10.01, 9.07, 7.02, 8.07, 9.08, 8.12, 7.10
giSek3	ftgen	3, 0, 10, -2,	9.00, 7.01, 8.07, 10.02, 7.07, 8.08, 7.12, 9.10


;********************************************************************************
; Instrument 1: Kontrollinstrument
;********************************************************************************

; Ved hjelp av en metronom, trigger dette instrumentet en schedkwhen som kan 
; styre de andre instrumentene.

instr 1

; Variabler
iFrek	=	60	; Spilletone
kMFrek	=	0.8

; Lager metronom hvor hver puls er et ett-tall.
ktrig	metro	kMFrek

; Lager schedkwhen
schedkwhen	ktrig, 0, 0, 3, 0, 30, iFrek


endin


;********************************************************************************
; Instrument 2: Filtrert støy
;********************************************************************************

; Dette instrumentet genererer støy som så blir filtrert gjennom filter.

instr 2

; %%%%% FILTER

; Støyariabler
iAmp	=	0.2
iSeed	=	2
iBits	=	1

; Lager støysignal
aNoise	rand	iAmp, iSeed, iBits

; MIDI-kontrollverdier for filter
kFrek	ctrl7	1, 71, 100, 10000	; Knekkkfrekvens (LP/HP) eller senterfrekvens (BP/BR)
kFrek	port	kFrek, 0.05			; Glatter ut kontrollverdiene
kBandF	ctrl7	1, 72, 0.01, 2		; Faktor for bÃ¥ndvidde
kLP_amp	ctrl7	1, 73, 0, 0.5		; Separat kontroll av amplituden til de fire filtrene
kHP_amp	ctrl7	1, 74, 0, 0.5		; Separat kontroll av amplituden til de fire filtrene
kBP_amp	ctrl7	1, 75, 0, 0.5		; Separat kontroll av amplituden til de fire filtrene
kBR_amp	ctrl7	1, 76, 0, 0.5		; Separat kontroll av amplituden til de fire filtrene

; Setter bandvidden for bandpass og bandstoppfiltrene relativ til senterfrekvens
kBand		=		kFrek * kBandF

; Lavpass og høypass
alp		butterlp	aNoise * kLP_amp, kFrek
ahp		butterhp	aNoise * kHP_amp, kFrek

; Dobbel bandpassfiltrering
abp		butterbp	aNoise * kBP_amp, kFrek, kBand
abr		butterbr	aNoise * kBR_amp, kFrek, kBand


; %%%%% MIX

; Kombinerer all lyden
aLyd	=	aNoise ; + ahp + abp + abr

; Setter stereomix
aLydL	=	aLyd
aLydR	=	aLyd

; Oppdaterer master
gaMasterL	+=	aLydL
gaMasterR	+=	aLydR


endin


;********************************************************************************
; Instrument 3: Bassdrone
;********************************************************************************

; Dette instrumentet adderer et lydsignal med et lignende lydsignal som varierer 
; litt i amplitude og tonehøyde, for å skape variasjon i klangen.

instr 3

; %%%%% DRONE

; Variabler
iAmp	=	0.1
iFrek	=	p4
iMode	=	12

; MIDI-in
;iAmp	ampmidi
;iFrek	cpsmidi

; Tilfeldighetsgenerering
kRand1	rspline	iFrek * 0.95, iFrek * 1.05, 3, 6
kRand2	rspline	iAmp * 0.95, iAmp * 1.05, 3, 6

; Lydgenerering
aBass1	vco2	iAmp, iFrek, iMode
aBass2	vco2	iAmp + kRand2, iFrek + kRand1, iMode


; %%%%% MIX

; Kombinerer lyden
aBass	=	aBass1 + aBass2

; Stereomix
aLydL	=	aBass
aLydR	=	aBass

; Lyd til master
gaMasterL	+=	aLydL
gaMasterR	+=	aLydR


endin


;********************************************************************************
; Instrument 4: Tilfeldige lyder
;********************************************************************************

; Dette instrumentet plukker tilfeldig ut pch-verdier fra en av tonesekvensene,
; konverterer dem til frekvensverdier og spiller dem av i et tilfeldig sted i 
; stereofeltet.

instr 4

; %%%%% TILFELDIGHETSGENERATOR

; Variabler
iAmp		=	0.2
iGenFrek	=	16
iMode		=	6
iTabell		=	3

; MIDI-kontrollverdier
kNdxMin		ctrl7	1, 1, 0, 7.99
kNdxMax		ctrl7	1, 2, 0, 7.99

; Tilfeldighetsgenerering
kIndex	randomh	kNdxMin, kNdxMax, iGenFrek
kSkal	randomh	0, 1, iGenFrek

; Henter pch-verdier fra tabell
kPch	table	kIndex,	iTabell

; Gjør om fra pch til frekvens
kFrek 	=		cpspch(kPch)

; Lyd til variabel
aToner	vco2	iAmp, kFrek, iMode


; %%%%% MIX

; Skalerer skalarene
kSkalL	=	kSkal
kSkalR	=	1 - kSkal

; Skalerer lyd
aLydL	=	aToner * kSkalL
aLydR	=	aToner * kSkalR

; Oppdaterer master
gaMasterL	+=	aLydL
gaMasterR	+=	aLydR


endin


;********************************************************************************
; Instrument 5: Master Out
;********************************************************************************

; Dette instrumentet fungerer som en masterkontroll som lyden fra de andre
; instrumentene sendes til, før den går ut.

instr 5

; %%%%% LYD UT

; Sender ut lyd
	outs	gaMasterL, gaMasterR

; Skriver ut lyd til fil
	fout	"3sekvens3.wav", 18, gaMasterL, gaMasterR

; Rengjøring
gaMasterL	=	0
gaMasterR	=	0


endin


</CsInstruments>


<CsScore>
; %STANDARDAVSPILLING
;f0 z
;i1	0	30
;i2	0	30
;i3	0	30
;i4	0	30
i5	0	30


</CsScore>


</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
