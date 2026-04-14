CALC Rub_doses_received IS HIST(Rub-LA,0,count)
CALC Rub_last_dose_date IS HIST(Rub-LA,-1,date)
CALC Rub_age_at_first_dose IS INTERVAL(BASE:dob,HIST(Rub-LA,1,date))
CALC Rub_d1d2 IS INTERVAL(HIST(Rub-LA,1,date),HIST(Rub-LA,2,date))

TARGET Rubella

FOLDER 0 "Common to measles, mumps and rubella"

  FOLDER 1 "Born ≤ 1956 AND History of measles, mumps and rubella -"
    IF ALL OF
    BASE:dob<=1956-12-31
    SYNTH:HIST-MMR "MMR - History of measles, mumps and rubella" = false

    FOLDER 11 "Zero dose"
      IF CALC:Rub_doses_received = 0

      RULE 11/01 "Born ≤ 1956, 0 dose: Vaccination not recommended"
        IF CALC:Rub_doses_received = 0
        DO Neutral
        MESSAGES  MSG9 MSG10
      END RULE 11/01
    END FOLDER 11

    FOLDER 12 "One dose"
      IF CALC:Rub_doses_received = 1

      RULE 12/01 "Born ≤ 1956, 1 dose: Special case - Vaccination not recommended"
        IF CALC:Rub_doses_received = 1
        DO Exception
        MESSAGES  MSG24 MSG25
      END RULE 12/01
    END FOLDER 12

    FOLDER 13 "Two doses"
      IF CALC:Rub_doses_received = 2

      RULE 13/01 "Born ≤ 1956, 2 doses: Up to date"
        IF CALC:Rub_doses_received = 2
        DO Recommended
          Status COMPLETED
        MESSAGES  MSG5
      END RULE 13/01
    END FOLDER 13
  END FOLDER 1

  FOLDER 2 "Born ≥ 1957 AND History of measles, mumps and rubella -"
    IF ALL OF
    BASE:dob>=1957-01-01
    SYNTH:HIST-MMR "MMR - History of measles, mumps and rubella" = false
    COND:C1233 "Person regularly receiving normal human immunoglobulins" = false

    FOLDER 21 "Zero dose"
      IF CALC:Rub_doses_received = 0

      RULE 21/01 "Born ≥ 1957, ≥  6m old, 0 dose: To do between 12 and 15 month old"
        IF CALC:Age>=6m
        DO Recommended
          Status DUE
          Age 12m..15m
      END RULE 21/01
    END FOLDER 21

    FOLDER 22 "One dose"
      IF CALC:Rub_doses_received = 1

      FOLDER 221 "Schoolchild -"
        IF COND:C1093 "School child" = false

        RULE 221/01 "Born ≥ 1957, Schoolchild-, [12m-7y] old, 1 dose: To do 6 to 8w after LD and from the age of 7y"
          IF CALC:Age in 12m..7y
          DO Recommended
            Status DUE
            Age 7y
            Delay 6w..8w from CALC:Rub_last_dose_date
          MESSAGES  MSG11 MSG30
        END RULE 221/01

        RULE 221/02 "Born ≥ 1957, Schoolchild-, ≥ 8y old, 1 dose: To do ASAP 6 to 8w after LD"
          IF CALC:Age>=8y
          DO Recommended
            Status DUE
            Delay 6w..8w from CALC:Rub_last_dose_date
          MESSAGES  MSG30
        END RULE 221/02
      END FOLDER 221

      FOLDER 222 "Schoolchild +"
        IF COND:C1093 "School child" = true

        RULE 222/01 "Born ≥ 1957, Schoolchild+, [12m-6y] old, 1 dose: To do 6 to 8w after LD and from the age of 6y"
          IF CALC:Age in 12m..6y
          DO Recommended
            Status DUE
            Age 6y
            Delay 6w..8w from CALC:Rub_last_dose_date
          MESSAGES  MSG29 MSG30
        END RULE 222/01

        RULE 222/02 "Born ≥ 1957, Schoolchild+, ≥ 7y old, 1 dose: To do ASAP 6 to 8w after LD"
          IF CALC:Age>=7y
          DO Recommended
            Status DUE
            Delay 6w..8w from CALC:Rub_last_dose_date
          MESSAGES  MSG1 MSG30
        END RULE 222/02
      END FOLDER 222
    END FOLDER 22

    FOLDER 23 "Two doses"
      IF CALC:Rub_doses_received = 2

      RULE 23/01 "Born ≥ 1957,  d1 ≥ 6m old, 2 doses: Up to date"
        IF CALC:Rub_age_at_first_dose>=6m
        DO Recommended
          Status COMPLETED
        MESSAGES  MSG5
      END RULE 23/01

      RULE 23/02 "Born ≥ 1957, d1 ≤ 5m old, 2 doses: To do 6-8w after LD"
        IF CALC:Rub_age_at_first_dose<=5m
        DO Recommended
          Status DUE
          Delay 6w..8w from CALC:Rub_last_dose_date
      END RULE 23/02
    END FOLDER 23

    FOLDER 24 "Three doses"
      IF CALC:Rub_doses_received = 3

      RULE 24/01 "Born ≥ 1957, 3 doses: Up to date"
        IF CALC:Rub_doses_received = 3
        DO Recommended
          Status COMPLETED
        MESSAGES  MSG5
      END RULE 24/01
    END FOLDER 24

    FOLDER 25 "Four doses or more"
      IF CALC:Rub_doses_received>=4

      RULE 25/01 "Born ≥ 1957, ≥ 4 doses: Special case + message overaccaccinated"
        IF CALC:Rub_doses_received>=4
        DO Exception
        MESSAGES  MSG8
      END RULE 25/01
    END FOLDER 25
  END FOLDER 2

  FOLDER 3 "History of measles, mumps and rubella +"
    IF SYNTH:HIST-MMR "MMR - History of measles, mumps and rubella" = true

    RULE 3/01 "History of measles, mumps and rubella +: Up to date"
      IF CALC:Age>=1d
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG79
    END RULE 3/01
  END FOLDER 3

  FOLDER 4 "Regularly receives human immunoglobulin"
    IF COND:C1233 "Person regularly receiving normal human immunoglobulins" = true

    RULE 4/01 "Regularly receives human immunoglobulin+: Up to date"
      IF CALC:Age>=1d
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG79 MSG340
    END RULE 4/01
  END FOLDER 4

  FOLDER 8 "Contraindications and special cases (Copie)"

    FOLDER 81 "Contraindications (Copie)"

      RULE 81/01 "Case « Contraindication to MMR vaccination » checked: Contraindication + message"
        IF COND:C1018 "Contraindication to measles, mumps and rubella (MMR) vaccination" = true
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

    FOLDER 82 "Special cases (Copie)"

      RULE 82/01 "Case  « Refusal to vaccinate against this disease » checked: Special case + message"
        IF COND:C591 "Refusal to vaccinate against measles, mumps and rubella" = true
        DO Exception
        MESSAGES  MSG19 MSG20
      END RULE 82/01
    END FOLDER 82
  END FOLDER 8

  FOLDER 9 "Further information (Copie)"

    RULE 9/01 "If to do, Born ≥ 1957, 0 dose: Message"
      WHEN Recommended
      IF ALL OF
        BASE:dob>=1957-01-01
        CALC:Rub_doses_received = 0
      DO Neutral
      MESSAGES  MSG12
    END RULE 9/01

    RULE 9/02 "If to do, 0 dose, [12m-8y] old: Mandatory vaccination"
      WHEN Recommended
      IF ALL OF
        CALC:Age in 12m..8y
        CALC:Rub_doses_received = 0
      DO Neutral
      MESSAGES  MSG32
    END RULE 9/02

    RULE 9/03 "d1 ≤ 5m  old: message d1 too early"
      IF CALC:Rub_age_at_first_dose<=5m
      DO Neutral
      MESSAGES  MSG6 MSG7
    END RULE 9/03

    RULE 9/04 "d1 [6-8m] old, 2 doses: message d1 too early"
      IF ALL OF
        CALC:Rub_age_at_first_dose in 6m..8m
        CALC:Rub_doses_received = 2
      DO Neutral
      MESSAGES  MSG22 MSG23
    END RULE 9/04

    RULE 9/05 "d1d2 ≤ 2w, 2 doses: message d1d2 too short"
      IF ALL OF
        CALC:Rub_d1d2<=2w
        CALC:Rub_doses_received = 2
      DO Neutral
      MESSAGES  MSG80 MSG28
    END RULE 9/05

    RULE 9/06 "If To do, Born ≥ 01/01/1957: message vaccination scheme"
      WHEN Recommended
      IF BASE:dob>=1957-01-01
      DO Neutral
      MESSAGES  MSG128
    END RULE 9/06
  END FOLDER 9
END FOLDER 0

FOLDER 1 "Only for rubella"

  RULE 1/03 "History of rubella+: message"
    WHEN Recommended
    IF ALL OF
      SYNTH:HIST-MMR "MMR - History of measles, mumps and rubella" = false
      COND:C148 "History of rubella" = true
    DO Neutral
    MESSAGES  MSG73
  END RULE 1/03
END FOLDER 1
END TARGET

MESSAGE MSG128 Comments ANY PRIO 50
  "The vaccination schedule for people born from 1957 is 2 doses:<br>
- First dose between the ages of 12 and 15 months,<br>
- Second dose at age 7.<br>
In the case of admission to a school, the second dose may be administered from the age of 6."@en
 END MESSAGE MSG128

MESSAGE MSG73 Summary ANY PRIO 0
  "Despite a history of rubella, vaccination with a trivalent vaccine is indicated."@en
 END MESSAGE MSG73

MESSAGE MSG13 Alert ANY PRIO 0
  "Vaccination contraindicated by the doctor."@en
 END MESSAGE MSG13

MESSAGE MSG14 Justification ANY PRIO 0
  "The box indicating a contraindication for this disease has been ticked in the health profile (‘Contraindicated vaccinations’ section)."@en
 END MESSAGE MSG14

MESSAGE MSG11 Summary ANY PRIO 0
  "To be done from the age of 7."@en
 END MESSAGE MSG11

MESSAGE MSG30 Comments ANY PRIO 0
  "Always wait 6 to 8 weeks after the last dose."@en
 END MESSAGE MSG30

MESSAGE MSG19 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG19

MESSAGE MSG20 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been ticked in the health profile (‘Refusal of vaccination’ section)."@en
 END MESSAGE MSG20

MESSAGE MSG32 Alert ANY PRIO 0
  "This vaccination is compulsory in Latvia from the age of 12 months."@en
 END MESSAGE MSG32

MESSAGE MSG22 Summary ANY PRIO 0
  "The 1st dose was administered between 6 and 8 months of age inclusive, and the addition of a 3rd dose should be discussed."@en
 END MESSAGE MSG22

MESSAGE MSG23 Justification ANY PRIO 0
  "When the vaccine is administered before the age of 9 months, it is less effective."@en
 END MESSAGE MSG23

MESSAGE MSG80 Alert ANY PRIO 0
  "Diagram not respected: see commentary."@en
 END MESSAGE MSG80

MESSAGE MSG28 Comments ANY PRIO 0
  "If the interval between the two doses is less than 3 weeks, discuss adding a 3rd dose."@en
 END MESSAGE MSG28

MESSAGE MSG6 Justification ANY PRIO 0
  "The measles, mumps and rubella vaccine should not be given before the age of 6 months; the earlier in life it is given, the less effective it is."@en
 END MESSAGE MSG6

MESSAGE MSG7 Summary ANY PRIO 0
  "The 1st dose was administered too early: this justifies the administration of an additional dose."@en
 END MESSAGE MSG7

MESSAGE MSG1 Summary ANY PRIO 0
  "To be done as soon as possible."@en
 END MESSAGE MSG1

MESSAGE MSG79 Summary ANY PRIO 0
  "Up to date against measles, mumps and rubella."@en
 END MESSAGE MSG79

MESSAGE MSG5 Summary ANY PRIO 0
  "Vaccination schedule completed."@en
 END MESSAGE MSG5

MESSAGE MSG17 Justification ANY PRIO 0
  "Pregnancy temporarily contraindicates the use of live virus vaccines, such as those against measles, rubella, mumps, chickenpox or yellow fever."@en
 END MESSAGE MSG17

MESSAGE MSG18 Alert ANY PRIO 0
  "Pregnancy temporarily contraindicates the use of live virus vaccines."@en
 END MESSAGE MSG18

MESSAGE MSG15 Justification ANY PRIO 0
  "Immunosuppression contraindicates the use of live virus vaccines, such as those against measles, rubella, mumps, chickenpox or yellow fever."@en
 END MESSAGE MSG15

MESSAGE MSG16 Alert ANY PRIO 0
  "Immunosuppression contraindicates the use of live virus vaccines."@en
 END MESSAGE MSG16

MESSAGE MSG340 Justification ANY PRIO 0
  "Human normal polyvalent immunoglobulin contains antibodies against the measles, mumps, rubella and chickenpox viruses. People who regularly receive these immunoglobulins are therefore protected against these diseases."@en
 END MESSAGE MSG340

MESSAGE MSG12 Justification ANY PRIO 0
  "People born since 1957 are unlikely to already have natural immunity against measles, mumps and rubella."@en
 END MESSAGE MSG12

MESSAGE MSG24 Summary ANY PRIO 0
  "Incomplete vaccination schedule but no recommendation."@en
 END MESSAGE MSG24

MESSAGE MSG25 Justification ANY PRIO 0
  "The full vaccination schedule comprises 2 doses. However, this vaccination is not generally recommended for people born before 1957, who have a high probability of already being naturally immunised."@en
 END MESSAGE MSG25

MESSAGE MSG9 Justification ANY PRIO 0
  "People born before 1957 have a high probability of already having natural immunity to measles."@en
 END MESSAGE MSG9

MESSAGE MSG10 Summary ANY PRIO 0
  "Vaccination is not generally recommended for people born before 1957."@en
 END MESSAGE MSG10

MESSAGE MSG8 Alert ANY PRIO 0
  "This person has been over-vaccinated against measles."@en
 END MESSAGE MSG8

MESSAGE MSG29 Summary ANY PRIO 0
  "For schoolchildren, from the age of 6."@en
 END MESSAGE MSG29
