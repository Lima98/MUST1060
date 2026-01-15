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
iFrek cpsmidib 7 ; get note from midi intrument
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

