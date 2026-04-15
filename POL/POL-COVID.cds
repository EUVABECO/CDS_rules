CALC Covid_doses_received IS HIST(COVID,0,count)
CALC Covid_last_dose_date IS HIST(COVID,-1,date)
CALC Covid_last_valences IS HIST(COVID,-1,valences)


SYNTH COV-RF-MED "COV-RF-MED - Medical risk factors for COVID-19" IS ANY OF
  COND:C24 "HIV infection" = true
  SYNTH:OBESITY "COMMON-BMI - Obesity if BMI ≥ 25 Kg/m2" = true
  COND:C404 "Cancer or hematological malignancy" = true
  SYNTH:COMMON-HEART "COMMON-HEART - Chronic heart diseases" = true
  COND:C304 "Severe asthma under continuous treatment" = true
  COND:C281 "Chronic obstructive pulmonary disease (COPD)" = true
  COND:C958 "Diabetes" = true
  SYNTH:COMMON-SOT-HSCT "COMMON - Solid organ or stem cell transplantation" = true
  SYNTH:COMMON-KIDNEY "COMMON-KIDNEY - Chronic kidney disease" = true
  COND:C199 "Other serious neurological condition" = true
  SYNTH:COMMON-NEURO "COMMON-NEURO - Neurological  diseases and neurodevelopmental disorder" = true

TARGET COVID

FOLDER 1 "≥ 18y old"
  IF CALC:Age>=18y

  RULE 1/01 "≥ 18y old, 0 dose: To do ASAP"
    IF CALC:Covid_doses_received = 0
    DO Recommended
      Status DUE
      Age 18y
  END RULE 1/01

  RULE 1/02 "≥ 18y old, 1 dose JN.1: Up to date"
    IF ALL OF
      CALC:Covid_doses_received = 1
      CALC:Covid_last_valences contains Covid-ARNm-S-OMI-JN-1           # To fix in NUVA - No . in name
    DO Recommended
      Status COMPLETED
    MESSAGES  MSG200
  END RULE 1/02

  RULE 1/03 "≥ 18y old, 1 dose not JN.1: To do 3m after LD"
    IF ALL OF
      CALC:Covid_doses_received = 1
      CALC:Covid_last_valences contains no Covid-ARNm-S-OMI-JN-1
    DO Recommended
      Status DUE
      Age 18y
      Delay 3m from CALC:Covid_last_dose_date
    MESSAGES  MSG201
  END RULE 1/03
END FOLDER 1

FOLDER 9 "Further information"

  RULE 9/01 "If to do: Message = Vaccines that can be used"
    WHEN Recommended
    IF CALC:Age>=18y
    DO Neutral
    MESSAGES  MSG186 MSG202
  END RULE 9/01

  RULE 9/04 "If to do, ≥ 60y old: Message"
    WHEN Recommended
    IF CALC:Age>=60y
    DO Neutral
    MESSAGES  MSG190
  END RULE 9/04

  FOLDER 91 "Excel files"

    RULE 91/03 "if to do, [18-59y] old: Information"
      WHEN Recommended
      IF CALC:Age in 18y..59y
      DO Neutral
      MESSAGES  MSG48
    END RULE 91/03

    RULE 91/04 "if to do, ≥ 60y old or RF+: Information"
      WHEN Recommended
      IF ANY OF
        SYNTH:COV-RF-MED "COV-RF-MED - Medical risk factors for COVID-19" = true
        CALC:Age>=60y
      DO Neutral
      MESSAGES  MSG187 MSG48
    END RULE 91/04

    RULE 91/07 "If to do, BMI ≥25: Message"
      WHEN Recommended
      IF SYNTH:OBESITY "COMMON-BMI - Obesity if BMI ≥ 25 Kg/m2" = true
      DO Neutral
      MESSAGES  MSG189
    END RULE 91/07

    RULE 91/08 "If to do, Pregnancy: Message"
      WHEN Recommended
      IF SYNTH:PREGNANCY_ONGOING "MATERNITY-PREGNANCY - Pregnancy in progress" = true
      DO Neutral
      MESSAGES  MSG48 MSG191
    END RULE 91/08

    RULE 91/09 "If to do, COVID-19: Message"
      WHEN Recommended
      IF COND:C919 "Date of last COVID-19">=1d
      DO Neutral
      MESSAGES  MSG48 MSG192
    END RULE 91/09

    RULE 91/10 "If to do, Allergy to any component of vaccine: Message + alert"
      IF ALL OF
        COND:C1161 "Allergy from a previous vaccine administration" = true
        CALC:Age>=18y
      DO Neutral
      MESSAGES  MSG51 MSG165 MSG166 MSG104
    END RULE 91/10

    RULE 91/12 "If to do, Cancer: Message"
      WHEN Recommended
      IF COND:C404 "Cancer or hematological malignancy" = true
      DO Neutral
      MESSAGES  MSG193
    END RULE 91/12

    RULE 91/13 "If to do, Heart diseases: Message"
      WHEN Recommended
      IF SYNTH:COMMON-HEART "COMMON-HEART - Chronic heart diseases" = true
      DO Neutral
      MESSAGES  MSG194
    END RULE 91/13

    RULE 91/14 "If to do, Asthma: Message"
      WHEN Recommended
      IF SYNTH:COMMON-ASTHM "COMMON-ASTHM - Asthma severe or not" = true
      DO Neutral
      MESSAGES  MSG195
    END RULE 91/14

    RULE 91/15 "If to do, COPD: Message"
      WHEN Recommended
      IF COND:C281 "Chronic obstructive pulmonary disease (COPD)" = true
      DO Neutral
      MESSAGES  MSG195
    END RULE 91/15

    RULE 91/16 "If to do, Diabetes: Message"
      WHEN Recommended
      IF COND:C958 "Diabetes" = true
      DO Neutral
      MESSAGES  MSG196
    END RULE 91/16

    RULE 91/17 "If to do, Neurological diseases and neurodevelopmental disorder: Message"
      WHEN Recommended
      IF SYNTH:COMMON-NEURO "COMMON-NEURO - Neurological  diseases and neurodevelopmental disorder" = true
      DO Neutral
      MESSAGES  MSG197
    END RULE 91/17

    RULE 91/18 "If to do, People after organ and tissue transplantation: Message"
      WHEN Recommended
      IF SYNTH:COMMON-SOT-HSCT "COMMON - Solid organ or stem cell transplantation" = true
      DO Neutral
      MESSAGES  MSG198
    END RULE 91/18

    RULE 91/19 "If to do, HIV: Message"
      WHEN Recommended
      IF COND:C24 "HIV infection" = true
      DO Neutral
      MESSAGES  MSG188
    END RULE 91/19

    RULE 91/20 "If to do, Chronic kidney disease: Message"
      WHEN Recommended
      IF SYNTH:COMMON-KIDNEY "COMMON-KIDNEY - Chronic kidney disease" = true
      DO Neutral
      MESSAGES  MSG199
    END RULE 91/20
  END FOLDER 91
END FOLDER 9
END TARGET

MESSAGE MSG186 Other PRO PRIO 0
  "To be done with an adult vaccine (Spikevax JN.1 or Comirnaty JN.1)."@en
 END MESSAGE MSG186

MESSAGE MSG202 Comments ANY PRIO 0
  "COVID-19 vaccine can be administered at any time before or after administration of other vaccines, including ‘live’, inactivated vaccines. An interval of at least 3 months since the last dose of COVID-19 vaccination is recommended."@en
 END MESSAGE MSG202

MESSAGE MSG195 Justification ANY PRIO 0
  "Vaccination should be performed in adults with comorbidities that increase the risk of severe COVID-19, i.e. chronic lung disease."@en
 END MESSAGE MSG195

MESSAGE MSG196 Justification ANY PRIO 0
  "Vaccination should be performed in adults with comorbidities that increase the risk of severe COVID-19, i.e. diabetes mellitus."@en
 END MESSAGE MSG196

MESSAGE MSG193 Justification ANY PRIO 0
  "Vaccination should be performed in adults with comorbidities that increase the risk of severe COVID-19, i.e. active cancer."@en
 END MESSAGE MSG193

MESSAGE MSG51 Alert ANY PRIO 0
  "Warning: allergy - see comments before any vaccine administration."@en
 END MESSAGE MSG51

MESSAGE MSG165 Comments PATIENT PRIO 0
  "An allergy to a previous vaccine administration has been reported. You must clearly inform the healthcare professional before any new vaccination, regardless of the vaccine administered."@en
 END MESSAGE MSG165

MESSAGE MSG166 Comments PRO PRIO 0
  "An allergy to a previous vaccine administration has been reported. Before any new vaccination, carefully check the origin of the previous allergy and adapt the course of action. Seek specialist advice if in doubt."@en
 END MESSAGE MSG166

MESSAGE MSG104 Comments ANY PRIO 0
  "NOTE! It is important to consult a medical doctor before the next  vaccination in case of any allergic reaction."@en
 END MESSAGE MSG104

MESSAGE MSG197 Justification ANY PRIO 0
  "Vaccination should be performed in adults with comorbidities that increase the risk of severe COVID-19, i.e. neurodevelopmental disorders."@en
 END MESSAGE MSG197

MESSAGE MSG199 Justification ANY PRIO 0
  "Vaccination should be performed in adults with comorbidities that increase the risk of severe COVID-19, i.e. chronic kidney disease."@en
 END MESSAGE MSG199

MESSAGE MSG188 Justification ANY PRIO 0
  "Vaccination should be performed in adults with comorbidities that increase the risk of severe COVID-19, i.e. immunosuppressive disease."@en
 END MESSAGE MSG188

MESSAGE MSG189 Justification ANY PRIO 0
  "Vaccination should be performed in adults with comorbidities that increase the risk of severe COVID-19, i.e. obesity (BMI≥25)."@en
 END MESSAGE MSG189

MESSAGE MSG190 Justification ANY PRIO 0
  "Vaccination should be carried out in people at highest risk of a severe COVID-19 course, which include those aged 60 years and older."@en
 END MESSAGE MSG190

MESSAGE MSG198 Justification ANY PRIO 0
  "Vaccination should be performed in adults with comorbidities that increase the risk of severe COVID-19, i.e. immunosuppressive treatment."@en
 END MESSAGE MSG198

MESSAGE MSG48 Other ANY PRIO 10
  "Refund: 100%."@en
 END MESSAGE MSG48

MESSAGE MSG192 Justification ANY PRIO 0
  "The Vaccination Team recommends that the withdrawal period be lifted for persons subject to vaccination against COVID-19 who have tested positive for SARS-CoV-2. A history of COVID-19 is not a contraindication to vaccination. Available data show that people who have been infected with SARS-CoV-2 and subsequently vaccinated develop a strong immunological response, known as ‘hybrid immunity’, which is far superior to that seen with natural infection or vaccination. "@en
 END MESSAGE MSG192

MESSAGE MSG191 Justification ANY PRIO 0
  "COVID-19 vaccine may be administered at any time before or after administration of other vaccines, including vaccines recommended for pregnant women."@en
 END MESSAGE MSG191

MESSAGE MSG201 Justification ANY PRIO 0
  "It is recommended to administer a latest-generation vaccine containing the OMICRON JN.1 valence three months after the last dose of a previous-generation COVID-19 vaccine."@en
 END MESSAGE MSG201

MESSAGE MSG200 Justification ANY PRIO 0
  "A booster dose is not currently recommended, but recommendations may change."@en
 END MESSAGE MSG200

MESSAGE MSG187 Summary ANY PRIO 0
  "Vaccination against COVID-19 is particularly recommended."@en
 END MESSAGE MSG187

MESSAGE MSG194 Justification ANY PRIO 0
  "Vaccination should be performed in adults with comorbidities that increase the risk of severe COVID-19, i.e. cardiovascular disease."@en
 END MESSAGE MSG194
