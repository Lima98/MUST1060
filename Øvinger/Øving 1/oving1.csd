<CsoundSynthesizer>

<CsOptions>
-odac
</CsOptions>

<CsInstruments>
sr = 44100 ; sample rate
ksmps = 32 ; control rate
nchnls = 2 ; number of channels
0dbfs = 1 ; maximum amplitude (0dB)

;bassline
instr bass
iTone = cpspch(p5)

aSub  oscils  p4,   iTone*0.5,  1   ;sub-octave bass
aMain vco2    p4,   iTone,      12  ;main bass 

aEnv  linen p4, 0,  p3, 0.5
aBass = (aSub + aMain)*aEnv

outs aBass, aBass

endin

;marmonic pad
instr pad
if p6 == 0 then;          major
  iRoot = cpspch(p5)
  i3rd  = cpspch(p5 + 0.04)
  i5th  = cpspch(p5 + 0.07)
  print iRoot
  print i3rd
  print i5th
  prints "major-----------------------" 

elseif p6 == 1 then;      minor
  iRoot = cpspch(p5)
  i3rd  = cpspch(p5 + 0.03)
  i5th  = cpspch(p5 + 0.07)
  print iRoot
  print i3rd
  print i5th
  prints "minor-----------------------"

else;                     error
  prints "Invalid chord quality"
  turnoff
endif  

;make audio of chord tones
aRoot  vco2   p4,   iRoot, 12
a3rd   vco2   p4,   i3rd,  12
a5th   vco2   p4,   i5th,  12

aEnv  cosseg  p4/2,  p3, p4

;build chord audio
aChord = (aRoot + a3rd + a5th)*aEnv

outs aChord, aChord

endin

;melody
instr melody
iTone = cpspch(p5)

aTone  oscils  p4,   iTone,  1
aEnv  madsr 0.2,  0.1, p4, 0.05
aTone = aTone * aEnv

outs aTone, aTone

endin

;ostinato (detail)
instr ostinato
ifn  = 0;   table number for cyclic decay buffer(?)
imeth = 1;  method of pluck, this sounded like what I wanted
iTone = cpspch(p5)

asig pluck p4, iTone, iTone, ifn, imeth, .1, 10
;her er omhylningskurve på en måte en del av pluck-en så lagde ikke egen her

outs asig, asig
endin

</CsInstruments>

<CsScore>
;p1       p1    p3  p4    p5    p6

;BASSLINE --------------------------
;p1       p1    p3  p4    p5    
;instr    start dur amp   tone    
i "bass"  0     2   0.6   7.04; E
i "bass"  +     2   .     7.03; D#
; barline
i "bass"  +     2   .     7.01; C#
i "bass"  +     2   .     6.11; B
; barline
i "bass"  +     2   .     7.04; E
i "bass"  +     2   .     7.03; D#
; barline
i "bass"  +     2   .     7.01; C#
i "bass"  +     2   .     6.11; B
; barline
; barline
i "bass"  +     2   .     6.09; A
i "bass"  +     2   .     6.08; G#
; barline
i "bass"  +     2   .     6.06; F#
i "bass"  +     2   .     6.04; E
; barline
i "bass"  +     2   .     6.09; A
i "bass"  +     1   .     6.08; G#
i "bass"  +   0.5   .     6.09; A
i "bass"  +   0.5   .     6.11; B
; barline
i "bass"  +     1   .     6.00; C
i "bass"  +     1   .     6.10; Bb
i "bass"  +     1   .     6.09; A
i "bass"  +     1   .     6.06; F#
; barline
i "bass"  +     4   .     6.04; E
;BASSLINE --------------------------

;PAD -------------------------------
;p1       p1    p3  p4    p5    p6
;instr    start dur amp   tone  qual(0=maj, 1=min)
i "pad"   0     4   0.3   8.04  0; Emaj
;  barline
i "pad"   +     4   0.3   8.06  1; F#min
;  barline
i "pad"   +     4   0.3   8.04  0; Emaj
;  barline
i "pad"   +     4   0.3   8.06  1; F#min
;  barline
;  barline
i "pad"   +     4   0.3   8.09  0; Amaj
;  barline
i "pad"   +     4   0.3   8.06  0; F#min 
;  barline
i "pad"   +     4   0.3   8.09  0; Amaj
;  barline
i "pad"   +     2   0.3   8.00  0; Cmaj
i "pad"   +     2   0.3   8.02  0; Dmaj
;  barline
i "pad"   +     4   0.3   7.04  0; Emaj
;PAD END --------------------------

;MELODY ---------------------------
;p1         p1    p3  p4    p5
i "melody"  0     1   0.8   8.04 
i "melody"  +     1   0.8   8.08 
i "melody"  +     1   0.8   8.03 
i "melody"  +     1   0.8   8.06
;  barline
i "melody"  +     2   0.8   8.01
i "melody"  +     2   0.8   8.03
;  barline
i "melody"  +     1   0.8   8.04 
i "melody"  +     1   0.8   8.08 
i "melody"  +     1   0.8   8.03 
i "melody"  +     1   0.8   8.06
;  barline
i "melody"  +     2   0.8   8.09
i "melody"  +     1   0.8   8.08
i "melody"  +     1   0.8   8.06
;  barline
;  barline
i "melody"  +     2   0.8   8.09
i "melody"  +     2   0.8   8.11
;  barline
i "melody"  +     2   0.8   8.04 
i "melody"  +     1   0.8   8.08 
i "melody"  +     1   0.8   8.06
;  barline
i "melody"  +     2   0.8   8.08
i "melody"  +     2   0.8   8.06
;  barline
i "melody"  +     2   0.8   8.07
i "melody"  +     2   0.8   8.06
;  barline
i "melody"  +     4   0.8   8.04
;  barline
;MELODY END -----------------------

;OSTINATO -------------------------
i "ostinato"  0   0.5   0.2   9.04
i "ostinato"  +   .     .     9.06
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
;  barline
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
;  barline
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
;  barline
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
;  barline
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
;  barline
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
;  barline
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
;  barline
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
i "ostinato"  +   .     .     9.04
i "ostinato"  +   .     .     9.06
;  barline
i "ostinato"  +   2     .     9.06
i "ostinato"  +   2     .     9.04
;OSTINATO END ---------------------


</CsScore>

</CsoundSynthesizer>
