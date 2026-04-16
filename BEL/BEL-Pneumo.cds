SYNTH PNEU-RF-ADU "PNEU-RF-ADU - Risk factors for severe pneumococcal infection (Adults)" IS ANY OF
  COND:C24 "HIV infection" = true
  COND:C19 "Waiting for an organ transplant (kidney, heart, liver or lung)" = true
  COND:C932 "Date of a solid organ transplant (kidney, heart, liver or lungs)">=6m
  COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)">=3m
  COND:C578 "Ongoing chemotherapy for solid tumor (cancer)" = true
  COND:C594 "Ongoing chemotherapy for hematological malignancy (leukemia)" = true
  COND:C413 "Other immunosuppressive therapy" = true
  COND:C579 "Biotherapy leading to immunosuppression" = true
  COND:C141 "Prolonged or high-dose corticosteroid therapy" = true
  COND:C36 "Spleen removal or non-functioning" = true
  COND:C23 "Homozygous sickle cell disease" = true
  COND:C7 "Double heterozygous sickle cell disease" = true
  SYNTH:PNEU-ID "PNEU-ID - Hereditary immune deficiencies and pneumococcal vaccine" = true
  COND:C50 "Moderate heart failure" = true
  COND:C3 "Severe heart failure" = true
  COND:C39 "Chronic respiratory failure" = true
  COND:C281 "Chronic obstructive pulmonary disease (COPD)" = true
  COND:C612 "Emphysema" = true
  COND:C304 "Severe asthma under continuous treatment" = true
  COND:C17 "Chronic renal failure on dialysis" = true
  COND:C18 "Chronic renal failure NOT on dialysis" = true
  COND:C41 "Chronic liver disease" = true
  COND:C34 "Osteo-meningeal breach" = true
  COND:C35 "Candidate for implantation or holder of a cochlear implant" = true
  COND:C6 "Nephrotic syndrome" = true
  COND:C2 "Cyanogenic congenital heart disease" = true
  COND:C404 "Cancer or hematological malignancy" = true
  COND:C992 "End date of chemotherapy for solid tumor (cancer)"<=2y
  COND:C1000 "Excessive alcohol use" = true
  COND:C917 "Strong immunosuppressive treatment (covid)" = true
  COND:C958 "Diabetes" = true

SYNTH PNEU-ID "PNEU-ID - Hereditary immune deficiencies and pneumococcal vaccine" IS ALL OF
  COND:C1231 "Immunocompromised person" = true

SYNTH PNEU-RF-CHILD "PNEU-RF-CHILD - Risk factors for severe pneumococcal infection (Children)" IS ALL OF
  SYNTH:PNEU-RF-ADU "PNEU-RF-ADU - Risk factors for severe pneumococcal infection (Adults)" = true

SYNTH PNEU-RF-ADU16-85 "PNEU-RF-ADU16-85 - [16-85y] old with an increased risk of pneumococcal infection" IS ANY OF
  COND:C24 "HIV infection" = true
  COND:C19 "Waiting for an organ transplant (kidney, heart, liver or lung)" = true
  COND:C932 "Date of a solid organ transplant (kidney, heart, liver or lungs)" >= 6m
  COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)" >= 3m
  COND:C578 "Ongoing chemotherapy for solid tumor (cancer)" = true
  COND:C594 "Ongoing chemotherapy for hematological malignancy (leukemia)" = true
  COND:C413 "Other immunosuppressive therapy " = true
  COND:C579 "Biotherapy leading to immunosuppression " = true
  COND:C141 "Prolonged or high-dose corticosteroid therapy " = true
  COND:C36 "Spleen removal or non-functioning " = true
  COND:C23 "Homozygous sickle cell disease " = true
  COND:C7 "Double heterozygous sickle cell disease " = true
  SYNTH:PNEU-ID "PNEU-ID - Hereditary immune deficiencies and pneumococcal vaccine" = true
  COND:C34 "Osteo-meningeal breach" = true
  COND:35 "Candidate for implantation or holder of a cochlear implant " = true
  COND:404 "Cancer or hematological malignancy " = true
  COND:C992 "End date of chemotherapy for solid tumor (cancer)" <= 2y
  COND:C917 "Strong immunosuppressive treatment (covid)" = true
  COND:1231 "Immunocompromised person " = true

SYNTH PNEU-RF-ADU-65-85 "PNEU-RF-ADU-65-85 - [65-85y] old no RF no comorbidity" IS ALL OF
  CALC:Age in 65..85
  SYNTH:PNEU-RF-ADU16-85 = false
  SYNTH:PNEU-RF-ADU50-85 = false

SYNTH PNEU-RF-ADU50-85 "PNEU-RF-ADU50-85 - [50-85y] old with a comorbidity" IS ANY OF
  COND:C50 "Moderate heart failure" = true
  COND:C3 "Severe heart failure " = true
  COND:C39 "Chronic respiratory failure " = true
  COND:C281 "Chronic obstructive pulmonary disease (COPD)" = true
  COND:612 "Emphysema " = true
  COND:304 "Severe asthma under continuous treatment " = true
  COND:17 "Chronic renal failure on dialysis " = true
  COND:18 "Chronic renal failure NOT on dialysis " = true
  COND:41 "Chronic liver disease " = true
  COND:6 "Nephrotic syndrome " = true
  COND:2 "Cyanogenic congenital heart disease " = true
  COND:1000 "Excessive alcohol use " = true
  COND:1157 "Chronic neuromuscular diseases with risk of false swallowing " = true
  COND:958 "Diabetes " = true
  COND:54 "Smoker " = true

SYNTH PNEU-ONLY-13-15 "PNEU-ONLY-13/15 - Received only doses 13 or 15 valent (not unconjugated vaccine)" IS ALL OF
  CALC:Pneu_valences_received contains VPC-03
  CALC:Pneu_valences_received contains no VPC-08
  CALC:Pneu_valences_received contains no VPP-05

SYNTH PNEU-LD-23 "PNEU-LD-23 - Last dose include unconjgated vaccine like PNEUMO 23" IS ALL OF 
  CALC:Pneu_last_dose_valences contains VPP-05

SYNTH PNEU-PREMA "PNEU-PREMA - Premature babies ≤ 36w" IS ALL OF 
  COND:C995 "Number of weeks of amenorrhoea at birth for a premature baby"<=36

SYNTH PNEU-LD-20 "PNEU-LD-20 - Last dose is PREVENAR 20" IS ALL OF
  CALC:Pneu_last_dose_valences contains VPC-08
  CALC:Pneu_last_dose_valences contains no VPC-09N

SYNTH PNEU-D2-13-15 "PNEU-D2-13/15 - d2 = 13 or 15 conjugated vaccine" IS ALL OF
  CALC:Pneu_second_dose_valences contains VPC-03
  CALC:Pneu_second_dose_valences contains no VPC-08

SYNTH PNEU-D1-13-15 "PNEU-D1-13/15 - d1 = 13 or 15 conjugated vaccine" IS ALL OF
  CALC:Pneu_first_dose_valences contains VPC-03
  CALC:Pneu_first_dose_valences contains no VPC-08

SYNTH PNEU-LD-13-15 "PNEU-LD-13/15 - Last dose is 13 or 15 conjugated vaccine" IS ALL OF
  CALC:Pneu_last_dose_valences contains VPC-03
  CALC:Pneu_last_dose_valences contains no VPC-08

SYNTH PNEU-BLD-23 "PNEU-BLD-23 - Before last dose include unconjgated like PNEUMO 23" IS ALL OF
  CALC:Pneu_penultimate_dose_valences contains VPP-05

SYNTH PNEU-13-15 "PNEU-13/15 - Received ≥ 1 dose conjugated vaccine like 13 or 15" IS ALL OF
  CALC:Pneu_valences_received contains VPC-03
  CALC:Pneu_valences_received contains no VPC-08

SYNTH PNEU-ONLY-23 "PNEU-ONLY-23 - Received only doses unconjugated vaccine like PNEUMO 23" IS ALL OF
  CALC:Pneu_valences_received contains no VPC-04
  CALC:Pneu_valences_received contains no VPC-08
  CALC:Pneu_valences_received contains VPP-05

SYNTH PNEU-20 "PNEU-20 - Received ≥ 1 dose conjugated vaccine like PREVENAR 20" IS ALL OF
  CALC:Pneu_valences_received contains VPC-08
  CALC:Pneu_valences_received contains no VPC-09N

SYNTH PNEU-2D-23 "PNEU-2D-23 - 2 doses unconjgated vaccine like PNEUMO 23" IS ALL OF 
  CALC:PPSV_05_doses_received = 2

CALC Pneu_doses_received IS HIST(Pneumo,0,count)
CALC Pneu_received_valences is HIST(Pneumo,0,valences)
CALC PPSV_05_doses_received IS HIST(PPSV-05,0,count)

CALC Pneu_first_dose_valences is HIST(Pneumo,1,valences)
CALC Pneu_age_at_first_act is INTERVAL(BASE:dob, HIST(PNEUMO,1,date))

CALC Pneu_second_dose_valences is HIST(Pneumo,2,valences)

CALC PPSV_05_age_at_first_dose IS INTERVAL(BASE:dob,HIST(PPSV-05,1,date))

CALC Pneu_penultimate_dose_date IS HIST(Pneumo,-2,date)
CALC Pneu_penultimate_dose_valences IS HIST(Pneumo,-2,valences)

CALC Pneu_last_dose_date IS HIST(Pneumo,-1,date)
CALC Pneu_lst_dose_valences_ids IS HIST(Pneumo,-1,valences)
CALC Pneu_age_at_last_dose IS INTERVAL(BASE:dob,CALC:Pneu_last_dose_date)
CALC Per_time_since_last_dose IS INTERVAL(CALC:Per_last_dose_date,BASE:eval)


CALC Pneu_d1d2 is INTERVAL(HIST(PNEUMO,1,date),HIST(PNEUMO,2,date))
CALC Pneu_d2d3 is INTERVAL(HIST(PNEUMO,2,date),HIST(PNEUMO,3,date))
CALC Pneu_d3d4 is INTERVAL(HIST(PNEUMO,3,date),HIST(PNEUMO,4,date))
	

TARGET Pneumo

FOLDER 1 "Risk Factors -"
  IF ALL OF
  SYNTH:PNEU-RF-CHILD "PNEU-RF-CHILD - Risk factors for severe pneumococcal infection (Children)" = false
  SYNTH:PNEU-RF-ADU "PNEU-RF-ADU - Risk factors for severe pneumococcal infection (Adults)" = false
  SYNTH:PNEU-RF-ADU16-85  = false
  SYNTH:PNEU-RF-ADU50-85 = false

  FOLDER 11 "≤ 64y old"
    IF CALC:Age<=64y

    FOLDER 110 "Zero dose"
      IF CALC:Pneu_doses_received = 0

      RULE 110/01 "RF-, ≤ 6m old, 0 dose: To do from 2m old"
        IF CALC:Age<=6m
        DO Recommended
          Status DUE
          Age 2m
      END RULE 110/01

      RULE 110/02 "RF-, ≥ 7m old, 0 dose: To do ASAP"
        IF CALC:Age in 7m..11m
        DO Recommended
          Status DUE
          Age 7m
      END RULE 110/02
    END FOLDER 110

    FOLDER 111 "First dose ≤ 6 month"
      IF CALC:Pneu_age_at_first_act<=6m

      FOLDER 1111 "One dose PCV13/15"
        IF ALL OF
        CALC:Pneu_doses_received = 1
        SYNTH:PNEU-ONLY-13-15 "PNEU-ONLY-13/15 - Received only doses 13 or 15 valent (not unconjugated vaccine)" = true

        RULE 111-1/01 "RF-, Premature baby-, 1 dose  PCV13/15, d1 ≤ 6m old: To do from 4m old 8w after LD with same number of valences -  Scheme 3 doses (2+1)"
          IF ALL OF
            CALC:Pneu_doses_received = 1
            SYNTH:PNEU-PREMA "PNEU-PREMA - Premature babies ≤ 36w" = false
          DO Recommended
            Status DUE
            Age 4m
            Delay 8w from CALC:Pneu_last_dose_date
        END RULE 111-1/01

        RULE 111-1/02 "RF-, Premature baby+, 1 dose  PCV13/15, d1 ≤ 6m old: To do from 3m old 4w after LD with same number of valences - Scheme 4 doses (3+1)"
          IF ALL OF
            CALC:Pneu_doses_received = 1
            SYNTH:PNEU-PREMA "PNEU-PREMA - Premature babies ≤ 36w" = true
          DO Recommended
            Status DUE
            Age 3m
            Delay 4w from CALC:Pneu_last_dose_date
        END RULE 111-1/02
      END FOLDER 1111

      FOLDER 1112 "Two doses PCV13/15"
        IF ALL OF
        CALC:Pneu_doses_received = 2
        SYNTH:PNEU-ONLY-13-15 "PNEU-ONLY-13/15 - Received only doses 13 or 15 valent (not unconjugated vaccine)" = true

        RULE 111-2/01 "RF-, Premature baby+, 2 doses PCV13/15, d1 ≤ 6m old: To do from 4m old 4w after LD with PCV13/15"
          IF SYNTH:PNEU-PREMA "PNEU-PREMA - Premature babies ≤ 36w" = true
          DO Recommended
            Status DUE
            Age 4m
            Delay 4w from CALC:Pneu_last_dose_date
        END RULE 111-2/01

        RULE 111-2/01 "RF-, Premature baby-, 2 doses PCV13/15, d1 ≤ 6m old: To do from 12m old 8m after LD with PCV13/15"
          IF SYNTH:PNEU-PREMA "PNEU-PREMA - Premature babies ≤ 36w" = false
          DO Recommended
            Status DUE
            Age 12m
            Delay 8m from CALC:Pneu_last_dose_date
        END RULE 111-2/01
      END FOLDER 1112

      FOLDER 1113 "Three doses or more PCV13/15"
        IF ALL OF
        CALC:Pneu_doses_received>=3
        SYNTH:PNEU-ONLY-13-15 "PNEU-ONLY-13/15 - Received only doses 13 or 15 valent (not unconjugated vaccine)" = true

        RULE 111-3/01 "RF-, Premature baby-, 3 doses PCV13/15, d1 ≤ 6m old: Up to date"
          IF SYNTH:PNEU-PREMA "PNEU-PREMA - Premature babies ≤ 36w" = true
          DO Recommended
            Status COMPLETED
          MESSAGES  MSG11
        END RULE 111-3/01

        RULE 111-3/02 "RF-, Premature baby+, 3 doses PCV13/15, d1 ≤ 6m old: To do from 12m old 8m after LD with PCV13/15"
          IF ALL OF
            SYNTH:PNEU-PREMA "PNEU-PREMA - Premature babies ≤ 36w" = true
            CALC:Pneu_doses_received = 3
          DO Recommended
            Status DUE
            Age 12m
            Delay 8m from CALC:Pneu_last_dose_date
        END RULE 111-3/02
      END FOLDER 1113

      FOLDER 1114 "Four doses or more PCV13/15"
        IF ALL OF
        CALC:Pneu_doses_received>=4
        SYNTH:PNEU-ONLY-13-15 "PNEU-ONLY-13/15 - Received only doses 13 or 15 valent (not unconjugated vaccine)" = true

        RULE 111-4/01 "RF-, ≥ 4 doses PCV13/15, d1 ≤ 6m old: Up to date"
          IF CALC:Pneu_doses_received>=4
          DO Recommended
            Status COMPLETED
          MESSAGES  MSG11
        END RULE 111-4/01
      END FOLDER 1114
    END FOLDER 111

    FOLDER 112 "First dose 7- 11 months"
      IF CALC:Pneu_age_at_first_act in 7m..11m

      FOLDER 1121 "One dose PCV13/15"
        IF ALL OF
        CALC:Pneu_doses_received = 1
        SYNTH:PNEU-ONLY-13-15 "PNEU-ONLY-13/15 - Received only doses 13 or 15 valent (not unconjugated vaccine)" = true

        RULE 112-1/01 "RF-, d1 [7-11m] old, 1 dose PCV13/15: To do 4w after LD with same number of valences"
          IF CALC:Pneu_doses_received = 1
          DO Recommended
            Status DUE
            Delay 4w from CALC:Pneu_last_dose_date
        END RULE 112-1/01
      END FOLDER 1121

      FOLDER 1122 "Two doses PCV13/15"
        IF ALL OF
        CALC:Pneu_doses_received = 2
        SYNTH:PNEU-ONLY-13-15 "PNEU-ONLY-13/15 - Received only doses 13 or 15 valent (not unconjugated vaccine)" = true

        RULE 112-2/01 "RF-, d1 [7-11m] old, 2 dose PCV13/15: To do 4-8w after LD with with same number of valences"
          IF CALC:Pneu_doses_received = 2
          DO Recommended
            Status DUE
            Delay 4w..8w from CALC:Pneu_last_dose_date
        END RULE 112-2/01
      END FOLDER 1122

      FOLDER 1123 "Three doses or more PCV13/15"
        IF ALL OF
        CALC:Pneu_doses_received>=3
        SYNTH:PNEU-ONLY-13-15 "PNEU-ONLY-13/15 - Received only doses 13 or 15 valent (not unconjugated vaccine)" = true

        RULE 112-3/01 "RF-, d1 [7-11m] old, 3 dose PCV13/15: Up to date"
          IF CALC:Pneu_doses_received>=3
          DO Recommended
            Status COMPLETED
          MESSAGES  MSG11
        END RULE 112-3/01
      END FOLDER 1123
    END FOLDER 112

    FOLDER 113 "First dose 12- 23 months"
      IF CALC:Pneu_age_at_first_act in 12m..23m

      FOLDER 1131 "One dose PCV13/15"
        IF ALL OF
        CALC:Pneu_doses_received = 1
        SYNTH:PNEU-ONLY-13-15 "PNEU-ONLY-13/15 - Received only doses 13 or 15 valent (not unconjugated vaccine)" = true

        RULE 113-1/01 "RF-, d1 [12-23m] old, 1 dose PCV13/15: To do 8w after LD  with same number of valences"
          IF CALC:Pneu_doses_received = 1
          DO Recommended
            Status DUE
            Delay 8w from CALC:Pneu_last_dose_date
        END RULE 113-1/01
      END FOLDER 1131

      FOLDER 1132 "Two doses or more PCV13/15"
        IF ALL OF
        CALC:Pneu_doses_received>=2
        SYNTH:PNEU-ONLY-13-15 "PNEU-ONLY-13/15 - Received only doses 13 or 15 valent (not unconjugated vaccine)" = true

        RULE 113-2/01 "RF-, d1 [12-23m] old, ≥ 2 doses PCV13/15: Up to date"
          IF CALC:Pneu_doses_received>=2
          DO Recommended
            Status COMPLETED
          MESSAGES  MSG11
        END RULE 113-2/01
      END FOLDER 1132
    END FOLDER 113

    FOLDER 114 "First dose ≥ 24 months"
      IF ALL OF
      SYNTH:PNEU-RF-ADU "PNEU-RF-ADU - Risk factors for severe pneumococcal infection (Adults)" = false
      CALC:Pneu_age_at_first_act>=24m

      RULE 114/01 "RF-, d1 ≥ 24m old, ≥1dose, LD = PCV13/15: Up to date"
        IF CALC:Pneu_doses_received>=1
        DO Recommended
          Status COMPLETED
        MESSAGES  MSG11
      END RULE 114/01
    END FOLDER 114
  END FOLDER 11
END FOLDER 1

FOLDER 2 "Risk Factors +"

  FOLDER 21 "≤ 23m old"
    IF ALL OF
    CALC:Age<=23m
    SYNTH:PNEU-RF-CHILD "PNEU-RF-CHILD - Risk factors for severe pneumococcal infection (Children)" = true

    FOLDER 211 "Zero dose"
      IF CALC:Pneu_doses_received = 0
    END FOLDER 211

    FOLDER 212 "One dose PCV13/15"
      IF ALL OF
      CALC:Pneu_doses_received = 1
      SYNTH:PNEU-ONLY-13-15 "PNEU-ONLY-13/15 - Received only doses 13 or 15 valent (not unconjugated vaccine)" = true

      RULE 212/01 "RF+, ≤ 23m old, 1 dose, d1 ≤ 6m old: To do 1m after LD + message"
        IF ALL OF
          CALC:Age<=23m
          CALC:Pneu_age_at_first_act<=6m
        DO Recommended
          Status DUE
          Delay 1m from CALC:Pneu_last_dose_date
        MESSAGES  MSG108
      END RULE 212/01

      RULE 212/02 "RF+, ≤ 23m old, 1 dose, d1 [7-11m] old: DUE 1m after LD with PCV13/15"
        IF CALC:Pneu_age_at_first_act in 7m..11m
        DO Recommended
          Status DUE
          Delay 1m from CALC:Pneu_last_dose_date
        MESSAGES  MSG123 MSG91
      END RULE 212/02

      RULE 212/03 "RF+, ≤ 23m old, 1 dose, d1 [12-23m] old: To do 2m after LD with PCV13/15"
        IF CALC:Pneu_age_at_first_act>=12m
        DO Recommended
          Status DUE
          Delay 2m from CALC:Pneu_last_dose_date
        MESSAGES  MSG103
      END RULE 212/03
    END FOLDER 212

    FOLDER 213 "Two doses PCV13/15"
      IF ALL OF
      CALC:Pneu_doses_received = 2
      SYNTH:PNEU-ONLY-13-15 "PNEU-ONLY-13/15 - Received only doses 13 or 15 valent (not unconjugated vaccine)" = true

      RULE 213/01 "RF+, ≤ 23m old, d1 [6w-6m] old, d1d2 ≤ 6w, 2 doses: To do 1m after LD (3rd dose)"
        IF ALL OF
          CALC:Pneu_d1d2<=6w
          CALC:Pneu_age_at_first_act in 6w..6m
        DO Recommended
          Status DUE
          Delay 1m from CALC:Pneu_last_dose_date
        MESSAGES  MSG127 MSG128
      END RULE 213/01

      RULE 213/02 "RF+, ≤ 23m old, d1 [6w-6m] old, d1d2 ≥ 7w, 2 doses: To do from 12m old 2m after LD with PCV13/15"
        IF ALL OF
          CALC:Pneu_d1d2>=7w
          CALC:Pneu_age_at_first_act in 6w..6m
        DO Recommended
          Status DUE
          Age 12m
          Delay 2m from CALC:Pneu_last_dose_date
        MESSAGES  MSG91
      END RULE 213/02

      RULE 213/03 "RF+, ≤ 23m old, d1 [7-11m] old, 2 doses: To do from 12m old, 5m after LD"
        IF CALC:Pneu_age_at_first_act in 7m..11m
        DO Recommended
          Status DUE
          Age 12m
          Delay 5m from CALC:Pneu_last_dose_date
      END RULE 213/03

      RULE 213/04 "RF+, ≤ 23m old, d1 ≥ 12m old, d1d2 ≤ 6w, 2 doses: To do 2m after LD"
        IF ALL OF
          CALC:Pneu_d1d2<=6w
          CALC:Pneu_age_at_first_act>=12m
        DO Recommended
          Status DUE
          Delay 2m from CALC:Pneu_last_dose_date
        MESSAGES  MSG129
      END RULE 213/04

      RULE 213/05 "RF+, ≤ 23m old, d1 ≥ 12m old, d1d2 ≥ 7w, 2 doses: To do from 24m old, 8w after LD"
        IF ALL OF
          CALC:Pneu_d1d2>=7w
          CALC:Pneu_age_at_first_act>=12m
        DO Recommended
          Status DUE
          Age 24m
          Delay 8w from CALC:Pneu_last_dose_date
        MESSAGES  MSG105
      END RULE 213/05
    END FOLDER 213

    FOLDER 214 "Three doses or more PCV13/15"
      IF ALL OF
      CALC:Pneu_doses_received>=3
      SYNTH:PNEU-ONLY-13-15 "PNEU-ONLY-13/15 - Received only doses 13 or 15 valent (not unconjugated vaccine)" = true

      RULE 214/01 "RF+, ≤ 23m old, LD ≤ 9m old, 3 doses: To do from 12-15m old, 5m after LD"
        IF ALL OF
          CALC:Pneu_doses_received = 3
          CALC:Pneu_age_at_last_dose<=9m
        DO Recommended
          Status DUE
          Age 12m..15m
          Delay 5m from CALC:Pneu_last_dose_date
        MESSAGES  MSG87
      END RULE 214/01

      RULE 214/02 "RF+, ≤ 23m old, LD 10m old, ≥ 3 doses: To do from 12-15m old, 5m after LD"
        IF CALC:Pneu_age_at_last_dose = 10m
        DO Recommended
          Status DUE
          Age 12m..15m
          Delay 5m from CALC:Pneu_last_dose_date
      END RULE 214/02

      RULE 214/03 "RF+, ≤ 23m old, LD ≥ 11m old, ≥ 3 doses: To do from 24m old, 8w after LD with 23v"
        IF CALC:Pneu_age_at_last_dose>=11m
        DO Recommended
          Status DUE
          Age 24m
          Delay 8w from CALC:Pneu_last_dose_date
        MESSAGES  MSG86
      END RULE 214/03
    END FOLDER 214
  END FOLDER 21

  FOLDER 22 "[24m-15y] old"
    IF ALL OF
    CALC:Age in 24m..15y
    SYNTH:PNEU-RF-CHILD "PNEU-RF-CHILD - Risk factors for severe pneumococcal infection (Children)" = true

    FOLDER 221 "Zero dose"
      IF CALC:Pneu_doses_received = 0

      RULE 221/01 "RF+, [24m-15y] old, 0 dose: To do PCV13/15"
        IF CALC:Pneu_doses_received = 0
        DO Recommended
          Status DUE
          Age 24m
      END RULE 221/01
    END FOLDER 221

    FOLDER 222 "One dose"
      IF CALC:Pneu_doses_received = 1

      RULE 222/01 "RF+, [24-59m] old, 1 dose PCV13/15 ≥ 24m old: To do 2m after LD with PCV13/15"
        IF ALL OF
          CALC:Pneu_age_at_first_act>=24m
          CALC:Age in 24m..59m
          SYNTH:PNEU-ONLY-13-15 "PNEU-ONLY-13/15 - Received only doses 13 or 15 valent (not unconjugated vaccine)" = true
        DO Recommended
          Status DUE
          Delay 2m from CALC:Pneu_last_dose_date
      END RULE 222/01

      RULE 222/02 "RF+, [24m-15y] old, 1 dose PCV13/15 ≤ 23m old : To do 2m after LD with PCV13/15"
        IF ALL OF
          CALC:Pneu_age_at_first_act in 6w..23m
          SYNTH:PNEU-ONLY-13-15 "PNEU-ONLY-13/15 - Received only doses 13 or 15 valent (not unconjugated vaccine)" = true
        DO Recommended
          Status DUE
          Delay 2m from CALC:Pneu_last_dose_date
        MESSAGES  MSG103
      END RULE 222/02

      RULE 222/03 "RF+, [60m-15y] old, 1 dose PCV13/15 ≥ 24m old: To do 2m after LD with 23v"
        IF ALL OF
          CALC:Age in 60m..17y
          CALC:Pneu_age_at_first_act>=24m
          SYNTH:PNEU-ONLY-13-15 "PNEU-ONLY-13/15 - Received only doses 13 or 15 valent (not unconjugated vaccine)" = true
        DO Recommended
          Status DUE
          Delay 2m from CALC:Pneu_last_dose_date
        MESSAGES  MSG86
      END RULE 222/03

      RULE 222/04 "RF+, [24m-15y] old, 1 dose 23v ≥ 24m old: To do 1y after LD with PCV13/15"
        IF ALL OF
          CALC:Pneu_age_at_first_act>=24m
          SYNTH:PNEU-LD-23 "PNEU-LD-23 - Last dose include unconjgated vaccine like PNEUMO 23" = true
        DO Recommended
          Status DUE
          Delay 1y from CALC:Pneu_last_dose_date
        MESSAGES  MSG99 MSG91
      END RULE 222/04
    END FOLDER 222

    FOLDER 223 "Two doses"
      IF CALC:Pneu_doses_received = 2

      RULE 223/01 "RF+, [24m-15y] old, 2 doses PCV13/15, d1 ≥ 24m old, d1d2 ≥ 3w: To do 2m after LD with 23v"
        IF ALL OF
          CALC:Pneu_d1d2>=3w
          SYNTH:PNEU-ONLY-13-15 "PNEU-ONLY-13/15 - Received only doses 13 or 15 valent (not unconjugated vaccine)" = true
          CALC:Pneu_age_at_first_act>=24m
        DO Recommended
          Status DUE
          Delay 2m from CALC:Pneu_last_dose_date
        MESSAGES  MSG86
      END RULE 223/01

      RULE 223/02 "RF+, [24m-15y] old, 2 doses PCV13/15, d1 ≥ 12m old, d1d2 ≥ 7w: To do 2m after LD with 23v"
        IF ALL OF
          CALC:Pneu_age_at_first_act>=12m
          CALC:Pneu_d1d2>=7w
          SYNTH:PNEU-ONLY-13-15 "PNEU-ONLY-13/15 - Received only doses 13 or 15 valent (not unconjugated vaccine)" = true
        DO Recommended
          Status DUE
          Delay 2m from CALC:Pneu_last_dose_date
        MESSAGES  MSG86
      END RULE 223/02

      RULE 223/03 "RF+, [24m-15y] old, 2 doses PCV13/15, d1 ≤11m old, d2 ≤ 23m old: To do 2m after LD with PCV13/15"
        IF ALL OF
          CALC:Pneu_age_at_first_act<=11m
          CALC:Pneu_age_at_last_dose<=23m
          SYNTH:PNEU-ONLY-13-15 "PNEU-ONLY-13/15 - Received only doses 13 or 15 valent (not unconjugated vaccine)" = true
        DO Recommended
          Status DUE
          Delay 2m from CALC:Pneu_last_dose_date
        MESSAGES  MSG91 MSG92
      END RULE 223/03

      RULE 223/04 "RF+, [24m-15y] old, 2 doses PCV13/15, d1d2 ≤ 6w, d2 ≤ 23m old: To do 2m after LD with PCV13/15"
        IF ALL OF
          CALC:Pneu_d1d2<=6w
          CALC:Pneu_age_at_last_dose<=23m
          SYNTH:PNEU-ONLY-13-15 "PNEU-ONLY-13/15 - Received only doses 13 or 15 valent (not unconjugated vaccine)" = true
        DO Recommended
          Status DUE
          Delay 2m from CALC:Pneu_last_dose_date
        MESSAGES  MSG91 MSG113
      END RULE 223/04

      RULE 223/05 "RF+, [24m-15y] old, 2 doses 23v, d1 ≥ 24m old, d1d2 ≥ 3w: To do 2m after LD with PCV13/15"
        IF ALL OF
          CALC:Pneu_age_at_first_act>=24m
          CALC:Pneu_d1d2>=3w
          SYNTH:PNEU-2D-23 "PNEU-2D-23 - 2 doses unconjgated vaccine like PNEUMO 23" = true
        DO Recommended
          Status DUE
          Delay 2m from CALC:Pneu_last_dose_date
        MESSAGES  MSG114 MSG91
      END RULE 223/05

      RULE 223/06 "RF+, [24-59m] old, 1 dose PCV13/15 + 1 dose 23v, d1 ≥ 24m old, d1d2 ≥ 6w: To do 5y after LD with 23v"
        IF ALL OF
          CALC:Age in 24m..59m
          CALC:Pneu_d1d2>=6w
          CALC:Pneu_age_at_first_act>=24m
          SYNTH:PNEU-LD-23 "PNEU-LD-23 - Last dose include unconjgated vaccine like PNEUMO 23" = true
          SYNTH:PNEU-D1-13-15 "PNEU-D1-13/15 - d1 = 13 or 15 conjugated vaccine" = true
        DO Recommended
          Status DUE
          Delay 5y from CALC:Pneu_last_dose_date
        MESSAGES  MSG93 MSG115
      END RULE 223/06

      RULE 223/07 "RF+, [60m-15y] old, 1 dose PCV13/15 + 1 dose 23v, d1 ≥ 24m old, d1d2 ≥ 6w: To do 5y after LD with 23v"
        IF ALL OF
          CALC:Pneu_age_at_first_act>=24m
          CALC:Pneu_d1d2>=6w
          CALC:Age in 60m..15y
          SYNTH:PNEU-LD-23 "PNEU-LD-23 - Last dose include unconjgated vaccine like PNEUMO 23" = true
          SYNTH:PNEU-D1-13-15 "PNEU-D1-13/15 - d1 = 13 or 15 conjugated vaccine" = true
        DO Recommended
          Status DUE
          Delay 5y from CALC:Pneu_last_dose_date
        MESSAGES  MSG93
      END RULE 223/07
    END FOLDER 223

    FOLDER 224 "Three doses"
      IF CALC:Pneu_doses_received = 3

      RULE 224/01 "RF+, [24m-15y] old, 3 doses PCV13/15, LD ≤ 10m old, d1d2 ≥ 3w, d2d3 ≥ 3w: To do 2m after LD with PCV13/15"
        IF ALL OF
          CALC:Pneu_age_at_last_dose<=10m
          CALC:Pneu_d1d2>=3w
          CALC:Pneu_d2d3>=3w
          SYNTH:PNEU-ONLY-13-15 "PNEU-ONLY-13/15 - Received only doses 13 or 15 valent (not unconjugated vaccine)" = true
        DO Recommended
          Status DUE
          Delay 2m from CALC:Pneu_last_dose_date
        MESSAGES  MSG100 MSG91
      END RULE 224/01

      RULE 224/02 "RF+, [24m-15y] old, 3 doses PCV13/15, LD ≥ 11m old, d1d2 ≥ 3w, d2d3 ≥ 3w: To do 2m after LD with 23v"
        IF ALL OF
          CALC:Pneu_d1d2>=3w
          CALC:Pneu_age_at_last_dose>=11m
          CALC:Pneu_d2d3>=3w
          SYNTH:PNEU-ONLY-13-15 "PNEU-ONLY-13/15 - Received only doses 13 or 15 valent (not unconjugated vaccine)" = true
        DO Recommended
          Status DUE
          Delay 2m from CALC:Pneu_last_dose_date
        MESSAGES  MSG86
      END RULE 224/02

      RULE 224/03 "RF+, [24m-15y] old, d1d2=PCV13/15, d3=23v, d1 ≥ 12m old, d1d2 ≥ 6w, d2d3 ≥ 6w: To do 5y after LD with 23v"
        IF ALL OF
          CALC:Pneu_age_at_first_act>=12m
          CALC:Pneu_d1d2>=6w
          CALC:Pneu_d2d3>=6w
          SYNTH:PNEU-D1-13-15 "PNEU-D1-13/15 - d1 = 13 or 15 conjugated vaccine" = true
          SYNTH:PNEU-D2-13-15 "PNEU-D2-13/15 - d2 = 13 or 15 conjugated vaccine" = true
          SYNTH:PNEU-LD-23 "PNEU-LD-23 - Last dose include unconjgated vaccine like PNEUMO 23" = true
        DO Recommended
          Status DUE
          Delay 5y from CALC:Pneu_last_dose_date
        MESSAGES  MSG86
      END RULE 224/03

      RULE 224/04 "RF+, [24m-15y] old, d1d2=PCV13/15, d3=23v, d1 [6w-11m] old, d1d2 ≥ 3w, d2d3 ≥ 3w, d3  ≥ 24m old: DUE AF 5y after LD with 23v"
        IF ALL OF
          CALC:Pneu_d1d2>=3w
          CALC:Pneu_d2d3>=3w
          CALC:Pneu_age_at_first_act in 6w..11m
          CALC:Pneu_age_at_last_dose>=24m
          SYNTH:PNEU-D1-13-15 "PNEU-D1-13/15 - d1 = 13 or 15 conjugated vaccine" = true
          SYNTH:PNEU-D2-13-15 "PNEU-D2-13/15 - d2 = 13 or 15 conjugated vaccine" = true
          SYNTH:PNEU-LD-23 "PNEU-LD-23 - Last dose include unconjgated vaccine like PNEUMO 23" = true
        DO Recommended
          Status DUE
          Delay 5y from CALC:Pneu_last_dose_date
        MESSAGES  MSG93 MSG94
      END RULE 224/04
    END FOLDER 224

    FOLDER 225 "Four doses or more"
      IF CALC:Pneu_doses_received>=4

      RULE 225/01 "RF+, [24m-15y] old, ≥ 4 doses PCV13/15 only, LD ≥ 11m old, d1d2 ≥ 3w, d2d3 ≥ 3w, d3d4 ≥ 3w, BLD-LD ≥ 3w: To do 2m after LD with 23v"
        IF ALL OF
          CALC:Pneu_d1d2>=3w
          CALC:Pneu_d2d3>=3w
          CALC:Pneu_d3d4>=3w
          INTERVAL(CALC:Pneu_penultimate_dose_date,CALC:Pneu_last_dose_date)>=3w
          CALC:Pneu_age_at_last_dose>=11m
          SYNTH:PNEU-D1-13-15 "PNEU-D1-13/15 - d1 = 13 or 15 conjugated vaccine" = true
        DO Recommended
          Status DUE
          Delay 2m from CALC:Pneu_last_dose_date
        MESSAGES  MSG86
      END RULE 225/01

      RULE 225/02 "RF+, [24m-15y] old, ≥ 4 doses 23v only, d1d2 ≥ 3w, d2d3 ≥ 3w, d3d4 ≥ 3w, BLD-LD ≥ 3w: To do 1y after LD with PCV13/15"
        IF ALL OF
          CALC:Pneu_d1d2>=3w
          CALC:Pneu_d2d3>=3w
          INTERVAL(CALC:Pneu_penultimate_dose_date,CALC:Pneu_last_dose_date)>=3w
          CALC:Pneu_d3d4>=3w
          SYNTH:PNEU-ONLY-23 "PNEU-ONLY-23 - Received only doses unconjugated vaccine like PNEUMO 23" = true
        DO Recommended
          Status DUE
          Delay 1y from CALC:Pneu_last_dose_date
        MESSAGES  MSG118 MSG114
      END RULE 225/02

      RULE 225/03 "RF+, [24m-15y] old, ≥ 4 doses, ≥ 1 dose PCV13/15, LD=23v, d1 ≥ 11m old, d1d2 ≥ 3w, d2d3 ≥ 3w, d3d4 ≥ 3w, BLD-LD ≥ 3w: To do 5y after LD with 23v"
        IF ALL OF
          CALC:Pneu_d2d3>=3w
          CALC:Pneu_age_at_last_dose>=11m
          CALC:Pneu_d1d2>=3w
          CALC:Pneu_d3d4>=3w
          INTERVAL(CALC:Pneu_penultimate_dose_date,CALC:Pneu_last_dose_date)>=3w
          SYNTH:PNEU-13-15 "PNEU-13/15 - Received ≥ 1 dose conjugated vaccine like 13 or 15" = true
          SYNTH:PNEU-LD-23 "PNEU-LD-23 - Last dose include unconjgated vaccine like PNEUMO 23" = true
        DO Recommended
          Status DUE
          Delay 5y from CALC:Pneu_last_dose_date
        MESSAGES  MSG86 MSG88
      END RULE 225/03

      RULE 225/04 "RF+, [24m-15y] old, ≥ 4 doses, BLD=23v, LD=PCV13/15, d1d2 ≥ 3w, d2d3 ≥ 3w, d3d4 ≥ 3w, BLD-LD ≥ 3w: To do 5y after BLD with 23v"
        IF ALL OF
          INTERVAL(CALC:Pneu_penultimate_dose_date,CALC:Pneu_last_dose_date)>=3w
          CALC:Pneu_d1d2>=3w
          CALC:Pneu_d2d3>=3w
          CALC:Pneu_d3d4>=3w
          SYNTH:PNEU-BLD-23 "PNEU-BLD-23 - Before last dose include unconjgated like PNEUMO 23" = true
          SYNTH:PNEU-LD-13-15 "PNEU-LD-13/15 - Last dose is 13 or 15 conjugated vaccine" = true
        DO Recommended
          Status DUE
          Delay 5y from CALC:Pneu_penultimate_dose_date
        MESSAGES  MSG96 MSG86
      END RULE 225/04
    END FOLDER 225
  END FOLDER 22

  FOLDER 23 "[16-85y] old"
    IF CALC:Age in 16y..85y

    FOLDER 231 "[16-85y] old with increased risk of pneumococcal infection"
      IF SYNTH:PNEU-RF-ADU16-85 = true

      FOLDER 2310 "Zero dose"
        IF CALC:Pneu_doses_received = 0

        RULE 230/01 "RF+, [16-85y] old, 0 dose: To do from 15y old with PCV20 (Booster 23v every 5y)"
          IF CALC:Pneu_doses_received = 0
          DO Recommended
            Status DUE
            Age 15y
          MESSAGES  MSG120 MSG121
        END RULE 230/01
      END FOLDER 2310

      FOLDER 2311 "One dose"
        IF CALC:Pneu_doses_received = 1

        RULE 2311/01 "RF+, [16-85y] old, 1 dose, PCV20: To do 5y after LD with 23v"
          IF SYNTH:PNEU-LD-20 "PNEU-LD-20 - Last dose is PREVENAR 20" = true
          DO Recommended
            Status DUE
            Delay 5y from CALC:Pneu_last_dose_date
          MESSAGES  MSG95
        END RULE 2311/01

        RULE 2311/02 "RF+, [16-85y] old, 1 dose, 23v: To do 1y after LD with PCV20 (And after, 23v evry 5y)"
          IF SYNTH:PNEU-LD-23 "PNEU-LD-23 - Last dose include unconjgated vaccine like PNEUMO 23" = true
          DO Recommended
            Status DUE
            Delay 1y from CALC:Pneu_last_dose_date
          MESSAGES  MSG111 MSG156
        END RULE 2311/02
      END FOLDER 2311

      FOLDER 2312 "Two doses or more"
        IF CALC:Pneu_doses_received>=2

        RULE 231-2/01 "RF+, [16-85y] old, ≥ 2 doses, PCV20, LD=23v: To do 5y after LD with 23v"
          IF ALL OF
            SYNTH:PNEU-20 "PNEU-20 - Received ≥ 1 dose conjugated vaccine like PREVENAR 20" = true
            SYNTH:PNEU-LD-23 "PNEU-LD-23 - Last dose include unconjgated vaccine like PNEUMO 23" = true
          DO Recommended
            Status DUE
            Delay 16y from CALC:Pneu_last_dose_date
          MESSAGES  MSG95
        END RULE 231-2/01

        RULE 231-2/02 "RF+, [16-85y] old, ≥ 2 doses, PCV13/15 only: To do 1y after LD with 23v"
          IF SYNTH:PNEU-ONLY-13-15 "PNEU-ONLY-13/15 - Received only doses 13 or 15 valent (not unconjugated vaccine)" = true
          DO Recommended
            Status DUE
            Delay 1y from CALC:Pneu_last_dose_date
          MESSAGES  MSG124 MSG125
        END RULE 231-2/02
      END FOLDER 2312
    END FOLDER 231

    FOLDER 232 "[50-85y] old with comorbidity"
      IF ALL OF
      CALC:Age in 50y..85y
      SYNTH:PNEU-RF-ADU50-85 = true
      SYNTH:PNEU-RF-ADU16-85 = false

      FOLDER 2320 "Zero dose"
        IF CALC:Pneu_doses_received = 0

        RULE 232-0/01 "Comorbidity+, [50-85y] old, 0 dose: To do from 50y old with PCV20 (Booster 5y after)"
          IF CALC:Pneu_doses_received = 0
          DO Recommended
            Status DUE
            Age 50y
          MESSAGES  MSG120 MSG132
        END RULE 232-0/01
      END FOLDER 2320

      FOLDER 2321 "One dose"
        IF CALC:Pneu_doses_received = 1

        RULE 232-1/01 "Comorbidity+, [50-85y] old, 1 dose, PCV20: To do 5y after LD with 23v (and stop)"
          IF SYNTH:PNEU-LD-20 "PNEU-LD-20 - Last dose is PREVENAR 20" = true
          DO Recommended
            Status DUE
            Delay 5y from CALC:Pneu_last_dose_date
          MESSAGES  MSG157 MSG158
        END RULE 232-1/01

        RULE 232-1/02 "Comorbidity+, [50-85y] old, 1 dose, 23v: To do 1y after LD with PCV20 (And after, 23v one time)"
          IF SYNTH:PNEU-LD-23 "PNEU-LD-23 - Last dose include unconjgated vaccine like PNEUMO 23" = true
          DO Recommended
            Status DUE
            Delay 1y from CALC:Pneu_last_dose_date
          MESSAGES  MSG111 MSG156
        END RULE 232-1/02
      END FOLDER 2321

      FOLDER 2322 "Two doses or more"
        IF CALC:Pneu_doses_received>=2

        RULE 232-2/01 "Comorbidity+, [50-85y] old, ≥ 2 doses, PCV20, LD=23v: Up to date"
          IF ALL OF
            SYNTH:PNEU-20 "PNEU-20 - Received ≥ 1 dose conjugated vaccine like PREVENAR 20" = true
            SYNTH:PNEU-LD-23 "PNEU-LD-23 - Last dose include unconjgated vaccine like PNEUMO 23" = true
          DO Recommended
            Status COMPLETED
          MESSAGES  MSG159
        END RULE 232-2/01

        RULE 232-2/02 "Comorbidity+, [50-85y] old, ≥ 2 doses, LD=PCV20: To do 1y after LD with 23v"
          IF SYNTH:PNEU-LD-20 "PNEU-LD-20 - Last dose is PREVENAR 20" = true
          DO Recommended
            Status DUE
            Delay 1y from CALC:Pneu_last_dose_date
          MESSAGES  MSG160 MSG124
        END RULE 232-2/02
      END FOLDER 2322
    END FOLDER 232

    FOLDER 233 "[65-85y] old no RF no comorbidity"
      IF SYNTH:PNEU-RF-ADU-65-85 = true

      FOLDER 2330 "Zero dose"
        IF CALC:Pneu_doses_received = 0

        RULE 2330/01 "RF-, Comorbidity-, [65-85y] old, 0 dose: To do from 65y old with PCV20 (No need booster)"
          IF CALC:Pneu_doses_received = 0
          DO Recommended
            Status DUE
            Age 65y
          MESSAGES  MSG120 MSG155
        END RULE 2330/01
      END FOLDER 2330

      FOLDER 2331 "One dose or more"
        IF CALC:Pneu_doses_received>=1

        RULE 2331/01 "RF-, Comorbidity-, [65-85y] old, ≥ 1 dose: Up to date"
          IF CALC:Pneu_doses_received>=1
          DO Recommended
            Status COMPLETED
          MESSAGES  MSG155
        END RULE 2331/01
      END FOLDER 2331
    END FOLDER 233
  END FOLDER 23
END FOLDER 2

FOLDER 3 "≥ 86y old"
  IF CALC:Age>=86y

  RULE 3/01 "≥ 86y old, ≥ 1 dose: Up to date"
    IF CALC:Pneu_doses_received>=1
    DO Recommended
      Status COMPLETED
    MESSAGES  MSG161
  END RULE 3/01
END FOLDER 3

FOLDER 8 "Contraindications and special cases"

  FOLDER 81 "Contraindications"

    RULE 81/01 "Case « Contraindication to pneumococcal infection » checked: Contraindication + message"
      IF COND:C1017 "Contraindication to vaccination against pneumococcal disease" = true
      DO Contraindicated
      MESSAGES  MSG14 MSG15
    END RULE 81/01
  END FOLDER 81

  FOLDER 82 "Special cases"

    RULE 82/01 "23-valent before 24 months old"
      IF ALL OF
        CALC:Pneu_doses_received>=1
        CALC:PPSV_05_age_at_first_dose<=23m
      DO Exception
      MESSAGES  MSG90
    END RULE 82/01

    RULE 82/02 "Case  « Refusal to vaccinate against this disease » checked: Special case + message"
      IF COND:C616 "Refusal of pneumococcal vaccination" = true
      DO Exception
      MESSAGES  MSG6 MSG7
    END RULE 82/02
  END FOLDER 82
END FOLDER 8

FOLDER 9 "Further information"

  FOLDER 91 "≤ 23 months"
    IF CALC:Age<=23m

    RULE 91/01 "If to do, ≤ 23m old, 0 dose: Message = with PCV13 or 15"
      WHEN Recommended
      IF CALC:Pneu_doses_received = 0
      DO Neutral
      MESSAGES  MSG118 MSG119
    END RULE 91/01

    RULE 91/02 "If to do, ≤ 23m old, Premature baby: Message = Reinforced diagram"
      WHEN Recommended
      IF SYNTH:PNEU-PREMA "PNEU-PREMA - Premature babies ≤ 36w" = true
      DO Neutral
      MESSAGES  MSG163 MSG162
    END RULE 91/02

    RULE 91/03 "If To do, ≤ 23m old, LD=PCV13/15: Message = Continue with same vaccine"
      WHEN Recommended
      IF SYNTH:PNEU-LD-13-15 "PNEU-LD-13/15 - Last dose is 13 or 15 conjugated vaccine" = true
      DO Neutral
      MESSAGES  MSG101
    END RULE 91/03

    RULE 91/04 "if To do, Risk Factors+: Message = Risk factor for serious pneumococcal infection "
      WHEN Recommended
      IF SYNTH:PNEU-RF-CHILD "PNEU-RF-CHILD - Risk factors for severe pneumococcal infection (Children)" = true
      DO Neutral
      MESSAGES  MSG106 MSG89 MSG107
    END RULE 91/04
  END FOLDER 91

  FOLDER 92 "≥ 24 months"
    IF CALC:Age>=24m

    RULE 91/03 "if To do, ≥ 24m old, Risk Factors+: Message = Risk factor for serious pneumococcal infection."
      WHEN Recommended
      IF SYNTH:PNEU-RF-ADU "PNEU-RF-ADU - Risk factors for severe pneumococcal infection (Adults)" = true
      DO Neutral
      MESSAGES  MSG89
    END RULE 91/03

    RULE 92/02 "If to do, [65-85]y old: Message = Information on pneumo. infections, more serious and frequent after 65 y old"
      WHEN Recommended
      IF CALC:Age in 65y..85y
      DO Neutral
      MESSAGES  MSG85
    END RULE 92/02
  END FOLDER 92
END FOLDER 9
END TARGET

MESSAGE MSG11 Summary ANY PRIO 0
  "Vaccination schedule completed."@en
 END MESSAGE MSG11

MESSAGE MSG89 Justification ANY PRIO 50
  "Vaccination is recommended because there is a risk factor for serious pneumococcal infection."@en
 END MESSAGE MSG89

MESSAGE MSG106 Comments ANY PRIO 0
  "The reinforced vaccination schedule includes 3 doses of a pneumococcal conjugate vaccine containing at least 13 valences at 1-month intervals followed by a booster from the age of 15 months."@en
 END MESSAGE MSG106

MESSAGE MSG107 Summary ANY PRIO 0
  "A reinforced vaccination schedule is recommended in the event of a risk factor for serious pneumococcal infection."@en
 END MESSAGE MSG107

MESSAGE MSG86 Summary ANY PRIO 0
  "Next dose with 23-valent non-conjugated vaccine."@en
 END MESSAGE MSG86

MESSAGE MSG103 Justification ANY PRIO 0
  "Incomplete infant vaccination schedule."@en
 END MESSAGE MSG103

MESSAGE MSG108 Justification ANY PRIO 0
  "An additional dose is recommended for this infant because, in addition to age, he has a risk factor for serious pneumococcal infection (4-dose schedule instead of 3 doses for other infants)."@en
 END MESSAGE MSG108

MESSAGE MSG161 Summary ANY PRIO 0
  "Pneumococcal vaccination is no longer recommended for people over the age of 85, due to a lack of efficacy data."@en
 END MESSAGE MSG161

MESSAGE MSG99 Justification ANY PRIO 0
  "Once a dose of 23-valent non-conjugate pneumococcal vaccine has been administered, a pneumococcal conjugate vaccine should be given at least 1 year after the last dose."@en
 END MESSAGE MSG99

MESSAGE MSG91 Summary ANY PRIO 0
  "Next dose with a pneumococcal conjugate vaccine containing at least 13 valencies."@en
 END MESSAGE MSG91

MESSAGE MSG129 Justification ANY PRIO 0
  "When pneumococcal vaccination is started from the age of 12 months, the vaccination schedule consists of 2 doses with an interval of at least 2 months. An additional dose of a pneumococcal conjugate vaccine containing at least 13 valences is recommended for this infant, because the interval between the 2 doses already received is less than 7 weeks."@en
 END MESSAGE MSG129

MESSAGE MSG120 Summary ANY PRIO 0
  "Give one dose of 20-valent polysaccharide conjugate vaccine."@en
 END MESSAGE MSG120

MESSAGE MSG132 Comments ANY PRIO 0
  "For adults with co-morbidity, a booster dose of 23-valent non-conjugated polysaccharide vaccine should be given once, 5 years after the primary vaccination. <br>
In the case of severe underlying co-morbidity, a dose of 23-valent non-conjugated polysaccharide vaccine every 5 years should be considered."@en
 END MESSAGE MSG132

MESSAGE MSG111 Summary ANY PRIO 0
  "Give a dose of the 20-valent polysaccharide conjugate vaccine."@en
 END MESSAGE MSG111

MESSAGE MSG156 Justification ANY PRIO 0
  "For people previously vaccinated only with the 23-valent non-conjugated pneumococcal vaccine, it is recommended that they receive a dose of 20-valent conjugated polysaccharide vaccine, followed by the 23-valent non-conjugated pneumococcal vaccine for booster doses every 5 years."@en
 END MESSAGE MSG156

MESSAGE MSG157 Summary ANY PRIO 0
  "Give a single dose of 23-valent non-conjugated pneumococcal vaccine."@en
 END MESSAGE MSG157

MESSAGE MSG158 Justification ANY PRIO 0
  "There is no need for a subsequent booster except in the case of serious underlying co-morbidity: a dose of 23-valent non-conjugated polysaccharide vaccine every 5 years should then be considered."@en
 END MESSAGE MSG158

MESSAGE MSG93 Summary ANY PRIO 0
  "Revaccination with a 23-valent non-conjugate vaccine 5 years after the last dose in case of risk factor."@en
 END MESSAGE MSG93

MESSAGE MSG94 Justification PRO PRIO 0
  "Note that it would have been preferable to administer a third dose of a conjugate vaccine containing at least 13 valences before administering a dose of 23-valent non-conjugate vaccine, because the first dose of conjugate vaccine was administered before the age of 12 months. The conduct to be followed in this situation is not codified. In this case, we propose to carry out a booster vaccination five years later."@en
 END MESSAGE MSG94

MESSAGE MSG90 Alert ANY PRIO 0
  "Non-conjugated pneumococcal vaccines should not be given before the age of 2 years. Specialist advice is required."@en
 END MESSAGE MSG90

MESSAGE MSG155 Justification ANY PRIO 0
  "Between the ages of 65 and 85, if there are no risk factors or co-morbidities, there is no need for a booster."@en
 END MESSAGE MSG155

MESSAGE MSG14 Alert ANY PRIO 0
  "Vaccination contraindicated by the doctor."@en
 END MESSAGE MSG14

MESSAGE MSG15 Justification ANY PRIO 0
  "The box indicating a contraindication for this disease has been checked in the health profile (section “Contraindicated vaccinations”)."@en
 END MESSAGE MSG15

MESSAGE MSG124 Summary ANY PRIO 0
  "Complete the vaccination schedule with a 23-valent non-conjugated pneumococcal vaccine."@en
 END MESSAGE MSG124

MESSAGE MSG125 Justification ANY PRIO 0
  "It is recommended that at-risk populations and people aged 65 and over should be vaccinated against pneumococcus with a dose of conjugated polysaccharide vaccine, followed a year later by a dose of 23-valent non-conjugated polysaccharide vaccine. Both vaccines are necessary: the conjugate vaccine is more effective but contains fewer valences than the 23-valent non-conjugate vaccine, which provides full protection."@en
 END MESSAGE MSG125

MESSAGE MSG163 Justification ANY PRIO 0
  "For premature infants born before 37 weeks of amenorrhea, a reinforced schedule should be applied: three doses of primary vaccination one month apart from the age of 2 months, followed by a booster dose from 12 months (3+1 instead of the classic 2+1 schedule)."@en
 END MESSAGE MSG163

MESSAGE MSG162 Summary ANY PRIO 0
  "For premature infants born before 37 weeks of amenorrhea, a reinforced regimen should be applied."@en
 END MESSAGE MSG162

MESSAGE MSG96 Justification ANY PRIO 0
  "Revaccination with a 23-valent non-conjugate vaccine 5 years after the last dose of the same vaccine."@en
 END MESSAGE MSG96

MESSAGE MSG85 Justification ANY PRIO 0
  "Vaccination prevents pneumococcal infections, which are more serious and more common in older people."@en
 END MESSAGE MSG85

MESSAGE MSG100 Justification ANY PRIO 0
  "An additional dose of pneumococcal conjugate vaccine containing at least 13 valences is required because the last dose of this vaccine was administered before the age of 11 months."@en
 END MESSAGE MSG100

MESSAGE MSG88 Justification ANY PRIO 0
  "Re-vaccination with the 23-valent non-conjugate vaccine is recommended every 5 years if there are risk factors."@en
 END MESSAGE MSG88

MESSAGE MSG118 Summary ANY PRIO 0
  "With a pneumococcal conjugate vaccine containing 13 or 15 valences."@en
 END MESSAGE MSG118

MESSAGE MSG119 Comments ANY PRIO 0
  "Vaccination prevents pneumococcal infections, which are more serious and more frequent in infants. Vaccination with a pneumococcal conjugate vaccine containing 13 or 15 valences."@en
 END MESSAGE MSG119

MESSAGE MSG95 Summary ANY PRIO 0
  "Revaccination every 5 years with a 23-valent non-conjugated pneumococcal vaccine."@en
 END MESSAGE MSG95

MESSAGE MSG92 Justification PRO PRIO 0
  "The first dose of conjugate vaccine was administered before 12 months of age and the second dose before 24 months of age. It is necessary to complete the vaccination schedule with an additional dose of conjugate vaccine before subsequently administering a dose of 23-valent non-conjugate vaccine."@en
 END MESSAGE MSG92

MESSAGE MSG127 Summary ANY PRIO 0
  "﻿Vaccination schedule reinforced with an additional dose before the booster dose."@en
 END MESSAGE MSG127

MESSAGE MSG128 Justification ANY PRIO 0
  "For infants at high risk of serious pneumococcal disease, the primary vaccination is reinforced with a 3rd dose."@en
 END MESSAGE MSG128

MESSAGE MSG123 Justification ANY PRIO 0
  "When vaccination against invasive pneumococcal disease is initiated in an infant aged 7 to 11 months, the vaccination schedule consists of 2 doses with an interval of at least 1 month between doses. A third dose is recommended during the second year of life."@en
 END MESSAGE MSG123

MESSAGE MSG105 Summary ANY PRIO 0
  "Next dose with a 23-valent non-conjugate vaccine from the age of 24 months."@en
 END MESSAGE MSG105

MESSAGE MSG6 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG6

MESSAGE MSG7 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been checked in the health profile (section “Refusal of vaccination”)."@en
 END MESSAGE MSG7

MESSAGE MSG114 Justification ANY PRIO 0
  "To date, only 23-valent non-conjugated pneumococcal vaccines have been administered: these must be supplemented with a 13- or 15-valent conjugate vaccine after the last dose of 23-valent vaccine, and then with a 23-valent vaccine 5 years after the previous dose of 23-valent vaccine."@en
 END MESSAGE MSG114

MESSAGE MSG87 Justification ANY PRIO 0
  "A booster dose is recommended between 12 and 15 months of age to strengthen protection against serious pneumococcal infections (the last dose was given before 10 months of age)."@en
 END MESSAGE MSG87

MESSAGE MSG101 Comments ANY PRIO 0
  "It is preferable to continue a schedule started with a vaccine containing the same valences."@en
 END MESSAGE MSG101

MESSAGE MSG113 Justification PRO PRIO 0
  "The 2nd dose of vaccine was given before the age of 24 months and the interval between the 2 doses is less than 7 weeks. It is necessary to complete the vaccination schedule with an additional dose of conjugate vaccine before subsequently giving a dose of the 23-valent unconjugated vaccine."@en
 END MESSAGE MSG113

MESSAGE MSG115 Justification PRO PRIO 0
  "Note that it would have been preferable to administer two doses of a conjugate vaccine 8 weeks apart (instead of just one) before administering the 23-valent non-conjugate vaccine. The conduct to be adopted in this situation is not codified. We propose here to do a booster vaccination 5 years later but an additional dose of conjugate vaccine can be discussed."@en
 END MESSAGE MSG115

MESSAGE MSG121 Comments ANY PRIO 0
  "A booster should be given every 5 years with a 23-valent non-conjugated polysaccharide vaccine."@en
 END MESSAGE MSG121

MESSAGE MSG159 Justification ANY PRIO 0
  "Between the ages of 50 and 85, if there are no risk factors for severe disease, there is no need for a booster."@en
 END MESSAGE MSG159

MESSAGE MSG160 Justification ANY PRIO 0
  "People aged between 50 and 65 suffering from co-morbidity should receive a dose of conjugated polysaccharide vaccine followed, a year later, by a dose of 23-valent unconjugated polysaccharide vaccine. Both vaccines are necessary: the conjugate vaccine is more effective but contains fewer valences than the 23-valent non-conjugate vaccine, which completes the protection."@en
 END MESSAGE MSG160
