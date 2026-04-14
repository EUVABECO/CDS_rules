CALC VZV_doses_received IS HIST(VZV-LA,0,count)
CALC VZV_last_dose_date IS HIST(VZV-LA,-1,date)
CALC VZV_age_at_first_dose IS INTERVAL(BASE:dob,HIST(VZV-LA,1,date))
CALC VZV_d1d2 IS INTERVAL(HIST(VZV-LA,1,date),HIST(VZV-LA,2,date))

TARGET Chickenpox

FOLDER 1 "Up to date"

  FOLDER 11 "History of chickenpox +"
    IF COND:C145 "History of chickenpox" = true

    RULE 2/01 "History of chickenpox +: Up to date"
      IF CALC:Age>=10d
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG341
    END RULE 2/01
  END FOLDER 11

  FOLDER 11 "Regularly receives human immunoglobulin"
    IF COND:C1233 "Person regularly receiving normal human immunoglobulins" = true

    RULE 2/01 "History of chickenpox +: Up to date"
      IF CALC:Age>=10d
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG340 MSG341
    END RULE 2/01
  END FOLDER 11
END FOLDER 1

FOLDER 2 "History of chickenpox -"
  IF ALL OF
  COND:C145 "History of chickenpox" = false
  COND:C1233 "Person regularly receiving normal human immunoglobulins" = false

  FOLDER 20 "Zero dose"
    IF CALC:VZV_doses_received = 0

    RULE 20/01 "History -, ≥ 6m old, 0 dose: To do between 12 and 15 month old"
      IF CALC:Age>=6m
      DO Recommended
        Status DUE
        Age 12m..15m
    END RULE 20/01
  END FOLDER 20

  FOLDER 21 "One dose"
    IF CALC:VZV_doses_received = 1

    FOLDER 211 "Schoolchild -"
      IF COND:C1093 "School child" = false

      RULE 211/01 "History-, Schoolchild-, [12m-7y], 1 dose: To do 6 to 8w after LD and from the age of 7y"
        IF CALC:Age in 12m..7y
        DO Recommended
          Status DUE
          Age 7y
          Delay 6w..8w from CALC:VZV_last_dose_date
        MESSAGES  MSG11 MSG30
      END RULE 211/01

      RULE 211/02 "History-, Schoolchild-, ≥ 8y old, 1 dose: To do 6 to 8w after LD"
        IF CALC:Age>=8y
        DO Recommended
          Status DUE
          Delay 6w..8w from CALC:VZV_last_dose_date
        MESSAGES  MSG1 MSG30
      END RULE 211/02
    END FOLDER 211

    FOLDER 212 "Schoolchild +"
      IF COND:C1093 "School child" = true

      RULE 212/01 "History-, Schoolchild+, [12m-6y], 1 dose: To do 6 to 8w after LD and from the age of 6y"
        IF CALC:Age in 12m..6y
        DO Recommended
          Status DUE
          Age 6y
          Delay 6w..8w from CALC:VZV_last_dose_date
        MESSAGES  MSG29 MSG30
      END RULE 212/01

      RULE 212/02 "History-, Schoolchild+, ≥ 7y old, 1 dose: To do 6 to 8w after LD"
        IF CALC:Age>=7y
        DO Recommended
          Status DUE
          Delay 6w..8w from CALC:VZV_last_dose_date
        MESSAGES  MSG1 MSG30
      END RULE 212/02
    END FOLDER 212
  END FOLDER 21

  FOLDER 22 "Two doses"
    IF CALC:VZV_doses_received = 2

    RULE 22/01 "History-,  d1 ≥ 6m old, 2 doses: Up to date"
      IF CALC:VZV_age_at_first_dose>=6m
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG5
    END RULE 22/01

    RULE 22/02 "History-, d1 ≤ 5m old, 2 doses: To do 6-8w after LD"
      IF CALC:VZV_age_at_first_dose<=5m
      DO Recommended
        Status DUE
        Delay 6w..8w from CALC:VZV_last_dose_date
    END RULE 22/02
  END FOLDER 22

  FOLDER 23 "Three doses and more"
    IF CALC:VZV_doses_received>=3

    RULE 23/01 "History-, 3 doses and more: Up to date"
      IF CALC:VZV_doses_received = 3
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG5
    END RULE 23/01
  END FOLDER 23
END FOLDER 2

FOLDER 8 "Contraindications and special cases"

  FOLDER 81 "Contraindications"

    RULE 81/01 "Case « Contraindication to smallpox vaccination » checked: Contraindication + message"
      IF COND:C1019 "Contraindication to chickenpox vaccination" = true
      DO Contraindicated
      MESSAGES  MSG13 MSG14
    END RULE 81/01

    RULE 81/02 "Risk factors contraindicating vaccination with live viruses: Contraindication + message"
      IF SYNTH:COMMON-RF-ID "COMMON-RF-ID - ID risk factors contraindicating vaccination with live vaccines" = true
      DO Contraindicated
      MESSAGES  MSG15 MSG16
    END RULE 81/02

    RULE 81/03 "Pregnancy in progress: Contraindication + message"
      IF SYNTH:PREGNANCY_ONGOING "PREGNANCY - Pregnancy in progress" = true
      DO Contraindicated
      MESSAGES  MSG17 MSG18
    END RULE 81/03
  END FOLDER 81

  FOLDER 82 "Special cases"

    RULE 82/01 "Case  « Refusal to vaccinate against this disease » checked: Special case + message"
      IF COND:C624 "Refusal to vaccinate against chickenpox" = true
      DO Exception
      MESSAGES  MSG19 MSG20
    END RULE 82/01
  END FOLDER 82
END FOLDER 8

FOLDER 9 "Further information"

  RULE 9/01 "0 dose, [12m-8y] old, If to do: Mandatory vaccination"
    WHEN Recommended
    IF ALL OF
      CALC:Age in 12m..8y
      CALC:VZV_doses_received = 0
    DO Neutral
    MESSAGES  MSG32
  END RULE 9/01

  RULE 9/02 "If To do: message vaccination scheme"
    WHEN Recommended
    IF CALC:Age>=12m
    DO Neutral
    MESSAGES  MSG81
  END RULE 9/02

  RULE 9/03 "d1 ≤ 5m  old: message d1 too early"
    IF CALC:VZV_age_at_first_dose<=5m
    DO Neutral
    MESSAGES  MSG6 MSG7
  END RULE 9/03

  RULE 9/04 "d1 [6-8m], 2 doses: message d1 too early"
    IF ALL OF
      CALC:VZV_age_at_first_dose in 6m..8m
      CALC:VZV_doses_received = 2
    DO Neutral
    MESSAGES  MSG22 MSG23
  END RULE 9/04

  RULE 9/05 "d1d2 ≤ 2w, 2 doses: message d1d2 too short"
    IF ALL OF
      CALC:VZV_d1d2<=2w
      CALC:VZV_doses_received = 2
    DO Neutral
    MESSAGES  MSG80 MSG28
  END RULE 9/05
END FOLDER 9
END TARGET

MESSAGE MSG19 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG19

MESSAGE MSG20 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been ticked in the health profile (‘Refusal of vaccination’ section)."@en
 END MESSAGE MSG20

MESSAGE MSG17 Justification ANY PRIO 0
  "Pregnancy temporarily contraindicates the use of live virus vaccines, such as those against measles, rubella, mumps, chickenpox or yellow fever."@en
 END MESSAGE MSG17

MESSAGE MSG18 Alert ANY PRIO 0
  "Pregnancy temporarily contraindicates the use of live virus vaccines."@en
 END MESSAGE MSG18

MESSAGE MSG13 Alert ANY PRIO 0
  "Vaccination contraindicated by the doctor."@en
 END MESSAGE MSG13

MESSAGE MSG14 Justification ANY PRIO 0
  "The box indicating a contraindication for this disease has been ticked in the health profile (‘Contraindicated vaccinations’ section)."@en
 END MESSAGE MSG14

MESSAGE MSG15 Justification ANY PRIO 0
  "Immunosuppression contraindicates the use of live virus vaccines, such as those against measles, rubella, mumps, chickenpox or yellow fever."@en
 END MESSAGE MSG15

MESSAGE MSG16 Alert ANY PRIO 0
  "Immunosuppression contraindicates the use of live virus vaccines."@en
 END MESSAGE MSG16

MESSAGE MSG1 Summary ANY PRIO 0
  "To be done as soon as possible."@en
 END MESSAGE MSG1

MESSAGE MSG30 Comments ANY PRIO 0
  "Always wait 6 to 8 weeks after the last dose."@en
 END MESSAGE MSG30

MESSAGE MSG22 Summary ANY PRIO 0
  "The 1st dose was administered between 6 and 8 months of age inclusive, and the addition of a 3rd dose should be discussed."@en
 END MESSAGE MSG22

MESSAGE MSG23 Justification ANY PRIO 0
  "When the vaccine is administered before the age of 9 months, it is less effective."@en
 END MESSAGE MSG23

MESSAGE MSG32 Alert ANY PRIO 0
  "This vaccination is compulsory in Latvia from the age of 12 months."@en
 END MESSAGE MSG32

MESSAGE MSG6 Justification ANY PRIO 0
  "The measles, mumps and rubella vaccine should not be given before the age of 6 months; the earlier in life it is given, the less effective it is."@en
 END MESSAGE MSG6

MESSAGE MSG7 Summary ANY PRIO 0
  "The 1st dose was administered too early: this justifies the administration of an additional dose."@en
 END MESSAGE MSG7

MESSAGE MSG81 Comments ANY PRIO 50
  "The vaccination schedule is 2 doses:<br>
- First dose between the ages of 12 and 15 months,<br>
- Second dose at age 7.<br>
In the case of admission to a school, the second dose may be administered from the age of 6."@en
 END MESSAGE MSG81

MESSAGE MSG11 Summary ANY PRIO 0
  "To be done from the age of 7."@en
 END MESSAGE MSG11

MESSAGE MSG5 Summary ANY PRIO 0
  "Vaccination schedule completed."@en
 END MESSAGE MSG5

MESSAGE MSG29 Summary ANY PRIO 0
  "For schoolchildren, from the age of 6."@en
 END MESSAGE MSG29

MESSAGE MSG340 Justification ANY PRIO 0
  "Human normal polyvalent immunoglobulin contains antibodies against the measles, mumps, rubella and chickenpox viruses. People who regularly receive these immunoglobulins are therefore protected against these diseases."@en
 END MESSAGE MSG340

MESSAGE MSG341 Summary ANY PRIO 0
  "Up to date with chickenpox."@en
 END MESSAGE MSG341

MESSAGE MSG80 Alert ANY PRIO 0
  "Diagram not respected: see commentary."@en
 END MESSAGE MSG80

MESSAGE MSG28 Comments ANY PRIO 0
  "If the interval between the two doses is less than 3 weeks, discuss adding a 3rd dose."@en
 END MESSAGE MSG28
