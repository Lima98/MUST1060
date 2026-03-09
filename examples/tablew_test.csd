<CsoundSynthesizer>
<CsOptions>
-odac -d -Ma
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

giTab ftgen 0, 0, 8, -2, 0
giInd init 0

instr 1
iNote notnum
	tablew iNote, giInd, giTab
	ftprint giTab

if giInd <= 8 then
 giInd += 1
elseif giInd > 8 then
 giInd = 0
endif


endin

</CsInstruments>
<CsScore>
f0 z
</CsScore>
</CsoundSynthesizer>
