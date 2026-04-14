CALC Rota_doses_received IS HIST(ROTA-LA,0,count)

CALC Rota_first_vaccine IS HIST(ROTA-LA,1,vaccine)

CALC Rota_last_dose_date IS HIST(ROTA-LA,-1,date)
CALC Rota_age_at_last_dose IS INTERVAL(BASE:dob,CALC:Rota_last_dose_date)

CALC Rota_d1d2 IS INTERVAL(HIST(ROTA-LA,1,date),HIST(ROTA-LA,2,date))
CALC Rota_d2d3 IS INTERVAL(HIST(ROTA-LA,2,date),HIST(ROTA-LA,3,date))

TARGET Rotavirus

FOLDER 1 "Zero dose"
  IF CALC:Rota_doses_received = 0

  RULE 1/01 "0 dose, [15d-12w] old: To do from 2m with ROTARIX or ROTATEQ"
    IF ALL OF
      CALC:Age in 15d..12w
      CALC:Rota_doses_received = 0
    DO Recommended
      Status DUE
      Age 2m
    MESSAGES  MSG57
  END RULE 1/01

  RULE 1/02 "0 dose, [13w-19w] old: AF ASAP with ROTARIX"
    IF ALL OF
      CALC:Age in 13w..19w
      CALC:Rota_doses_received = 0
    DO Recommended
      Status DUE
      Age 2m
    MESSAGES  MSG58 MSG59
  END RULE 1/02

  RULE 1/03 "0 dose, [20w-7m] old: Too late !"
    IF ALL OF
      CALC:Age in 20w..7m
      CALC:Rota_doses_received = 0
    DO Neutral
    MESSAGES  MSG60 MSG61
  END RULE 1/03
END FOLDER 1

FOLDER 2 "One dose"
  IF CALC:Rota_doses_received = 1

  FOLDER 21 "ROTARIX"
    IF CALC:Rota_first_vaccine = VAC0514 #ROTARIX

    RULE 21/01 "1 dose  ROTARIX, ≤ 23w old, d1≤ 19w old: To do with ROTARIX from 4m old and 4w après after LD"
      IF ALL OF
        CALC:Age<=23w
        CALC:Rota_age_at_last_dose<=19w
      DO Recommended
        Status DUE
        Age 4m
        Delay 4w from CALC:Rota_last_dose_date
      MESSAGES  MSG36 MSG44
    END RULE 21/01

    RULE 21/02 "1 dose  ROTARIX, ≥ 24w old: Too late !"
      IF CALC:Age>=24w
      DO Exception
      MESSAGES  MSG53
    END RULE 21/02
  END FOLDER 21

  FOLDER 22 "ROTATEC"
    IF CALC:Rota_first_vaccine = VAC0031 #ROTATEQ

    RULE 22/01 "1 dose  ROTAREQ, ≤ 28w old, d1 ≤ 12w old: To do ROTATEC  from 4m and 4w after LD"
      IF ALL OF
        CALC:Age<=28w
        CALC:Rota_age_at_last_dose<=12w
      DO Recommended
        Status DUE
        Age 4m
        Delay 4w from CALC:Rota_last_dose_date
      MESSAGES  MSG49 MSG36
    END RULE 22/01

    RULE 22/02 "1 dose  ROTATEC, ≥ 29w old: Too late !"
      IF CALC:Age>=29w
      DO Exception
      MESSAGES  MSG53
    END RULE 22/02
  END FOLDER 22
END FOLDER 2

FOLDER 3 "Two doses"
  IF CALC:Rota_doses_received = 2

  FOLDER 31 "ROTARIX"
    IF CALC:Rota_first_vaccine = VAC0514 #ROTARIX


    RULE 31/01 "2 doses ROTARIX: Up to date"
      IF CALC:Age>=2m
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG5
    END RULE 31/01
  END FOLDER 31

  FOLDER 32 "ROTATEC"
    IF CALC:Rota_first_vaccine = VAC0031 #ROTATEQ

    RULE 32/01 "2 doses ROTATEQ, ≤ 32w old, dd ≤ 28w old: To do with ROTATEC from 6m and 4w after LD"
      IF ALL OF
        CALC:Age<=32w
        CALC:Rota_age_at_last_dose<=28w
      DO Recommended
        Status DUE
        Age 6m
        Delay 4w from CALC:Rota_last_dose_date
      MESSAGES  MSG36
    END RULE 32/01

    RULE 32/02 "2 doses ROTATEQ, ≥ 33w old: Too late !"
      IF CALC:Age<=33w
      DO Exception
      MESSAGES  MSG54
    END RULE 32/02
  END FOLDER 32
END FOLDER 3

FOLDER 4 "Three doses and more"
  IF CALC:Rota_doses_received>=3

  RULE 4/01 "≥ 3 doses: Up to date"
    IF ALL OF
      CALC:Age>=2m
      CALC:Rota_doses_received>=3
    DO Recommended
      Status COMPLETED
    MESSAGES  MSG5
  END RULE 4/01
END FOLDER 4

FOLDER 8 "Contraindications and special cases"

  FOLDER 81 "Contraindications"
  END FOLDER 81

  FOLDER 82 "Special cases"

    RULE 82/01 "≤5y old, Case  « Refusal to vaccinate against this disease » checked: Special case + message"
      IF ALL OF
        COND:C1025 "Refusal of rotavirus vaccination" = true
        CALC:Age<=5y
      DO Exception
      MESSAGES  MSG19 MSG20
    END RULE 82/01
  END FOLDER 82
END FOLDER 8

FOLDER 9 "Further information"

  RULE 9/01 "[2-6m] old, If to do: Mandatory vaccination"
    WHEN Recommended
    IF ALL OF
      CALC:Age in 2m..6m
      CALC:Rota_doses_received = 0
    DO Neutral
    MESSAGES  MSG69
  END RULE 9/01

  RULE 9/02 "If To do: Information on contraindications"
    WHEN Recommended
    IF CALC:Age>15d
    DO Neutral
    MESSAGES  MSG45
  END RULE 9/02

  RULE 9/03 "d1d2 ≤ 2w: information message about d1d2 interval not respected"
    IF CALC:Rota_d1d2<=2w
    DO Neutral
    MESSAGES  MSG55
  END RULE 9/03

  RULE 9/04 "d2d3 ≤ 2w: information message about d2d3 interval not respected"
    IF CALC:Rota_d2d3<=2w
    DO Neutral
    MESSAGES  MSG56
  END RULE 9/04

  RULE 9/05 "If To do, d1 = ROTARIX: Continue with ROTARIX"
    WHEN Recommended
    IF CALC:Rota_first_vaccine = VAC0514 #ROTARIX
    DO Neutral
    MESSAGES  MSG62
  END RULE 9/05

  RULE 9/06 "If To do, d1 = ROTATEQ: Continue with ROTATEQ"
    WHEN Recommended
    IF CALC:Rota_first_vaccine = VAC0031# ROTATEQ
    DO Neutral
    MESSAGES  MSG63
  END RULE 9/06
END FOLDER 9
END TARGET

MESSAGE MSG63 Comments ANY PRIO 0
  "Vaccination started with ROTATEQ must be continued with ROTATEQ."@en
 END MESSAGE MSG63

MESSAGE MSG36 Justification ANY PRIO 0
  "The interval between doses should be at least 4 weeks."@en
 END MESSAGE MSG36

MESSAGE MSG44 Summary ANY PRIO 0
  "Continue with Rotarix vaccine."@en
 END MESSAGE MSG44

MESSAGE MSG19 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG19

MESSAGE MSG20 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been ticked in the health profile (‘Refusal of vaccination’ section)."@en
 END MESSAGE MSG20

MESSAGE MSG57 Comments ANY PRIO 0
  "To be administered with ROTARIX or ROTATEC vaccine."@en
 END MESSAGE MSG57

MESSAGE MSG56 Alert ANY PRIO 0
  "The interval between the 2nd and 3rd doses was not respected."@en
 END MESSAGE MSG56

MESSAGE MSG45 Comments ANY PRIO 0
  "Vaccination is contraindicated in the following cases: immunodeficiency, congenital digestive anomaly at risk of intussusception or history of intussusception, concomitant febrile illness (which is a temporary contraindication)."@en
 END MESSAGE MSG45

MESSAGE MSG5 Summary ANY PRIO 0
  "Vaccination schedule completed."@en
 END MESSAGE MSG5

MESSAGE MSG62 Comments ANY PRIO 0
  "Vaccination started with ROTARIX must be continued with ROTARIX."@en
 END MESSAGE MSG62

MESSAGE MSG53 Summary ANY PRIO 0
  "It is too late to administer a 2nd dose."@en
 END MESSAGE MSG53

MESSAGE MSG58 Comments ANY PRIO 0
  "To be administered with the ROTARIX vaccine."@en
 END MESSAGE MSG58

MESSAGE MSG59 Justification ANY PRIO 0
  "The ROTATEC vaccine can be used as the first dose only up to 12 weeks of age. Therefore, the ROTARIX vaccine must be used in 2 doses."@en
 END MESSAGE MSG59

MESSAGE MSG69 Summary ANY PRIO 0
  "This vaccination is compulsory in Latvia, from the age of 2 months."@en
 END MESSAGE MSG69

MESSAGE MSG49 Summary ANY PRIO 0
  "Continue with the Rotateq vaccine."@en
 END MESSAGE MSG49

MESSAGE MSG60 Summary ANY PRIO 0
  "It is too late to administer a first dose."@en
 END MESSAGE MSG60

MESSAGE MSG61 Justification ANY PRIO 0
  "The ROTATEC vaccine can only be administered as a 1st dose up to 12 weeks of age.
And vaccination with the ROTARIX vaccine must be completed before the 24th week of age. The 1st dose must therefore be administered before the 20th week (minimum interval of 4 weeks between 2 doses)."@en
 END MESSAGE MSG61

MESSAGE MSG54 Summary ANY PRIO 0
  "It is too late to administer the 3rd dose."@en
 END MESSAGE MSG54

MESSAGE MSG55 Alert ANY PRIO 0
  "The interval between the 1st and 2nd doses was not respected."@en
 END MESSAGE MSG55
