; 3a) Forstå oppbyggingen
;
; n. Delay-biten av koden er helt lik, alstå linjene med delayr, deltap3 og delayw. Det er en wet-dry mix i stereodelay-koden som det ikke er i flangeren. Av en eller annen grunn så er ksmsps satt til 16 i flanger, men 32 i stereodelay. aDelTid blir ganget med 0.01 i flangeren, dette er vel den største forskjellen jeg ser. I tillegg til at det er stereo i delaykoden og ikke stereo i denne.
;
; o. Default samplerate er 44100 så iOffset regnes da ut ved 16/44100 som er 0,0003628118, men i eksempelet er den på 0.00034, dette kan være fordi det er nærmere hvis man bruker samplerate på 48000 da får vi 0,0000333333 som forsåvidt kan rundes opp til verdien i eksempelet. Jeg antar at  funksjonen til denne verdien er å forskyve LFO-en for å unngå delaytid på 0 som i stereodelay-eksempelet.
;
; p. Mangel på ordentlig miksin kan føre til clipping da lysignalene bare blir summert sammen og kan bli for høye.
;
; 3b) Utvid
;
; q. Wet/dry miks er implementert som ønsket.
;
; r. Hører ikke mye forskjell, men føler det dukker opp litt artefakter på 32 som jeg ikke hører på 16.
;
; s. Når jeg bruker andre lydfiles som er mer tonale or harmoniske lage flangeren en "styggere" klagn, mens på tormmesample får den en sånn kul metallisk klang på et vis. Jeg tror det har noe med å gjøre at trommesamplet består av kortere lyder som ikke klinger lenge og den har ikke noe særlig tydelig tonalitet som gjør at lyden blir en effekt. Mens på med tonale lyder så blir lyden styggere fordi det legges oppå lyden igjen og "ødelegger" tonaliteten/klangen. Det kan absolutt fungere som en effekt, men jeg syntes det funket best med trommesamplet.
<Cabbage>
form caption("Flanger") size(400, 300), guiMode("queue") pluginId("Flng")
rslider bounds(296, 162, 100, 100), channel("gain"), range(0, 1, 0.9, 1, .01), text("Gain"), trackerColour("lime"), outlineColour(0, 0, 0, 50), textColour("white")
;rslider bounds(100, 100, 100, 100), channel("delaytid"), range(0, 1, 0.01, 0.5, 0.00001), text("delaytid")
rslider bounds(10, 10, 100, 100), channel("dybde"), range(0, 1, 0.9, 1, 0.001), text("LFOdybde") textColour("white")
rslider bounds(200, 10, 100, 100), channel("frek"), range(0, 10, 0.2, 1, 0.001), text("LFOfrek") textColour("white")
rslider bounds(300, 10, 100, 100), channel("feedb"), range(0, 1, 0.5, 1, 0.001), text("Feedb") textColour("white")
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

;a1 diskin2  "Fele2.wav", 1, 4
;a1, a2 diskin2  "ClassicalGuitar.wav", 1
; For flanger er det lettest å bruke et trommesample
a1, a2 diskin2  "140_superjazzy-drum-odys.aif", 1, 0, 1
;a2 = a1

kDelTid chnget "delaytid"
kDybde chnget "dybde"
kFrek chnget "frek"
kFeedb chnget "feedb"
kMiks  chnget "miks"

kDelTid port kDelTid, 0.05
aDelTid = a(kDelTid)*0.01

; To LFOer
kDybde = kDybde*0.0006
aLFO   poscil  kDybde, kFrek
aLFO2  poscil  kDybde, kFrek, giSinus, 0.5   ; Den ene i motfase
iOffset = 0.00067  ; Tilsvarer ksmps/sr som jeg snakket om
                                
aDelTid  = aLFO + kDybde + iOffset
aDelTid2 = aLFO2 + kDybde + iOffset

; OBS! vdelay bruker ms
iMaxDel = 1
aDelay init     0

; Stereo = to delaylinjer som bruker hver sin LFO
aMaxDel  delayr iMaxDel
aDelay   deltap3 aDelTid
         delayw  a1 + aDelay * kFeedb
         
aMaxDel  delayr iMaxDel
aDelay2  deltap3 aDelTid
         delayw  a2 + aDelay2 * kFeedb

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
