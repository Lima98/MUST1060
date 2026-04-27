#set page(
  paper: "a4",
  margin: (x: 1.8cm, y: 1.8cm),
)

#set text(
  lang: "nb",
  size: 10.5pt,
)

#set par(
  justify: true,
  leading: 0.62em,
)

#show heading.where(level: 1): it => block(above: 0.9em, below: 0.35em)[
  #text(13pt, weight: "bold")[#it.body]
]

#show heading.where(level: 2): it => block(above: 0.55em, below: 0.2em)[
  #text(10.5pt, weight: "bold")[#it.body]
]

= Semesterrapport MUST1060

Prosjektet mitt er et Csound-instrument som tar imot MIDI-toner og omintonerer dem fra lik temperering til ren stemming (just intonation). Målet var å lage et verktøy som gjør det mulig å høre forskjellen mellom vanlig tangentbordsstemming og rene intervaller i akkorder. I tillegg ville jeg koble dette til en enkel lydprosesseringseffekt, slik at prosjektet både inneholder lydgenerering og lydprosessering, slik oppgaven krever.

== Idé

Ideen kom fra interesse for musikkteori, korintonasjon og forholdet mellom harmonikk og stemming. På et vanlig MIDI-keyboard er alle intervaller låst til 12-delt lik temperering, men i ensemblesang og strykerpraksis justeres ofte intervaller mot enklere frekvensforhold. Jeg ønsket derfor å lage et program som beregner slike justeringer i sanntid, slik at akkorder kan oppleves som mer stabile og ``rene``. Den musikalske tanken var at dette både kunne fungere som et pedagogisk verktøy og som et kreativt klangverktøy.

== Prosess

Arbeidsprosessen startet med en enkel versjon der alle aktive toner ble lagret i en global tilstand, og der den laveste holdte tonen ble brukt som grunntone. Denne løsningen fungerte som et første bevis på konseptet, og gjorde det mulig å teste tabeller med cent-avvik for de tolv intervallklassene. Deretter lagde jeg en mer avansert live-versjon der grunntonen ikke nødvendigvis er den laveste tonen, men den eldste holdte tonen. Dette gjør det lettere å spille omvendinger uten at hele akkorden retunes på en uønsket måte.

Underveis brukte jeg både teknikker fra undervisningen og selvstudium i Csound-dokumentasjon. Særlig gjaldt dette arbeid med arrays, egne opcodes, MIDI-håndtering, tabelloppslag og sanntidsoppdatering av global tilstand. Jeg brukte også utskrift av tabeller i konsollen som et verktøy for å feilsøke hvilke toner systemet oppfattet som aktive, hvilken tone som ble valgt som grunntone, og hvilke frekvensforhold som faktisk ble brukt.

== Teknisk løsning

Den grunnleggende lydgeneratoren er enkel: hver MIDI-tone blir lest inn med note-nummer og anslagsstyrke, og frekvensen blir deretter justert med en cent-verdi hentet fra en tabell over intervallforskyvninger. I den enkle versjonen blir resultatet spilt av med en sinusoscillator, slik at det er lett å høre intonasjonsforskjellene tydelig. I live-versjonen kan samme tuningmotor enten sende signalet til en ren referanselyd eller til en carrier for en vocoder.

Lydprosesseringen i prosjektet ligger i vocoder-delen av live-versjonen. Her bygges et harmonisk carrier-signal opp fra de stemte tonene, mens mikrofoninngang analyseres spektralt og brukes til å forme carrier-signalet. Dette er løst med FFT-baserte opkoder som analyserer både mikrofon og carrier, filtrerer spekteret og syntetiserer resultatet tilbake til lyd. På denne måten blir prosjektet ikke bare et stemmingsverktøy, men også et instrument der menneskestemme eller andre inngangssignaler kan prege klangen.

== Evaluering og refleksjon

Jeg synes prosjektet lykkes best når det gjelder selve hovedideen: det demonstrerer tydelig hvordan ren stemming kan implementeres og høres i praksis, og det viser også en musikalsk interessant kobling mellom stemming og klangprosessering. Samtidig er løsningen ikke helt perfekt. Systemet er avhengig av regler for hvilken tone som skal tolkes som grunntone, og dette kan fortsatt gi overraskende resultater i enkelte spillesituasjoner, særlig hvis toner trykkes ned eller slippes på måter som ikke samsvarer med den harmoniske funksjonen brukeren tenker seg.

Hvis jeg skulle videreutviklet prosjektet, ville jeg lagt til bedre kontroll over valg av grunntone, for eksempel med MIDI-kontroller, pedal eller en eksplisitt ``hold root``-funksjon. Jeg ville også jobbet videre med brukergrensesnitt og preset-løsninger for ulike stemmingssystemer. Alt i alt mener jeg at prosjektet viser både teknisk forståelse og en selvstendig musikalsk idé, samtidig som det har tydelige forbedringsmuligheter som har gjort arbeidsprosessen lærerik.
