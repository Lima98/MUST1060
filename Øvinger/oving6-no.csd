<Cabbage>
form caption("Cabbage Sequencer/Arpeggiator") size(420, 200)
rslider bounds(20, 20, 100, 100) channel("tempo") range(60, 240, 120, 1, 1) text("Tempo")
label bounds(140, 20, 200, 20) text("Step Pattern (1=on", "0=off):") channel("label3")
numberbox bounds(140, 50, 40, 20) channel("step1") range(0, 1, 1, 1, 1)
numberbox bounds(190, 50, 40, 20) channel("step2") range(0, 1, 1, 1, 1)
numberbox bounds(240, 50, 40, 20) channel("step3") range(0, 1, 1, 1, 1)
numberbox bounds(290, 50, 40, 20) channel("step4") range(0, 1, 1, 1, 1)
label bounds(140, 80, 200, 20) text("Arp Notes (MIDI):")
numberbox bounds(140, 110, 40, 20) channel("note1") range(60, 84, 60, 1, 1)
numberbox bounds(190, 110, 40, 20) channel("note2") range(60, 84, 64, 1, 1)
numberbox bounds(240, 110, 40, 20) channel("note3") range(60, 84, 67, 1, 1)
numberbox bounds(290, 110, 40, 20) channel("note4") range(60, 84, 72, 1, 1)
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-d -odac -b128 -B256
</CsOptions>

<CsInstruments>
sr      = 44100
kr      = 4410
nchnls  = 2
0dbfs   = 1

giSteps ftgen 0, 0, 4, -2, 1, 1, 1, 1   ; default: all steps on
giNotes ftgen 0, 0, 4, -2, 60, 64, 67, 72 ; default: C E G C

kTempo chnget "tempo"

kStep1 chnget "step1"
kStep2 chnget "step2"
kStep3 chnget "step3"
kStep4 chnget "step4"

kNote1 chnget "note1"
kNote2 chnget "note2"
kNote3 chnget "note3"
kNote4 chnget "note4"

; Write GUI values to tables
tablew kStep1, 0, giSteps
tablew kStep2, 1, giSteps
tablew kStep3, 2, giSteps
tablew kStep4, 3, giSteps
tablew kNote1, 0, giNotes
tablew kNote2, 1, giNotes
tablew kNote3, 2, giNotes
tablew kNote4, 3, giNotes

instr 1 ; Sequencer/Arp master
    kTrig metro (kTempo/60) ; trigger at tempo
    if kTrig == 1 then
        kndx init 0
        kndx = (kndx + 1) % 4
        kStep table kndx, giSteps
            if kStep == 1 then
            kNote table kndx, giNotes
            event "i", 2, 0, 0.2, kNote
        endif
    endif
endin

instr 2 ; Simple synth voice
    iNote = p4
    aEnv linseg 0, 0.01, 1, 0.18, 0
    aSig oscili 0.2*aEnv, cpsmidinn(iNote)
    outs aSig, aSig
endin

</CsInstruments>
<CsScore>
i1 0 z
</CsScore>
</CsoundSynthesizer>
