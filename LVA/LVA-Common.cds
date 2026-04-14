CALC Age "Age at eval time" IS INTERVAL (BASE:dob, BASE:eval)
CALC BMI IS DIV(COND:C962 "Weight",MUL(COND:C963 "Height", COND:C963))

SYNTH PREGNANCY_OVER "PREGNANCY - Pregnancy over" IS ANY OF
  COND:C1081 "Pregnancy start date">=40w
  COND:C1032 "Date of delivery">=0d
  
SYNTH PREGNANCY_ONGOING "PREGNANCY - Pregnancy in progress" IS ALL OF
  COND:C1081 "Pregnancy start date" in 1d..39w
  SYNTH:PREGNANCY_OVER "PREGNANCY - Pregnancy over" = false
  
SYNTH COAG_DISORDERS "COMMON - coagulation disorders" IS ANY OF
  COND:C16 "Hemophilia" = true
  COND:C479 "Thrombocytopenia" = true
  COND:C477 "Thrombocytopenic purpura" = true
  COND:C478 "Anticoagulant treatment" = true
  COND:C1232 "Other bleeding disorder" = true

SYNTH OBESITY IS ANY OF BMI >= 30  

SYNTH COMMON-RF-ID "COMMON-RF-ID - ID risk factors contraindicating vaccination with live vaccines" IS ANY OF
  COND:C917 "Strong immunosuppressive treatment (covid)" = true
  COND:C932 "Date of a solid organ transplant (kidney, heart, liver or lungs)">=1d
  COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)" in 1d..23m
  COND:C578 "Ongoing chemotherapy for solid tumor (cancer)" = true
  COND:C594 "Ongoing chemotherapy for hematological malignancy (leukemia)" = true
  COND:C579 "Biotherapy leading to immunosuppression" = true
  COND:C413 "Other immunosuppressive therapy" = true
  COND:C141 "Prolonged or high-dose corticosteroid therapy" = true
  COND:C924 "Chronic lymphocytic leukemia" = true
  COND:C582 "Common variable immune deficiency (CVID)" = true
  COND:C583 "Bruton's disease (X-linked agammaglobulinemia)" = true
  COND:C1010 "Congenital immune deficiency, with strong immunosuppression" = true
  COND:C1096 "Immunodeficiency, whatever the cause (disease or treatment)." = true
  COND:C21 "Complement deficit" = true
  COND:C582 "Common variable immune deficiency (CVID)" = true
  COND:C581 "Severe chronic neutropenia" = true
  COND:C580 "Phagocytic cell deficiency (septic granulomatosis)" = true
  COND:C830 "Hyper IgM syndrome" = true
  COND:C584 "IgG subclass deficiency" = true
  COND:C880 "Rare systemic autoimmune disease with immunosuppressive therapy" = true
  COND:C587 "Partial combined immunodeficiency" = true
  
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

SYNTH AFFECTIONS-CHR-HEART-ADLT "AFFECTIONS-CHR-HEART-ADLT - Chronic heart disease in adults" IS ANY OF
  COND:C3 "Severe heart failure" = true
  COND:C4 "Severe Valvulopathy" = true
  COND:C927 "Myocarditis or pericarditis not related to SARS-CoV-2 infection, prior to vaccination and still active" = true
  COND:C954 "Cardiomyopathy" = true
  COND:C2 "Cyanogenic congenital heart disease" = true
  COND:C1037 "Other serious cardiovascular disease" = true
  COND:C961 "Hypertension, complicated or not" = true
  COND:C547 "Coronary artery disease" = true
  
SYNTH AFFECTIONS-CHR-ID-ADLT "AFFECTIONS-CHR-ID-ADLT - ID in adults" IS ANY OF
  COND:C880 "Rare systemic autoimmune disease with immunosuppressive therapy" = true
  COND:C1010 "Congenital immune deficiency, with strong immunosuppression" = true
  COND:C1096 "Immunodeficiency, whatever the cause (disease or treatment)." = true

SYNTH AFFECTIONS-CHR-PSY-ADLT "AFFECTIONS-CHR-PSY-ADLT - Psychiatric disorders in adults" IS ANY OF
  COND:C864 "Dementia or psychiatric disorder" = true
  COND:C1098 "Other mental illnesses" = true
  
SYNTH AFFECTIONS-CHR-URO-ADLT "AFFECTIONS-CHR-URO-ADLT - Chronic kidney disease in adults" IS ANY OF
  COND:C17 "Chronic renal failure on dialysis" = true
  COND:C18 "Chronic renal failure NOT on dialysis" = true
  COND:C6 "Nephrotic syndrome" = true
  COND:C1095 "Other chronic kidney diseases" = true

SYNTH AFFECTIONS-CHR-META-ADLT "AFFECTIONS-CHR-META-ADLT - Chronic metabolic disorders in adults" IS ANY OF
  COND:C958 "Diabetes" = true
  COND:C1094 "Other chronic metabolic diseases" = true
  SYNTH:OBESITY "COMMON-META - Obesity if BMI ≥ 30 Kg/m2" = true
  
SYNTH AFFECTIONS-CHR-HEART-CHILD "AFFECTIONS-CHR-HEART-CHILD - Chronic heart disease in children" IS ANY OF
  COND:C3 "Severe heart failure" = true
  COND:C4 "Severe Valvulopathy" = true
  COND:C927 "Myocarditis or pericarditis not related to SARS-CoV-2 infection, prior to vaccination and still active" = true
  COND:C954 "Cardiomyopathy" = true
  COND:C2 "Cyanogenic congenital heart disease" = true
  COND:C1037 "Other serious cardiovascular disease" = true

SYNTH AFFECTIONS-CHR-URO-CHILD "AFFECTIONS-CHR-URO-CHILD - Chronic kidney disease in children" IS ANY OF
  COND:C17 "Chronic renal failure on dialysis" = true
  COND:C18 "Chronic renal failure NOT on dialysis" = true
  COND:C6 "Nephrotic syndrome" = true
  COND:C1095 "Other chronic kidney diseases" = true

SYNTH AFFECTIONS-CHR-LUNG-CHILD "AFFECTIONS-CHR-LUNG-CHILD - Chronic lung disease in children" IS ANY OF
  COND:C126 "Asthma (other than severe and under continuous treatment)" = true
  COND:C304 "Severe asthma under continuous treatment" = true
  COND:C127 "Mucoviscidosis" = true
  COND:C128 "Bronchopulmonary dysplasia" = true
  COND:C39 "Chronic respiratory failure" = true
  COND:C281 "Chronic obstructive pulmonary disease (COPD)" = true
  COND:C142 "Other chronic respiratory disease" = true

SYNTH AFFECTIONS-CHR-META-CHILD "AFFECTIONS-CHR-META-CHILD - Chronic metabolic disorders in children" IS ANY OF
  COND:C958 "Diabetes" = true
  COND:C1094 "Other chronic metabolic diseases" = true
  SYNTH:OBESITY "COMMON-META - Obesity if BMI ≥ 30 Kg/m2" = true

SYNTH AFFECTIONS-CHR-ID-CHILD "AFFECTIONS-CHR-ID-CHILD - ID in children" IS ANY OF
  COND:C880 "Rare systemic autoimmune disease with immunosuppressive therapy" = true
  COND:C1010 "Congenital immune deficiency, with strong immunosuppression" = true
  COND:C1096 "Immunodeficiency, whatever the cause (disease or treatment)." = true
  