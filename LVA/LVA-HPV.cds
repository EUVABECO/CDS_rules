CALC HPV_doses_received IS HIST(HPV,0,count)
CALC HPV_age_at_first_dose IS INTERVAL(BASE:dob,HIST(HPV,1,date))
CALC HPV_last_dose_date IS HIST(HPV,-1,date)
CALC HPV_d1d2 IS INTERVAL(HIST(HPV,1,date),HIST(HPV,2,date))
CALC HPV_last_dose_is_booster IS HIST(HPV,-1,booster)


SYNTH HPV-GR1 "HPV-GR1 - Priority group 1" IS ANY OF
  COND:C1280 "Cervical adenocarcinoma in situ" = true
  COND:C1279 "Precancerous genital or anal lesion (grade 2/3)" = true
  SYNTH:COMMON-RF-ID "COMMON-RF-ID - ID risk factors contraindicating vaccination with live vaccines" = true
  COND:C24 "HIV infection" = true
  COND:C1281 "High-grade cervical dysplasia" = true

TARGET HPV
FOLDER - "General rules"
END FOLDER -

FOLDER 1 "11 to 17 years old"
  IF CALC:Age in 11y..17y

  FOLDER 11 "Zero dose"
    IF CALC:HPV_doses_received = 0

    RULE 1 "[11-17y] old, 0 dose: To do from 12y old"
      IF CALC:HPV_doses_received = 0
      DO Recommended
        Status DUE
        Age 12y..17y
      MESSAGES  MSG64
    END RULE 1
  END FOLDER 11

  FOLDER 12 "One dose"
    IF CALC:HPV_doses_received = 1

    RULE 1 "[11-17y] old, 1 dose, d1 ≤ 14y old: To do 5 to 11m after LD"
      IF ALL OF
        CALC:HPV_doses_received = 1
        CALC:HPV_age_at_first_dose<=14y
      DO Recommended
        Status DUE
        Age 12y..17y
        Delay 5m..11m from CALC:HPV_last_dose_date
      MESSAGES  MSG66
    END RULE 1

    RULE 2 "[11-17y] old, 1 dose, d1 ≥ 15y old: To do 2m after LD"
      IF ALL OF
        CALC:HPV_doses_received = 1
        CALC:HPV_age_at_first_dose>=15y
      DO Recommended
        Status DUE
        Age 12y..17y
        Delay 2m from CALC:HPV_last_dose_date
      MESSAGES  MSG364
    END RULE 2
  END FOLDER 12

  FOLDER 13 "Two doses"
    IF CALC:HPV_doses_received = 2

    RULE 1 "[11-17y] old, 2 doses, d1 ≤ 14y old, d1d2 ≤ 4m: To do 3rd dose + message interval not respected"
      IF ALL OF
        CALC:HPV_doses_received = 2
        CALC:HPV_d1d2<=4m
        CALC:HPV_age_at_first_dose<=14y
      DO Recommended
        Status DUE
        Delay 1m from CALC:HPV_last_dose_date
      MESSAGES  MSG67
    END RULE 1

    RULE 2 "[11-17y] old, 2 doses, d1 ≤ 14y old, d1d2 ≥ 4m: Up to date"
      IF ALL OF
        CALC:HPV_doses_received = 2
        CALC:HPV_age_at_first_dose<=14y
        CALC:HPV_d1d2>=5m
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG5
    END RULE 2

    RULE 3 "[11-17y] old, 2 doses, d1 ≥ 15y: To do 4m after LD"
      IF ALL OF
        CALC:HPV_doses_received = 2
        CALC:HPV_age_at_first_dose>=15y
      DO Recommended
        Status DUE
        Delay 4m from CALC:HPV_last_dose_date
      MESSAGES  MSG365
    END RULE 3
  END FOLDER 13

  FOLDER 14 "Three doses and more"
    IF CALC:HPV_doses_received>=3

    RULE 1 "[11-17y old],  ≥3 doses: Up to date"
      IF CALC:HPV_doses_received>=3
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG5
    END RULE 1
  END FOLDER 14
END FOLDER 1

FOLDER 2 "≥ 18y old"
  IF CALC:Age>=18y

  FOLDER 21 "Zéro dose"
    IF CALC:HPV_doses_received = 0

    RULE 21/01 "0 dose, [18-24y] old: To do from 18y old (Priority level 3)"
      IF ALL OF
        CALC:Age in 18y..24y
        SYNTH:HPV-GR1 "HPV-GR1 - Priority group 1" = false
      DO Recommended
        Status DUE
        Age 18y
      MESSAGES  MSG350 MSG359 MSG351
    END RULE 21/01

    RULE 21/02 "0 dose, 25y old: To do from 25y old (Priority level 2)"
      IF CALC:Age = 25y
      DO Recommended
        Status DUE
        Age 25y
      MESSAGES  MSG352 MSG358 MSG351
    END RULE 21/02

    RULE 21/03 "0 dose, [18-55y] old, Femal, Cervical adenocarcinoma in situ: To do from 18y old (Priority level 1)"
      IF ALL OF
        CALC:Age in 18y..55y
        COND:C1280 "Cervical adenocarcinoma in situ" = true
        BASE:sex = f
      DO Recommended
        Status DUE
        Age 18y
      MESSAGES  MSG357 MSG351 MSG353
    END RULE 21/03

    RULE 21/04 "0 dose, [18-55y] old, Femal, High-grade cervical dysplasia: To do from 18y old (Priority level 1)"
      IF ALL OF
        CALC:Age in 18y..55y
        BASE:sex = f
        COND:C1281 "High-grade cervical dysplasia" = true
      DO Recommended
        Status DUE
        Age 18y
      MESSAGES  MSG362 MSG357 MSG351
    END RULE 21/04

    RULE 21/05 "0 dose, [18-45y] old, Femal, Precancerous lesions: To do from 18y old (Priority level 1)"
      IF ALL OF
        CALC:Age in 18y..45y
        BASE:sex = f
        COND:C1279 "Precancerous genital or anal lesion (grade 2/3)" = true
      DO Recommended
        Status DUE
        Age 18y
      MESSAGES  MSG354 MSG357 MSG351
    END RULE 21/05

    RULE 21/06 "0 dose, [18-45y] old, Man and Femal, ID+: To do from 18y old (Priority level 1)"
      IF ALL OF
        CALC:Age in 18y..45y
        SYNTH:COMMON-RF-ID "COMMON-RF-ID - ID risk factors contraindicating vaccination with live vaccines" = true
      DO Recommended
        Status DUE
        Age 18y
      MESSAGES  MSG355 MSG357 MSG351
    END RULE 21/06

    RULE 21/07 "0 dose, [18-45y] old, Man and Femal, HIV+: To do from 18y old (Priority level 1)"
      IF ALL OF
        CALC:Age in 18y..45y
        COND:C24 "HIV infection" = true
      DO Recommended
        Status DUE
        Age 18y
      MESSAGES  MSG356 MSG357 MSG351
    END RULE 21/07
  END FOLDER 21

  FOLDER 22 "One dose"
    IF ALL OF
    CALC:HPV_doses_received = 1
    CALC:HPV_last_dose_is_booster = false

    RULE 22/01 "Booster-, 1 dose, ≥ 18y odl: To do 2m after LD"
      IF CALC:Age>=18y
      DO Recommended
        Status DUE
        Delay 2m from CALC:HPV_last_dose_date
      MESSAGES  MSG351
    END RULE 22/01
  END FOLDER 22

  FOLDER 23 "Two doses"
    IF ALL OF
    CALC:HPV_doses_received = 2
    CALC:HPV_last_dose_is_booster = false

    RULE 23/01 "Booster-, 2 doses, ≥ 18y old: To do 4m after LD"
      IF CALC:Age>=18y
      DO Recommended
        Status DUE
        Delay 4m from CALC:HPV_last_dose_date
      MESSAGES  MSG351
    END RULE 23/01
  END FOLDER 23

  FOLDER 33 "Three doses or more"
    IF ANY OF
    CALC:HPV_doses_received>=3
    CALC:HPV_last_dose_is_booster = true

    RULE 33/01 "≥ 3 doses or LD is a booster, ≥ 18y old: Up to date"
      IF CALC:Age>=18y
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG5
    END RULE 33/01
  END FOLDER 33
END FOLDER 2

FOLDER 8 "Contraindications and special cases"

  FOLDER 81 "Contraindications"
  END FOLDER 81

  FOLDER 82 "Special cases"

    RULE 82/01 "[11-20y] old, Case  « Refusal to vaccinate against this disease » checked: Special case + message"
      WHEN Recommended
      IF ALL OF
        COND:C626 "Refusal of HPV vaccination" = true
        CALC:Age in 11y..20y
      DO Exception
      MESSAGES  MSG19 MSG20
    END RULE 82/01
  END FOLDER 82
END FOLDER 8

FOLDER 9 "Further information"

  RULE 9/01 "[11-17y] old, d1 ≤ 14y old, If to do: message vaccination scheme"
    WHEN Recommended
    IF ALL OF
      CALC:Age in 11y..17y
      CALC:HPV_age_at_first_dose<=14y
    DO Neutral
    MESSAGES  MSG65
  END RULE 9/01

  RULE 9/02 "[11-17y] old, d1 ≥ 15y old, If to do: message vaccination scheme"
    WHEN Recommended
    IF ALL OF
      CALC:Age in 11y..17y
      CALC:HPV_age_at_first_dose>=15y
    DO Neutral
    MESSAGES  MSG366
  END RULE 9/02

  RULE 9/03 "≥ 18y old, If to do: message new program"
    WHEN Recommended
    IF CALC:Age>=18y
    DO Neutral
    MESSAGES  MSG361 MSG360
  END RULE 9/03

  RULE 9/04 "0 dose, [12-17y] old, If to do: Mandatory vaccination"
    WHEN Recommended
    IF ALL OF
      CALC:Age in 12y..17y
      CALC:HPV_doses_received = 0
    DO Neutral
    MESSAGES  MSG68
  END RULE 9/04
END FOLDER 9
END TARGET

MESSAGE MSG65 Comments ANY PRIO 0
  "The vaccination schedule consists of 2 doses, with an interval of 5 to 11 months between doses, to be administered between 12 and 17 years of age."@en
 END MESSAGE MSG65

MESSAGE MSG67 Justification ANY PRIO 0
  "The interval between the 2 doses is too short (less than 5 months). A 3rd dose is necessary."@en
 END MESSAGE MSG67

MESSAGE MSG351 Comments ANY PRIO 0
  "The vaccination schedule consists of three doses: 0, 2, and 6 months.
<br>The second dose should be administered at least one month after the first dose, and the third dose should be administered at least three months after the second dose. All three doses should be administered within one year."@en
 END MESSAGE MSG351

MESSAGE MSG357 Summary PATIENT PRIO 0
  "Vaccination is recommended because at least one risk factor is present."@en
 END MESSAGE MSG357

MESSAGE MSG353 Summary PRO PRIO 0
  "Vaccination is recommended for women aged 18–55 diagnosed with cervical adenocarcinoma in situ (AIS) (1st priority group)."@en
 END MESSAGE MSG353

MESSAGE MSG352 Summary PRO PRIO 0
  "Vaccination is recommended for women and men aged 25 years and over (2nd priority group)."@en
 END MESSAGE MSG352

MESSAGE MSG358 Summary PATIENT PRIO 0
  "Vaccination is recommended at the age of 25."@en
 END MESSAGE MSG358

MESSAGE MSG356 Summary PRO PRIO 0
  "Vaccination is recommended for women and men aged 18 to 45 living with HIV (1st priority group)."@en
 END MESSAGE MSG356

MESSAGE MSG354 Summary PRO PRIO 0
  "Vaccination is recommended for women aged 18 to 45 years with precancerous lesions: CIN 2/3 (cervix), VaIN 2/3 (vagina), VIN 2/3 (vulva), AIN 2/3 (anal canal) (1st priority group)."@en
 END MESSAGE MSG354

MESSAGE MSG5 Summary ANY PRIO 0
  "Vaccination schedule completed."@en
 END MESSAGE MSG5

MESSAGE MSG68 Alert ANY PRIO 0
  "This vaccination is compulsory in Latvia, between the ages of 12 and 17."@en
 END MESSAGE MSG68

MESSAGE MSG66 Summary ANY PRIO 0
  "Take a dose between 5 months and 11 months after the first dose (schedule started before the age of 15 years with 2 doses)."@en
 END MESSAGE MSG66

MESSAGE MSG355 Summary PRO PRIO 0
  "Vaccination is recommended for immunocompromised women and men aged 18 to 45 (1st priority group)."@en
 END MESSAGE MSG355

MESSAGE MSG19 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG19

MESSAGE MSG20 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been ticked in the health profile (‘Refusal of vaccination’ section)."@en
 END MESSAGE MSG20

MESSAGE MSG365 Summary ANY PRIO 0
  "Vaccination schedule started from the age of 15: a 3rd dose, 4 months after the last dose, is necessary."@en
 END MESSAGE MSG365

MESSAGE MSG361 Details PRO PRIO 0
  "<strong>New HPV Vaccination Recommendation in Latvia</strong>
<br>Following amendments to Cabinet Regulation No. 330 in July 2025, Latvia expanded access to publicly funded HPV vaccination. This reform introduced a classification of patients into three priority groups to organize vaccination according to dose availability:
<br>Group 1: People at increased risk
<br>Group 2: Second priority group
<br>Group 3: Last priority group
<br>Vaccination is carried out in this order of priority, depending on available supplies."@en
 END MESSAGE MSG361

MESSAGE MSG360 Details PATIENT PRIO 0
  "New HPV vaccination recommendation in Latvia, following amendments to Cabinet Regulation No. 330 adopted in July 2025. These changes expand access to state-funded HPV vaccination."@en
 END MESSAGE MSG360

MESSAGE MSG362 Summary PRO PRIO 0
  "Vaccination is recommended for women aged 18 to 55 years, before or after surgical treatment for high-grade cervical dysplasia (HSIL)  (Priority Group 1)."@en
 END MESSAGE MSG362

MESSAGE MSG350 Summary PRO PRIO 0
  "Vaccination is recommended for women and men aged 18 to 24 inclusive (3rd priority group)."@en
 END MESSAGE MSG350

MESSAGE MSG359 Summary PATIENT PRIO 0
  "Vaccination is recommended between the ages of 18 and 24."@en
 END MESSAGE MSG359

MESSAGE MSG364 Summary ANY PRIO 0
  "Faire une dose 2 mois après la première dose (schéma débuté à partir de l'âge de 15 ans : 0-2-6m)."@en
 END MESSAGE MSG364

MESSAGE MSG366 Comments ANY PRIO 0
  "The vaccination schedule consists of 3 doses, with an interval of 1 to 2 months between the first 2 doses, then 4 months after the second dose."@en
 END MESSAGE MSG366

MESSAGE MSG64 Summary ANY PRIO 0
  "First dose from the age of 12."@en
 END MESSAGE MSG64
