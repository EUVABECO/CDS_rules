CALC Rub_doses_received IS HIST(Rub-LA,0,count)

CALC Rub_first_dose_age IS INTERVAL(BASE:dob,HIST(Rub-LA,1,date))

CALC Rub_last_dose_date IS HIST(Rub-LA,-1,date)
CALC Rub_time_since_last_dose IS INTERVAL(CALC:Rub_last_dose_date,BASE:eval)

CALC Rub_d1d2 IS INTERVAL(HIST(Rub-LA,1,date),HIST(Rub-LA,2,date))

TARGET Rubella
FOLDER 0 "Common to measles, mumps and rubella (Copie)"

  FOLDER 1 "[12m-64y] old AND History of measles, mumps and rubella - (Copie)"
    IF ALL OF
    SYNTH:MMR-HISTORY "MMR - History of measles, mumps and rubella" = false
    CALC:Age in 6m..64y

    FOLDER 11 "Zero dose (Copie)"
      IF CALC:Rub_doses_received = 0

      RULE 11/01 "[6m-64y] old, 0 dose: To do from 12m old"
        IF CALC:Age>=6m
        DO Recommended
          Status DUE
          Age 12m
      END RULE 11/01
    END FOLDER 11

    FOLDER 12 "One dose (Copie)"
      IF CALC:Rub_doses_received = 1

      RULE 12/01 "[12m-7y] old, 1 dose: To do 6 to 8w after LD and from 7-8y old"
        IF CALC:Age in 12m..7y
        DO Recommended
          Status DUE
          Age 7y..8y
          Delay 6w..8w from CALC:Rub_last_dose_date
        MESSAGES  MSG12 MSG10
      END RULE 12/01

      RULE 12/02 "≥ 8y old, 1 dose: To do ASAP 6 to 8w after LD"
        IF CALC:Age>=8y
        DO Recommended
          Status DUE
          Delay 6w..8w from CALC:Rub_last_dose_date
        MESSAGES  MSG10
      END RULE 12/02
    END FOLDER 12

    FOLDER 13 "Two doses (Copie)"
      IF CALC:Rub_doses_received = 2

      RULE 13/01 "d1 ≥ 6m old, 2 doses: Up to date"
        IF CALC:Rub_first_dose_age>=6m
        DO Recommended
          Status COMPLETED
        MESSAGES  MSG11
      END RULE 13/01

      RULE 13/02 "d1 ≤ 5m old, 2 doses: To do 6-8w after LD"
        IF CALC:Rub_first_dose_age<=5m
        DO Recommended
          Status DUE
          Delay 6w..8w from CALC:Rub_last_dose_date
      END RULE 13/02
    END FOLDER 13

    FOLDER 14 "Three doses (Copie)"
      IF CALC:Rub_doses_received = 3

      RULE 14/01 "3 doses: Up to date"
        IF CALC:Rub_doses_received = 3
        DO Recommended
          Status COMPLETED
        MESSAGES  MSG11
      END RULE 14/01
    END FOLDER 14

    FOLDER 15 "Four doses or more (Copie)"
      IF CALC:Rub_doses_received>=4

      RULE 15/01 "≥ 4 doses: Special case + message overaccaccinated"
        IF CALC:Rub_doses_received>=4
        DO Exception
        MESSAGES  MSG18
      END RULE 15/01
    END FOLDER 15
  END FOLDER 1

  FOLDER 2 "≥ 65 old (Copie)"
    IF ALL OF
    SYNTH:MMR-HISTORY "MMR - History of measles, mumps and rubella" = false
    CALC:Age>=65y

    FOLDER 22 "One dose (Copie)"

      RULE 22/01 "≥ 65y old, 1 dose: Special case - Vaccination not recommended"
        IF CALC:Rub_doses_received = 1
        DO Exception
        MESSAGES  MSG30
      END RULE 22/01
    END FOLDER 22

    FOLDER 23 "Two doses (Copie)"

      RULE 23/01 "≥ 65y old, 2 doses: Up to date"
        IF CALC:Rub_doses_received = 2
        DO Recommended
          Status COMPLETED
        MESSAGES  MSG11
      END RULE 23/01
    END FOLDER 23
  END FOLDER 2

  FOLDER 3 "History of measles, mumps and rubella + (Copie)"
    IF SYNTH:MMR-HISTORY "MMR - History of measles, mumps and rubella" = true

    RULE 3/01 "History of measles, mumps and rubella +: Up to date"
      IF CALC:Age>=1d
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG21
    END RULE 3/01
  END FOLDER 3

  FOLDER 8 "Contraindications and special cases (Copie)"

    FOLDER 81 "Contraindications (Copie)"

      RULE 81/01 "Case « Contraindication to MMR vaccination » checked: Contraindication + message"
        IF COND:C1018 "Contraindication to measles, mumps and rubella (MMR) vaccination" = true
        DO Contraindicated
        MESSAGES  MSG14 MSG15
      END RULE 81/01

      RULE 81/02 "Risk factors contraindicating vaccination with live viruses: Contraindication + message"
        IF SYNTH:COMMON-RF-ID "COMMON-RF-ID - ID risk factors contraindicating vaccination with live vaccines" = true
        DO Contraindicated
        MESSAGES  MSG34 MSG35
      END RULE 81/02

      RULE 81/03 "Pregnancy in progress: Contraindication + message"
        IF SYNTH:PREGNANCY_ONGOING "COMMON-PREGNANCY - Pregnancy in progress" = true
        DO Contraindicated
        MESSAGES  MSG16 MSG17
      END RULE 81/03
    END FOLDER 81

    FOLDER 82 "Special cases (Copie)"

      RULE 82/01 "Case  « Refusal to vaccinate against this disease » checked: Special case + message"
        IF COND:C591 "Refusal to vaccinate against measles, mumps and rubella" = true
        DO Exception
        MESSAGES  MSG6 MSG7
      END RULE 82/01
    END FOLDER 82
  END FOLDER 8

  FOLDER 9 "Further information (Copie)"

    RULE 9/01 "d1 ≤ 5m  old: message d1 too early"
      IF CALC:Rub_first_dose_age<=5m
      DO Neutral
      MESSAGES  MSG28 MSG29
    END RULE 9/01

    RULE 9/02 "d1 [6-8m] old, 2 doses: message d1 too early"
      IF ALL OF
        CALC:Rub_first_dose_age in 6m..8m
        CALC:Rub_doses_received = 2
      DO Neutral
      MESSAGES  MSG22 MSG23
    END RULE 9/02

    RULE 9/03 "d1d2 ≤ 2w, 2 doses: message d1d2 too short"
      IF ALL OF
        CALC:Rub_d1d2<=2w
        CALC:Rub_doses_received = 2
      DO Neutral
      MESSAGES  MSG32 MSG33
    END RULE 9/03

    RULE 9/04 "If To do, ≤ 19y old: message vaccination scheme"
      WHEN Recommended
      IF ALL OF
        CALC:Rub_doses_received<=1
        CALC:Age<=19y
      DO Neutral
      MESSAGES  MSG27
    END RULE 9/04

    RULE 9/05 "If To do, ≥ 20y old: message vaccination catch up scheme"
      WHEN Recommended
      IF ALL OF
        CALC:Rub_doses_received<=1
        CALC:Age>=20y
      DO Neutral
      MESSAGES  MSG49
    END RULE 9/05

    RULE 9/06 "[13-50y] old, Fem, LD ≤ 31d: message contraception"
      IF ALL OF
        CALC:Rub_time_since_last_dose<=1m
        SYNTH:WOMAN-13-50 "COMMON - Woman of childbearing age (13y - 50y)" = true
      DO Neutral
      MESSAGES  MSG46 MSG45
    END RULE 9/06

    RULE 9/07 "If to do: message to do with "
      WHEN Recommended
      IF CALC:Age>=9m
      DO Neutral
      MESSAGES  MSG48
    END RULE 9/07
  END FOLDER 9
END FOLDER 0

FOLDER 1 "Only for rubella"

  RULE 1/01 "History of rubella+: message"
    WHEN Recommended
    IF ALL OF
      SYNTH:MMR-HISTORY "MMR - History of measles, mumps and rubella" = false
      COND:C148 "History of rubella" = true
    DO Neutral
    MESSAGES  MSG51
  END RULE 1/01
END FOLDER 1
END TARGET

MESSAGE MSG11 Summary ANY PRIO 0
  "Vaccination schedule completed."@en
 END MESSAGE MSG11

MESSAGE MSG46 Justification ANY PRIO 0
  "Women who have recently been vaccinated and are planning to become pregnant should be advised to postpone their plans for one month. Effective contraception can be usefully put in place."@en
 END MESSAGE MSG46

MESSAGE MSG45 Alert ANY PRIO 0
  "Effective contraception for one month after each dose of vaccine."@en
 END MESSAGE MSG45

MESSAGE MSG51 Summary ANY PRIO 0
  "Despite a history of rubella, vaccination with a trivalent vaccine is indicated."@en
 END MESSAGE MSG51

MESSAGE MSG21 Summary ANY PRIO 0
  "Up to date against measles, mumps and rubella."@en
 END MESSAGE MSG21

MESSAGE MSG30 Summary ANY PRIO 0
  "Incomplete vaccination schedule but no recommendation."@en
 END MESSAGE MSG30

MESSAGE MSG10 Comments ANY PRIO 0
  "Always respect an interval of 6 to 8 weeks with the last dose."@en
 END MESSAGE MSG10

MESSAGE MSG49 Comments ANY PRIO 0
  "The vaccination schedule consists of two doses spaced 6 to 8 weeks apart. In non-immune adults, catch-up vaccination is recommended up to the age of 65."@en
 END MESSAGE MSG49

MESSAGE MSG22 Summary ANY PRIO 0
  "The 1st dose was administered between 6 and 8 months inclusive, the addition of a 3rd dose is to be discussed."@en
 END MESSAGE MSG22

MESSAGE MSG23 Justification ANY PRIO 0
  "When the vaccine is administered before the age of 9 months, it is less effective."@en
 END MESSAGE MSG23

MESSAGE MSG28 Justification ANY PRIO 0
  "The measles, mumps and rubella vaccine should not be given before 6 months of age; the earlier in life it is given, the less effective it is."@en
 END MESSAGE MSG28

MESSAGE MSG29 Summary ANY PRIO 0
  "The first dose was given too early: this justifies the administration of an additional dose."@en
 END MESSAGE MSG29

MESSAGE MSG27 Comments ANY PRIO 50
  "The vaccination schedule is 2 doses:<br>
- First dose at 12 months of age,<br>
- Second dose at 7-8 years of age."@en
 END MESSAGE MSG27

MESSAGE MSG16 Justification ANY PRIO 0
  "Pregnancy temporarily contraindicates the use of live virus vaccines, such as measles, rubella, mumps, varicella, or yellow fever vaccines."@en
 END MESSAGE MSG16

MESSAGE MSG17 Alert ANY PRIO 0
  "Pregnancy temporarily contraindicates the use of live virus vaccines."@en
 END MESSAGE MSG17

MESSAGE MSG14 Alert ANY PRIO 0
  "Vaccination contraindicated by the doctor."@en
 END MESSAGE MSG14

MESSAGE MSG15 Justification ANY PRIO 0
  "The box indicating a contraindication for this disease has been checked in the health profile (section “Contraindicated vaccinations”)."@en
 END MESSAGE MSG15

MESSAGE MSG34 Justification ANY PRIO 0
  "Immunodeficiency contraindicates the use of live virus vaccines, such as measles, mumps, rubella, varicella or yellow fever vaccines."@en
 END MESSAGE MSG34

MESSAGE MSG35 Alert ANY PRIO 0
  "Immunodeficiency contraindicates the use of live virus vaccines."@en
 END MESSAGE MSG35

MESSAGE MSG48 Other PRO PRIO 0
  "Vaccines that can be used:<br>
Trivalent measles, mumps and rubella: MM RVaxpro, Priorix<br>
Quadrivalent measles, mumps, rubella and varicella: ProQuad"@en
 END MESSAGE MSG48

MESSAGE MSG32 Alert ANY PRIO 0
  "Schedule not followed: see comment."@en
 END MESSAGE MSG32

MESSAGE MSG33 Comments ANY PRIO 0
  "The interval between the two doses is less than 3 weeks, discuss the addition of a 3rd dose."@en
 END MESSAGE MSG33

MESSAGE MSG6 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG6

MESSAGE MSG7 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been checked in the health profile (section “Refusal of vaccination”)."@en
 END MESSAGE MSG7

MESSAGE MSG346 Details PATIENT PRIO 0
  "--"@en
 END MESSAGE MSG346

MESSAGE MSG12 Summary ANY PRIO 0
  "To be done at the age of 7."@en
 END MESSAGE MSG12

MESSAGE MSG18 Alert ANY PRIO 0
  "This person is over vaccinated against measles, mumps and rubella."@en
 END MESSAGE MSG18
