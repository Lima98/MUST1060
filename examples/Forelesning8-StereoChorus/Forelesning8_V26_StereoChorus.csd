; 2a) Forstå oppgybbingen
; 
; h. Det ser ut til at delaytiden varierer mellom 0 og 1 sekund fra rslideren med "delaytid". Jeg ser dog ikke hvor den skaleres med 1000 for å få det i ms.
; 
; i.
; Funksjonen til LFO-ene er å modulere delaytiden for å skape en chorus effekt. Den ene er forsinket en halv fase for å "tjukne" choruse effeten.
; 
; j.
; Hvis vi hadde hadd feedback i tillegg i chorus effekten ville den a blitt chorus effekten blirr med fremhevet, den ville blitt mer intens og fått litt sånn metallisk shimmer kanskje.
;
; 2b) Utvid og eksperimenter
;
; k. Har prøvd ut med et fiolinsample jeg lagde og det hørtes mer rotete ut enn gitaren.
;
; l. Wet/dry miksing er allerede implementert i dette eksempelet. Linje 26 lager miks rslider-en og linje 79 og 80 er allerede på formatet oppgaven spør etter.
;
; m. Når jeg satte offsetten til en fast verdi på 5ms så ble det mye hakking og hopping i lyden. Det hørtes ut som den drev å hoppe litt inn og ut på et vis og forskjøvet mellom ørene.

<Cabbage>
form caption("StereoChorus") size(400, 300), guiMode("queue") pluginId("def1")
rslider bounds(296, 162, 100, 100), channel("gain"), range(0, 1, 0.9, 1, .01), text("Gain"), trackerColour("lime"), outlineColour(0, 0, 0, 50), textColour("black")
;rslider bounds(100, 100, 100, 100), channel("delaytid"), range(0, 1, 0.01, 0.5, 0.00001), text("delaytid")
rslider bounds(10, 10, 100, 100), channel("dybde"), range(0, 1, 0.9, 1, 0.001), text("dybde")
rslider bounds(200, 10, 100, 100), channel("frek"), range(0, 20, 0.2, 1, 0.001), text("frek")
;rslider bounds(300, 10, 100, 100), channel("feedb"), range(0, 1, 0.5, 1, 0.001), text("Feedb")
rslider bounds(300, 10, 100, 100), channel("miks"), range(0, 1, 0.5, 1, 0.001), text("Miks")
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

;a1 diskin2  "Fele2.wav", 1, 4
; For chorus hører man lettest effekten med et akkordinstrument som f.eks. gitar
a1, a2 diskin2  "ClassicalGuitar.wav", 1, 0, 1
;a1, a2 diskin2  "fiolin.wav", 1, 0, 1 ; Egenlagd fiolinsample
a2 = a1

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
