<Cabbage>
form caption("ProtoTrommemaskin") size(500, 200), guiMode("queue"), pluginId("TrMs")
nslider bounds(10, 120, 60, 40), channel("Teller") range(1, 8, 1, 1, 1)
button bounds(10, 50, 50, 50), channel("St1") text("1") colour:1("Green") value(1)
button bounds(70, 50, 50, 50), channel("St2") text("2") colour:1("Green") value(1)
button bounds(130, 50, 50, 50), channel("St3") text("3") colour:1("Green") value(1)
button bounds(190, 50, 50, 50), channel("St4") text("4") colour:1("Green") value(1)
button bounds(250, 50, 50, 50), channel("St5") text("5") colour:1("Green") value(1)
button bounds(310, 50, 50, 50), channel("St6") text("6") colour:1("Green") value(1)
button bounds(370, 50, 50, 50), channel("St7") text("7") colour:1("Green") value(1)
button bounds(430, 50, 50, 50), channel("St8") text("8") colour:1("Green") value(1)
;vslider bounds(10, 10, 30, 140) channel("transp"), text("Transp"), range(-12, 12, 0, 1, 1)
rslider bounds(380, 120, 70, 70), channel("tempo"), range(0.5, 8, 2, 1, 0.01)
;keyboard bounds(8, 158, 381, 95)
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

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;       GLOBALE TABELLER
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

; Lydtabell
giTab1  ftgen 0, 0, 0, -1, "HiHat.wav", 0, 0, 0

; Tabell med steg til sequencer (1 = på, 0 = av)
giSteg  ftgen 0, 0, 8, -2, 1, 1, 1, 1, 1, 1, 1, 1
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


; *******************************************************
;       Kontrollinstrument
; *******************************************************
instr 1
; Hent inn verdi fra knapper om steg er på eller av
kSt1 chnget "St1"
kSt2 chnget "St2"
kSt3 chnget "St3"
kSt4 chnget "St4"
kSt5 chnget "St5"
kSt6 chnget "St6"
kSt7 chnget "St7"
kSt8 chnget "St8"

; Skriv til tabell med stegene
    tablew kSt1, 0, giSteg
    tablew kSt2, 1, giSteg
    tablew kSt3, 2, giSteg
    tablew kSt4, 3, giSteg
    tablew kSt5, 4, giSteg
    tablew kSt6, 5, giSteg
    tablew kSt7, 6, giSteg
    tablew kSt8, 7, giSteg

kMetroFrek chnget "tempo"

; Lag en metronom med teller 
kMetro metro   kMetroFrek
kTeller init 0
kTeller += kMetro
; Tilbakestill teller 
if  kTeller > 8  then
 kTeller = 1
endif

; Bruk teller til å lese av tabell
kSteg   table   kTeller-1, giSteg

; Trigg samplespillende instrument når steget er skrudd på (kSteg==1)
; og metronomen har et tikk == 1
if kSteg == 1 && kMetro == 1 then
 event "i", 2, 0, 0.3
endif
; Skriv teller-verdien til pluggvinduet
cabbageSetValue "Teller" , kTeller

endin

; *******************************************************
;           LYDSPILLENDE INSTRUMENT
; *******************************************************
instr  2
iAmp = 0.2
iTransp = 1
iChnls = ftchnls(giTab1)

; Velg riktig loscil ut fra antall kanaler i lydfila
if iChnls == 1 then
 a1 loscil iAmp, iTransp, giTab1, 1
 a2 = a1
elseif iChnls == 2 then
 a1, a2 loscil iAmp, iTransp, giTab1, 1
endif

outs a1, a2

endin

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
i1  0 z
</CsScore>
</CsoundSynthesizer>
