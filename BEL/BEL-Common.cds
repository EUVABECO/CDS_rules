CALC Age "Age at eval time" IS INTERVAL (BASE:dob, BASE:eval)
CALC BMI IS DIV(COND:C962 "Weight",MUL(COND:C963 "Height", COND:C963))

SYNTH COMMON-BMI IS ALL OF
  CALC:BMI >= 40
  
SYNTH PREGNANCY_OVER "PREGNANCY - Pregnancy over" IS ANY OF
  COND:C1081 "Pregnancy start date">=40w
  COND:C1032 "Date of delivery">=0d
  
SYNTH PREGNANCY_ONGOING "PREGNANCY - Pregnancy in progress" IS ALL OF
  COND:C1081 "Pregnancy start date" in 1d..39w
  SYNTH:PREGNANCY_OVER "PREGNANCY - Pregnancy over" = false

SYNTH OBESITY IS ANY OF CALC:BMI >= 30  
  
SYNTH COMMON-RF-ID "COMMON-RF-ID - ID risk factors contraindicating vaccination with live vaccines" IS ANY OF
  COND:C917 "Strong immunosuppressive treatment (covid)" = true
  COND:C932 "Date of a solid organ transplant (kidney, heart, liver or lungs)">=1d
  COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)">=1d
  COND:C578 "Ongoing chemotherapy for solid tumor (cancer)" = true
  COND:C594 "Ongoing chemotherapy for hematological malignancy (leukemia)" = true
  COND:C579 "Biotherapy leading to immunosuppression" = true
  COND:C413 "Other immunosuppressive therapy" = true
  COND:C1231 "Immunocompromised person" = true

SYNTH COMMUN-VIH "COMMUN-VIH - VIH avec CD4 ≤ 199 (ID)" IS ALL OF
  COND:C24 "HIV infection" = true
  COND:C933 "CD4 rate"<=199


SYNTH WOMAN-13-50 "COMMON - Woman of childbearing age (13y - 50y)" IS ALL OF
  CALC:Age in 13y..50y
  BASE:sex = f


SYNTH FLU-RF-ALL "FLU-RF-ALL - Risk factors for severe influenza and COVID-19 (Group 1 + 2 + 3 + 4)" IS ANY OF
  SYNTH:FLU-RF-GRP1 "FLU-RF-GRP1 - Risk factors group 1" = true
  SYNTH:FLU-RF-GRP2 "FLU-RF-GRP2 - Occupational risk factors for vaccination against Covid 19 and flu" = true
  SYNTH:FLU-RF-GRP4 "FLU-RF-GRP4 - [50-64y] old + (Tabac / Alcool / BMI ≥ 30)" = true

SYNTH FLU-RF-GRP1 "FLU-RF-GRP1 - Risk factors group 1" IS ANY OF
  CALC:Age>=65y
  SYNTH:FLU-RF-RES "FLU-RF-RES - Risk factors for community residence for vaccination against flu" = true
  SYNTH:PREGNANCY_ONGOING "COMMON-PREGNANCY - Pregnancy in progress" = true
  SYNTH:COMMON-BMI "COMMON-BMI - BMI ≥ 40" = true
  SYNTH:FLU-RF-GRP1-1 "FLU-RF-GRP1-1 - Children aged between 6 months and 18 years undergoing long-term aspirin treatment." = true
  SYNTH:FLU-RF-GRP1-2 "FLU-RF-GRP1-2 - Medical risk factors for influenza vaccination" = true

SYNTH FLU-RF-GRP1-1 "FLU-RF-GRP1-1 - Children aged between 6 months and 18 years undergoing long-term aspirin treatment." IS ALL OF
  CALC:Age in 6m..18y
  COND:C1229 "On long-term aspirin therapy" = true
  
SYNTH FLU-RF-GRP1-2 "FLU-RF-GRP1-2 - Medical risk factors for influenza vaccination" IS ANY OF
  COND:C859 "Trisomy 21" = true
  COND:C3 "Severe heart failure" = true
  COND:C949 "Severe extrapulmonary restrictive pathology" = true
  COND:C954 "Cardiomyopathy" = true
  COND:C953 "Unstable coronary artery disease" = true
  COND:C127 "Mucoviscidosis" = true
  COND:C873 "Pulmonary fibrosis" = true
  COND:C404 "Cancer or hematological malignancy" = true
  COND:C17 "Chronic renal failure on dialysis" = true
  COND:C956 "Cirrhosis" = true
  COND:C36 "Spleen removal or non-functioning" = true
  COND:C957 "Major neuro-cognitive deficit" = true
  COND:C19 "Waiting for an organ transplant (kidney, heart, liver or lung)" = true
  COND:C198 "Myopathy or other severe neuromuscular disorder" = true
  COND:C304 "Severe asthma under continuous treatment" = true
  COND:C579 "Biotherapy leading to immunosuppression" = true
  COND:C413 "Other immunosuppressive therapy" = true
  SYNTH:COMMUN-VIH "COMMUN-VIH - VIH avec CD4 ≤ 199 (ID)" = true
  COND:C932 "Date of a solid organ transplant (kidney, heart, liver or lungs)">=1d
  COND:C281 "Chronic obstructive pulmonary disease (COPD)" = true
  COND:C1231 "Immunocompromised person" = true
  COND:C958 "Diabetes" = true
 
SYNTH FLU-RF-GRP2 "FLU-RF-GRP2 - Occupational risk factors for vaccination against Covid 19 and flu" IS ANY OF
  COND:C378 "Active health professional" = true
  COND:C1006 "Works in a home for the elderly" = true
  COND:C1007 "Works in a home for the disabled" = true
  COND:C56 "Physician" = true
  COND:C61 "Dental surgeon" = true
  COND:C62 "Nurse" = true
  COND:C1006 "Works in a home for the elderly" = true
  COND:C1007 "Works in a home for the disabled" = true
  COND:C88 "Works in a pre-school childcare facility (daycare, nursery school, etc.)" = true
  COND:C249 "Works in a medical biology laboratory" = true
  COND:C273 "Works in a maternity hospital" = true
  COND:C90 "Works in a social institution or service contributing to child protection" = true

SYNTH FLU-RF-GRP4 "FLU-RF-GRP4 - [50-64y] old + (Tabac / Alcool / BMI ≥ 30)" IS ALL OF
  CALC:Age in 50y..64y
  SYNTH:FLU-RF-GRP4-1 "FLU-RF-GRP4-1 - Tabac || Alccol || BMI ≥ 30 " = true

SYNTH FLU-RF-GRP4-1 "FLU-RF-GRP4-1 - Tabac || Alccol || BMI ≥ 30 " IS ANY OF
  COND:C1000 "Excessive alcohol use" = true
  Missing>=30
  COND:C54 "Smoker" = true

SYNTH FLU-RF-RES "FLU-RF-RES - Risk factors for community residence for vaccination against flu" IS ANY OF
  COND:C1009 "Lives in a home for the elderly" = true
  COND:C1008 "Lives in a residence for the disabled" = true
  
