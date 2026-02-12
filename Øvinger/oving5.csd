<Cabbage> bounds(0, 0, 0, 0)

form caption("Lima Synth") size(700, 500), guiMode("queue"), pluginId("LimS")
keyboard bounds(14, 398, 675, 95)

groupbox bounds(236, 104, 230, 177) channel("groupbox10021") text("Reverb")
groupbox bounds(4, 4, 219, 393) channel("groupbox10022") text("Synth 1")
groupbox bounds(478, 0, 220, 395) channel("groupbox10023") text("Synth 2")

combobox bounds(110, 28, 106, 29) channel("s1_wave") text("Sawtooth", "Sine", "Triangle", "Square") popupText("Synth 1 waveform") value(2)
rslider bounds(20, 28, 60, 60) channel("s1_amp") range(0, 1, 0.5, 1, 0.001) text("Amp") textColour(0, 255, 96, 255) popupText("Synth 1 amplitude")

hslider bounds(84, 58, 133, 27) channel("s1_att") range(0.0001, 2, 0.1, 1, 0.001) text("Attack") textColour(69, 255, 26, 255) 
hslider bounds(84, 80, 133, 27) channel("s1_dec") range(0.0001, 2, 0.1, 1, 0.001) text("Decay") textColour(69, 255, 26, 255) 
hslider bounds(84, 102, 133, 28) channel("s1_sus") range(0.0001, 1, 0.5, 1, 0.001) text("Sustain") textColour(69, 255, 26, 255) 
hslider bounds(84, 126, 133, 27) channel("s1_rel") range(0.0001, 2, 0.1, 1, 0.001) text("Release") textColour(69, 255, 26, 255) 

rslider bounds(24, 98, 50, 50) channel("s1_det") popupText("Detune in cents") range(-50, 50, 0, 1, 1) text("Detune") textColour(49, 238, 45, 255) 

combobox bounds(492, 26, 106, 31) channel("s2_wave") text("Sawtooth", "Sine", "Triangle", "Square") popupText("Synth 2 waveform") value(2)
rslider bounds(622, 26, 60, 60) channel("s2_amp") range(0, 1, 0.5, 1, 0.001) text("Amp") textColour(132, 243, 106, 255) popupText("Synth 2 amplitude") 

hslider bounds(488, 58, 133, 27) channel("s2_att") range(0.0001, 2, 0.1, 1, 0.001) text("Attack") textColour(69, 255, 26, 255) 
hslider bounds(488, 78, 133, 27) channel("s2_dec") range(0.0001, 2, 0.1, 1, 0.001) text("Decay") textColour(69, 255, 26, 255) 
hslider bounds(488, 98, 133, 27) channel("s2_sus") range(0.0001, 1, 0.5, 1, 0.001) text("Sustain") textColour(69, 255, 26, 255) 
hslider bounds(488, 122, 133, 27) channel("s2_rel") range(0.0001, 2, 0.1, 1, 0.001) text("Release") textColour(69, 255, 26, 255) 

rslider bounds(630, 96, 50, 50) channel("s2_det") popupText("Detune in cents") range(-50, 50, 0, 1, 1) text("Detune") textColour(49, 238, 45, 255) 

rslider bounds(260, 202, 60, 60) channel("g_rev_cut") popupText("Lowpass cutoff") range(20, 20000, 3000, 1, 10) text("Cutoff") textColour(48, 255, 79, 255)
rslider bounds(310, 122, 80, 80) channel("g_rev") range(0, 1, 0, 1, 0.001) identChannel("Global Reverb") text("Reverb") popupText("Global Reverb") textColour(111, 255, 49, 255)
rslider bounds(384, 202, 60, 60) channel("g_rev_fed") range(0.5, 1, 0.8, 1, 0.001) text("Feedback") popupText("Reverb feedback") textColour(99, 255, 62, 255)

rslider bounds(298, 0, 100, 100) channel("g_vol") range(0, 1, 0.2, 1, 0.001) text("Volume") popupText("Global Volume") textColour(42, 255, 62, 255)

hrange bounds(10, 156, 202, 40) channel("s1_hp", "s1_lp") max(20000) min(0) range(0, 20000, 0:20000, 1, 0.001) text("Filter") popupText("Low and highpass")
hrange bounds(490, 154, 202, 40) channel("s2_hp", "s2_lp") max(20000) min(0) range(0, 20000, 0:20000, 1, 0.001) text("Filter") popupText("Low and highpass")

rslider bounds(310, 288, 70, 70) channel("g_sub") range(0, 1, 0, 1, 0.001) text("Sub") popupText("Sub sine") textColour(50, 248, 57, 255)
vslider bounds(488, 214, 50, 150) channel("s2_noi") range(0, 1, 0, 1, 0.001) text("Noise") popupText("White noise") textColour(49, 238, 67, 255)
vslider bounds(164, 220, 50, 150) channel("s1_noi") range(0, 1, 0, 1, 0.001) text("Noise") popupText("White noise") textColour(49, 238, 67, 255)

groupbox bounds(16, 204, 144, 180) channel("groupbox10027") colour(100, 100, 101, 255) text("Vibrato") fontColour(255, 255, 255, 255)
rslider bounds(26, 248, 50, 50) channel("s1_vib_amp") range(0, 1, 0, 1, 0.001) text("Amp") textColour(57, 255, 98, 255)
rslider bounds(92, 248, 50, 50) channel("s1_vib_frq") range(0.001, 0.1, 0.05, 1, 0.001) text("Freq.") textColour(80, 255, 96, 255)
button bounds(44, 320, 80, 40) channel("s1_vib_tgl") text("Vib. off", "Vib. on") colour:0(123, 0, 0, 255) colour:1(52, 111, 0, 255)

groupbox bounds(546, 200, 144, 180) channel("groupbox10026") colour(100, 100, 101, 255) text("Vibrato") fontColour(255, 255, 255, 255)
rslider bounds(556, 242, 50, 50) channel("s2_vib_amp") range(0, 1, 0, 1, 0.001) text("Amp") textColour(57, 255, 98, 255)
rslider bounds(626, 242, 50, 50) channel("s2_vib_frq") range(0.001, 0.1, 0.05, 1, 0.001) text("Freq.") textColour(80, 255, 96, 255)
button bounds(580, 316, 80, 40) channel("s2_vib_tgl") text("Vib. off", "Vib. on") colour:0(123, 0, 0, 255) colour:1(52, 111, 0, 255)
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
ksmps = 32
nchnls = 2
0dbfs = 1

giWave  ftgen 0, 0, 5, -2, 0, 12, 10, 6

gaSend init 0

instr 1
    
; ////////////////////////// SYNTH 1 /////////////////////////
    k1_amp  chnget  "s1_amp"
    i1_att  chnget  "s1_att"
    i1_dec  chnget  "s1_dec"
    i1_sus  chnget  "s1_sus"
    i1_rel  chnget  "s1_rel"
    i1_det  chnget  "s1_det"
    k1_lp   chnget  "s1_lp"
    k1_hp   chnget  "s1_hp"
    k1_noi  chnget  "s1_noi"
    k1_via  chnget  "s1_vib_amp"
    k1_vif  chnget  "s1_vib_frq"
    k1_vib  chnget  "s1_vib_tgl"

    iIndex  chnget "s1_wave"
    iWave   table iIndex-1, giWave
    
    aLFO1    poscil p4*k1_vif, k1_via
    kVib1    =   p4 + aLFO1
    aVib1    vco2 p5*k1_amp, kVib1

    kEnv1    madsr i1_att, i1_dec, i1_dec, i1_rel 
    aOut1    vco2 p5*k1_amp, p4*cent(i1_det), iWave
    aVib1    poscil p5*k1_amp, p4+aLFO1
    
    aOut1 += aVib1*k1_vib
    
    
    aNoi    rand 0.5
    
    aOut1   += aNoi*k1_noi
    aOut1   butlp aOut1, k1_lp
    aOut1   buthp aOut1, k1_hp
; ////////////////////////// SYNTH 1 /////////////////////////

; ////////////////////////// SYNTH 2 /////////////////////////
    k2_amp  chnget  "s2_amp"
    i2_att  chnget  "s2_att"
    i2_dec  chnget  "s2_dec"
    i2_sus  chnget  "s2_sus"
    i2_rel  chnget  "s2_rel"
    i2_det  chnget  "s2_det"
    k2_lp   chnget  "s2_lp"
    k2_hp   chnget  "s2_hp"
    k2_noi  chnget  "s2_noi"
    k2_via  chnget  "s2_vib_amp"
    k2_vif  chnget  "s2_vib_frq"
    k2_vib  chnget  "s2_vib_tgl"

    iIndex  chnget "s2_wave"
    iWave   table iIndex-1, giWave
    
    aLFO2    poscil p4*k2_vif, k2_via
    kVib2    =   p4 + aLFO2
    aVib2    vco2 p5*k2_amp, kVib2

    kEnv2    madsr i2_att, i2_dec, i2_dec, i2_rel 
    aOut2    vco2 p5*k2_amp, p4*cent(i2_det), iWave
    aVib2    poscil p5*k2_amp, p4+aLFO2
    
    aOut2 += aVib2*k2_vib
    
    
    aNoi    rand 0.5
    
    aOut2   += aNoi*k2_noi
    aOut2   butlp aOut2, k2_lp
    aOut2   buthp aOut2, k2_hp
; ////////////////////////// SYNTH 2 /////////////////////////
    
    kSub    chnget "g_sub"
    aOutSub poscil kSub,  p4*0.5
    gaSend = gaSend + aOut1*kEnv1 + aOut2*kEnv2 + aOutSub
endin

instr 2
   kCut chnget  "g_rev_cut"
   kFed chnget  "g_rev_fed"
   kVol chnget  "g_vol"
   aRevL, aRevR reverbsc gaSend, gaSend, kFed, kCut 
   kRev chnget "g_rev"

   outs (gaSend*(1-kRev) + aRevL * kRev)*kVol, (gaSend*(1-kRev) + aRevR * kRev)*kVol
   gaSend = 0
endin


</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0  z
i2  0 z
</CsScore>
</CsoundSynthesizer>
