SYNTH MEN-B-RF "MEN-B - Risk factors" IS ANY OF
  COND:C36 "Spleen removal or non-functioning" = true
  COND:23 "Homozygous sickle cell disease " = true
  COND:7 "Double heterozygous sickle cell disease " = true
  COND:8 "Sickle cell disease " = true
  COND:21 "Complement deficit " = true

CALC MenB_doses_received IS HIST(MenB,0,count)
CALC MenB_last_dose_date IS HIST(MenB,-1,date)

CALC MenB_first_vaccine IS HIST(MenB,1,vaccine)
CALC MenB_age_at_first_dose IS INTERVAL(BASE:dob,HIST(MenB,1,date))

CALC MenB_second_vaccine IS HIST(MenB,2,vaccine)
CALC MenB_4CMenB_doses IS HIST(V4CMenB,0,count)               # To be fixed in NUVA, an identifier cannot start with a number

CALC  MenB_d1d2 IS INTERVAL(HIST(MenB,1,date),HIST(MenB,2,date))


TARGET MenB

FOLDER 1 "RF+"
  IF SYNTH:MEN-B-RF = true

  FOLDER 10 "Zero dose"
    IF CALC:MenB_doses_received = 0

    RULE 10/01 "≤ 9y old, 0 dose: To do from 2m with Bexsero"
      IF CALC:Age in 0m..9y
      DO Recommended
        Status DUE
        Age 2m
    END RULE 10/01

    RULE 10/02 "≥10y old, 0 dose: To do ASAP with Bexsero or Trumenba"
      IF CALC:Age>=10y
      DO Recommended
        Status OVERDUE
    END RULE 10/02
  END FOLDER 10

  FOLDER 11 "One dose"
    IF CALC:MenB_doses_received = 1

    FOLDER 111 "d1 = BEXSERO"
      IF CALC:MenB_first_vaccine = VAC0495 # BEXSERO

      RULE 111/01 "[2-23m] old, 1 dose = Bexsero: To do with Bexsero 2m after LD"
        IF CALC:MenB_age_at_first_dose in 2m..23m
        DO Recommended
          Status DUE
          Delay 2m from CALC:MenB_last_dose_date
      END RULE 111/01

      RULE 111/02 "≥ 24m, 1 dose Bexsero: To do with Bexsero 1m after LD"
        IF CALC:Age>=24m
        DO Recommended
          Status DUE
          Delay 1m from CALC:MenB_last_dose_date
      END RULE 111/02
    END FOLDER 111

    FOLDER 112 "d1 = TRUMENBA"
      IF CALC:MenB_first_vaccine = VAC0582 #TRUMENBA

      RULE 112/01 "≥ 10a, 1 dose = Trumenba: To do with Trumenba 6m after LD"
        IF CALC:Age>=10y
        DO Recommended
          Status DUE
          Delay 6m from CALC:MenB_last_dose_date
      END RULE 112/01
    END FOLDER 112
  END FOLDER 11

  FOLDER 12 "Two doses"
    IF CALC:MenB_doses_received = 2

    FOLDER 121 "Only BEXSERO"
      IF CALC:MenB_4CMenB_doses = 2

      RULE 121/01 "≤ 23m old, 2 doses, d1d2 = Bexsero, d1 [2-5m] old: To do with Bexsero 6m after LD, between 12-15m old"
        IF ALL OF
          CALC:Age<=23m
          CALC:MenB_age_at_first_dose in 2m..5m
        DO Recommended
          Status DUE
          Age 12m..15m
          Delay 6m from CALC:MenB_last_dose_date
      END RULE 121/01

      RULE 121/02 "≤ 23m old, 2 doses, d1d2 = Bexsero, d1 [6-11m] old: To do with Bexsero 2m after LD, After 12m old"
        IF ALL OF
          CALC:Age<=23m
          CALC:MenB_age_at_first_dose in 6m..11m
        DO Recommended
          Status DUE
          Age 12m
          Delay 2m from CALC:MenB_last_dose_date
      END RULE 121/02

      RULE 121/03 "≤ 23m old, 2 doses, d1d2 = Bexsero, d1 [12-23m] old: To do with Bexsero 12-23m after LD"
        IF ALL OF
          CALC:Age<=23m
          CALC:MenB_age_at_first_dose in 12m..23m
        DO Recommended
          Status DUE
          Delay 12m..23m from CALC:MenB_last_dose_date
      END RULE 121/03

      RULE 121/04 "≥ 24m old, 2 doses, d1d2 = Bexsero, d1 [2-23m] old: To do 12-23m after LD"
        IF ALL OF
          CALC:Age>=24m
          CALC:MenB_age_at_first_dose in 2m..23m
        DO Recommended
          Status DUE
          Delay 12m..23m from CALC:MenB_last_dose_date
      END RULE 121/04

      RULE 121/05 "≥ 2m old, 2 doses, d1d2 = Bexsero, d1 ≥ 24m old: To do 5y afyer LD"
        IF ALL OF
          CALC:Age>=24m
          CALC:MenB_age_at_first_dose>=24m
        DO Recommended
          Status DUE
          Delay 5y from CALC:MenB_last_dose_date
      END RULE 121/05
    END FOLDER 121

    FOLDER 122 "d1 = TRUMENBA"
      IF CALC:MenB_first_vaccine = VAC0582 # TRUMENBA

      RULE 122/01 "≥ 10y old, 2 doses, d1d2 = Trumanba, d1 ≥ 10y old: DUE with Trumenba 5y after LD"
        IF ALL OF
          CALC:Age>=10y
          CALC:MenB_age_at_first_dose>=10y
        DO Recommended
          Status DUE
          Delay 5y from CALC:MenB_last_dose_date
      END RULE 122/01
    END FOLDER 122
  END FOLDER 12

  FOLDER 13 "Three doses or more"
    IF CALC:MenB_doses_received>=3

    RULE 13/1 "≥3 doses: DUE 5y after LD (with same vaccine)"
      IF CALC:Age>=24m
      DO Recommended
        Status DUE
        Delay 5y from CALC:MenB_last_dose_date
    END RULE 13/1
  END FOLDER 13
END FOLDER 1

FOLDER 8 "Contraindications and special cases"

  RULE 8/01 "[2-23m] old, 2 doses, d1d2 = Bexsero, d1d2 ≤ 44d : Special case - Message = Time between 2 doses too short"
    IF ALL OF
      CALC:Age in 2m..23m
      CALC:MenB_doses_received = 2
      CALC:MenB_first_vaccine = VAC0495  # BEXSERO
      CALC:MenB_second_vaccine = VAC0495 # BEXSERO
      CALC:MenB_d1d2<=44d
    DO Exception
    MESSAGES  MSG191 MSG184
  END RULE 8/01

  RULE 8/02 "≥ 24m old, 2 doses, d1d2 = Bexsero, d1d2 ≤ 20d: Special case - Message =  Time between 2 doses too short"
    IF ALL OF
      CALC:Age>=24m
      CALC:MenB_doses_received = 2
      CALC:MenB_second_vaccine = VAC0495 # BEXSERO
      CALC:MenB_d1d2<=20d
      CALC:MenB_first_vaccine = VAC0495 # BEXSERO
    DO Exception
    MESSAGES  MSG184 MSG185
  END RULE 8/02

  RULE 8/04 "Case  « Refusal to vaccinate against this disease » checked: Special case + message"
    IF COND:C619 "Meningococcal B vaccine refusal" = true
    DO Exception
    MESSAGES  MSG6 MSG7
  END RULE 8/04
END FOLDER 8

FOLDER 9 "Further information"

  RULE 9/01 "If to do, 0 dose, ≤ 9y old: usable vaccine Bexsero"
    WHEN Recommended
    IF ALL OF
      CALC:Age<=9y
      CALC:MenB_doses_received = 0
    DO Neutral
    MESSAGES  MSG178
  END RULE 9/01

  RULE 9/02 "If to do, 0 dose, ≥ 10y old: usable vaccine Bexsero, Trumenba"
    WHEN Recommended
    IF ALL OF
      CALC:Age>=10y
      CALC:MenB_doses_received = 0
    DO Neutral
    MESSAGES  MSG179
  END RULE 9/02

  RULE 9/03 "If to do, d1 = BEXSERO, ≥ 10y old: Continue with same vaccine"
    WHEN Recommended
    IF ALL OF
      CALC:MenB_first_vaccine = VAC0495 # BEXSERO
      CALC:Age>=10y
    DO Neutral
    MESSAGES  MSG192
  END RULE 9/03

  RULE 9/04 "If to do, d1 = TRUMENBA, ≥ 10y old: Continue with same vaccine"
    WHEN Recommended
    IF ALL OF
      CALC:MenB_first_vaccine = VAC0582 # TRUMENBA
      CALC:Age>=10y
    DO Neutral
    MESSAGES  MSG187
  END RULE 9/04

  RULE 9/05 "General rationale for meningococcal vaccination"
    IF CALC:Age>=1d
    DO Neutral
    MESSAGES  MSG180 MSG193
  END RULE 9/05

  RULE 9/06 "If pregnant: Message alert"
    IF SYNTH:PREGNANCY_ONGOING "COMMON-PREGNANCY - Pregnancy in progress" = true
    DO Neutral
    MESSAGES  MSG188 MSG190
  END RULE 9/06
END FOLDER 9
END TARGET

MESSAGE MSG184 Alert ANY PRIO 0
  "Too short a time between 2 doses (see comments)."@en
 END MESSAGE MSG184

MESSAGE MSG185 Comments ANY PRIO 0
  "The first two doses of BEXSERO were administered with an interval of less than 20 days: specialist advice is required."@en
 END MESSAGE MSG185

MESSAGE MSG188 Alert PATIENT PRIO 0
  "During pregnancy, vaccination only if the risk of exposure is clearly defined."@en
 END MESSAGE MSG188

MESSAGE MSG190 Justification ANY PRIO 0
  "There are no clinical data on the use of meningococcal vaccines in pregnant women. However, given the seriousness of meningococcal disease, pregnancy should not preclude vaccination when the risk of exposure is clearly defined."@en
 END MESSAGE MSG190

MESSAGE MSG180 Comments ANY PRIO 0
  "Vaccination against meningococcus B is recommended for people at risk of invasive meningococcal infections regardless of their age, namely:<br>
- People with anatomical or functional asplenia, including sickle cell disease;<br>
- People with congenital or acquired complement deficiency;<br>
- People with humoral immunity deficiency."@en
 END MESSAGE MSG180

MESSAGE MSG193 Justification ANY PRIO 5
  "Vaccination helps prevent serious meningococcal infections (meningitis and septicemia), which can lead to permanent after-effects (deafness, neurological disorders) or death. In addition, vaccination limits the circulation of bacteria in the population."@en
 END MESSAGE MSG193

MESSAGE MSG191 Comments ANY PRIO 0
  "The first two doses of BEXSERO were administered with an interval of less than 45 days: specialist advice is required."@en
 END MESSAGE MSG191

MESSAGE MSG192 Comments ANY PRIO 0
  "Scheme started with BEXSERO vaccine: Since BEXSERO and TRUMENBA vaccines are not interchangeable, people who have started a vaccination programme with one of the vaccines should continue it with the same vaccine."@en
 END MESSAGE MSG192

MESSAGE MSG178 Other ANY PRIO 0
  "Vaccine available: Bexsero."@en
 END MESSAGE MSG178

MESSAGE MSG179 Other ANY PRIO 0
  "Vaccines that can be used: Bexsero, Trumenba."@en
 END MESSAGE MSG179

MESSAGE MSG6 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG6

MESSAGE MSG7 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been checked in the health profile (section “Refusal of vaccination”)."@en
 END MESSAGE MSG7

MESSAGE MSG187 Comments ANY PRIO 0
  "Scheme started with TRUMENBA vaccine: Since TRUMENBA and BEXSERO vaccines are not interchangeable, people who have started a vaccination programme with one of the vaccines must continue it with the same vaccine."@en
 END MESSAGE MSG187

MESSAGE MSG346 Details PATIENT PRIO 0
  "--"@en
 END MESSAGE MSG346
