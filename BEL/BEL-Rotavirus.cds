CALC Rota_doses_received IS HIST(ROTA-LA,0,count)
CALC Rota_vaccines_received IS HIST(ROTA-LA,0,vaccine)

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
    MESSAGES  MSG65
  END RULE 1/01

  RULE 1/02 "0 dose, [13w-19w] old: AF ASAP with ROTARIX"
    IF ALL OF
      CALC:Age in 13w..19w
      CALC:Rota_doses_received = 0
    DO Recommended
      Status DUE
      Age 2m
    MESSAGES  MSG70 MSG71
  END RULE 1/02

  RULE 1/03 "0 dose, [20w-7m] old: Too late !"
    IF ALL OF
      CALC:Age in 20w..7m
      CALC:Rota_doses_received = 0
    DO Neutral
    MESSAGES  MSG75 MSG76
  END RULE 1/03
END FOLDER 1

FOLDER 2 "One dose"
  IF CALC:Rota_doses_received = 1

  FOLDER 21 "ROTARIX"
    IF CALC:Rota_first_vaccine = VAC0514# ROTARIX

    RULE 21/01 "1 dose  ROTARIX, ≤ 23w old, d1≤ 19w old: To do with ROTARIX from 3m old and 4w après ddafter LD"
      IF ALL OF
        CALC:Age<=23w
        CALC:Rota_age_at_last_dose<=19w
      DO Recommended
        Status DUE
        Age 3m
        Delay 4w from CALC:Rota_last_dose_date
      MESSAGES  MSG63 MSG64
    END RULE 21/01

    RULE 21/02 "1 dose  ROTARIX, [24w-6m] old: Too late !"
      IF CALC:Age in 24w..6m
      DO Exception
      MESSAGES  MSG69
    END RULE 21/02
  END FOLDER 21

  FOLDER 22 "ROTATEC"
    IF CALC:Rota_first_vaccine = VAC0031# ROTATEQ

    RULE 22/01 "1 dose  ROTAREQ, ≤ 28w old, d1 ≤ 12w old: To do ROTATEC  from 3m and 4w after LD"
      IF ALL OF
        CALC:Age<=28w
        CALC:Rota_age_at_last_dose<=12w
      DO Recommended
        Status DUE
        Age 3m
        Delay 4w from CALC:Rota_last_dose_date
      MESSAGES  MSG72 MSG63
    END RULE 22/01

    RULE 22/02 "1 dose  ROTATEC, [29w-6m] old: Too late !"
      IF CALC:Age in 29w..6m
      DO Exception
      MESSAGES  MSG69
    END RULE 22/02
  END FOLDER 22
END FOLDER 2

FOLDER 3 "Two doses"
  IF CALC:Rota_doses_received = 2

  FOLDER 31 "ROTARIX"
    IF CALC:Rota_vaccines_received contains only VAC0514 # ROTARIX

    RULE 31/01 "2 doses ROTARIX: Up to date"
      IF CALC:Age>=2m
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG11
    END RULE 31/01
  END FOLDER 31

  FOLDER 32 "ROTATEC"
  
    IF CALC:Rota_vaccines_received contains only VAC0031 # ROTATEQ

    RULE 32/01 "2 doses ROTATEQ, ≤ 32w old, dd ≤ 28w old: To do with ROTATEC from 4m and 4w after LD"
      IF ALL OF
        CALC:Age<=32w
        CALC:Rota_age_at_last_dose<=28w
      DO Recommended
        Status DUE
        Age 4m
        Delay 4w from CALC:Rota_last_dose_date
      MESSAGES  MSG63
    END RULE 32/01

    RULE 32/02 "2 doses ROTATEQ, ≥ 33w old: Too late !"
      IF CALC:Age>=33w
      DO Exception
      MESSAGES  MSG73
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
    MESSAGES  MSG11
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
      MESSAGES  MSG6 MSG7
    END RULE 82/01
  END FOLDER 82
END FOLDER 8

FOLDER 9 "Further information"

  RULE 9/02 "If To do: Information on contraindications"
    WHEN Recommended
    IF CALC:Age>15d
    DO Neutral
    MESSAGES  MSG66
  END RULE 9/02

  RULE 9/03 "d1d2 ≤ 2w: information message about d1d2 interval not respected"
    IF CALC:Rota_d1d2<=2w
    DO Neutral
    MESSAGES  MSG74
  END RULE 9/03

  RULE 9/04 "d2d3 ≤ 2w: information message about d2d3 interval not respected"
    IF CALC:Rota_d2d3<=2w
    DO Neutral
    MESSAGES  MSG68
  END RULE 9/04

  RULE 9/05 "If To do, d1 = ROTARIX: Continue with ROTARIX"
    WHEN Recommended
    IF CALC:Rota_first_vaccine = VAC0514# ROTARIX
    DO Neutral
    MESSAGES  MSG67
  END RULE 9/05

  RULE 9/06 "If To do, d1 = ROTATEQ: Continue with ROTATEQ"
    WHEN Recommended
    IF CALC:Rota_first_vaccine = VAC0031# ROTATEQ
    DO Neutral
    MESSAGES  MSG62
  END RULE 9/06
END FOLDER 9
END TARGET

MESSAGE MSG62 Comments ANY PRIO 0
  "Vaccination, started with ROTATEQ must be continued with ROTATEQ."@en
 END MESSAGE MSG62

MESSAGE MSG65 Comments ANY PRIO 0
  "To be done with the ROTARIX or ROTATEC vaccine."@en
 END MESSAGE MSG65

MESSAGE MSG63 Justification ANY PRIO 0
  "The interval between doses must be at least 4 weeks."@en
 END MESSAGE MSG63

MESSAGE MSG64 Summary ANY PRIO 0
  "Continue with the Rotarix vaccine."@en
 END MESSAGE MSG64

MESSAGE MSG11 Summary ANY PRIO 0
  "Vaccination schedule completed."@en
 END MESSAGE MSG11

MESSAGE MSG6 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG6

MESSAGE MSG7 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been checked in the health profile (section “Refusal of vaccination”)."@en
 END MESSAGE MSG7

MESSAGE MSG69 Summary ANY PRIO 0
  "It is too late to administer a 2nd dose."@en
 END MESSAGE MSG69

MESSAGE MSG74 Alert ANY PRIO 0
  "The interval between the 1st and 2nd doses was not respected."@en
 END MESSAGE MSG74

MESSAGE MSG70 Comments ANY PRIO 0
  "To be done with the ROTARIX vaccine."@en
 END MESSAGE MSG70

MESSAGE MSG71 Justification ANY PRIO 0
  "The ROTATEC vaccine can be used as a first dose only up to the age of 12 weeks. It is therefore necessary to use the ROTARIX vaccine in 2 doses."@en
 END MESSAGE MSG71

MESSAGE MSG73 Summary ANY PRIO 0
  "It is too late to administer the 3rd dose."@en
 END MESSAGE MSG73

MESSAGE MSG66 Comments ANY PRIO 0
  "Vaccination is contraindicated in the following cases: immunodeficiency, congenital digestive anomaly at risk of intussusception or history of intestinal intussusception, concomitant febrile illness (this being a temporary contraindication)."@en
 END MESSAGE MSG66

MESSAGE MSG67 Comments ANY PRIO 0
  "Vaccination, started with ROTARIX must be continued with ROTARIX."@en
 END MESSAGE MSG67

MESSAGE MSG72 Summary ANY PRIO 0
  "Continue with Rotateq vaccine."@en
 END MESSAGE MSG72

MESSAGE MSG75 Summary ANY PRIO 0
  "It is too late to administer a 1st dose."@en
 END MESSAGE MSG75

MESSAGE MSG76 Justification ANY PRIO 0
  "ROTATEC vaccine can only be administered as a 1st dose up to 12 weeks of age.
And vaccination with ROTARIX vaccine must be completed before the 24th week of age. The 1st dose must therefore be administered before the 20th week (minimum interval of 4 weeks between 2 doses)."@en
 END MESSAGE MSG76

MESSAGE MSG346 Details PATIENT PRIO 0
  "--"@en
 END MESSAGE MSG346

MESSAGE MSG68 Alert ANY PRIO 0
  "The interval between the 2nd and 3rd dose has not been respected."@en
 END MESSAGE MSG68
