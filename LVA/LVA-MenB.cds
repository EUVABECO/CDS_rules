CALC MenB_doses_received IS HIST(MenB,0,count)
CALC MenB_last_dose_date IS HIST(MenB,-1,date)

CALC MenB_first_vaccine IS HIST(MenB,1,vaccine)
CALC MenB_age_at_first_dose IS INTERVAL(BASE:dob,HIST(MenB,1,date))

CALC MenB_second_vaccine IS HIST(MenB,2,vaccine)
CALC MenB_4CMenB_doses IS HIST(V4CMenB,0,count)               # To be fixed in NUVA, an identifier cannot start with a number

CALC  MenB_d1d2 IS INTERVAL(HIST(MenB,1,date),HIST(MenB,2,date))


TARGET MenB

FOLDER 1 "RF+"

  IF SYNTH:MEN_RF_WO_HSCT = true

  FOLDER 10 "Zero dose"
    IF CALC:MenB_doses_received = 0

    RULE 10/01 "≤ 9y, 0 dose: To do from 2m with Bexsero"
      IF CALC:Age in 0m..9y
      DO Recommended
        Status DUE
        Age 2m
      MESSAGES  MSG311
    END RULE 10/01

    RULE 10/02 "≥10y, 0 dose: To do ASAP with Bexsero or Trumenba"
      IF CALC:Age>=10y
      DO Recommended
        Status OVERDUE
      MESSAGES  MSG265 MSG336
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
        MESSAGES  MSG311
      END RULE 111/01

      RULE 111/02 "≥ 24m, 1 dose Bexsero: To do with Bexsero 1m after LD"
        IF CALC:Age>=24m
        DO Recommended
          Status DUE
          Delay 1m from CALC:MenB_last_dose_date
        MESSAGES  MSG311
      END RULE 111/02
    END FOLDER 111

    FOLDER 112 "d1 = TRUMENBA"
      IF CALC:MenB_first_vaccine = VAC0582 #TRUMENBA

      RULE 112/01 "≥ 10a, 1 dose = Trumenba: To do with Trumenba 6m after LD"
        IF CALC:Age>=10y
        DO Recommended
          Status DUE
          Delay 6m from CALC:MenB_last_dose_date
        MESSAGES  MSG319
      END RULE 112/01
    END FOLDER 112
  END FOLDER 11

  FOLDER 12 "Two doses"
    IF CALC:MenB_doses_received = 2

    FOLDER 121 "Tous les vaccins reçus = BEXSERO"
      IF CALC:MenB_4CMenB_doses = 2

      RULE 121/01 "≤ 23m old, 2 doses, d1d2 = Bexsero, d1 [2-5m] old: To do with Bexsero 6m after LD, between 12-15m old"
        IF ALL OF
          CALC:Age<=23m
          CALC:MenB_age_at_first_dose in 2m..5m
        DO Recommended
          Status DUE
          Age 12m..15m
          Delay 6m from CALC:MenB_last_dose_date
        MESSAGES  MSG311
      END RULE 121/01

      RULE 121/02 "≤ 23m old, 2 doses, d1d2 = Bexsero, d1 [6-11m] old: To do with Bexsero 2m after LD, After 12m old"
        IF ALL OF
          CALC:Age<=23m
          CALC:MenB_age_at_first_dose in 6m..11m
        DO Recommended
          Status DUE
          Age 12m
          Delay 2m from CALC:MenB_last_dose_date
        MESSAGES  MSG311
      END RULE 121/02

      RULE 121/03 "≤ 23m old, 2 doses, d1d2 = Bexsero, d1 [12-23m] old: To do with Bexsero 12-23m after LD"
        IF ALL OF
          CALC:Age<=23m
          CALC:MenB_age_at_first_dose in 12m..23m
        DO Recommended
          Status DUE
          Delay 12m..23m from CALC:MenB_last_dose_date
        MESSAGES  MSG311
      END RULE 121/03

      RULE 121/04 "≥ 24m old, 2 doses, d1d2 = Bexsero, d1 [2-23m] old: To do 12-23m after LD"
        IF ALL OF
          CALC:Age>=24m
          CALC:MenB_age_at_first_dose in 2m..23m
        DO Recommended
          Status DUE
          Delay 12m..23m from CALC:MenB_last_dose_date
        MESSAGES  MSG311
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
      IF CALC:MenB_first_vaccine = VAC0582 #TRUMENBA

      RULE 122/01 "≥ 10y old, 2 doses, d1d2 = Trumanba, d1 ≥ 10y old: DUE with Trumenba 5y after LD"
        IF ALL OF
          CALC:Age>=10y
          CALC:MenB_age_at_first_dose>=10y
        DO Recommended
          Status DUE
          Delay 5y from CALC:MenB_last_dose_date
        MESSAGES  MSG319
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
      CALC:MenB_first_vaccine = VAC0495 #BEXSERO
      CALC:MenB_second_vaccine = VAC0495 #BEXSERO
      CALC:MenB_d1d2<=44d
    DO Exception
    MESSAGES  MSG315 MSG316
  END RULE 8/01

  RULE 8/02 "≥ 24m old, 2 doses, d1d2 = Bexsero, d1d2 ≤ 20d: Special case - Message =  Time between 2 doses too short"
    IF ALL OF
      CALC:Age>=24m
      CALC:MenB_doses_received = 2
      CALC:MenB_second_vaccine = VAC0495 # BEXSERO
      CALC:MenB_d1d2<=20d
      CALC:MenB_first_vaccine = VAC0495 #BEXSERO
    DO Exception
    MESSAGES  MSG316 MSG321
  END RULE 8/02

  RULE 8/03 "If pregnant: Contraindicate"
    WHEN Recommended
    IF SYNTH:PREGNANCY_ONGOING "PREGNANCY - Pregnancy in progress" = true
    DO Contraindicated
    MESSAGES  MSG260 MSG261 MSG262
  END RULE 8/03

  RULE 8/04 "Case  « Refusal to vaccinate against this disease » checked: Special case + message"
    IF COND:C619 "Meningococcal B vaccine refusal" = true
    DO Exception
    MESSAGES  MSG326 MSG20
  END RULE 8/04
END FOLDER 8

FOLDER 9 "Further information"

  RULE 9/01 "If to do, d1 = BEXSERO, ≥ 10y old: Continue with same vaccine"
    WHEN Recommended
    IF ALL OF
      CALC:MenB_first_vaccine = VAC0495 #BEXSERO
      CALC:Age>=10y
    DO Neutral
    MESSAGES  MSG317
  END RULE 9/01

  RULE 9/02 "If to do, d1 = TRUMENBA, ≥ 10y old: Continue with same vaccine"
    WHEN Recommended
    IF ALL OF
      CALC:MenB_first_vaccine = VAC0582 #TRUMENBA
      CALC:Age>=10y
    DO Neutral
    MESSAGES  MSG330
  END RULE 9/02

  RULE 9/03 "General rationale for meningococcal vaccination"
    IF CALC:Age>=1d
    DO Neutral
    MESSAGES  MSG309
  END RULE 9/03

  RULE 9/04 "If To do, Coagulation disorders: Message"
    WHEN Recommended
    IF SYNTH:COAG_DISORDERS "COMMON - coagulation disorders" = true
    DO Neutral
    MESSAGES  MSG338 MSG339
  END RULE 9/04
END FOLDER 9
END TARGET

MESSAGE MSG265 Comments ANY PRIO 0
  "Vaccination recommended in the presence of one of the following risk factors:<br>
- Military;<br>
- Research laboratory personnel working specifically on meningococcus;<br>
- Adolescents and young adults aged 15 to 24 living in dormitories;<br>
- Adolescents and young adults aged 15 to 24 who smoke;<br>
- Persons with terminal complement deficiency or receiving anti-C5 treatment, particularly persons treated with eculizumab (SOLIRIS®) or ravulizumab (ULTROMIRIS®). These persons must be monitored post-vaccination due to the possible risk of haemolysis;<br>
- Persons with properdin deficiency;<br>
- Persons with anatomical or functional asplenia;<br>
- People who have received a hematopoietic stem cell transplant;<br>
- Persons infected with HIV."@en
 END MESSAGE MSG265

MESSAGE MSG336 Other PRO PRIO 0
  "Vaccins utilisables : BEXSERO ou TRUMENBA."@en
 END MESSAGE MSG336

MESSAGE MSG311 Other PRO PRIO 0
  "Possible vaccine : BEXSERO."@en
 END MESSAGE MSG311

MESSAGE MSG326 Alert ANY PRIO 0
  "Vaccination against meningococcal B was refused."@en
 END MESSAGE MSG326

MESSAGE MSG20 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been ticked in the health profile (‘Refusal of vaccination’ section)."@en
 END MESSAGE MSG20

MESSAGE MSG316 Alert ANY PRIO 0
  "Too short a time between 2 doses (see comments)."@en
 END MESSAGE MSG316

MESSAGE MSG321 Justification ANY PRIO 0
  "The first two doses of BEXSERO were administered with an interval of less than 20 days: specialist advice is required."@en
 END MESSAGE MSG321

MESSAGE MSG319 Other PRO PRIO 0
  "Vaccin utilisable : TRUMENBA."@en
 END MESSAGE MSG319

MESSAGE MSG338 Summary ANY PRIO 0
  "The administration of the vaccine should be performed only subcutaneously: see comments."@en
 END MESSAGE MSG338

MESSAGE MSG339 Comments ANY PRIO 0
  "All injectable vaccines carry a risk of intramuscular haematoma in patients with thrombocytopenia, coagulation disorders or receiving anticoagulant therapy. In general, vaccines should be administered with caution to such patients. Whenever possible, subcutaneous administration should be preferred."@en
 END MESSAGE MSG339

MESSAGE MSG330 Comments ANY PRIO 0
  "Scheme started with TRUMENBA vaccine: Since TRUMENBA and BEXSERO vaccines are not interchangeable, people who have started a vaccination programme with one of the vaccines must continue it with the same vaccine."@en
 END MESSAGE MSG330

MESSAGE MSG260 Alert PATIENT PRIO 0
  "During your pregnancy, vaccination only if the risk of exposure is clearly defined."@en
 END MESSAGE MSG260

MESSAGE MSG261 Alert PRO PRIO 0
  "During pregnancy, vaccination only if the risk of exposure is clearly defined."@en
 END MESSAGE MSG261

MESSAGE MSG262 Justification ANY PRIO 0
  "There are no clinical data on the use of meningococcal vaccines in pregnant women. However, given the seriousness of meningococcal disease, pregnancy should not preclude vaccination when the risk of exposure is clearly defined."@en
 END MESSAGE MSG262

MESSAGE MSG315 Justification ANY PRIO 0
  "The first two doses of BEXSERO were administered with an interval of less than 45 days: specialist advice is required."@en
 END MESSAGE MSG315

MESSAGE MSG317 Comments ANY PRIO 0
  "Scheme started with BEXSERO vaccine: Since BEXSERO and TRUMENBA vaccines are not interchangeable, people who have started a vaccination programme with one of the vaccines should continue it with the same vaccine."@en
 END MESSAGE MSG317

MESSAGE MSG309 Justification ANY PRIO 5
  "Vaccination helps prevent serious meningococcal infections (meningitis and septicemia), which can lead to permanent after-effects (deafness, neurological disorders) or death. In addition, vaccination limits the circulation of bacteria in the population."@en
 END MESSAGE MSG309
