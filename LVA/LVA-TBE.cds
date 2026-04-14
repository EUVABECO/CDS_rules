CALC TBE_doses_received IS HIST(TBE,0,count)

CALC TBE_first_dose_valences IS HIST(TBE,1,valences)
CALC TBE_first_dose_age IS INTERVAL(BASE:dob,HIST(TBE,1,date))
CALC TBE_time_since_first_dose IS INTERVAL(HIST(TBE,1,date),BASE:eval)

CALC TBE_second_dose_valences IS HIST(TBE,2,valences)

CALC TBE_last_dose_date IS HIST(TBE,-1,date)
CALC TBE_last_dose_vaccine IS HIST(TBE,-1,vaccine)
CALC TBE_last_dose_booster IS HIST(TBE,-1,booster)

CALC TBE_d1d2 IS INTERVAL(HIST(TBE,1,date),HIST(TBE,1,date))

SYNTH ET-D1-TICO "ET-D1-TICO - 1st dose is inactivated whole vaccine against ET, Neudörfl strain (TICO, FSME) child or adult dose" IS ANY OF
  SYNTH:ET-D1-TICO-CHILD "ET-D1-TICO-CHILD - 1st dose Tico child or equivalent" = true
  SYNTH:ET-D1-TICO-ADLT "ET-D1-TICO-ADLT - 1st dose Tico adult or equivalent" = true

SYNTH ET-D1-TICO-CHILD "ET-D1-TICO-CHILD - 1st dose Tico child or equivalent" IS ALL OF CALC:TBE_first_dose_valences contains TBE-Neudorfl-PED

SYNTH ET-D1-TICO-ADLT "ET-D1-TICO-ADLT - 1st dose Tico adult or equivalent" IS ALL OF CALC:TBE_first_dose_valences contains TBE-Neudorfl-ADU

SYNTH ET-D2-TICO "ET-D2-TICO - 2nd dose is inactivated whole vaccine against ET, Neudörfl strain (TICO, FSME) child or adult dose" IS ANY OF
  SYNTH:ET-D2-TICO-CHILD "ET-D2-TICO-CHILD - 2nd dose Tico child or equivalent" = true
  SYNTH:ET-D2-TICO-ADLT "ET-D2-TICO-ADLT - 2nd dose Tico adult or equivalent" = true

SYNTH ET-D2-TICO-ADLT "ET-D2-TICO-ADLT - 2nd dose Tico adult or equivalent" IS ALL OF CALC:TBE_second_dose_valences contains TBE-Neudorfl-ADU

SYNTH ET-D2-TICO-CHILD "ET-D2-TICO-CHILD - 2nd dose Tico child or equivalent" IS ALL OF CALC:TBE_second_dose_valences contains TBE-Neudorfl-PED

TARGET TBE
FOLDER 0 "Zero dose"
  IF CALC:TBE_doses_received = 0

  RULE 0/01 "[11-15m] old, 0 dose: DUE from 12-15m"
    IF CALC:Age in 11m..15m
    DO Recommended
      Status DUE
      Age 12m..15m
  END RULE 0/01

  RULE 0/01 "[16m-18y] old, 0 dose: DUE ASAP"
    IF CALC:Age in 16m..18y
    DO Recommended
      Status DUE
      Age 16m
  END RULE 0/01
END FOLDER 0

FOLDER 1 "TICOVAC 0,25 mL (1 to 15y old)"
  IF ANY OF
  CALC:TBE_last_dose_vaccine = VAC0039 # TICOVAC 0,25 mL
  CALC:TBE_last_dose_vaccine = VAC0774 #FSME-IMMUN 0,25 mL

  FOLDER 11 "One dose"
    IF CALC:TBE_doses_received = 1

    RULE 11/01 "≤ 15y old, 1 dose TICOVAC 0,25 mL: To do 1 to 3m after LD"
      IF CALC:Age<=15y
      DO Recommended
        Status DUE
        Delay 1m..3m from CALC:TBE_last_dose_date
      MESSAGES  MSG91
    END RULE 11/01

    RULE 11/02 "≤ 15y old, 1 dose TICOVAC 0,25 mL, d1 ≤ 14d: message accelerated scheme possible with 1dose 14d after LD"
      IF ALL OF
        CALC:Age<=15y
        CALC:TBE_time_since_first_dose<=14d
      DO Neutral
      MESSAGES  MSG89 MSG114
    END RULE 11/02
  END FOLDER 11

  FOLDER 12 "Two doses"
    IF CALC:TBE_doses_received = 2

    RULE 12/01 "≤ 15y old, 2 doses TICOVAC 0,25 mL: To do 5 to 12m after LD"
      IF CALC:Age<=15y
      DO Recommended
        Status DUE
        Delay 5m..12m from CALC:TBE_last_dose_date
      MESSAGES  MSG109
    END RULE 12/01

    RULE 12/02 "≥ 16y old, 2 doses TICOVAC 0,25 mL: DUE 5 to 12m after LD with Ticovac 0,25 ?????????"
      IF CALC:Age>=16y
      DO Recommended
        Status DUE
        Delay 5m..12m from CALC:TBE_last_dose_date
      MESSAGES  MSG96
    END RULE 12/02
  END FOLDER 12

  FOLDER 13 "Three doses"
    IF CALC:TBE_doses_received = 3

    RULE 13/01 "3 doses Ticovac 0,25 mL: To do 3y after LD"
      IF CALC:Age>=12m
      DO Recommended
        Status DUE
        Delay 3y from CALC:TBE_last_dose_date
      MESSAGES  MSG93
    END RULE 13/01
  END FOLDER 13

  FOLDER 14 "Four doses and more OR LD is a booster"
    IF ANY OF
    CALC:TBE_doses_received>=4
    CALC:TBE_last_dose_booster = true

    RULE 14/01 "≥ 4 doses Ticovac 0,25 mL OR LD is a booster: To do 10y after LD"
      IF CALC:Age>=12m
      DO Recommended
        Status DUE
        Delay 10y from CALC:TBE_last_dose_date
      MESSAGES  MSG117
    END RULE 14/01
  END FOLDER 14
END FOLDER 1

FOLDER 2 "TICOVAC 0,5 mL (≥ 16y old)"
  IF ANY OF
  CALC:TBE_last_dose_vaccine = VAC0038 # TICOVAC 0,5 mL)
  CALC:TBE_last_dose_vaccine = VAC0575 # FSME-IMMUN)

  FOLDER 21 "One dose"
    IF CALC:TBE_doses_received = 1

    RULE 21/01 " ≥ 16y old, 1 dose TICOVAC 0,50 mL: To do 1 to 3m after LD"
      IF CALC:Age>=16y
      DO Recommended
        Status DUE
        Delay 1m..3m from CALC:TBE_last_dose_date
      MESSAGES  MSG91
    END RULE 21/01

    RULE 21/02 "≥16y old, 1 dose TICOVAC 0,50 mL, d1 ≤ 14d: message accelerated scheme possible with 1dose 14d after LD"
      IF ALL OF
        CALC:Age>=16y
        CALC:TBE_time_since_first_dose<=14d
      DO Neutral
      MESSAGES  MSG89 MSG114
    END RULE 21/02
  END FOLDER 21

  FOLDER 22 "Two dose"
    IF CALC:TBE_doses_received = 2

    RULE 22/01 "≥ 16y old, 2 doses TICOVAC 0,50 mL: To do 5 to 12m after LD"
      IF CALC:Age>=16y
      DO Recommended
        Status DUE
        Delay 5m..12m from CALC:TBE_last_dose_date
      MESSAGES  MSG100
    END RULE 22/01
  END FOLDER 22

  FOLDER 23 "Three doses"
    IF CALC:TBE_doses_received = 3

    RULE 23/01 "3 doses Ticovac 0,50 mL: To do 3y after LD"
      IF CALC:Age>=16y
      DO Recommended
        Status DUE
        Delay 3y from CALC:TBE_last_dose_date
      MESSAGES  MSG93
    END RULE 23/01
  END FOLDER 23

  FOLDER 24 "Four doses and more OR LD is a booster"
    IF ANY OF
    CALC:TBE_doses_received>=4
    CALC:TBE_last_dose_booster = true

    RULE 24/01 "≥ 4 doses Ticovac 0,50 mL OR LD is a booster: To do 10y after LD"
      IF CALC:Age>=16y
      DO Recommended
        Status DUE
        Delay 10y from CALC:TBE_last_dose_date
      MESSAGES  MSG117
    END RULE 24/01
  END FOLDER 24
END FOLDER 2

FOLDER 5 "ENCEPUR (≥ 12y old)"
  IF CALC:TBE_last_dose_vaccine = VAC0079 # ENCEPUR

  FOLDER 51 "One dose"
    IF CALC:TBE_doses_received = 1

    RULE 51/01 "≥ 12y old, 1 dose Encepur: To to 1 to 3m after LD"
      IF CALC:Age>=12y
      DO Recommended
        Status DUE
        Delay 1m..3m from CALC:TBE_last_dose_date
      MESSAGES  MSG91
    END RULE 51/01

    RULE 51/02 "≥12y old, 1 dose Encepur, d1 ≤ 7d: message accelerated scheme possible with 1dose 7d after LD"
      IF ALL OF
        CALC:Age>=12y
        CALC:TBE_time_since_first_dose<=7d
      DO Neutral
      MESSAGES  MSG118 MSG119
    END RULE 51/02
  END FOLDER 51

  FOLDER 52 "Two doses"
    IF CALC:TBE_doses_received = 2

    RULE 25/01 "≥ 12y old, 2 doses Encepur, d1d2 ≤ 14d: To do 21d after LD (accelerated scheme)"
      IF ALL OF
        CALC:Age>=12y
        CALC:TBE_d1d2<=14d
      DO Recommended
        Status DUE
        Delay 21d from CALC:TBE_last_dose_date
      MESSAGES  MSG104
    END RULE 25/01

    RULE 25/02 "≥ 12y old, 2 doses Encepur, d1d2 ≥ 15d: To do 9 to 12m after LD"
      IF ALL OF
        CALC:TBE_d1d2>=15d
        CALC:Age>=12y
      DO Recommended
        Status DUE
        Delay 9m..12m from CALC:TBE_last_dose_date
      MESSAGES  MSG106
    END RULE 25/02
  END FOLDER 52

  FOLDER 53 "Three doses"
    IF CALC:TBE_doses_received = 3

    FOLDER 531 "Standard schedule"

      RULE 531/01 "≥ 12y old, LD Encepur, d1d2 ≥ 15d (Standard schedule): To do 1st booter 3y after LD"
        IF CALC:Age in 12y..49y
        DO Recommended
          Status DUE
          Delay 3y from CALC:TBE_last_dose_date
        MESSAGES  MSG121 MSG120
      END RULE 531/01
    END FOLDER 531

    FOLDER 532 "Accelerated schedule"
      IF CALC:TBE_d1d2<=14d

      RULE 532/01 "≥ 12y old, LD Encepur, d1d2 ≤ 14d (Accelerated schedule): To do 1st booter 12 to 18m after LD"
        IF CALC:Age in 12y..49y
        DO Recommended
          Status DUE
          Delay 12m..18m from CALC:TBE_last_dose_date
        MESSAGES  MSG92 MSG122
      END RULE 532/01
    END FOLDER 532
  END FOLDER 53

  FOLDER 54 "Four doses and more"
    IF CALC:TBE_doses_received>=4

    RULE 54/01 "[12-49y] old, LD Encepur: To do booter 5y after LD"
      IF CALC:Age in 12y..49y
      DO Recommended
        Status DUE
        Delay 5y from CALC:TBE_last_dose_date
      MESSAGES  MSG123
    END RULE 54/01

    RULE 54/02 "≥ 50y old, LD Encepur: To do booter 3y after LD"
      IF CALC:Age>=50y
      DO Recommended
        Status DUE
        Delay 3y from CALC:TBE_last_dose_date
      MESSAGES  MSG124
    END RULE 54/02
  END FOLDER 54
END FOLDER 5

FOLDER 8 "Contraindications and special cases"

  FOLDER 81 "Contraindications"
  END FOLDER 81

  FOLDER 82 "Special cases"

    RULE 82/01 "Case  « Refusal to vaccinate against this disease » checked: Special case + message"
      IF COND:C627 "Refusal of tick-borne encephalitis vaccination" = true
      DO Exception
      MESSAGES  MSG19 MSG20
    END RULE 82/01
  END FOLDER 82
END FOLDER 8

FOLDER 9 "Further information"

  RULE 9/01 "If To do, Ticovac 0,25 mL (OR FSME Junior), 1 dose ≤ 11m old: message alert d1 to early"
    WHEN Recommended
    IF ALL OF
      CALC:TBE_first_dose_age<=11m
      SYNTH:ET-D1-TICO-CHILD "ET-D1-TICO-CHILD - 1st dose Tico child or equivalent" = true
    DO Neutral
    MESSAGES  MSG115
  END RULE 9/01

  RULE 9/02 "If To do, Ticovac OR FSME, d1d2 ≤ 12d: message alert interval too short"
    WHEN Recommended
    IF ALL OF
      CALC:TBE_d1d2<=12d
      SYNTH:ET-D1-TICO "ET-D1-TICO - 1st dose is inactivated whole vaccine against ET, Neudörfl strain (TICO, FSME) child or adult dose" = true
      SYNTH:ET-D2-TICO "ET-D2-TICO - 2nd dose is inactivated whole vaccine against ET, Neudörfl strain (TICO, FSME) child or adult dose" = true
    DO Neutral
    MESSAGES  MSG116
  END RULE 9/02

  RULE 9/02 "If To do: message vaccination scheme"
    WHEN Recommended
    IF CALC:Age>=12m
    DO Neutral
    MESSAGES  MSG129
  END RULE 9/02

  RULE 9/05 "If To do, ≥ 3 doses: Message possibility of changing vaccine after primary vaccination"
    WHEN Recommended
    IF CALC:TBE_doses_received>=4
    DO Neutral
    MESSAGES  MSG95
  END RULE 9/05
END FOLDER 9
END TARGET

MESSAGE MSG89 Summary ANY PRIO 0
  "Accelerated schedule possible with a 2nd dose 14 days after the first dose."@en
 END MESSAGE MSG89

MESSAGE MSG114 Justification ANY PRIO 0
  "If a rapid immunological response is required, the second injection can be given 2 weeks after the first. After the first two injections, sufficient protection is expected for the current tick season."@en
 END MESSAGE MSG114

MESSAGE MSG96 Summary ANY PRIO 0
  "Give the 3rd dose of primary vaccination with Ticovac 0.25 mL."@en
 END MESSAGE MSG96

MESSAGE MSG91 Justification ANY PRIO 0
  "To be administered one to three months after the first dose."@en
 END MESSAGE MSG91

MESSAGE MSG118 Summary ANY PRIO 0
  "Accelerated schedule possible with a 2nd dose 7 days after the first dose."@en
 END MESSAGE MSG118

MESSAGE MSG119 Justification ANY PRIO 0
  " If a rapid immunological response is required, the second injection can be given 1 week after the first."@en
 END MESSAGE MSG119

MESSAGE MSG116 Alert ANY PRIO 0
  "The interval between the first and second doses of TOCOVAC (or FSME) should not have been less than 13 days."@en
 END MESSAGE MSG116

MESSAGE MSG129 Comments ANY PRIO 0
  "In Latvia, it is recommended to vaccinate children between the ages of 12 months and 18 years."@en
 END MESSAGE MSG129

MESSAGE MSG19 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG19

MESSAGE MSG20 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been ticked in the health profile (‘Refusal of vaccination’ section)."@en
 END MESSAGE MSG20

MESSAGE MSG92 Justification ANY PRIO 0
  "As part of an accelerated vaccination schedule, give the 1st booster 12 to 18 months after the last dose of primary vaccination."@en
 END MESSAGE MSG92

MESSAGE MSG122 Summary ANY PRIO 0
  "Accelerated vaccination schedule"@en
 END MESSAGE MSG122

MESSAGE MSG106 Summary ANY PRIO 0
  "Classic scheme with Encepur."@en
 END MESSAGE MSG106

MESSAGE MSG117 Summary ANY PRIO 0
  "Booster vaccination 10 years after the last dose."@en
 END MESSAGE MSG117

MESSAGE MSG115 Alert ANY PRIO 0
  "TOCOVAC 0.25 mL should not have been administered before the age of 12 months."@en
 END MESSAGE MSG115

MESSAGE MSG93 Summary ANY PRIO 0
  "Booster vaccination 3 years after the 3rd dose."@en
 END MESSAGE MSG93

MESSAGE MSG121 Justification ANY PRIO 0
  "As part of a standard schedule, the 1st booster vaccination should be given 3 years after the last dose of primary vaccination."@en
 END MESSAGE MSG121

MESSAGE MSG120 Summary ANY PRIO 0
  "Standard vaccination schedule."@en
 END MESSAGE MSG120

MESSAGE MSG100 Summary ANY PRIO 0
  "Give the 3rd dose of primary vaccination with Ticovac O.50 mL."@en
 END MESSAGE MSG100

MESSAGE MSG124 Summary ANY PRIO 0
  "Booster vaccination 3 years after the last dose."@en
 END MESSAGE MSG124

MESSAGE MSG123 Summary ANY PRIO 0
  "Booster vaccination 5 years after the last dose."@en
 END MESSAGE MSG123

MESSAGE MSG95 Comments PRO PRIO 0
  "According to the official recommendations of the World Health Organisation (WHO), after primary vaccination with a tick-borne encephalitis vaccine, another vaccine can be administered as a booster dose."@en
 END MESSAGE MSG95

MESSAGE MSG104 Summary ANY PRIO 0
  "Accelerated scheme with Encepur."@en
 END MESSAGE MSG104

MESSAGE MSG109 Justification ANY PRIO 0
  "Give the 3rd dose of primary vaccination with Ticovac 0.25 mL."@en
 END MESSAGE MSG109
