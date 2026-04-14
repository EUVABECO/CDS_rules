CALC HepB_doses_received IS HIST(HepB,0,count)
CALC HepB_last_dose_is_booster IS HIST(HepB,-1,booster)
CALC HepB_last_dose_date IS HIST(HepB,-1,date)
CALC HepB_penultimate_dose_date IS HIST(HepB,-2,date)
CALC HepB_antepenultimate_dose_date IS HIST(HepB,-3,date)
CALC HepB_d2d3 IS INTERVAL(HIST(HepB,2,date),HIST(HepB,3,date))


TARGET HepB

FOLDER 1 "≤ 23m old, Mothers HBsAg -"
  IF ALL OF
  CALC:Age<=23m
  COND:C15 "Newborn of a mother with HBsAg" = false

  FOLDER 11 "Zero dose"
    IF CALC:HepB_doses_received = 0

    RULE 11/01 "≤ 23m, 0 dose: To do at 2m old"
      IF CALC:Age>=15d
      DO Recommended
        Status DUE
        Age 2m
    END RULE 11/01
  END FOLDER 11

  FOLDER 12 "Last dose is not a booster"
    IF CALC:HepB_last_dose_is_booster = false

    FOLDER 121 "One dose"
      IF CALC:HepB_doses_received = 1

      RULE 121/01 "≤ 23m, Booster-, 1 dose: To do from 4m old and 1m after LD"
        IF CALC:Age>=2m
        DO Recommended
          Status DUE
          Age 4m
          Delay 1m from CALC:HepB_last_dose_date
      END RULE 121/01
    END FOLDER 121

    FOLDER 122 "Two doses"
      IF CALC:HepB_doses_received = 2

      RULE 122/01 "≤ 23m, Booster-, 2 doses: To do from 6m old and 1m after LD"
        IF CALC:Age>=2m
        DO Recommended
          Status DUE
          Age 6m
          Delay 1m from CALC:HepB_last_dose_date
      END RULE 122/01
    END FOLDER 122

    FOLDER 123 "Three doses"
      IF CALC:HepB_doses_received = 3

      RULE 123/01 "≤ 23m, Booster-, 3 doses: To do from 12-15m old and 6m after LD"
        IF CALC:Age>=2m
        DO Recommended
          Status DUE
          Age 12m..15m
          Delay 6m from CALC:HepB_last_dose_date
      END RULE 123/01
    END FOLDER 123

    FOLDER 124 "Four doses or more"
      IF CALC:HepB_doses_received>=4

      RULE 124/01 "≤ 23m, Booster-, ≥ 4 doses, [0-23m]: Up to date"
        IF CALC:Age in 2m..24m
        DO Recommended
          Status COMPLETED
      END RULE 124/01
    END FOLDER 124
  END FOLDER 12
END FOLDER 1

FOLDER 2 "≤ 23m old, Mothers HBsAg +"
  IF ALL OF
  CALC:Age<=23m
  COND:C15 "Newborn of a mother with HBsAg" = true

  FOLDER 21 "Zero dose"
    IF CALC:HepB_doses_received = 0

    RULE 21/01 "≤ 23m, Mothers HBsAg+, 0 dose: To do at birth"
      IF CALC:Age>=0d
      DO Recommended
        Status DUE
      MESSAGES  MSG224
    END RULE 21/01
  END FOLDER 21

  FOLDER 22 "Last dose is not a booster"
    IF CALC:HepB_last_dose_is_booster = false

    FOLDER 221 "One dose"
      IF CALC:HepB_doses_received = 1

      RULE 221/01 "≤ 23m, Mothers HBsAg+, Booster-, 1 dose: To do from 2m old and 1m after LD"
        IF CALC:Age>=1m
        DO Recommended
          Status DUE
          Age 2m
          Delay 1m from CALC:HepB_last_dose_date
      END RULE 221/01
    END FOLDER 221

    FOLDER 222 "Two doses"
      IF CALC:HepB_doses_received = 2

      RULE 222/01 "≤ 23m, Mothers HBsAg+, Booster-, 2 doses: To do from 4m old and 1m after LD"
        IF CALC:Age>=3m
        DO Recommended
          Status DUE
          Age 4m
          Delay 1m from CALC:HepB_last_dose_date
      END RULE 222/01
    END FOLDER 222

    FOLDER 223 "Three doses"
      IF CALC:HepB_doses_received = 3

      RULE 223/01 "≤ 23m, Mothers HBsAg+, Booster-, 2 doses: To do from 6m old and 1m after LD"
        IF CALC:Age>=5m
        DO Recommended
          Status DUE
          Age 6m
          Delay 1m from CALC:HepB_last_dose_date
      END RULE 223/01
    END FOLDER 223

    FOLDER 224 "Four doses"
      IF CALC:HepB_doses_received = 4

      RULE 224/01 "≤ 23m, Mothers HBsAg+, Booster-, 4 doses: To do from 12-15m old and 6m after LD"
        IF CALC:Age>=10m
        DO Recommended
          Status DUE
          Age 12m..15m
          Delay 6m from CALC:HepB_last_dose_date
      END RULE 224/01
    END FOLDER 224

    FOLDER 225 "Five doses or more"
      IF CALC:HepB_doses_received>=5

      RULE 225/01 "≤ 23m, Mothers HBsAg+, Booster-, ≥ 4 doses, [0-23m]: Up to date (Copie)"
        IF CALC:Age in 2m..24m
        DO Recommended
          Status COMPLETED
      END RULE 225/01
    END FOLDER 225
  END FOLDER 22

  FOLDER 23 "Last dose is a booster"
    IF CALC:HepB_last_dose_is_booster = true

    RULE 23/01 "≤23m old, Mothers HBsAg+, Booster+, ≥ 1 dose: Up to date"
      IF CALC:HepB_doses_received>=1
      DO Recommended
        Status COMPLETED
    END RULE 23/01
  END FOLDER 23
END FOLDER 2

FOLDER 3 "≥24m old (Vaccination catch-up)"
  IF CALC:Age>=24m

  FOLDER 31 "Zero dose"
    IF CALC:HepB_doses_received = 0

    RULE 31/01 "≥ 24m old, 0 dose: To do ASAP (catch-up)"
      IF CALC:HepB_doses_received = 0
      DO Recommended
        Status DUE
    END RULE 31/01
  END FOLDER 31

  FOLDER 32 "Last dose is not a booster"
    IF CALC:HepB_last_dose_is_booster = false

    FOLDER 321 "One dose"
      IF CALC:HepB_doses_received = 1

      RULE 321/01 "≥24m old, Booster-, 1 dose: To do 1m after LD (Vaccination schedule 0-1-6m)"
        IF CALC:HepB_doses_received = 1
        DO Recommended
          Status DUE
          Delay 1m from CALC:HepB_last_dose_date
      END RULE 321/01
    END FOLDER 321

    FOLDER 322 "Two doses"
      IF CALC:HepB_doses_received = 2

      RULE 322/01 "≥24m old, Booster-, 2 doses: To do 1m after LD (Vaccination schedule 0-1-6m)"
        IF CALC:HepB_doses_received = 2
        DO Recommended
          Status DUE
          Delay 1m from CALC:HepB_last_dose_date
      END RULE 322/01

      RULE 322/02 "≥24m old, Booster-, 2 doses: To do 6m after d1 (Vaccination schedule 0-1-6m)"
        IF CALC:HepB_doses_received = 2
        DO Recommended
          Status DUE
          Delay 6m from CALC:HepB_penultimate_dose_date
      END RULE 322/02
    END FOLDER 322

    FOLDER 323 "Three doses"
      IF CALC:HepB_doses_received = 3

      RULE 323/01 "≥24m old, Booster-, 3 doses, d2-d3 ≥ 3m: Up to date"
        IF CALC:HepB_d2d3>=3m
        DO Recommended
          Status COMPLETED
      END RULE 323/01

      RULE 323/02 "≥24m old, Booster-, 3 doses, d2-d3 ≤ 2m: To do 12m after d1 (Accelerated vaccination schedule 0-1-2-12)"
        IF CALC:HepB_d2d3<=2m
        DO Recommended
          Status DUE
          Delay 12m from CALC:antepenultimate_prevention_act_date
        MESSAGES  MSG204
      END RULE 323/02
    END FOLDER 323

    FOLDER 324 "Four doses or more"
      IF CALC:HepB_doses_received>=4

      RULE 324/01 "≥24m old, Booster-, ≥ 4 doses: Up to date"
        IF CALC:HepB_doses_received>=4
        DO Recommended
          Status COMPLETED
      END RULE 324/01
    END FOLDER 324
  END FOLDER 32

  FOLDER 33 "Last dose is a booster"
    IF CALC:HepB_last_dose_is_booster = true

    RULE 33/01 "≥24m old, Booster+, ≥ 1 dose: Up to date"
      IF CALC:HepB_doses_received>=1
      DO Recommended
        Status COMPLETED
    END RULE 33/01
  END FOLDER 33
END FOLDER 3

FOLDER 8 "Contraindications and special cases"

  RULE 8/01 "Case  « Refusal to vaccinate against this disease » checked: Special case + message"
    IF COND:C614 "Refusal to vaccinate against hepatitis B" = true
    DO Exception
    MESSAGES  MSG19 MSG20
  END RULE 8/01
END FOLDER 8

FOLDER 9 "Further information"

  RULE 9/01 "If to do, ≤ 23m, 0 dose: Mandatory vaccination"
    WHEN Recommended
    IF ALL OF
      CALC:HepB_doses_received = 0
      CALC:Age in 1m..23m
    DO Neutral
    MESSAGES  MSG69
  END RULE 9/01

  RULE 9/02 "If to do, ≥24m old, 0 dose: Catch-up"
    WHEN Recommended
    IF ALL OF
      CALC:HepB_doses_received = 0
      CALC:Age>=24m
    DO Neutral
    MESSAGES  MSG205
  END RULE 9/02

  RULE 9/03 "If To do, 0 dose, ≤ 24m old, Mothers HBsAg+-: message vaccination scheme"
    WHEN Recommended
    IF ALL OF
      CALC:Age<=5d
      CALC:HepB_doses_received = 0
      COND:C15 "Newborn of a mother with HBsAg" = true
    DO Neutral
    MESSAGES  MSG226 MSG225
  END RULE 9/03

  RULE 9/03 "If To do, ≤ 4 doses, Booster-, ≤ 24m old, Mothers HBsAg-: message vaccination scheme"
    WHEN Recommended
    IF ALL OF
      CALC:Age in 15d..23m
      CALC:HepB_doses_received<=4
      CALC:HepB_last_dose_is_booster = false
      COND:C15 "Newborn of a mother with HBsAg" = false
    DO Neutral
    MESSAGES  MSG131
  END RULE 9/03

  RULE 9/04 "If to do, [1-20m] old: message to do with DTaP-IPV-Hib-HvB"
    WHEN Recommended
    IF CALC:Age in 1m..20m
    DO Neutral
    MESSAGES  MSG134
  END RULE 9/04

  RULE 9/05 "If To do, ≤ 3 doses, Booster-, ≥ 24m old: message vaccination scheme (0-1-6)"
    WHEN Recommended
    IF ALL OF
      CALC:Age>=24m
      CALC:HepB_doses_received<=3
      CALC:HepB_last_dose_is_booster = false
    DO Neutral
    MESSAGES  MSG90
  END RULE 9/05

  RULE 9/06 "If To do, [24m-15y] old: Message = Vaccine recommended for use"
    WHEN Recommended
    IF CALC:Age in 24m..15y
    DO Neutral
    MESSAGES  MSG94
  END RULE 9/06

  RULE 9/07 "If To do, ≥16y old: Message = Vaccine recommended for use"
    WHEN Recommended
    IF CALC:Age>=16y
    DO Neutral
    MESSAGES  MSG223
  END RULE 9/07

  RULE 9/08 "If To do, Coagulation disorders: Message"
    WHEN Recommended
    IF SYNTH:COAG_DISORDERS "COMMON - coagulation disorders" = true
    DO Neutral
    MESSAGES  MSG338 MSG339
  END RULE 9/08
END FOLDER 9
END TARGET

MESSAGE MSG19 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG19

MESSAGE MSG20 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been ticked in the health profile (‘Refusal of vaccination’ section)."@en
 END MESSAGE MSG20

MESSAGE MSG226 Other ANY PRIO 0
  "Vaccine recommended for use: ENGERIX B10 or HBVAXPRO 5 µg."@en
 END MESSAGE MSG226

MESSAGE MSG225 Justification ANY PRIO 0
  "In newborns of mothers carrying the HBs antigen, the primary vaccination schedule is 5 doses: one dose at birth, then at 2, 4 and 6 months and finally between 12 and 15 months."@en
 END MESSAGE MSG225

MESSAGE MSG338 Summary ANY PRIO 0
  "The administration of the vaccine should be performed only subcutaneously: see comments."@en
 END MESSAGE MSG338

MESSAGE MSG339 Comments ANY PRIO 0
  "All injectable vaccines carry a risk of intramuscular haematoma in patients with thrombocytopenia, coagulation disorders or receiving anticoagulant therapy. In general, vaccines should be administered with caution to such patients. Whenever possible, subcutaneous administration should be preferred."@en
 END MESSAGE MSG339

MESSAGE MSG134 Other PRO PRIO 0
  "Vaccine recommended for use: DTaP-IPV-Hib-HvB.<br>
Ex : INFANRIX HEXA."@en
 END MESSAGE MSG134

MESSAGE MSG69 Summary ANY PRIO 0
  "This vaccination is compulsory in Latvia, from the age of 2 months."@en
 END MESSAGE MSG69

MESSAGE MSG224 Alert ANY PRIO 0
  "For newborns of mothers carrying the HBs antigen, vaccination against hepatitis B should be started at birth."@en
 END MESSAGE MSG224

MESSAGE MSG90 Comments ANY PRIO 0
  "The primary vaccination schedule is 3 doses: 0, 1, 6 months (two injections one month apart, followed by a third dose six months after the first injection)."@en
 END MESSAGE MSG90

MESSAGE MSG94 Other ANY PRIO 0
  "Vaccine recommended for use: ENGERIX B10 or HBVAXPRO 5 µg."@en
 END MESSAGE MSG94

MESSAGE MSG223 Other ANY PRIO 0
  "Vaccine recommended for use: ENGERIX B20 or HBVAXPRO 10 µg."@en
 END MESSAGE MSG223

MESSAGE MSG131 Justification ANY PRIO 10
  "The primary vaccination schedule consists of 4 doses: 2, 4 and 6 months, then between 12 and 15 months. "@en
 END MESSAGE MSG131

MESSAGE MSG205 Alert ANY PRIO 0
  "A vaccination catch-up must be carried out."@en
 END MESSAGE MSG205

MESSAGE MSG204 Justification ANY PRIO 0
  "The interval between the 2nd and 3rd doses is incompatible with the classical schedule (0-1-6 months), but it is compatible with the accelerated schedule (0-1-2 months, then booster at 12 months). A booster dose is therefore necessary 12 months after the first dose."@en
 END MESSAGE MSG204
