CALC T_doses_received IS HIST(T,0,count)
CALC T_last_dose_is_booster IS HIST(T,-1,booster)
CALC T_last_dose_date IS HIST(T,-1,date)
CALC T_age_at_last_dose IS INTERVAL(BASE:dob,CALC:T_last_dose_date)
CALC T_time_since_last_act IS INTERVAL(CALC:T_last_dose_date,BASE:eval)

TARGET Tetanus

FOLDER 1 "18y old or more - Pregnancy -, Skin lesion -"
  IF ALL OF
  CALC:Age>=18y
  SYNTH:PREGNANCY_ONGOING "MATERNITY-PREGNANCY - Pregnancy in progress" = false
  COND:C1173 "Skin lesions that may expose you to the risk of tetanus" = false

  FOLDER 10 "Zero dose"
    IF CALC:T_doses_received = 0

    RULE 10/1 "0 dose, 18y old: To do ASAP"
      IF CALC:Age<=18y
      DO Recommended
        Status DUE
        Age 18y
    END RULE 10/1

    RULE 10/2 "0 dose, ≥19y old, RF-: recommended"
      IF ALL OF
        CALC:Age>=19y
        SYNTH:DIPH-RF "DIPH-RF - Risk factor for diphtéria" = false
      DO Recommended
        Status DUE
        Age 18y
      MESSAGES  MSG164
    END RULE 10/2

    RULE 10/3 "0 dose, ≥19y old, RF+: To do ASAP"
      IF ALL OF
        CALC:Age>=19y
        SYNTH:DIPH-RF "DIPH-RF - Risk factor for diphtéria" = true
      DO Recommended
        Status DUE
        Age 19y
    END RULE 10/3
  END FOLDER 10

  FOLDER 11 "≤ 2 doses and LD is not a booster"
    IF ALL OF
    CALC:T_doses_received<=2
    CALC:T_last_dose_is_booster = false

    RULE 11/01 "One dose: to do 2m after LD"
      IF CALC:T_doses_received = 1
      DO Recommended
        Status DUE
    END RULE 11/01

    RULE 11/02 "Two doses: to do 6m after LD"
      IF CALC:T_doses_received = 2
      DO Recommended
        Status DUE
        Delay 6m from CALC:T_last_dose_date
    END RULE 11/02
  END FOLDER 11

  FOLDER 12 "Three doses or more or LD is a booster"
    IF ANY OF
    CALC:T_doses_received>=3
    CALC:T_last_dose_is_booster = true

    RULE 12/01 "≥ 3 doses or LD is booster, LD ≤ 17y old: to do from 18y, 4y after LD"
      IF ALL OF
        CALC:Age>=18y
        CALC:T_age_at_last_dose<=17y
      DO Recommended
        Status DUE
        Age 18y
        Delay 4y from CALC:T_last_dose_date
      MESSAGES  MSG299
    END RULE 12/01

    RULE 12/02 "≥ 3 doses or LD is booster, LD ≥ 18y old: to do in 10 years"
      IF ALL OF
        CALC:Age>=18y
        CALC:T_age_at_last_dose>=18y
      DO Recommended
        Status DUE
        Delay 10y from CALC:T_last_dose_date
      MESSAGES  MSG156
    END RULE 12/02
  END FOLDER 12
END FOLDER 1

FOLDER 2 "Pregnancy +"
  IF SYNTH:PREGNANCY_ONGOING "MATERNITY-PREGNANCY - Pregnancy in progress" = true

  RULE 2/01 "0 dose, Pregnancy in progress: To do between 27 and 36w"
    IF CALC:Age>=18y
    DO Recommended
      Status DUE
      Age 18y
      Delay 27w..36w from COND:C1081 "Pregnancy start date"
  END RULE 2/01
END FOLDER 2

FOLDER 3 "Skin lesion +"
  IF COND:C1173 "Skin lesions that may expose you to the risk of tetanus" = true

  RULE 3/01 "Skin lesion, 0 dose OR LD ≥ 5y: to do ASAP (Excel file 06)"
    IF ANY OF
      CALC:T_time_since_last_act>=5y
      CALC:T_doses_received = 0
    DO Recommended
      Status OVERDUE
    MESSAGES  MSG48
  END RULE 3/01
END FOLDER 3

FOLDER 9 "Further information"

  RULE 9/01 "If to do, Mandatory vaccination, 18y old: Information"
    WHEN Recommended
    IF CALC:Age = 18y
    DO Neutral
    MESSAGES  MSG155 MSG300
  END RULE 9/01

  RULE 9/02 "If to do, Mandatory vaccination, RF+, ≥ 19y old: Information"
    WHEN Recommended
    IF ALL OF
      SYNTH:DIPH-MANDATORY "DIPH-MANDATORY - Mandatory vaccination for of diphteria" = true
      CALC:Age>=19y
    DO Neutral
    MESSAGES  MSG155 MSG301
  END RULE 9/02

  RULE 9/03 "If to do, 18y old: Information about refund 100%,"
    WHEN Recommended
    IF CALC:Age = 18y
    DO Neutral
    MESSAGES  MSG302
  END RULE 9/03

  RULE 9/04 "If to do, Refund 100%, ≥19y old: Information"
    WHEN Recommended
    IF ALL OF
      SYNTH:DIPH-REFUND "DIPH-REFUND - Refund: 100%" = true
      CALC:Age>=19y
    DO Neutral
    MESSAGES  MSG48
  END RULE 9/04

  RULE 9/05 "If to do: Document"
    WHEN Recommended
    IF CALC:Age>=18y
    DO Neutral
  END RULE 9/05

  FOLDER 91 "Excel files"

    RULE 91/05 "If to do, Pregnancy: Information"
      WHEN Recommended
      IF SYNTH:PREGNANCY_ONGOING "MATERNITY-PREGNANCY - Pregnancy in progress" = true
      DO Neutral
      MESSAGES  MSG154
    END RULE 91/05

    RULE 91/06 "If to do, Skin lesions that may expose you to the risk of tetanus: Information"
      WHEN Recommended
      IF COND:C1173 "Skin lesions that may expose you to the risk of tetanus" = true
      DO Neutral
      MESSAGES  MSG163 MSG303
    END RULE 91/06

    RULE 91/07 "If to do, Allergy from a previous vaccination: Information"
      WHEN Recommended
      IF COND:C1161 "Allergy from a previous vaccine administration" = true
      DO Neutral
      MESSAGES  MSG51 MSG165 MSG166 MSG122
    END RULE 91/07

    RULE 91/09 "If to do, Before transplantation of internal organs, haematopoietic cells: Information"
      WHEN Recommended
      IF SYNTH:COMMON-WAIT-TRANSPLANT "COMMON - Waiting for a transplant" = true
      DO Neutral
      MESSAGES  MSG152
    END RULE 91/09

    RULE 91/09 "If to do, After transplantation of internal organs, haematopoietic cells: Information"
      WHEN Recommended
      IF SYNTH:COMMON-SOT-HSCT "COMMON - Solid organ or stem cell transplantation" = true
      DO Neutral
      MESSAGES  MSG153
    END RULE 91/09

    RULE 91/10 "If to do, Spleen removal or non-functioning : Information"
      WHEN Recommended
      IF COND:C36 "Spleen removal or non-functioning" = true
      DO Neutral
      MESSAGES  MSG167
    END RULE 91/10

    RULE 91/13 "If to do, Close and prolonged contact with an infant under 12 months of age: Information"
      WHEN Recommended
      IF COND:C1180 "Close and prolonged contact with an infant under 12 months of age" = true
      DO Neutral
      MESSAGES  MSG158
    END RULE 91/13

    RULE 91/16 "If to do, Medical staff: Information"
      WHEN Recommended
      IF SYNTH:COMMON-MED-STAFF "COMMON-MED-STAFF - Medical staff" = true
      DO Neutral
      MESSAGES  MSG157
    END RULE 91/16

    RULE 91/17 "If to do, Medical personnel in contact with newborns and infants: Information"
      WHEN Recommended
      IF COND:C1121 "Close professional contact with an infant under 6 months of age" = true
      DO Neutral
      MESSAGES  MSG159
    END RULE 91/17
  END FOLDER 91
END FOLDER 9
END TARGET

MESSAGE MSG159 Justification ANY PRIO 0
  "In view of the epidemiological rationale, diphtheria and tetanus vaccination is recommended for healthcare personnel, especially those in contact with newborns and infants. Vaccination against diphtheria, tetanus, pertussis with a diphtheria-tetanus-pertussis vaccine with a reduced pertussis component (Tdap or Tdap-IPV)."@en
 END MESSAGE MSG159

MESSAGE MSG157 Justification ANY PRIO 0
  "In view of the epidemiological rationale, diphtheria and tetanus vaccination is recommended for medical personnel. 
Vaccination against diphtheria, tetanus, pertussis with diphtheria-tetanus-pertussis vaccine with reduced pertussis component (Tdap or Tdap-IPV)."@en
 END MESSAGE MSG157

MESSAGE MSG163 Justification ANY PRIO 0
  "The obligation applies to injured persons at risk of tetanus infection if the last dose of primary or booster vaccination was given more than 5 years ago.<br>
With a monovalent tetanus (T) or combined diphtheria, tetanus (Td) vaccine or a diphtheria, tetanus, pertussis vaccine with a reduced pertussis component containing the cell-free pertussis component Tdap - for persons subject to mandatory pertussis vaccination."@en
 END MESSAGE MSG163

MESSAGE MSG303 Alert ANY PRIO 0
  "To be done without delay."@en
 END MESSAGE MSG303

MESSAGE MSG158 Justification ANY PRIO 0
  "In view of the epidemiological rationale, diphtheria, tetanus and pertusis vaccination is recommended for those around newborns and infants up to 12 months of age. Vaccination against diphtheria, tetanus, pertussis with diphtheria-tetanus-pertussis vaccine with reduced pertussis component (Tdap or Tdap-IPV)."@en
 END MESSAGE MSG158

MESSAGE MSG302 Other ANY PRIO 0
  "Reimbursement:<br>
- 100% for diphtheria and tetanus (Td).<br>
- 0% for diphtheria, tetanus and whooping cough (Tdap)."@en
 END MESSAGE MSG302

MESSAGE MSG164 Justification ANY PRIO 0
  "Vaccination is recommended for all adults."@en
 END MESSAGE MSG164

MESSAGE MSG152 Justification ANY PRIO 0
  "People who are to receive an internal organ or hematopoietic stem cell transplant are subject to mandatory vaccination against diphtheria, tetanus and pertussis."@en
 END MESSAGE MSG152

MESSAGE MSG156 Justification ANY PRIO 0
  "It is recommended that adults who have been vaccinated for the first time receive a single booster dose every 10 years.
Vaccination against diphtheria, tetanus, polio and pertussis with the diphtheria-tetanus-pertussis vaccine with reduced pertussis component (Tdap or Tdap-IPV)."@en
 END MESSAGE MSG156

MESSAGE MSG167 Justification ANY PRIO 0
  "People with asplenia, splenic dysfunction or splenic removal are subject to mandatory vaccination against diphtheria, tetanus, pertusis and polio."@en
 END MESSAGE MSG167

MESSAGE MSG154 Justification ANY PRIO 0
  "For epidemiological reasons, vaccination against this disease is recommended for pregnant women after the 27th to 36th week of pregnancy and, in justified cases of risk of preterm birth, after the 20th week of pregnancy, in a single-dose schedule, as a recommended vaccination for which the purchase of vaccines has been covered by funding from the Minister of health.<br>
Vaccination against diphtheria, tetanus, pertussis with diphtheria-tetanus-pertussis vaccine with reduced pertussis component (Tdap or Tdap-IPV)."@en
 END MESSAGE MSG154

MESSAGE MSG155 Details ANY PRIO 0
  "Vaccination against diphtheria and tetanus is mandatory for: <br>
- children and adolescents up to and including the age of 18; <br>
- people with asplenia or with a dysfunction or removal of the spleen; <br>
- people before or after a solid organ or hematopoietic stem cell transplant; <br>
- people who have close contact (family, professional, etc.) with a patient suffering from diphtheria."@en
 END MESSAGE MSG155

MESSAGE MSG301 Alert ANY PRIO 0
  "Mandatory vaccination up to the age of 18 or in the presence of certain risk factors for diphtheria and tetanus."@en
 END MESSAGE MSG301

MESSAGE MSG299 Justification ANY PRIO 0
  "A booster vaccination against diphtheria and tetanus (Td) is compulsory at the age of 18. This vaccine is fully reimbursed. It is recommended that the vaccination against whooping cough (Tdap) be combined, but this combination is not reimbursed."@en
 END MESSAGE MSG299

MESSAGE MSG300 Alert ANY PRIO 0
  "Compulsory vaccination up to the age of 18 for diphtheria and tetanus."@en
 END MESSAGE MSG300

MESSAGE MSG48 Other ANY PRIO 10
  "Refund: 100%."@en
 END MESSAGE MSG48

MESSAGE MSG51 Alert ANY PRIO 0
  "Warning: allergy - see comments before any vaccine administration."@en
 END MESSAGE MSG51

MESSAGE MSG165 Comments PATIENT PRIO 0
  "An allergy to a previous vaccine administration has been reported. You must clearly inform the healthcare professional before any new vaccination, regardless of the vaccine administered."@en
 END MESSAGE MSG165

MESSAGE MSG166 Comments PRO PRIO 0
  "An allergy to a previous vaccine administration has been reported. Before any new vaccination, carefully check the origin of the previous allergy and adapt the course of action. Seek specialist advice if in doubt."@en
 END MESSAGE MSG166

MESSAGE MSG122 Comments ANY PRIO 10
  "NOTE! Hypersensitivity to the active substances or to any of the excipients listed and to any ingredient that may be present in trace amounts."@en
 END MESSAGE MSG122

MESSAGE MSG153 Justification ANY PRIO 0
  "Individuals who have undergone hematopoietic stem cell or internal organ transplantation are required to be vaccinated against diphtheria, tetanus, pertussis, and polio. Post-transplant patients should consult their physician to determine an appropriate vaccination schedule, taking into account their medical condition and immunosuppressive therapy."@en
 END MESSAGE MSG153
