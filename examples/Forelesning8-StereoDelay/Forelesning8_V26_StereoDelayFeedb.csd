; 1a) Forstå oppgaven
; a.
; delayr leser fra delaylinja. Tar inn maks delaytid som argument for å sette størrelsen på delaylinja
; deltap3 leser fra delaylinja med interpolasjon, og tar delaytid som argument
; delwayw skriver lydsignaled til delaylinja. Lydsignalet er argumentet
;
; b.
; kDelTid konvereres til a-rate for å minske "hakking" ved endringer i delaytid da k-rate er så pass sakte.
; 
; c.
; Poenget med port-opkoden er å glatte ut endringene i delaytid, slik at det ikke blir hakkete endringer i lyden. Uten portamento vil det kunne oppstå klikk og andre uønskede artefakter når delaytiden endres, spesielt hvis det skjer raskt eller i store hopp.
;
; d.
; Dette offsettet på 0.0007 sekunder er nødvendig for å unngå at delaytid blir 0, noe som kan føre til uønskede artefakter
;
; 1b) Legg til og eksperimenter med GUI-kontrollere
;
; e. De to sterokanalene kontrollerer delaytiden for hver kanal individuelt. Man hører det tydelig at ene øret får annet delay enn andre. Delaytid2 tar høyre øret og delaytid tar venstre.
;
; f. Når jeg satte opp halveringstiden til 0.5 så ble det en skikkelig "slide" effekt på delayet, kunne høres litt ut som en sånn slide-gitar effekt. Det føltes også mye "seigere" å justere, da det gikk lengre tid å bytte til ny delaytid. Når jeg satte den lavere, til 0.005 så ble den responsiv, men jeg fikk mye rare artefakter som hakking og litt sånn "sjøsyk" lyd.
;
; g. Ved å styre begge feedbackene med en slider og ha de relative til hverandre får vi en slags pseudo-ping-pong delay siden det ene øret alltid er litt lengre bak enn det andre.
<Cabbage>
form caption("StereoDelay") size(400, 300), guiMode("queue") pluginId("StDl")
rslider bounds(296, 162, 100, 100), channel("gain"), range(0, 1, 0.9, 1, .01), text("Gain"), trackerColour("lime"), outlineColour(0, 0, 0, 50), textColour("black")
rslider bounds(100, 100, 100, 100), channel("delaytid"), range(0, 1, 0.1, 0.5, 0.00001), text("delaytid") textColour("white")
rslider bounds(10, 10, 100, 100), channel("delaytid2"), range(0, 1, 0.1, 0.5, 0.001), text("delaytid2") textColour("white")
rslider bounds(200, 10, 100, 100), channel("frek"), range(0, 20, 0.2, 1, 0.001), text("frek")
rslider bounds(300, 10, 100, 100), channel("feedb"), range(0, 0.9999, 0.5, 1, 0.001), text("Feedb")
rslider bounds(10, 180, 100, 100), channel("miks"), range(0, 1, 0.5, 1, 0.001), text("Miks") textColour("white")

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

a1 diskin2  "Fele2.wav", 1, 4.5, 1
a2 = a1

; Hver kanal har sin egen delaytid for å fremme stereobildet
kDelTid chnget "delaytid"
kDelTid2 chnget "delaytid2"
kDybde chnget "dybde"
kFrek chnget "frek"
kFeedb chnget "feedb"
kMiks  chnget "miks"

kDelTid port kDelTid, 0.05  ; Portamento glatter ut verdiene fra GUI
kDelTid2 port kDelTid2, 0.05
aDelTid = a(kDelTid) + 0.0007  ; Vi gjør om til a-rate (med interpolasjon)
aDelTid2 = a(kDelTid * 1.03) + 0.0007  ; Vi gjør om til a-rate (med interpolasjon)

iMaxDel = 1
aDelay init     0

aMaxDel  delayr iMaxDel               
aDelay   deltap3 aDelTid              
         delayw  a1 + aDelay * kFeedb 
         
aMaxDel  delayr iMaxDel
aDelay2  deltap3 aDelTid2
         delayw  a2 + aDelay2 * kFeedb

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
