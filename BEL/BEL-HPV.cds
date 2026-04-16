CALC HPV_doses_received IS HIST(HPV,0,count)
CALC HPV_last_dose_date IS HIST(HPV,-1,date)
CALC HPV_d1d2 IS INTERVAL(HIST(HPV,1,date),HIST(HPV,2,date))

TARGET HPV
FOLDER 1 "11 to 18 years old"
  IF CALC:Age in 11y..18y

  FOLDER 11 "Zero dose"
    IF CALC:HPV_doses_received = 0

    RULE 1 "[11-18y] old, 0 dose: To do from 12y old"
      IF CALC:HPV_doses_received = 0
      DO Recommended
        Status DUE
        Age 12y..18y
      MESSAGES  MSG56
    END RULE 1
  END FOLDER 11

  FOLDER 12 "One dose"
    IF CALC:HPV_doses_received = 1

    RULE 1 "[11-18y] old, 1 dose: To do 6m after LD "
      IF CALC:HPV_doses_received = 1
      DO Recommended
        Status DUE
        Age 12y
        Delay 6m from CALC:HPV_last_dose_date
      MESSAGES  MSG55
    END RULE 1
  END FOLDER 12

  FOLDER 13 "Two doses"
    IF CALC:HPV_doses_received = 2

    RULE 1 "[11-18y] old, 2 doses, d1d2 ≤ 4m: To do 3rd dose 6m after LD + message interval not respected"
      IF ALL OF
        CALC:HPV_doses_received = 2
        CALC:HPV_d1d2<=4m
      DO Recommended
        Status DUE
        Age 12y
        Delay 6m from CALC:HPV_last_dose_date
      MESSAGES  MSG54
    END RULE 1

    RULE 2 "[11-18y] old, 2 doses, d1d2 ≥ 5m: Up to date"
      IF ALL OF
        CALC:HPV_doses_received = 2
        CALC:HPV_d1d2>=5m
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG11
    END RULE 2
  END FOLDER 13

  FOLDER 14 "Three doses and more"
    IF CALC:HPV_doses_received>=3

    RULE 1 "[11-18y old],  ≥3 doses, d1d2 ≥ 5m: Up to date"
      IF CALC:HPV_doses_received>=3
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG11
    END RULE 1
  END FOLDER 14
END FOLDER 1

FOLDER 1 "19 to 29 years old"
  IF CALC:Age in 19y..26y

  FOLDER 11 "Zero dose"
    IF CALC:HPV_doses_received = 0

    RULE 1 "[19-26y] old, 0 dose: Suggest from 19y old"
      IF CALC:HPV_doses_received = 0
      DO Suggested
      MESSAGES  MSG60 MSG59
    END RULE 1
  END FOLDER 11

  FOLDER 12 "One dose"
    IF CALC:HPV_doses_received = 1

    RULE 1 "[19-26y] old, 1 dose: To do 1-2m after LD"
      IF CALC:HPV_doses_received = 1
      DO Recommended
        Status DUE
        Age 19y
        Delay 1m..2m from CALC:HPV_last_dose_date
      MESSAGES  MSG61
    END RULE 1
  END FOLDER 12

  FOLDER 13 "Two doses"
    IF CALC:HPV_doses_received = 2

    RULE 2 "[19-26y] old, 2 doses: To do 4m after LD"
      IF CALC:HPV_doses_received = 2
      DO Recommended
        Status DUE
        Age 19y
        Delay 4m from CALC:HPV_last_dose_date
    END RULE 2
  END FOLDER 13

  FOLDER 14 "Three doses and more"
    IF CALC:HPV_doses_received>=3

    RULE 1 "[19-26y] old  ≥3 doses: Up to date"
      IF CALC:HPV_doses_received>=3
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG11
    END RULE 1
  END FOLDER 14
END FOLDER 1

FOLDER 8 "Contraindications and special cases"

  FOLDER 81 "Contraindications"
  END FOLDER 81

  FOLDER 82 "Special cases"

    RULE 82/01 "[11-26y] old, Case  « Refusal to vaccinate against this disease » checked: Special case + message"
      WHEN Recommended
      IF ALL OF
        COND:C626 "Refusal of HPV vaccination" = true
        CALC:Age in 11y..26y
      DO Exception
      MESSAGES  MSG6 MSG7
    END RULE 82/01
  END FOLDER 82
END FOLDER 8

FOLDER 9 "Further information"

  RULE 9/01 "If to do, [11-18y] old: message vaccination scheme"
    WHEN Recommended
    IF CALC:Age in 11y..18y
    DO Neutral
    MESSAGES  MSG53
  END RULE 9/01

  RULE 9/01 "If to do, [19-26y] old: message vaccination scheme"
    WHEN Recommended
    IF CALC:Age in 19y..26y
    DO Neutral
    MESSAGES  MSG58
  END RULE 9/01
END FOLDER 9

END TARGET

MESSAGE MSG11 Summary ANY PRIO 0
  "Vaccination schedule completed."@en
 END MESSAGE MSG11

MESSAGE MSG60 Summary ANY PRIO 0
  "May be offered to young women and men aged 19 to 26 inclusive who are not yet immunized."@en
 END MESSAGE MSG60

MESSAGE MSG59 Justification ANY PRIO 0
  "Catch-up vaccination, for those who have not benefited from general preventive vaccination, can be offered by the attending physician. The latter then follows a vaccination schedule of 3 doses at 0, 1 or 2 and 6 months."@en
 END MESSAGE MSG59

MESSAGE MSG55 Summary ANY PRIO 0
  "Give a dose between 5 months and 13 months inclusive after the first dose."@en
 END MESSAGE MSG55

MESSAGE MSG6 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG6

MESSAGE MSG7 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been checked in the health profile (section “Refusal of vaccination”)."@en
 END MESSAGE MSG7

MESSAGE MSG53 Comments ANY PRIO 0
  "The schedule is 2 doses, with a 6-month interval between doses."@en
 END MESSAGE MSG53

MESSAGE MSG61 Summary ANY PRIO 0
  "Take a dose between 1 month and 2 months after the first dose."@en
 END MESSAGE MSG61

MESSAGE MSG58 Comments ANY PRIO 0
  "The schedule is 3 doses at 0, 1 or 2 and 6 months."@en
 END MESSAGE MSG58

MESSAGE MSG56 Summary ANY PRIO 0
  "First dose from the age of 12 years."@en
 END MESSAGE MSG56

MESSAGE MSG54 Justification ANY PRIO 0
  "The interval between the 2 doses is too short (less than 5 months). A 3rd dose is necessary."@en
 END MESSAGE MSG54
