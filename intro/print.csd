<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
sr = 44100 ; samplingsrate
kr = 441 ; kontrollrate
nchnls = 2 ; antall kanaler
0dbfs = 1 ; maks nivå (0dB)

instr bass
aLyd oscil 10000, 440
out aLyd
endin


</CsInstruments>
<CsScore>
i1 0 2
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
 <bgcolor mode="background">
  <r>240</r>
  <g>240</g>
  <b>240</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
