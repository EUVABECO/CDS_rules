CALC Pneu_doses_received IS HIST(Pneumo,0,count)
CALC Pneu_d1d2 is INTERVAL(HIST(PNEUMO,1,date),HIST(PNEUMO,2,date))

CALC Pneu_age_at_first_act is INTERVAL(BASE:dob, HIST(PNEUMO,1,date))
CALC Pneu_last_dose_date IS HIST(Pneumo,-1,date)
CALC Pneu_last_dose_valences IS HIST(Pneumo,-1,valences)
CALC Pneu_age_at_last_dose IS INTERVAL(BASE:dob,CALC:Pneu_last_dose_date)
CALC Per_time_since_last_dose IS INTERVAL(CALC:Per_last_dose_date,BASE:eval)
CALC received_valence_ids is HIST(Pneumo,0,valences)
CALC PPSV-05_age_at_first_dose IS INTERVAL(BASE:dob,HIST(PPSV-05,1,date))

SYNTH PNEU_SCH1 "PNEU SCH1 0 dose and age[12-23m]" IS ALL OF
  CALC:Pneu_doses_received = 0
  CALC:Age in 12m..23m

SYNTH PNEU_UTD1 "PNEU-UTD1 - Pneumo up to date d1 ≤ 11m old and ≥ 3 doses" IS ALL OF
  CALC:Pneu_doses_received>3
  CALC:Pneu_age_at_first_act<=11m

SYNTH PNEU_UTD2 "PNEU-UTD2 - Pneumo up to date if d1 [12-23]m old and ≥ 2 doses" IS ALL OF
  CALC:Pneu_doses_received>2
  CALC:Pneu_age_at_last_dose in 12m..23m
  
SYNTH PNEU_UTD "PNEU-UTD - Pneumo up to date if d1 ≤ 23y old and scheme completed" IS ANY OF
  SYNTH:PNEU_UTD1 "PNEU-UTD1 - Pneumo up to date d1 ≤ 11m old and ≥ 3 doses" = true
  SYNTH:PNEU_UTD2 "PNEU-UTD2 - Pneumo up to date if d1 [12-23]m old and ≥ 2 doses" = true


SYNTH PNEU_1ST_7_15 "PNEU-1st7/15 - 1st dose 7 to 15 conjugated vaccine" IS ALL OF
  CALC:first_valence_ids contains VPC-04
  CALC:first_valence_ids contains no VPC-08

SYNTH PNEU_LD_10_15 "PNEU-LD10/15 - Last dose includes 7 to 15 conjugated vaccine" IS ALL OF
  CALC:Pneu_last_dose_valences contains VPC-04
  CALC:Pneu_last_dose_valences contains no VPC-08

SYNTH PNEU_RF_PREMA "PNEU-RF Premature birth ≤ 33 weeks" IS ALL OF COND:C995 "Number of weeks of amenorrhoea at birth for a premature baby"<=33

SYNTH PNEU_TOOSHORT "PNEU-TOOSHORT - d1 [6s-6m] old AND d1d2 ≤ 6w" IS ALL OF
  CALC:Pneu_age_at_first_act in 6w..6m
  CALC:Pneu_d1d2<=6w

SYNTH PNEU_SCH3 "PNEU SCH3 0 dose and age ≤6m" IS ALL OF
  CALC:Pneu_doses_received = 0
  CALC:Age<=6m

SYNTH PNEU_ONLY10_20_NOT23NC "PNEU-ONLY10/20-NOT23NC - Received only doses of PCV7 to 20 (Not non conjugated vaccine)" IS ALL OF
  CALC:received_valence_ids contains VPC-04
  CALC:received_valence_ids contains no VPC-09N
  CALC:received_valence_ids contains no VPP-05

SYNTH PNEU_LD20 "PNEU-LD20 - Last dose is PREVENAR 20" IS ALL OF
  CALC:Pneu_last_dose_valences contains VPC-08
  CALC:Pneu_last_dose_valences contains no VPC-09N

SYNTH PNEU_ID "PNEU-ID - Hereditary immune deficiencies and pneumococcal vaccine" IS ANY OF
  COND:C580 "Phagocytic cell deficiency (septic granulomatosis)" = true
  COND:C581 "Severe chronic neutropenia" = true
  COND:C21 "Complement deficit" = true
  COND:C582 "Common variable immune deficiency (CVID)" = true
  COND:C583 "Bruton's disease (X-linked agammaglobulinemia)" = true
  COND:C830 "Hyper IgM syndrome" = true
  COND:C584 "IgG subclass deficiency" = true
  COND:C587 "Partial combined immunodeficiency" = true

SYNTH PNEU_RF_ADU "PNEU-RF-ADU - Risk factors for severe pneumococcal infection (Adults)" IS ANY OF
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
  SYNTH:PNEU_ID "PNEU-ID - Hereditary immune deficiencies and pneumococcal vaccine" = true
  COND:C50 "Moderate heart failure" = true
  COND:C3 "Severe heart failure" = true
  COND:C39 "Chronic respiratory failure" = true
  COND:C281 "Chronic obstructive pulmonary disease (COPD)" = true
  COND:C612 "Emphysema" = true
  COND:C304 "Severe asthma under continuous treatment" = true
  COND:C17 "Chronic renal failure on dialysis" = true
  COND:C18 "Chronic renal failure NOT on dialysis" = true
  COND:C41 "Chronic liver disease" = true
  COND:C733 "Treated diabetes" = true
  COND:C34 "Osteo-meningeal breach" = true
  COND:C35 "Candidate for implantation or holder of a cochlear implant" = true
  COND:C6 "Nephrotic syndrome" = true
  COND:C2 "Cyanogenic congenital heart disease" = true
  COND:C404 "Cancer or hematological malignancy" = true
  COND:C992 "End date of chemotherapy for solid tumor (cancer)"<=2y
  COND:C1000 "Excessive alcohol use" = true
  COND:C917 "Strong immunosuppressive treatment (covid)" = true
  COND:C21 "Complement deficit" = true

SYNTH PNEU_RF_CHILD "PNEU-RF-CHILD - Risk factors for severe pneumococcal infection (Children)" IS ANY OF
  SYNTH:PNEU_RF_ADU "PNEU-RF-ADU - Risk factors for severe pneumococcal infection (Adults)" = true
  COND:C995 "Number of weeks of amenorrhoea at birth for a premature baby"<=33

SYNTH PNEU_ONLY7_15 "PNEU-ONLY7/15 - Received only doses of PCV7 to 15 (Not NC vaccine AND not PCV20)" IS ALL OF
  CALC:received_valence_ids contains VPC-04
  CALC:received_valence_ids contains no VPC-08
  CALC:received_valence_ids contains no VPP-05

SYNTH PNEU_SCH2 "PNEU SCH2 0 dose and age [7-11m]" IS ALL OF
  CALC:Pneu_doses_received = 0
  CALC:Age in 7m..11m

TARGET Pneumo
FOLDER - "General rules"
END FOLDER -

FOLDER 0 "≤ 23 months - Zero dose"
  IF ALL OF
  CALC:Pneu_doses_received = 0
  CALC:Age<=23m

  RULE 0/01 "≤ 23m old, 0 dose: To do from 2m old + message"
    IF CALC:Pneu_doses_received = 0
    DO Recommended
      Status DUE
      Age 2m
    MESSAGES  MSG110
  END RULE 0/01
END FOLDER 0

FOLDER 1 " ≤ 23 months - ≥ 1 dose"
  IF ALL OF
  CALC:Pneu_doses_received>=1
  CALC:Age<=23m

  FOLDER 11 "≤ 23 months - Not premature - Only PCV 7-15"
    IF ALL OF
    CALC:Age<=23m
    SYNTH:PNEU_RF_PREMA "PNEU-RF Premature birth ≤ 33 weeks" = false
    SYNTH:PNEU_ONLY7_15 "PNEU-ONLY7/15 - Received only doses of PCV7 to 15 (Not NC vaccine AND not PCV20)" = true

    FOLDER 111 "One dose PCV7/15"
      IF CALC:Pneu_doses_received = 1

      RULE 111/01 "≤ 23m old, 1 dose PCV10/15 [6w-6m] old: To do 2m after LD, 4m old (2+1 scheme with intervals 1m)"
        IF CALC:Pneu_age_at_first_act in 6w..6m
        DO Recommended
          Status DUE
          Age 4m
          Delay 2m from CALC:Pneumo_last_dose_date
      END RULE 111/01

      RULE 111/02 "≤ 23m old, 1dose PCV10/15 [7-11m] old: DUE 1m after LD with PCV10/15 (and booster after 12m old)"
        IF CALC:Pneu_age_at_first_act in 7m..11m
        DO Recommended
          Status DUE
          Delay 1m from CALC:Pneumo_last_dose_date
      END RULE 111/02

      RULE 111/03 "≤ 23m old, 1dose PCV10/15 [12-23m] old: DUE 2m after LD with PCV10/15 (and scheme terminate)"
        IF CALC:Pneu_age_at_first_act in 12m..23m
        DO Recommended
          Status DUE
          Delay 2m from CALC:Pneumo_last_dose_date
      END RULE 111/03
    END FOLDER 111

    FOLDER 112 "Two doses PCV7/15"
      IF CALC:Pneu_doses_received = 2

      RULE 112/01 "≤ 23m old, d1 [6w-6m] old, d1d2 ≥ 7w, 2 doses PCV10/15: To do from 12-15m old 2m after LD with PCV10/15 (Diagram 2+1 with interval 2m)"
        IF ALL OF
          CALC:Pneu_d1d2>=7w
          CALC:Pneu_age_at_first_act in 6w..6m
        DO Recommended
          Status DUE
          Age 12m..15m
          Delay 2m from CALC:Pneumo_last_dose_date
      END RULE 112/01

      RULE 112/02 "≤ 23m old, d1 [6w-6m] old, d1d2 ≤ 6w, 2 doses PCV10/15: To do 1m after LD (3rd dose) (Diagram 3+1 with interval 1m)"
        IF ALL OF
          CALC:Pneu_d1d2<=6w
          CALC:Pneu_age_at_first_act in 6w..6m
        DO Recommended
          Status DUE
          Delay 1m from CALC:Pneumo_last_dose_date
      END RULE 112/02

      RULE 112/03 "≤ 23m old, d1 [7-11m] old, 2 doses PCV10/15 To do from 12m old, 2m after LD"
        IF CALC:Pneu_age_at_first_act in 7m..11m
        DO Recommended
          Status DUE
          Age 12m
          Delay 2m from CALC:Pneumo_last_dose_date
      END RULE 112/03

      RULE 112/04 "≤ 23m old, d1 [12-23m] old, d1d2 ≥ 7w, 2 doses PCV10/15: Up to date"
        IF ALL OF
          CALC:Pneu_d1d2>=7w
          CALC:Pneu_age_at_first_act>=12m
        DO Recommended
          Status COMPLETED
      END RULE 112/04

      RULE 112/05 "≤ 23m old, d1 [12-23m] old, d1d2 ≤ 6w, 2 doses PCV10/15: Up to date + message"
        IF ALL OF
          CALC:Pneu_d1d2<=6w
          CALC:Pneu_age_at_first_act>=12m
        DO Recommended
          Status COMPLETED
        MESSAGES  MSG138
      END RULE 112/05
    END FOLDER 112

    FOLDER 113 "Three doses PCV7/15"
      IF CALC:Pneu_doses_received = 3

      RULE 113/01 "≤ 23m old, d1 [6w-6m] old, d1d2 ≤ 6w, 3 doses PCV10/15: To do 1m after LD and 12-15m old (4rd dose)"
        IF SYNTH:PNEU_TOOSHORT "PNEU-TOOSHORT - d1 [6s-6m] old AND d1d2 ≤ 6w" = true
        DO Recommended
          Status DUE
          Age 12m..15m
          Delay 1m from CALC:Pneumo_last_dose_date
      END RULE 113/01

      RULE 113/02 "≤ 23m old, 3 doses PCV10/15: Up to date"
        IF ALL OF
          SYNTH:PNEU_TOOSHORT "PNEU-TOOSHORT - d1 [6s-6m] old AND d1d2 ≤ 6w" = false
          CALC:Pneu_age_at_last_dose>=10m
        DO Recommended
          Status COMPLETED
      END RULE 113/02

      RULE 113/03 "≤ 23m old, 3 doses PCV10/15, LD ≤ 9m: Add 1 booster dose"
        IF ALL OF
          SYNTH:PNEU_TOOSHORT "PNEU-TOOSHORT - d1 [6s-6m] old AND d1d2 ≤ 6w" = false
          CALC:Pneu_age_at_last_dose<=9m
        DO Recommended
          Status DUE
          Age 11m
          Delay 2m from CALC:Pneumo_last_dose_date
        MESSAGES  MSG107
      END RULE 113/03
    END FOLDER 113

    FOLDER 114 "Four doses or more PCV7/15"
      IF CALC:Pneu_doses_received>=4

      RULE 114/01 "≤ 23m old, ≥ 4 doses PCV10/15: Up to date"
        IF CALC:Pneu_doses_received>=4
        DO Recommended
          Status COMPLETED
      END RULE 114/01
    END FOLDER 114
  END FOLDER 11

  FOLDER 12 "≤ 23 months - Premature - Only PCV 7-15"
    IF ALL OF
    CALC:Age<=23m
    SYNTH:PNEU_RF_PREMA "PNEU-RF Premature birth ≤ 33 weeks" = true
    SYNTH:PNEU_ONLY7_15 "PNEU-ONLY7/15 - Received only doses of PCV7 to 15 (Not NC vaccine AND not PCV20)" = true

    FOLDER 121 "One dose PCV7/15"
      IF CALC:Pneu_doses_received = 1

      RULE 121/01 "≤ 23m old, premature, 1 dose PCV10/15 [6w-6m] old: To do 1m after LD, 3m old (3+1 scheme with intervals 1m)"
        IF CALC:Pneu_age_at_first_act in 6w..6m
        DO Recommended
          Status DUE
          Age 3m
          Delay 1m from CALC:Pneumo_last_dose_date
      END RULE 121/01

      RULE 121/02 "≤ 23m old, premature, 1dose PCV10/15 [7-11m] old: DUE 1m after LD with PCV10/15 (and booster after 12m old) (Copie)"
        IF CALC:Pneu_age_at_first_act in 7m..11m
        DO Recommended
          Status DUE
          Delay 1m from CALC:Pneumo_last_dose_date
      END RULE 121/02

      RULE 121/03 "≤ 23m old, premature, 1dose PCV10/15 [12-23m] old: DUE 2m after LD with PCV10/15 (and scheme terminate) (Copie)"
        IF CALC:Pneu_age_at_first_act in 12m..23m
        DO Recommended
          Status DUE
          Delay 2m from CALC:Pneumo_last_dose_date
      END RULE 121/03
    END FOLDER 121

    FOLDER 122 "Two doses PCV7/15"
      IF CALC:Pneu_doses_received = 2

      RULE 122/01 "≤ 23m old, premature, d1 [6w-6m] old, d1d2 ≥ 3w, 2 doses PCV7/15: To do starting age 4m, 1m after LD (3+1 scheme with intervals 1m)"
        IF ALL OF
          CALC:Pneu_d1d2>=3w
          CALC:Pneu_age_at_first_act in 6w..6m
        DO Recommended
          Status DUE
          Age 4m
          Delay 1m from CALC:Pneumo_last_dose_date
      END RULE 122/01

      RULE 122/02 "≤ 23m old, premature, d1 [7-11m] old, 2 doses PCV7/15 To do from 12m old, 2m after LD"
        IF CALC:Pneu_age_at_first_act in 7m..11m
        DO Recommended
          Status DUE
          Age 12m
          Delay 2m from CALC:Pneumo_last_dose_date
      END RULE 122/02

      RULE 122/03 "≤ 23m old, premature, d1 [12-23m] old, d1d2 ≥ 7w, 2 doses PCV7/15: Up to date"
        IF ALL OF
          CALC:Pneu_d1d2>=7w
          CALC:Pneu_age_at_first_act>=12m
        DO Recommended
          Status COMPLETED
      END RULE 122/03

      RULE 122/04 "≤ 23m old, premature, d1 [12-23m] old, d1d2 ≤ 6w, 2 doses PCV10/15: Up to date + message"
        IF ALL OF
          CALC:Pneu_d1d2<=6w
          CALC:Pneu_age_at_first_act>=12m
        DO Recommended
          Status COMPLETED
        MESSAGES  MSG138
      END RULE 122/04
    END FOLDER 122

    FOLDER 123 "Three doses PCV7/15"
      IF CALC:Pneu_doses_received = 3

      RULE 123/01 "≤ 23m old, premature, d1 [6w-6m] old, 3 doses PCV7/15: To do 1m after LD (3+1 scheme)"
        IF ALL OF
          SYNTH:PNEU_RF_PREMA "PNEU-RF Premature birth ≤ 33 weeks" = true
          CALC:Pneu_age_at_first_act in 6w..6m
        DO Recommended
          Status DUE
          Age 12m..15m
          Delay 1m from CALC:Pneumo_last_dose_date
      END RULE 123/01

      RULE 123/02 "≤ 23m old, premature, 3 doses PCV7/15, d1≥7m old, LD ≥ 10m : Up to date"
        IF ALL OF
          CALC:Pneu_age_at_last_dose>=10m
          CALC:Pneu_age_at_first_act>=7m
        DO Recommended
          Status COMPLETED
      END RULE 123/02

      RULE 123/03 "≤ 23m old, premature, 3 doses PCV7/15, d1[6w-11m] : 4th dose"
        IF CALC:Pneu_age_at_first_act in 6w..6m
        DO Recommended
          Status DUE
          Age 11m..15m
      END RULE 123/03

      RULE 123/04 "≤ 23m old, premature, 3 doses PCV7/15, LD ≤ 9m: 4th dose"
        IF CALC:Pneu_age_at_last_dose<=9m
        DO Recommended
          Status DUE
          Age 11m
          Delay 2m from CALC:Pneumo_last_dose_date
        MESSAGES  MSG107
      END RULE 123/04
    END FOLDER 123

    FOLDER 124 "Four doses or more PCV7/15"
      IF CALC:Pneu_doses_received>=4

      RULE 124/01 "≤ 23m old, premature, ≥ 4 doses PCV10/15: Up to date"
        IF CALC:Pneu_doses_received>=4
        DO Recommended
          Status COMPLETED
      END RULE 124/01
    END FOLDER 124
  END FOLDER 12

  FOLDER 13 "≤ 23 months - Premature or not - LD = PCV20"
    IF ALL OF
    SYNTH:PNEU_LD20 "PNEU-LD20 - Last dose is PREVENAR 20" = true
    CALC:Age<=23m

    FOLDER 131 "One dose PCV20"
      IF CALC:Pneu_doses_received = 1

      RULE 131/01 "≤ 23m old, 1 dose PCV20 [6w-6m] old: To do 1m after LD (Diagram 3+1 with interval 1m)"
        IF CALC:Pneu_age_at_first_act in 6w..6m
        DO Recommended
          Status DUE
          Delay 1m from CALC:Pneumo_last_dose_date
      END RULE 131/01

      RULE 131/02 "≤ 23m old, 1dose PCV20 [7-11m] old: DUE 1m after LD with PCV20 (and booster after 12m old)"
        IF CALC:Pneu_age_at_first_act in 7m..11m
        DO Recommended
          Status DUE
          Delay 1m from CALC:Pneumo_last_dose_date
      END RULE 131/02

      RULE 131/03 "≤ 23m old, 1dose PCV20 [12-23m] old: DUE 2m after LD with PCV20 (and scheme terminate)"
        IF CALC:Pneu_age_at_first_act in 12m..23m
        DO Recommended
          Status DUE
          Delay 2m from CALC:Pneumo_last_dose_date
      END RULE 131/03
    END FOLDER 131

    FOLDER 132 "Two doses - LD PCV20"
      IF CALC:Pneu_doses_received = 2

      RULE 132/01 "≤ 23m old, d1 [6w-6m] old, 2 doses, LD=PCV20: To do 1m after LD with PCV20 (Diagram 3+1 with interval 1m)"
        IF CALC:Pneu_age_at_first_act in 6w..6m
        DO Recommended
          Status DUE
          Age 4m
          Delay 1m from CALC:Pneumo_last_dose_date
      END RULE 132/01

      RULE 132/02 "≤ 23m old, d1 [7-11m] old, 2 doses, LD=PCV20: To do from 12m old, 2m after LD"
        IF CALC:Pneu_age_at_first_act in 7m..11m
        DO Recommended
          Status DUE
          Age 12m
          Delay 2m from CALC:Pneumo_last_dose_date
      END RULE 132/02

      RULE 132/03 "≤ 23m old, d1 [12-23m] old, d1d2 ≥ 7w, 2 doses, LD=PCV20: Up to date"
        IF ALL OF
          CALC:Pneu_d1d2>=7w
          CALC:Pneu_age_at_first_act>=12m
        DO Recommended
          Status COMPLETED
      END RULE 132/03

      RULE 132/04 "≤ 23m old, d1 [12-23m] old, d1d2 ≤ 6w, 2 doses, LD=PCV20: up-to-date + M"
        IF ALL OF
          CALC:Pneu_d1d2<=6w
          CALC:Pneu_age_at_first_act>=12m
        DO Recommended
          Status DUE
          Delay 2m from CALC:Pneumo_last_dose_date
        MESSAGES  MSG125 MSG138
      END RULE 132/04
    END FOLDER 132

    FOLDER 133 "Three doses - LD PCV20"
      IF CALC:Pneu_doses_received = 3

      RULE 133/01 "≤ 23m old, d1 [6w-6m] old, 3 doses, LD=PCV20: To do from 12-15m old 2m after LD with PCV20 (Diagram 3+1 with interval 1m)"
        IF CALC:Pneu_age_at_first_act in 6w..6m
        DO Recommended
          Status DUE
          Age 12m..15m
          Delay 2m from CALC:Pneumo_last_dose_date
      END RULE 133/01

      RULE 133/02 "≤ 23m old, 3 doses, d1 ≥ 7m, LD=PCV20: Up to date"
        IF ALL OF
          CALC:Pneu_doses_received>=3
          CALC:Pneu_age_at_last_dose>=7m
        DO Recommended
          Status COMPLETED
      END RULE 133/02
    END FOLDER 133

    FOLDER 134 "Four doses or more - LD PCV20"
      IF CALC:Pneu_doses_received>=4

      RULE 134/01 "≤ 23m old, ≥ 4 doses, LD=PCV20: Up to date"
        IF CALC:Pneu_doses_received>=4
        DO Recommended
          Status COMPLETED
      END RULE 134/01
    END FOLDER 134
  END FOLDER 13
END FOLDER 1

FOLDER 2 "24 months or more"
  IF CALC:Age>=24m

  FOLDER 21 "Risk Factors -"
    IF SYNTH:PNEU_RF_ADU "PNEU-RF-ADU - Risk factors for severe pneumococcal infection (Adults)" = false

    FOLDER 211 "One dose or more"
      IF CALC:Pneu_doses_received>=1

      RULE 211/01 "≥ 24m old, Risk Factors-, d1 ≤ 23m old, scheme completed-: Vaccination possible"
        IF ALL OF
          SYNTH:PNEU_1ST_7_15 "PNEU-1st7/15 - 1st dose 7 to 15 conjugated vaccine" = true
          CALC:Pneu_age_at_first_act<=23m
          SYNTH:PNEU_UTD "PNEU-UTD - Pneumo up to date if d1 ≤ 23y old and scheme completed" = false
        DO Suggested
        MESSAGES  MSG229
      END RULE 211/01

      RULE 211/02 "≥ 24m old, Risk Factors-, d1 ≤ 23m old, scheme completed+: Up to date"
        IF ALL OF
          SYNTH:PNEU_1ST_7_15 "PNEU-1st7/15 - 1st dose 7 to 15 conjugated vaccine" = true
          CALC:Pneu_age_at_first_act<=23m
          SYNTH:PNEU_UTD "PNEU-UTD - Pneumo up to date if d1 ≤ 23y old and scheme completed" = true
        DO Recommended
          Status COMPLETED
      END RULE 211/02

      RULE 211/03 "≥ 24m old, Risk Factors-, ≥ 1 dose PCV10/15 (and not 20), d1 ≥ 24m old: Up to date"
        IF ALL OF
          SYNTH:PNEU_1ST_7_15 "PNEU-1st7/15 - 1st dose 7 to 15 conjugated vaccine" = true
          CALC:Pneu_age_at_first_act>=24m
        DO Recommended
          Status COMPLETED
      END RULE 211/03
    END FOLDER 211
  END FOLDER 21

  FOLDER 22 "Risk Factors +"
    IF SYNTH:PNEU_RF_ADU "PNEU-RF-ADU - Risk factors for severe pneumococcal infection (Adults)" = true

    FOLDER 221 "Zero dose"
      IF CALC:Pneu_doses_received = 0

      RULE 221/01 "≥ 24m old, Risk Factors+, 0 dose: To do PCV10/15 ASAP"
        IF CALC:Pneu_doses_received = 0
        DO Recommended
          Status DUE
          Age 24m
      END RULE 221/01
    END FOLDER 221

    FOLDER 222 "One dose or more"
      IF CALC:Pneu_doses_received>=1

      RULE 222/01 "≥ 24m old, Risk Factors+, d1 ≤ 23m old, scheme completed-: To do 1m after LD"
        IF ALL OF
          SYNTH:PNEU_1ST_7_15 "PNEU-1st7/15 - 1st dose 7 to 15 conjugated vaccine" = true
          CALC:Pneu_age_at_first_act<=23m
          SYNTH:PNEU_UTD "PNEU-UTD - Pneumo up to date if d1 ≤ 23y old and scheme completed" = false
        DO Recommended
          Status DUE
          Delay 1m from CALC:Pneumo_last_dose_date
        MESSAGES  MSG231
      END RULE 222/01

      RULE 222/02 "≥ 24m old, Risk Factors+, d1 ≤ 23m old, scheme completed+: Up to date"
        IF ALL OF
          SYNTH:PNEU_1ST_7_15 "PNEU-1st7/15 - 1st dose 7 to 15 conjugated vaccine" = true
          CALC:Pneu_age_at_first_act<=23m
          SYNTH:PNEU_UTD "PNEU-UTD - Pneumo up to date if d1 ≤ 23y old and scheme completed" = true
        DO Recommended
          Status COMPLETED
      END RULE 222/02

      RULE 222/03 "≥ 24m old, Risk Factors+, ≥ 1 dose PCV10/20, d1 ≥ 24m old: Up to date"
        IF ALL OF
          CALC:Pneu_age_at_first_act>=24m
          SYNTH:PNEU_ONLY10_20_NOT23NC "PNEU-ONLY10/20-NOT23NC - Received only doses of PCV7 to 20 (Not non conjugated vaccine)" = true
        DO Recommended
          Status COMPLETED
      END RULE 222/03
    END FOLDER 222
  END FOLDER 22
END FOLDER 2

FOLDER 8 "Contraindications and special cases"

  FOLDER 81 "Contraindications"

    RULE 81/01 "Case « Contraindication to pneumococcal infection » checked: Contraindication + message"
      IF COND:C1017 "Contraindication to vaccination against pneumococcal disease" = true
      DO Contraindicated
      MESSAGES  MSG13 MSG14
    END RULE 81/01
  END FOLDER 81

  FOLDER 82 "Special cases"

    RULE 82/01 "23-valent before 24 months old"
      IF ALL OF
        CALC:Pneu_doses_received>=1
        CALC:PPSV-05_age_at_first_dose<=23m
      DO Exception
      MESSAGES  MSG181
    END RULE 82/01

    RULE 82/02 "Case  « Refusal to vaccinate against this disease » checked: Special case + message"
      IF COND:C616 "Refusal of pneumococcal vaccination" = true
      DO Exception
      MESSAGES  MSG19 MSG20
    END RULE 82/02
  END FOLDER 82
END FOLDER 8

FOLDER 9 "Further information"

  FOLDER 91 "≤ 23 months"
    IF CALC:Age<=23m

    RULE 91/01 "≤ 23m old, 0 dose: Message information"
      IF ALL OF
        CALC:Pneu_doses_received = 0
        CALC:Age<=23m
      DO Neutral
      MESSAGES  MSG169
    END RULE 91/01

    RULE 91/02 "≤ 23m old, 0 dose: Message information"
      IF ALL OF
        SYNTH:PNEU_SCH3 "PNEU SCH3 0 dose and age ≤6m" = true
        SYNTH:PNEU_RF_PREMA "PNEU-RF Premature birth ≤ 33 weeks" = false
      DO Neutral
      MESSAGES  MSG230
    END RULE 91/02

    RULE 91/03 "≤ 23m old, 0 dose: Message information"
      IF ALL OF
        CALC:Pneu_age_at_first_act<=6m
        CALC:Age<=23m
        SYNTH:PNEU_ONLY7_15 "PNEU-ONLY7/15 - Received only doses of PCV7 to 15 (Not NC vaccine AND not PCV20)" = true
        SYNTH:PNEU_RF_PREMA "PNEU-RF Premature birth ≤ 33 weeks" = false
      DO Neutral
      MESSAGES  MSG230
    END RULE 91/03

    RULE 91/04 "≤ 23m old, 0 dose: Message information"
      IF ALL OF
        CALC:Pneu_age_at_first_act<=6m
        CALC:Age<=23m
        SYNTH:PNEU_LD20 "PNEU-LD20 - Last dose is PREVENAR 20" = true
        SYNTH:PNEU_RF_PREMA "PNEU-RF Premature birth ≤ 33 weeks" = false
      DO Neutral
      MESSAGES  MSG111
    END RULE 91/04

    RULE 91/05 "≤ 23m old, 0 dose: Message information"
      IF ANY OF
        SYNTH:PNEU_SCH2 "PNEU SCH2 0 dose and age [7-11m]" = true
        CALC:Pneu_age_at_first_act in 7m..11m
      DO Neutral
      MESSAGES  MSG103
    END RULE 91/05

    RULE 91/06 "≤ 23m old, 0 dose: Message information"
      IF ANY OF
        SYNTH:PNEU_SCH1 "PNEU SCH1 0 dose and age[12-23m]" = true
        CALC:Pneu_age_at_first_act in 12m..23m
      DO Neutral
      MESSAGES  MSG105
    END RULE 91/06

    RULE 91/07 "If to do, 0 dose: Mandatory vaccination"
      WHEN Recommended
      IF ALL OF
        CALC:Pneu_d1d2<=6w
        CALC:Pneu_age_at_first_act<=6m
        SYNTH:PNEU_RF_PREMA "PNEU-RF Premature birth ≤ 33 weeks" = false
      DO Neutral
      MESSAGES  MSG101
    END RULE 91/07

    RULE 91/08 "If to do, 0 dose: Mandatory vaccination"
      WHEN Recommended
      IF CALC:Pneu_doses_received = 0
      DO Neutral
      MESSAGES  MSG69
    END RULE 91/08

    RULE 91/09 "≤ 23m old, 0 dose: Message information"
      WHEN Recommended
      IF ALL OF
        CALC:Age<=23m
        SYNTH:PNEU_LD_10_15 "PNEU-LD10/15 - Last dose includes 7 to 15 conjugated vaccine" = true
        CALC:Pneu_last_dose_valences contains no VPC-22F
      DO Neutral
      MESSAGES  MSG154
    END RULE 91/09

    RULE 91/10 "≤ 23m old, 0 dose: Message information"
      WHEN Recommended
      IF ALL OF
        CALC:Age<=23m
        SYNTH:PNEU_LD_10_15 "PNEU-LD10/15 - Last dose includes 7 to 15 conjugated vaccine" = true
        CALC:Pneu_last_dose_valences contains VPC-22F
      DO Neutral
      MESSAGES  MSG113
    END RULE 91/10

    RULE 91/11 "≤ 23m old, 0 dose: Message information"
      WHEN Recommended
      IF SYNTH:PNEU_LD20 "PNEU-LD20 - Last dose is PREVENAR 20" = true
      DO Neutral
      MESSAGES  MSG195
    END RULE 91/11

    RULE 91/12 "if To do, Risk Factors+: Message = Risk factor for serious pneumococcal infection "
      WHEN Recommended
      IF SYNTH:PNEU_RF_CHILD "PNEU-RF-CHILD - Risk factors for severe pneumococcal infection (Children)" = true
      DO Neutral
      MESSAGES  MSG147
    END RULE 91/12

    RULE 91/13 "if To do, age ≤ 6m, premature infant: Message = reinforced vaccination schedule 3+1"
      WHEN Recommended
      IF ALL OF
        CALC:Age<=6m
        SYNTH:PNEU_RF_PREMA "PNEU-RF Premature birth ≤ 33 weeks" = true
      DO Neutral
      MESSAGES  MSG127 MSG130 MSG132
    END RULE 91/13

    RULE 91/14 "if To do, age [7m-23m], premature infant: Message = reinforced vaccination schedule 3+1 (Copie)"
      WHEN Recommended
      IF ALL OF
        CALC:Age in 7m..23m
        SYNTH:PNEU_RF_PREMA "PNEU-RF Premature birth ≤ 33 weeks" = true
        CALC:Pneu_age_at_first_act in 6w..6m
      DO Neutral
      MESSAGES  MSG132
    END RULE 91/14
  END FOLDER 91

  FOLDER 92 "≥ 24 months"
    IF CALC:Age>=24m

    RULE 92/01 "if To do, ≥ 24m old, Risk Factors+: Message = Risk factor for serious pneumococcal infection."
      WHEN Recommended
      IF SYNTH:PNEU_RF_ADU "PNEU-RF-ADU - Risk factors for severe pneumococcal infection (Adults)" = true
      DO Neutral
      MESSAGES  MSG126
    END RULE 92/01

    RULE 92/02 "If to do, ≥ 85y old: Message"
      WHEN Recommended
      IF CALC:Age>=85y
      DO Neutral
    END RULE 92/02

    RULE 92/03 "If to do, ≥ 65y old: message"
      WHEN Recommended
      IF CALC:Age>=65y
      DO Neutral
      MESSAGES  MSG145
    END RULE 92/03
  END FOLDER 92
END FOLDER 9

END TARGET

MESSAGE MSG105 Justification ANY PRIO 0
  "If vaccination begins between 12 and 23 months of age, the primary vaccination schedule consists of 2 doses at least two months apart, and there is no need for a booster dose."@en
 END MESSAGE MSG105

MESSAGE MSG229 Summary ANY PRIO 0
  "The vaccination schedule is not complete but this vaccine is no longer recommended after the age of 24 months, in the absence of risk factors."@en
 END MESSAGE MSG229

MESSAGE MSG145 Justification ANY PRIO 0
  "Vaccination prevents pneumococcal infections, which are more serious and more frequent in the elderly."@en
 END MESSAGE MSG145

MESSAGE MSG113 Comments ANY PRIO 0
  "Continue with the 15-valent pneumococcal polysaccharide conjugate vaccine."@en
 END MESSAGE MSG113

MESSAGE MSG181 Alert ANY PRIO 0
  "Non-conjugated pneumococcal vaccines should not be administered before the age of 2. Specialist advice is required."@en
 END MESSAGE MSG181

MESSAGE MSG19 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG19

MESSAGE MSG20 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been ticked in the health profile (‘Refusal of vaccination’ section)."@en
 END MESSAGE MSG20

MESSAGE MSG138 Justification ANY PRIO 0
  "When vaccination against pneumococcus is started from the age of 12 months, the vaccination schedule consists of 2 doses with an interval of at least 2 months. An additional dose may be considered for this infant, as the interval between the 2 doses already received is less than 7 weeks."@en
 END MESSAGE MSG138

MESSAGE MSG13 Alert ANY PRIO 0
  "Vaccination contraindicated by the doctor."@en
 END MESSAGE MSG13

MESSAGE MSG14 Justification ANY PRIO 0
  "The box indicating a contraindication for this disease has been ticked in the health profile (‘Contraindicated vaccinations’ section)."@en
 END MESSAGE MSG14

MESSAGE MSG231 Justification ANY PRIO 0
  "Le schéma vaccinal du nourrisson n'est pas complet : une dose supplémentaire est necessaire."@en
 END MESSAGE MSG231

MESSAGE MSG230 Justification ANY PRIO 0
  "If the infant is vaccinated before the age of 7 months, the primary vaccination schedule consists of 2 doses 2 months apart (normally at 2 and 4 months). A booster dose is recommended between the ages of 12 and 15 months."@en
 END MESSAGE MSG230

MESSAGE MSG110 Summary ANY PRIO 0
  "The national vaccination programme includes a 15-valent vaccine."@en
 END MESSAGE MSG110

MESSAGE MSG132 Justification ANY PRIO 0
  "A reinforced vaccination schedule is recommended for premature infants. This so-called ‘3+1’ schedule comprises 4 doses: a 3-dose primary vaccination at least one month apart (normally at 2, 3 and 4 months of age), followed by a fourth dose between 11 and 15 months of age. It applies when the first dose has been administered between the ages of 6 weeks and 6 months inclusive."@en
 END MESSAGE MSG132

MESSAGE MSG195 Comments PRO PRIO 0
  "Continue with the 20-valent pneumococcal polysaccharide conjugate vaccine."@en
 END MESSAGE MSG195

MESSAGE MSG154 Comments ANY PRIO 0
  "Next dose with a pneumococcal conjugate vaccine containing at least the same number of valences."@en
 END MESSAGE MSG154

MESSAGE MSG169 Comments ANY PRIO 0
  "Vaccination with a conjugate pneumococcal vaccine prevents pneumococcal infections, which are more serious and more frequent in infants."@en
 END MESSAGE MSG169

MESSAGE MSG69 Summary ANY PRIO 0
  "This vaccination is compulsory in Latvia, from the age of 2 months."@en
 END MESSAGE MSG69

MESSAGE MSG126 Justification ANY PRIO 0
  "Vaccination is recommended because there is a risk factor for serious pneumococcal infection."@en
 END MESSAGE MSG126

MESSAGE MSG111 Justification ANY PRIO 0
  "If an infant is vaccinated with a 20-valent vaccine before the age of 7 months, the primary vaccination schedule consists of 3 doses at 1-month intervals (normally at 2, 3 and 4 months). A booster dose is recommended between the ages of 12 and 15 months."@en
 END MESSAGE MSG111

MESSAGE MSG107 Summary ANY PRIO 0
  "The last dose was given before the age of 11 months, an additional dose is recommended."@en
 END MESSAGE MSG107

MESSAGE MSG147 Justification ANY PRIO 50
  "Vaccination is all the more recommended if there is a risk factor for serious pneumococcal infection."@en
 END MESSAGE MSG147

MESSAGE MSG103 Justification ANY PRIO 0
  "If the infant is vaccinated between 7 and 11 months of age, the primary vaccination schedule consists of 2 doses given one month apart. A booster dose is recommended during the second year of life."@en
 END MESSAGE MSG103

MESSAGE MSG101 Justification ANY PRIO 0
  "When the first dose of vaccine has been administered between the ages of 6 weeks and 6 months, the interval between the first two doses should be 2 months. A shorter interval justifies the administration of an additional dose."@en
 END MESSAGE MSG101

MESSAGE MSG127 Summary PRO PRIO 0
  "Premature infants should benefit from a reinforced vaccination schedule (3+1 instead of 2+1)."@en
 END MESSAGE MSG127

MESSAGE MSG130 Summary PATIENT PRIO 0
  "This premature baby should benefit from a reinforced vaccination schedule."@en
 END MESSAGE MSG130

MESSAGE MSG125 Summary PRO PRIO 0
  "A vaccination schedule with room for improvement."@en
 END MESSAGE MSG125
