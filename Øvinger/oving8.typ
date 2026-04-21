#show table.cell: it => {
  if it.x == 0 or it.y == 0 {
    text(size: 12pt, strong(it))
  } else if it.body == [] {
    // Replace empty cells with 'N/A'
    pad(..it.inset)[_N/A_]
  } else {
    it
  }
}

#set page(
  header: align(right,"Øving 8 - Jan-Øivind Lima"),
)

= Oppgave 4 - Sammenlign og forstå effektene

Det er i hovedsak tre ting som skiller de forskjellige effektene. Dette er _delaytid_, _feedback_ og _modulasjon_. I @comparison ser vi en liten sammenligning av hvordan disse tre parameterne er innstillt på de forskjellige effektene i grove trekk.

#figure(
  table(columns: 4, 
  [],[*Chorus*], [*Delay*], [*Flanger*],
  [*Delaytid*], [Medium (20-50ms ish)], [Lang (50ms+, kan være opp i sekunder)], [Veldig Kort (rundt 1-5ms)],
  [*Feedback*], [Lav], [Høy (ofte for gjentakende lyd)], [Høy (for å skape den skarpe lyden)],
  [*(LFO)Modulasjon*], [Ja (svingene modulasjon skaper effekten av "korklang")], [Nei (man kan ha, men det blir modulert delay)], [Ja (dette skaper sånn svingende "jet plane" lyd som man kan kalle det)],
),
caption: [Sammenligning av effekter]
)<comparison>


= Oppgave 5 - Kreativt element: Komposisjonsøvelse

== v. 
Jeg valgte chorus effekten, jeg endret en del farger til en finere palett og la til et bagrunnsbilde av et kor med litt lav opacity. Endret også parameterene til å ha en passende chorus effekt ved oppstart.

== w.
Eksporterte pluggen til DAW, men får ikke noe lyd igjennom. Har prøvd å koble opp på forskjellige måter inne i patcheren i cabbage, men det kommer ikke noe lyd igjennom. Jeg sender lydfil igjennom den, men det blir bare helt stille...

== x.
Får ikke gjort dette på en god måte uten å få lyden igjennom.

== y.
Jeg valgte chorus effekten fordi jeg syntes det er en behagelig effekt, såfremt den ikke er overdrevet. Jeg liker å leke med harmonier og klang og da å kunne eksperimentere med hvordan chorus effekten høres ut i forskjellige akkorder og klanger tenkte jeg var interessant. Jeg hadde håpet å kunne lage en liten kor aktig sats med en synth lyd og deretter variere chorus effekten til å fremheve det musikalske, for eksempel ved forholdninger legger på mer intens chorus for å øke spenningen mer og så dempe til en mer behagelig chorus ved oppløsning for å forsterke følelsen. Og kanskje gjøre motsatt andre steder for å se hvordan det føles med en "fin" forholdning som går inn i en mer "skitten" chorus ved oppløsning for en artig kontrast på et vis. 

