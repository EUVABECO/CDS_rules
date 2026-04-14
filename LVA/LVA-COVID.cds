CALC Covid_doses_received IS HIST(COVID,0,count)
CALC Covid_last_dose_date IS HIST(COVID,-1,date)

SYNTH COV-ATCD IS ALL OF COND:C919 "Date of last COVID-19" >= 0d

SYNTH COV-RF-ADLT "COV-RF-ADLT - Risk factors for severe COVID-19 in adults" IS ANY OF
  SYNTH:AFFECTIONS-CHR-LUNG-ADLT "AFFECTIONS-CHR-LUNG-ADLT - Chronic lung disease in adults" = true
  SYNTH:AFFECTIONS-CHR-HEART-ADLT "AFFECTIONS-CHR-HEART-ADLT - Chronic heart disease in adults" = true
  SYNTH:COV-CHR-META-ADLT "COV-CHR-META-ADLT - Chronic metabolic disorders in adults" = true
  SYNTH:AFFECTIONS-CHR-URO-ADLT "AFFECTIONS-CHR-URO-ADLT - Chronic kidney disease in adults" = true
  SYNTH:AFFECTIONS-CHR-ID-ADLT "AFFECTIONS-CHR-ID-ADLT - ID in adults" = true
  SYNTH:AFFECTIONS-CHR-LUNG-ADLT "AFFECTIONS-CHR-LUNG-ADLT - Chronic lung disease in adults" = true

SYNTH COV-CHR-META-ADLT "COV-CHR-META-ADLT - Chronic metabolic disorders in adults" IS ANY OF
  COND:C958 "Diabetes" = true
  COND:C1094 "Other chronic metabolic diseases" = true

SYNTH AFFECTIONS-CHR-ID-ADLT "AFFECTIONS-CHR-ID-ADLT - ID in adults" IS ANY OF
  COND:C880 "Rare systemic autoimmune disease with immunosuppressive therapy" = true
  COND:C1010 "Congenital immune deficiency, with strong immunosuppression" = true
  COND:C1096 "Immunodeficiency, whatever the cause (disease or treatment)." = true

SYNTH AFFECTIONS-CHR-LUNG-ADLT "AFFECTIONS-CHR-LUNG-ADLT - Chronic lung disease in adults" IS ANY OF
  COND:C126 "Asthma (other than severe and under continuous treatment)" = true
  COND:C304 "Severe asthma under continuous treatment" = true
  COND:C127 "Mucoviscidosis" = true
  COND:C128 "Bronchopulmonary dysplasia" = true
  COND:C39 "Chronic respiratory failure" = true
  COND:C281 "Chronic obstructive pulmonary disease (COPD)" = true
  COND:C142 "Other chronic respiratory disease" = true
  COND:C612 "Emphysema" = true
  COND:C912 "Sleep apnea" = true

SYNTH AFFECTIONS-CHR-URO-ADLT "AFFECTIONS-CHR-URO-ADLT - Chronic kidney disease in adults" IS ANY OF
  COND:C17 "Chronic renal failure on dialysis" = true
  COND:C18 "Chronic renal failure NOT on dialysis" = true
  COND:C6 "Nephrotic syndrome" = true
  COND:C1095 "Other chronic kidney diseases" = true

SYNTH AFFECTIONS-CHR-HEART-ADLT "AFFECTIONS-CHR-HEART-ADLT - Chronic heart disease in adults" IS ANY OF
  COND:C3 "Severe heart failure" = true
  COND:C4 "Severe Valvulopathy" = true
  COND:C927 "Myocarditis or pericarditis not related to SARS-CoV-2 infection, prior to vaccination and still active" = true
  COND:C954 "Cardiomyopathy" = true
  COND:C2 "Cyanogenic congenital heart disease" = true
  COND:C1037 "Other serious cardiovascular disease" = true
  COND:C961 "Hypertension, complicated or not" = true
  COND:C547 "Coronary artery disease" = true

TARGET COVID

FOLDER 1 "[12-64y] old"
  IF CALC:Age in 12y..64y

  RULE 1/01 "[12-64y] old, 0 dose: To do ASAP and 4m after last COVID-19"
    IF CALC:COVID_doses_received = 0
    DO Recommended
      Status DUE
      Age 12y
      Delay 4m from COND:C919 "Date of last COVID-19"
  END RULE 1/01

  FOLDER 11 "Zero history of COVID-19"
    IF SYNTH:COV-ATCD = false

    RULE 11/01 "[12-64y] old, ≥1 dose, 0 COVID: To do 12m after LD"
      IF CALC:COVID_doses_received>=1
      DO Recommended
        Status DUE
        Age 12y
        Delay 12m from CALC:Covid_last_dose_date
    END RULE 11/01
  END FOLDER 11

  FOLDER 12 "At least one history of COVID-19"
    IF SYNTH:COV-ATCD = true

    RULE 12/01 "[12-64y] old, ≥1 dose, COVID ≥ 8m LD: To do 4m after last COVID-19"
      IF ALL OF
        CALC:COVID_doses_received>=1
        INTERVAL(CALC:Covid_last_dose_date,COND:C919 "Date of last COVID-19")>=8m
      DO Recommended
        Status DUE
        Age 12y
        Delay 4m from COND:C919 "Date of last COVID-19"
    END RULE 12/01

    RULE 12/02 "[12-64y] old, ≥1 dose, COVID ≤ 7m LD: To do 12m after LD"
      IF ALL OF
        CALC:COVID_doses_received>=1
        INTERVAL(CALC:Covid_last_dose_date,COND:C919 "Date of last COVID-19") in 0d..7m
      DO Recommended
        Status DUE
        Age 12y
        Delay 12m from CALC:Covid_last_dose_date
    END RULE 12/02
  END FOLDER 12
END FOLDER 1

FOLDER 2 "≥ 65y old"
  IF CALC:Age>=65y

  RULE 2/01 "≥ 65y old, 0 dose: To do ASAP and 4m after last COVID-19"
    IF CALC:COVID_doses_received = 0
    DO Recommended
      Status DUE
      Age 65y
      Delay 4m from COND:C919 "Date of last COVID-19"
  END RULE 2/01

  FOLDER 21 "Zero history of COVID-19"
    IF SYNTH:COV-ATCD = false

    RULE 21/01 "≥ 65 old, ≥1 dose, 0 COVID: To do 6m after LD"
      IF CALC:COVID_doses_received>=1
      DO Recommended
        Status DUE
        Age 12y
        Delay 6m from CALC:Covid_last_dose_date
    END RULE 21/01
  END FOLDER 21

  FOLDER 22 "At least one history of COVID-19"
    IF SYNTH:COV-ATCD = true

    RULE 22/01 "≥ 65y old, ≥1 dose, COVID ≥ 2m LD: To do 4m after last COVID-19"
      IF ALL OF
        CALC:COVID_doses_received>=1
        INTERVAL(CALC:Covid_last_dose_date,COND:C919 "Date of last COVID-19")>=2m
      DO Recommended
        Status DUE
        Age 65y
        Delay 4m from COND:C919 "Date of last COVID-19"
    END RULE 22/01

    RULE 22/02 "≥ 65y old, ≥1 dose, COVID ≤ 1m LD: To do 6m after LD"
      IF ALL OF
        CALC:COVID_doses_received>=1
        INTERVAL(CALC:Covid_last_dose_date,COND:C919 "Date of last COVID-19")<=1m
      DO Recommended
        Status DUE
        Age 65y
        Delay 6m from CALC:Covid_last_dose_date
    END RULE 22/02
  END FOLDER 22
END FOLDER 2

FOLDER 9 "Further information"

  RULE 9/01 "If to do, ≥ 65y old, ≥ 0 dose: Information"
    WHEN Recommended
    IF CALC:Age>=65y
    DO Neutral
    MESSAGES  MSG202
  END RULE 9/01

  RULE 9/02 "If to do, ≥ 65y old, ≥ 1 dose: Information"
    WHEN Recommended
    IF ALL OF
      CALC:Age>=65y
      CALC:COVID_doses_received>=1
    DO Neutral
    MESSAGES  MSG198
  END RULE 9/02

  RULE 9/03 "If to do, COVID ≤ 4m: Information"
    WHEN Recommended
    IF COND:C919 "Date of last COVID-19"<=4m
    DO Neutral
    MESSAGES  MSG199
  END RULE 9/03

  RULE 9/04 "If to do, Pregnancy in progress: Information"
    WHEN Recommended
    IF SYNTH:PREGNANCY_ONGOING "PREGNANCY - Pregnancy in progress" = true
    DO Neutral
    MESSAGES  MSG200
  END RULE 9/04

  RULE 9/05 "If to do, BMI ≥ 30: Information"
    WHEN Recommended
    IF SYNTH:OBESITY "COMMON-META - Obesity if BMI ≥ 30 Kg/m2" = true
    DO Neutral
    MESSAGES  MSG201
  END RULE 9/05

  RULE 9/06 "If to do, Chronic condition: Information"
    WHEN Recommended
    IF SYNTH:COV-RF-ADLT "COV-RF-ADLT - Risk factors for severe COVID-19 in adults" = true
    DO Neutral
    MESSAGES  MSG203
  END RULE 9/06
END FOLDER 9
END TARGET

MESSAGE MSG200 Alert ANY PRIO 0
  "Vaccination particularly recommended during pregnancy."@en
 END MESSAGE MSG200

MESSAGE MSG201 Alert ANY PRIO 0
  "Vaccination particularly recommended if you are overweight."@en
 END MESSAGE MSG201

MESSAGE MSG203 Alert ANY PRIO 0
  "Vaccination particularly recommended if there is a medical risk factor for severe COVID-19."@en
 END MESSAGE MSG203

MESSAGE MSG198 Justification ANY PRIO 0
  "For people aged 65 and over, the minimum interval since the last Covid-19 vaccine is 6 months."@en
 END MESSAGE MSG198

MESSAGE MSG202 Alert ANY PRIO 0
  "Vaccination particularly recommended for people aged 65 and over."@en
 END MESSAGE MSG202

MESSAGE MSG199 Justification ANY PRIO 0
  "A delay of 4 to 6 months after the last episode of COVID-19 must be observed before administering a dose of vaccine."@en
 END MESSAGE MSG199
