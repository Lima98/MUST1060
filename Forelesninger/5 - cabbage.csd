<Cabbage>
form caption("Synth") size(800, 500), guiMode("queue"), pluginId("MISy")
;pluginId important when importing to a DAW, ID needs to be unique, only four characters
keyboard bounds(60, 366, 700, 120)
;x, y placement, x, y size

vslider bounds(-292, 296, 800, 72) text("Vol") textColour(255, 255, 255, 255) range(0, 1, 0, 1, 0.01) channel("volume")
rslider bounds(254, 210, 164, 154) text("Att") textColour(255, 255, 255, 255) range(0.0001, 3, 0.1, 1, 0.01) channel("att")
button  bounds(516, 296, 245, 47)   text("Rev") textColour("White") colour:0("Red") colour:1("Green")  channel("rev")
combobox bounds(278, 28, 120, 40) items("Sagtann", "Triangel", "Firkant", "Impuls") value(1) channel("waveform")
; min max default linear step


</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 --midi-key-cps=4 --midi-velocity-amp=5
;n and d            dont write sound and console output
;-+rtmidi=NULL      just has to be there for cabbage
;M0                 use midi
;--midi-key-cps=4   not strictly necessary, a way to make csound use p4 as cps and p5 as amp
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
ksmps = 32
nchnls = 2
0dbfs = 1

giWave  ftgen 0, 0, 5, -2, 0, 12, 10, 6

gaSend init 0

;instrument will be triggered by keyboard widget
instr 1

    kVol    chnget "volume"         ; Get vol from cabage channel
    iAtt    chnget "att"

    iIndex chnget "waveform"
    iWaveform table iIndex-1, giWave

    kEnv    madsr iAtt, .2, .6, .4
    aOut    vco2 p5*kVol, p4, iWaveform

    gaSend = gaSend + aOut*kEnv
endin

instr 2
   aRevL, aRevR reverbsc gaSend, gaSend, 0.8, 8000 
   kRev chnget "rev"

   outs gaSend + aRevL * kRev, gaSend + aRevR * kRev
   gaSend = 0
endin

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0  z
i2  0   z
</CsScore>
</CsoundSynthesizer>
