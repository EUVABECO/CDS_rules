CALC INF_last_dose_date IS HIST(INF,-1,date)	

SYNTH FLU-RF "FLU-RF - All risk factor for influenza (Med / Env / Pro / BMI / ≥65 old)" IS ANY OF
  SYNTH:FLU-RF-MED "FLU-RF-MED - Medical risk factors for influenza" = true
  SYNTH:FLU-RF-ENV "FLU-RF-ENV -  Environmental risk factor for influenza" = true
  SYNTH:FLU-RF-PRO "FLU-RF-PRO - Occupational risk factor for influenza" = true
  SYNTH:OBESITY "COMMON-META - Obesity if BMI ≥ 30 Kg/m2" = true
  CALC:Age>=65y

SYNTH FLU-RF-PRO "FLU-RF-PRO - Occupational risk factor for influenza" IS ANY OF
  COND:C1113 "Students of medical schools and universities providing education in medical fields" = true
  COND:C378 "Active health professional" = true
  COND:C1114 "Administrative staff working in healthcare segment" = true
  COND:C1115 "People having close professional contact with the elderly" = true
  COND:C1116 "People having close professional contact with chronic ill people" = true
  COND:C95 "National education professional in contact with children" = true
  COND:C1117 "Trade employees" = true
  COND:C82 "Works in a medical transport company" = true
  COND:C862 "Other profession in the field of transport" = true
  COND:C102 "Police officer" = true
  COND:C1118 "Military" = true
  COND:C1119 "Border guard" = true
  COND:C92 "Fireman" = true
  COND:C1120 "Other public sector jobs" = true
  COND:C1121 "Close professional contact with an infant under 6 months of age" = true
  COND:C1256 "Poultry and fur farm employees" = true

SYNTH FLU-RF-ENV "FLU-RF-ENV -  Environmental risk factor for influenza" IS ANY OF
  COND:C298 "Close and prolonged family contact with an infant under 6 months of age" = true
  COND:C1104 "People having close family contact with the elderly" = true
  COND:C1105 "People having close family contact with chronic ill people" = true
  COND:C1009 "Lives in a home for the elderly" = true
  COND:C1106 "Facilities providing round-the-clock care to the disabled people, chronically ill or the elderly" = true
  COND:C1112 "Hospices" = true
  COND:C1107 " Stay in an addiction treatment center" = true
  COND:C1108 "Health resorts" = true
  COND:C120 "Stay in a psychiatric institution" = true
  COND:C535 "Stay in a follow-up care and rehabilitation unit" = true

SYNTH FLU-RF-MED "FLU-RF-MED - Medical risk factors for influenza" IS ANY OF
  COND:C404 "Cancer or hematological malignancy" = true
  COND:C924 "Chronic lymphocytic leukemia" = true
  COND:C547 "Coronary artery disease" = true
  COND:C304 "Severe asthma under continuous treatment" = true
  COND:C281 "Chronic obstructive pulmonary disease (COPD)" = true
  COND:C958 "Diabetes" = true
  COND:C1094 "Other chronic metabolic diseases" = true
  COND:C956 "Cirrhosis" = true
  COND:C41 "Chronic liver disease" = true
  COND:C957 "Major neuro-cognitive deficit" = true
  COND:C198 "Myopathy or other severe neuromuscular disorder" = true
  COND:C199 "Other serious neurological condition" = true
  SYNTH:COMMON-SOT-HSCT "COMMON - Solid organ or stem cell transplantation" = true
  COND:C24 "HIV infection" = true
  COND:C36 "Spleen removal or non-functioning" = true
  COND:C6 "Nephrotic syndrome" = true
  COND:C17 "Chronic renal failure on dialysis" = true
  COND:C18 "Chronic renal failure NOT on dialysis" = true
  COND:C1110 "Relapsing nephrotic syndrome" = true
  COND:C1109 "Cardiovascular insufficiency" = true

TARGET Influenza

FOLDER - "General rules"
END FOLDER -

FOLDER 1 "Risk factor -"
  IF SYNTH:FLU-RF "FLU-RF - All risk factor for influenza (Med / Env / Pro / BMI / ≥65 old)" = false

  RULE 1/01 "[18/64y] old, Risk  factor -: Possible vaccination"
    IF CALC:Age in 18y..64y
    DO Suggested
  END RULE 1/01
END FOLDER 1

FOLDER 2 "Risk factor +"
  IF SYNTH:FLU-RF "FLU-RF - All risk factor for influenza (Med / Env / Pro / BMI / ≥65 old)" = true

  RULE 2/01 "Risk  factor +: To do every year between sept - dec"
    IF CALC:Age>=18y
    DO Recommended
      Status DUE
      Delay 6m from CALC:INF_last_dose_date
  END RULE 2/01
END FOLDER 2

FOLDER 9 "Further information"

  RULE 9/031 "RF+: Information + Text"
    IF SYNTH:FLU-RF "FLU-RF - All risk factor for influenza (Med / Env / Pro / BMI / ≥65 old)" = true
    DO Neutral
    MESSAGES  MSG367
  END RULE 9/031

  RULE 9/04 "If to do, For all: Information + Text"
    WHEN Recommended
    IF CALC:Age>=18y
    DO Neutral
    MESSAGES  MSG2
  END RULE 9/04

  RULE 91/04 "≥ 65y: Information - Refund 100%"
    IF CALC:Age>=65y
    DO Neutral
    MESSAGES  MSG48 MSG47
  END RULE 91/04

  RULE 91/05 "≥ 18y: Text"
    IF CALC:Age>=18y
    DO Neutral
  END RULE 91/05

  FOLDER 91 "Excel files"

    RULE 91/03 "[18/64y] old, Pregnancy -: Refund 50%"
      IF ALL OF
        CALC:Age in 18y..64y
        SYNTH:PREGNANCY_ONGOING "MATERNITY-PREGNANCY - Pregnancy in progress" = false
      DO Neutral
      MESSAGES  MSG3 MSG1
    END RULE 91/03

    RULE 91/11 "If to do, BMI ≥ 30: Information + Text"
      WHEN Recommended
      IF SYNTH:OBESITY "COMMON-META - Obesity if BMI ≥ 30 Kg/m2" = true
      DO Neutral
      MESSAGES  MSG46
    END RULE 91/11

    RULE 91/12 "[18/64y] old, Pregnancy +: Refund 100%"
      IF ALL OF
        SYNTH:PREGNANCY_ONGOING "MATERNITY-PREGNANCY - Pregnancy in progress" = true
        CALC:Age in 18y..64y
      DO Neutral
      MESSAGES  MSG48 MSG1
    END RULE 91/12

    RULE 91/13 "If to do, Allergy to any component of vaccine: Message"
      IF ALL OF
        COND:C1161 "Allergy from a previous vaccine administration" = true
        CALC:Age>=18y
      DO Neutral
      MESSAGES  MSG51 MSG165 MSG166 MSG104
    END RULE 91/13

    RULE 91/14 "Egg allergy: Information"
      IF COND:C202 "Egg allergy" = true
      DO Neutral
      MESSAGES  MSG51 MSG50
    END RULE 91/14

    RULE 91/15 "If to do, cancer: Information"
      WHEN Recommended
      IF COND:C404 "Cancer or hematological malignancy" = true
      DO Neutral
      MESSAGES  MSG4
    END RULE 91/15

    RULE 91/16 "If to do, Hematological malignancy: Information"
      WHEN Recommended
      IF SYNTH:COMMON-K-HEMA "COMMON-K-HEMA - Hematological malignancies" = true
      DO Neutral
      MESSAGES  MSG365
    END RULE 91/16

    RULE 91/17 "If to do, Chronic lymphocytic leukemia: Information"
      WHEN Recommended
      IF COND:C924 "Chronic lymphocytic leukemia" = true
      DO Neutral
      MESSAGES  MSG6
    END RULE 91/17

    RULE 91/18 "If to do, Circulatory insufficiency: Information"
      WHEN Recommended
      IF COND:C1109 "Cardiovascular insufficiency" = true
      DO Neutral
      MESSAGES  MSG7
    END RULE 91/18

    RULE 91/19 "If to do, Coronary disease, especially after the heart attack: Information"
      WHEN Recommended
      IF COND:C547 "Coronary artery disease" = true
      DO Neutral
      MESSAGES  MSG8
    END RULE 91/19

    RULE 91/20 "If to do, Asthma: Information"
      WHEN Recommended
      IF SYNTH:COMMON-ASTHM "COMMON-ASTHM - Asthma severe or not" = true
      DO Neutral
      MESSAGES  MSG9
    END RULE 91/20

    RULE 91/21 "If to do, Chronic obstructive pulmonary disease (COPD): Information"
      WHEN Recommended
      IF COND:C281 "Chronic obstructive pulmonary disease (COPD)" = true
      DO Neutral
      MESSAGES  MSG10
    END RULE 91/21

    RULE 91/22 "If to do, Diabetes: Information"
      WHEN Recommended
      IF COND:C958 "Diabetes" = true
      DO Neutral
      MESSAGES  MSG11
    END RULE 91/22

    RULE 91/23 "If to do, The others metabolic diseases: Information"
      WHEN Recommended
      IF COND:C1094 "Other chronic metabolic diseases" = true
      DO Neutral
      MESSAGES  MSG12
    END RULE 91/23

    RULE 91/24 "If to do, Liver diseases: Information"
      WHEN Recommended
      IF SYNTH:COMMON-LIVER "COMMON-LIVER - Chronic liver diseases" = true
      DO Neutral
      MESSAGES  MSG13
    END RULE 91/24

    RULE 91/25 "If to do, Neurological diseases and neurodevelopmental disorder: Information"
      WHEN Recommended
      IF SYNTH:COMMON-NEURO "COMMON-NEURO - Neurological  diseases and neurodevelopmental disorder" = true
      DO Neutral
      MESSAGES  MSG14
    END RULE 91/25

    RULE 91/26 "If to do, People after organ and tissue transplantation: Information"
      WHEN Recommended
      IF SYNTH:COMMON-SOT-HSCT "COMMON - Solid organ or stem cell transplantation" = true
      DO Neutral
      MESSAGES  MSG15
    END RULE 91/26

    RULE 91/27 "If to do, HIV infection: Information"
      WHEN Recommended
      IF COND:C24 "HIV infection" = true
      DO Neutral
      MESSAGES  MSG16
    END RULE 91/27

    RULE 91/28 "If to do, Spleen removal or non-functioning : Information"
      WHEN Recommended
      IF COND:C36 "Spleen removal or non-functioning" = true
      DO Neutral
      MESSAGES  MSG17
    END RULE 91/28

    RULE 91/29 "If to do, Relapsing nephrotic syndrome: Information"
      WHEN Recommended
      IF COND:C1110 "Relapsing nephrotic syndrome" = true
      DO Neutral
    END RULE 91/29

    RULE 91/30 "If to do, Renal failure: Information"
      WHEN Recommended
      IF SYNTH:COMMON-RENAL  "COMMON-RENAL - Chronic renal failure" = true
      DO Neutral
      MESSAGES  MSG19
    END RULE 91/30

    RULE 91/31 "If to do, Nephrotic syndrome: Information"
      WHEN Recommended
      IF COND:C6 "Nephrotic syndrome" = true
      DO Neutral
      MESSAGES  MSG20
    END RULE 91/31

    RULE 91/32 "If to do, People having close family contact with children under 6 months of age: Information"
      WHEN Recommended
      IF COND:C298 "Close and prolonged family contact with an infant under 6 months of age" = true
      DO Neutral
      MESSAGES  MSG21
    END RULE 91/32

    RULE 91/33 "If to do, People having close family contact with the elderly: Information"
      WHEN Recommended
      IF COND:C1104 "People having close family contact with the elderly" = true
      DO Neutral
      MESSAGES  MSG22
    END RULE 91/33

    RULE 91/34 "If to do, People having close family contact with chronic ill people: Information"
      WHEN Recommended
      IF COND:C1105 "People having close family contact with chronic ill people" = true
      DO Neutral
      MESSAGES  MSG23
    END RULE 91/34

    RULE 91/35 "If to do, Nursing homes: Information"
      WHEN Recommended
      IF COND:C1009 "Lives in a home for the elderly" = true
      DO Neutral
      MESSAGES  MSG24
    END RULE 91/35

    RULE 91/37 "If to do, Facilities providing round-the-clock care to the disabled people, chronically ill or the elderly: Information"
      WHEN Recommended
      IF COND:C1106 "Facilities providing round-the-clock care to the disabled people, chronically ill or the elderly" = true
      DO Neutral
      MESSAGES  MSG26
    END RULE 91/37

    RULE 91/39 "If to do, Hospices: Information"
      WHEN Recommended
      IF COND:C1112 "Hospices" = true
      DO Neutral
      MESSAGES  MSG28
    END RULE 91/39

    RULE 91/41 "If to do, Addiction treatment centers: Information"
      WHEN Recommended
      IF COND:C1107 " Stay in an addiction treatment center" = true
      DO Neutral
      MESSAGES  MSG30
    END RULE 91/41

    RULE 91/42 "If to do, Health resorts: Information"
      WHEN Recommended
      IF COND:C1108 "Health resorts" = true
      DO Neutral
      MESSAGES  MSG31
    END RULE 91/42

    RULE 91/43 "If to do, Entities providing psychiatric care services: Information"
      WHEN Recommended
      IF COND:C120 "Stay in a psychiatric institution" = true
      DO Neutral
      MESSAGES  MSG32
    END RULE 91/43

    RULE 91/44 "If to do, Entities providing medical rehabilitation services: Information"
      WHEN Recommended
      IF COND:C535 "Stay in a follow-up care and rehabilitation unit" = true
      DO Neutral
      MESSAGES  MSG33
    END RULE 91/44

    RULE 91/45 "If to do, Students of medical schools and universities providing education in medical fields: Information"
      WHEN Recommended
      IF COND:C1113 "Students of medical schools and universities providing education in medical fields" = true
      DO Neutral
      MESSAGES  MSG34
    END RULE 91/45

    RULE 91/46 "If to do, Medical staff: Information"
      WHEN Recommended
      IF SYNTH:COMMON-MED-STAFF "COMMON-MED-STAFF - Medical staff" = true
      DO Neutral
      MESSAGES  MSG35
    END RULE 91/46

    RULE 91/47 "If to do, Administrative staff working in healthcare segment: Information"
      WHEN Recommended
      IF COND:C1114 "Administrative staff working in healthcare segment" = true
      DO Neutral
      MESSAGES  MSG36
    END RULE 91/47

    RULE 91/48 "If to do, People having close professional contact with children under  6 months: Information"
      WHEN Recommended
      IF COND:C1121 "Close professional contact with an infant under 6 months of age" = true
      DO Neutral
      MESSAGES  MSG45
    END RULE 91/48

    RULE 91/49 "If to do, People having close professional contact with the elderly: Information"
      WHEN Recommended
      IF COND:C1115 "People having close professional contact with the elderly" = true
      DO Neutral
      MESSAGES  MSG38
    END RULE 91/49

    RULE 91/50 "If to do, People having close professional contact with chronic ill people: Information"
      WHEN Recommended
      IF COND:C1116 "People having close professional contact with chronic ill people" = true
      DO Neutral
      MESSAGES  MSG39
    END RULE 91/50

    RULE 91/51 "If to do, School employees: Information"
      WHEN Recommended
      IF COND:C95 "National education professional in contact with children" = true
      DO Neutral
      MESSAGES  MSG40
    END RULE 91/51

    RULE 91/52 "If to do, Trade employees: Information"
      WHEN Recommended
      IF COND:C1117 "Trade employees" = true
      DO Neutral
      MESSAGES  MSG41
    END RULE 91/52

    RULE 91/53 "If to do, Transport employees: Information"
      WHEN Recommended
      IF ANY OF
        COND:C82 "Works in a medical transport company" = true
        COND:C862 "Other profession in the field of transport" = true
      DO Neutral
      MESSAGES  MSG42
    END RULE 91/53

    RULE 91/54 "If to do, Employees of poultry and fur farms: Information"
      WHEN Recommended
      IF COND:C1256 "Poultry and fur farm employees" = true
      DO Neutral
      MESSAGES  MSG366
    END RULE 91/54

    RULE 91/55 "If to do, Police force: Information"
      WHEN Recommended
      IF COND:C102 "Police officer" = true
      DO Neutral
      MESSAGES  MSG43
    END RULE 91/55

    RULE 91/56 "If to do, Military: Information"
      WHEN Recommended
      IF COND:C1118 "Military" = true
      DO Neutral
      MESSAGES  MSG43
    END RULE 91/56

    RULE 91/57 "If to do, Border guard: Information"
      WHEN Recommended
      IF COND:C1119 "Border guard" = true
      DO Neutral
      MESSAGES  MSG43
    END RULE 91/57

    RULE 91/58 "If to do, Fire brigade: Information"
      WHEN Recommended
      IF COND:C92 "Fireman" = true
      DO Neutral
      MESSAGES  MSG43
    END RULE 91/58

    RULE 91/59 "If to do, Other public officers: Information"
      WHEN Recommended
      IF COND:C1120 "Other public sector jobs" = true
      DO Neutral
      MESSAGES  MSG43
    END RULE 91/59
  END FOLDER 91
END FOLDER 9
END TARGET

MESSAGE MSG43 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for public officers, such as police forcers, fire brigade and emergency workers. This group of people are in direct contact with a large number of people in various situations, which increases the risk of transmitting the flu and other infections."@en
 END MESSAGE MSG43

MESSAGE MSG42 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for transport workers. People hired in this industry are in daily contact with a large number of people (including travelling people) which increases the risk of transmitting the flu and other infections."@en
 END MESSAGE MSG42

MESSAGE MSG46 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for overweight or obese people (BMI ≥ 30), as they are at higher risk for severe disease and complications."@en
 END MESSAGE MSG46

MESSAGE MSG41 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for trade employees. People hired for example in supermarket shops are in daily contact with large numbers of clients  which increases the risk of transmitting the flu and other infections."@en
 END MESSAGE MSG41

MESSAGE MSG17 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people after spleen removal or having non-functioning spleen because of increased risk of infection (the spleen is crucial in the immune system and the absence of this organ can lead to a weakened immune response, making patients more vulnerable to severe flu complications)."@en
 END MESSAGE MSG17

MESSAGE MSG31 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people in health resorts. The residents of these facilities, often people with weakened immune system and chronically ill, are in high-risk group of severe complications due to flue infection."@en
 END MESSAGE MSG31

MESSAGE MSG22 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people having close family contact with the elderly. The senior citizens, especially over the age 65 years are in high-risk group of severe course of disease and the health complications of the flu. The flu can be especially dangerous for them, so health protection is crucial."@en
 END MESSAGE MSG22

MESSAGE MSG40 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for school employees. Teachers, tutors and adiministrative staff hired in schools are in daily contact with children and adolescents,  which increases the risk of transmitting the flu in school environement."@en
 END MESSAGE MSG40

MESSAGE MSG39 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people having close professional contact with chronic ill people. Chronic ill patients are in high-risk group of severe course of disease and the flu complications."@en
 END MESSAGE MSG39

MESSAGE MSG45 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people having close professional contact with children under 6 months. Infants and babies of this age group are especially vulnerable to severe complications of the flue because their immune system is not mature."@en
 END MESSAGE MSG45

MESSAGE MSG24 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people in nursing homes. The residents of nursing homes, often have the weakened immune system and suffer from chronic diseases what make them more vulnerable to severe course of the disease and the health complications (for example pneumonia)."@en
 END MESSAGE MSG24

MESSAGE MSG38 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people having close professional contact with the elderly. The senior citizens, especially over the age 65 years, are in high-risk group of severe course of disease and the health complications of the flue."@en
 END MESSAGE MSG38

MESSAGE MSG30 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people in addiction treatment centers. The residents of these facilities, often people with weakened immune system and other health problems, are in high-risk group of severe complications due to flue infection."@en
 END MESSAGE MSG30

MESSAGE MSG48 Other ANY PRIO 10
  "Refund: 100%."@en
 END MESSAGE MSG48

MESSAGE MSG47 Justification ANY PRIO 0
  "1. Flu vaccine is especially recommended for people aged 65 and older, as they are at higher risk for severe course of disease. Vaccinations are crucial to protecting the health of seniors, as influenza can lead to serious complications, such as pneumonia and even death. <br>
2. To be eligible for reimbursement, you need a prescription from a doctor."@en
 END MESSAGE MSG47

MESSAGE MSG51 Alert ANY PRIO 0
  "Warning: allergy - see comments before any vaccine administration."@en
 END MESSAGE MSG51

MESSAGE MSG50 Comments ANY PRIO 0
  "NOTE! If you suspect you may be allergic to egg protein, consult your doctor if you have not already done so. This allergy may lead to contraindications or require special precautions when using some vaccines that may contain minimal amounts of egg."@en
 END MESSAGE MSG50

MESSAGE MSG34 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for students of medical schools and universities providing education in medical fields. Due to the specific character of their studies, these people are in frequent contact with patients or with other students who may be in contact with patients."@en
 END MESSAGE MSG34

MESSAGE MSG36 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for administrative staff working in healthcare segment. These people don’t have direct contact with patients, but are crucial in healthcare entities activities and can be the source of flue transmission what can be dangerous for both patients and others workers."@en
 END MESSAGE MSG36

MESSAGE MSG13 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people with liver diseases because of increased risk of  complications. Viral infections such as flu can lead to an exacerbation of liver diseases symptoms, and increasing the risk of hospitalization and death."@en
 END MESSAGE MSG13

MESSAGE MSG28 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people in hospices. The residents of hospicies, often people with severe health problems or weakened immune system, are in high-risk group of severe course of the disease and the complications."@en
 END MESSAGE MSG28

MESSAGE MSG26 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people in facilities providing round-the-clock care to the disabled people, chronically ill or the elderly. The residents of these facilities, often have the weakened immune system and other health problems, what make them more vulnerable to severe course of the disease and the flu complications."@en
 END MESSAGE MSG26

MESSAGE MSG10 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people with chronic obstructive pulmonary disease (COPD) because this group of patients is at higher risk of influenza-related complications. Viral infections such as flu can lead to an exacerbation of COPD symptoms, which can led to hospitalization and a deterioration of lungs functionality."@en
 END MESSAGE MSG10

MESSAGE MSG8 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people with coronary disease, especially after the heart attack, because of increased risk of complications, which can lead to deteriorate of health status and even death among these people."@en
 END MESSAGE MSG8

MESSAGE MSG21 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people having close family contact with children under 6 months of age. Infants and babies of this age group are especially vulnerable to severe flu complications because their immune system is not mature."@en
 END MESSAGE MSG21

MESSAGE MSG165 Comments PATIENT PRIO 0
  "An allergy to a previous vaccine administration has been reported. You must clearly inform the healthcare professional before any new vaccination, regardless of the vaccine administered."@en
 END MESSAGE MSG165

MESSAGE MSG166 Comments PRO PRIO 0
  "An allergy to a previous vaccine administration has been reported. Before any new vaccination, carefully check the origin of the previous allergy and adapt the course of action. Seek specialist advice if in doubt."@en
 END MESSAGE MSG166

MESSAGE MSG104 Comments ANY PRIO 0
  "NOTE! It is important to consult a medical doctor before the next  vaccination in case of any allergic reaction."@en
 END MESSAGE MSG104

MESSAGE MSG35 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for medical staff because of direct contact with patients and - at the same time - with people in high-risk group (chronic ill people, the elderly). Thereupon the medical staff is exposed to flue infection and possibility to transmit the virus to patients."@en
 END MESSAGE MSG35

MESSAGE MSG2 Comments ANY PRIO 20
  "Influenza vaccination is especially recommended from September to December, as this is the period when the illness season begins. Getting vaccinated before an epidemic allows you to develop immunity and effective protection, especially for those at risk."@en
 END MESSAGE MSG2

MESSAGE MSG15 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people after organ and tissue transplantation because of increased risk of severe flu complications among these people. The flue infection among the group of people after organ and tissue transplanatation can leed to complications and even increased risk of death. 
"@en
 END MESSAGE MSG15

MESSAGE MSG16 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people with HIV infection because of increased risk of flu complications. Suppressed immune system make these people more vulnerable to severe course of disease and hospitalization."@en
 END MESSAGE MSG16

MESSAGE MSG32 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people in entities providing psychiatric care services. These patients often have weakened immune system and can have chronic diseases what make them more vulnerable to sever course of the flue."@en
 END MESSAGE MSG32

MESSAGE MSG33 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people in entities providing medical rehabilitation services. These patients often have weakened immune system and can have chronic diseases what make them more vulnerable to sever course of the flue."@en
 END MESSAGE MSG33

MESSAGE MSG3 Other ANY PRIO 10
  "Refund: 50%."@en
 END MESSAGE MSG3

MESSAGE MSG1 Summary PATIENT PRIO 0
  "To be eligible for reimbursement, you need a prescription from a doctor."@en
 END MESSAGE MSG1

MESSAGE MSG4 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people with cancer diseases and hematologic malignancies because of increased risk of flu complications among oncological patients."@en
 END MESSAGE MSG4

MESSAGE MSG11 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people with diabetes because of increased risk of severe complications among these people. Suppressed immune system of diabetes increases the risk of severe course of disease and hospitalization."@en
 END MESSAGE MSG11

MESSAGE MSG9 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people with asthma  because of increased risk of flu complications among these people. Viral infections such as flu can lead to an exacerbation of asthma symptoms, which can led to hospitalization and a deterioration of overall patient health."@en
 END MESSAGE MSG9

MESSAGE MSG14 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people with neurological diseases and neurodevelopmental disorders because of increased risk of flu complications among these people. Viral infections such as flu can lead to an exacerbation of neurological diseases symptoms, and increasing the risk of hospitalization. Suppressed immune system make these people more susceptible to severe course of disease."@en
 END MESSAGE MSG14

MESSAGE MSG19 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people with renal failure because of increased risk of flu complications."@en
 END MESSAGE MSG19

MESSAGE MSG365 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people with hematologic malignancies because of increased risk of flu complications among oncological patients."@en
 END MESSAGE MSG365

MESSAGE MSG12 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people with metabolic diseases because of possible increased risk of severe flu complications among these people."@en
 END MESSAGE MSG12

MESSAGE MSG20 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people with nephrotic syndrome, because these pateints are at higher-risk for flu complications. Nephrotic syndrome leads to wekenes immune system, what makes these patients more vulnerable to infectious disease and the severe course of the disease."@en
 END MESSAGE MSG20

MESSAGE MSG7 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people with circulatory insufficiency because of increased risk of flu complications among these people."@en
 END MESSAGE MSG7

MESSAGE MSG6 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people with chronic lymphocytic leukemia, as they are at higher risk for severe course of disease and health complications."@en
 END MESSAGE MSG6

MESSAGE MSG366 Justification ANY PRIO 0
  "Flu vaccination is especially recommended for workers on poultry and fur farms. These individuals are exposed to influenza viruses that can be transmitted by birds and other animals. Therefore, their protection through vaccination is crucial not only for their health, but also to prevent the spread of viruses among animals and humans."@en
 END MESSAGE MSG366

MESSAGE MSG23 Justification ANY PRIO 0
  "Flu vaccine is especially recommended for people having close family contact with chronic ill people. These people may be a potential source of flu infection for patients who are more vulnerable to severe course of disease and flu complications."@en
 END MESSAGE MSG23

MESSAGE MSG367 Summary ANY PRIO 0
  "Flu vaccination is particularly recommended due to a risk factor."@en
 END MESSAGE MSG367
