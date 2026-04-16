CALC VZV_doses_received IS HIST(VZV-LA,0,count)
CALC VZV_last_dose_date IS HIST(VZV-LA,-1,date)


SYNTH F13-50 "AGE-SEXE 13-50 ans et femme" IS ALL OF
  CALC:Age in 13y..50y
  BASE:sex = f

SYNTH DATE-APPLI-REGLE-2 "DATE-APPLI-REGLE 2" IS ALL OF 
  BASE:eval>=2020-01-01

SYNTH PREGNANCY_ONGOING "COMMON-PREGNANCY - Pregnancy in progress" IS ALL OF
  COND:C52 "Pregnancy - Date of last period" in 1d..41w
  SYNTH:PREGNANCY_OVER "COMMON-PREGNANCY - Pregnancy over" = false

SYNTH PREGNANCY_OVER "COMMON-PREGNANCY - Pregnancy over" IS ANY OF
  COND:C52 "Pregnancy - Date of last period">=42w
  COND:C1032 "Date of delivery">=0d

SYNTH COMMON-RF-ID "COMMON-RF-ID - ID risk factors contraindicating vaccination with live vaccines" IS ANY OF
  COND:C917 "Strong immunosuppressive treatment (covid)" = true
  COND:C932 "Date of a solid organ transplant (kidney, heart, liver or lungs)">=1d
  COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)">=1d
  COND:C578 "Ongoing chemotherapy for solid tumor (cancer)" = true
  COND:C594 "Ongoing chemotherapy for hematological malignancy (leukemia)" = true
  COND:C579 "Biotherapy leading to immunosuppression" = true
  COND:C413 "Other immunosuppressive therapy" = true
  COND:C1231 "Immunocompromised person" = true

Synth VAR-HIST "History of chickenpox" IS ANY OF
  COND:C145 "History of chickenpox" = true
  COND:C158 "Positive chickenpox serology" = true
  
SYNTH VAR-RF "Risk factors for chicken pox" IS ANY OF
  COND:C147 "Immunocompromised person in the entourage" = true
  COND:C90 "Works in a social institution or service contributing to child protection" = true
  COND:C273 "Works in a maternity hospital" = true
  COND:C56 "Physician" = true
  COND:C62 "Nurse" = true
  CALC:Age >= 12y
  COND:C19 "Waiting for an organ transplant (kidney, heart, liver or lung)" = true
  COND:C835 "Pending initiation of therapy that affects immunity" = true

TARGET Chickenpox
FOLDER - "General rules"

  RULE 01 "rejouer"
    IF CALC:Age>=1d
    DO Neutral
    MESSAGES  MSG346
  END RULE 01
END FOLDER -

FOLDER 1 "History of chickenpox +"
  IF SYNTH:VAR-HIST "History of chickenpox" = true

  RULE 1/1 "ATCD+ : AJ par immunité acquise"
    IF ALL OF
      CALC:Age>=1w
      CALC:VZV_doses_received>=0
    DO Recommended
      Status COMPLETED
    MESSAGES  MSG254 MSG255
  END RULE 1/1
END FOLDER 1

FOLDER 2 "History of chickenpox -"
  IF SYNTH:VAR-HIST "History of chickenpox" = false

  FOLDER 21 "Zero dose"
    IF CALC:VZV_doses_received = 0

    FOLDER 211 "[6-23m] old"
      IF CALC:Age in 6m..23m

      RULE 211/1 "[6-23m] old, 0 dose: Possible from 13-18m old, 4w after MMR vaccine"
        IF CALC:Age in 6m..23m
        DO Suggested
        MESSAGES  MSG265 MSG266 MSG267
      END RULE 211/1
    END FOLDER 211

    FOLDER 212 "≥ 12y old and RF+"
      IF ALL OF
      CALC:Age>=12y
      SYNTH:VAR-RF = true

      RULE 212/1 "≥ 12y old, 0 dose, RF+, sero not done: To do chickenpox serology"
        IF ALL OF
          COND:C46 "Negative chickenpox serology" = false
          COND:C624 "Refusal to vaccinate against chickenpox" = false
          COND:C1019 "Contraindication to chickenpox vaccination" = false
        DO Exception
        MESSAGES  MSG260
      END RULE 212/1

      RULE 212/2 "≥ 12y old, 0 dose, RF+, Serology-: To do from 12y old"
        IF COND:C46 "Negative chickenpox serology" = true
        DO Recommended
          Status DUE
          Age 12y
      END RULE 212/2
    END FOLDER 212
  END FOLDER 21

  FOLDER 22 "One dose"
    IF CALC:VZV_doses_received = 1

    RULE 22/1 "1 dose: To do 4w after LD"
      IF CALC:VZV_doses_received = 1
      DO Recommended
        Status DUE
        Delay 4w from CALC:VZV_last_dose_date
    END RULE 22/1
  END FOLDER 22

  FOLDER 23 "Two doses or more"
    IF CALC:VZV_doses_received>=2

    RULE 23/1 "2 doses: Up to date"
      IF CALC:VZV_doses_received>=2
      DO Recommended
        Status COMPLETED
    END RULE 23/1
  END FOLDER 23
END FOLDER 2

FOLDER 8 "Contraindications and special cases"

  RULE 8/01 "Pregnancy in progress: Contraindicate"
    IF SYNTH:PREGNANCY_ONGOING "COMMON-PREGNANCY - Pregnancy in progress" = true
    DO Contraindicated
    MESSAGES  MSG16 MSG17
  END RULE 8/01

  RULE 8/02 "ID: Contraindicate"
    IF SYNTH:COMMON-RF-ID "COMMON-RF-ID - ID risk factors contraindicating vaccination with live vaccines" = true
    DO Contraindicated
    MESSAGES  MSG34 MSG35
  END RULE 8/02

  RULE 8/03 "Case « Contraindication to chicken pox » checked: Contraindication + message"
    IF ALL OF
      COND:C1019 "Contraindication to chickenpox vaccination" = true
      SYNTH:DATE-APPLI-REGLE-2 "DATE-APPLI-REGLE 2" = true
    DO Contraindicated
    MESSAGES  MSG14 MSG15
  END RULE 8/03

  RULE 8/04 "Case  « Refusal to vaccinate against this disease » checked: Special case + message"
    IF COND:C624 "Refusal to vaccinate against chickenpox" = true
    DO Exception
    MESSAGES  MSG6 MSG7
  END RULE 8/04
END FOLDER 8

FOLDER 9 "Further information"
  IF SYNTH:VAR-HIST = false

  RULE 9/01 "Justification reco vaccinale chez personnes avec traitement affectant l'immunité en attente"
    IF ALL OF
      COND:C835 "Pending initiation of therapy that affects immunity" = true
      CALC:VZV_doses_received<=1
    DO Neutral
    MESSAGES  MSG257
  END RULE 9/01

  RULE 9/02 "Justification reco vaccinale pour un patient en attente de transplantation d'organe"
    IF ALL OF
      COND:C19 "Waiting for an organ transplant (kidney, heart, liver or lung)" = true
      CALC:VZV_doses_received<=1
    DO Neutral
    MESSAGES  MSG252
  END RULE 9/02

  RULE 9/03 "Ado éligible à la vaccination"
    IF ALL OF
      CALC:Age in 12y..17y
      CALC:VZV_doses_received<=1
    DO Neutral
    MESSAGES  MSG264
  END RULE 9/03

  RULE 9/04 "Femme en âge d'avoir des enfants éligible à la vaccination"
    IF ALL OF
      SYNTH:F13-50 "AGE-SEXE 13-50 ans et femme" = true
      CALC:VZV_doses_received<=1
    DO Neutral
    MESSAGES  MSG256
  END RULE 9/04

  RULE 9/05 "Personne immunodéprimée dans l'entourage"
    IF ALL OF
      COND:C47 "Immunocompromised person in the entourage" = true
      CALC:VZV_doses_received<=1
    DO Neutral
    MESSAGES  MSG248
  END RULE 9/05
END FOLDER 9
END TARGET

MESSAGE MSG254 Justification ANY PRIO 0
  "When a person has chickenpox, they develop protective antibodies against the disease. As a result, the person is protected and vaccination is not necessary."@en
 END MESSAGE MSG254

MESSAGE MSG255 Summary ANY PRIO 0
  "Immunity acquired through disease."@en
 END MESSAGE MSG255

MESSAGE MSG6 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG6

MESSAGE MSG7 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been checked in the health profile (section “Refusal of vaccination”)."@en
 END MESSAGE MSG7

MESSAGE MSG257 Summary ANY PRIO 0
  "Vaccination is recommended for people awaiting treatment affecting immunity in order to:
- prevent the onset of a more serious form of the disease in the event of immunodeficiency;
- protect the person as long as they are immunocompetent, vaccination being contraindicated in the event of immunodeficiency, because the varicella vaccine is a live attenuated vaccine."@en
 END MESSAGE MSG257

MESSAGE MSG252 Justification ANY PRIO 0
  "Vaccination is recommended for people waiting for an organ transplant to:
- prevent the occurrence of a more severe form of the disease after transplantation;
- protect the person as long as they are immunocompetent; vaccination will then be contraindicated because transplant recipients receive immunosuppressive treatment. The varicella vaccine is a live attenuated vaccine, but live vaccines are contraindicated in cases of immunodeficiency."@en
 END MESSAGE MSG252

MESSAGE MSG256 Justification ANY PRIO 0
  "Vaccination is recommended for women of childbearing age with no history of chickenpox to prevent severe chickenpox in the fetus or newborn."@en
 END MESSAGE MSG256

MESSAGE MSG248 Justification ANY PRIO 0
  "In the absence of a history of chickenpox, vaccination is recommended to protect an immunocompromised person in the entourage, vaccination being contraindicated in cases of immunodeficiency."@en
 END MESSAGE MSG248

MESSAGE MSG14 Alert ANY PRIO 0
  "Vaccination contraindicated by the doctor."@en
 END MESSAGE MSG14

MESSAGE MSG15 Justification ANY PRIO 0
  "The box indicating a contraindication for this disease has been checked in the health profile (section “Contraindicated vaccinations”)."@en
 END MESSAGE MSG15

MESSAGE MSG260 Alert ANY PRIO 0
  "Do a chickenpox serology test: vaccination is recommended if it is negative."@en
 END MESSAGE MSG260

MESSAGE MSG16 Justification ANY PRIO 0
  "Pregnancy temporarily contraindicates the use of live virus vaccines, such as measles, rubella, mumps, varicella, or yellow fever vaccines."@en
 END MESSAGE MSG16

MESSAGE MSG17 Alert ANY PRIO 0
  "Pregnancy temporarily contraindicates the use of live virus vaccines."@en
 END MESSAGE MSG17

MESSAGE MSG264 Justification ANY PRIO 0
  "Vaccination is recommended for adolescents aged 12 to 17 years inclusive with no history of chickenpox, because severe forms of chickenpox are more common in adolescents and adults than in children."@en
 END MESSAGE MSG264

MESSAGE MSG34 Justification ANY PRIO 0
  "Immunodeficiency contraindicates the use of live virus vaccines, such as measles, mumps, rubella, varicella or yellow fever vaccines."@en
 END MESSAGE MSG34

MESSAGE MSG35 Alert ANY PRIO 0
  "Immunodeficiency contraindicates the use of live virus vaccines."@en
 END MESSAGE MSG35

MESSAGE MSG265 Summary ANY PRIO 0
  "To be done between 13 and 8 months, after consulting a doctor."@en
 END MESSAGE MSG265

MESSAGE MSG266 Comments PRO PRIO 0
  "If the doctor decides to vaccinate against varicella on an individual level, a two-dose vaccination is recommended. Given that vaccination with the combined MMRV vaccine is associated with an increased incidence of febrile convulsions in children aged 12 to 23 months, the use of the monovalent vaccine is recommended for the first dose in children who have not yet had varicella.<br>
This vaccine should only be administered if the MMR vaccine has already been administered (while respecting an
interval of at least 4 weeks after the MMR vaccination). The recommended age for the first dose is then between 13 and 18 months, the second dose of the varicella vaccine will be administered after an interval of at least 4 weeks."@en
 END MESSAGE MSG266

MESSAGE MSG267 Comments PATIENT PRIO 0
  "If the doctor decides to vaccinate against varicella on an individual level, a two-dose vaccination is recommended for children who have not yet had varicella.<br>
This vaccine should only be administered if the MMR vaccine has already been administered (while respecting an interval of at least 4 weeks after the MMR vaccination). The recommended age for the first dose is then between 13 and 18 months, the second dose of the varicella vaccine will be administered after an interval of at least 4 weeks."@en
 END MESSAGE MSG267

MESSAGE MSG346 Details PATIENT PRIO 0
  "--"@en
 END MESSAGE MSG346
