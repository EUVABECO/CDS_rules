CALC Hib_doses_received IS HIST(Hib,0,count)
CALC Hib_last_dose_is_booster IS HIST(Hib,-1,booster)
CALC Hib_last_dose_date IS HIST(Hib,-1,date)


TARGET HiB

FOLDER 0 "Common (Hib-specific [15d-23m] old)"
  IF CALC:Age in 15d..23m

  FOLDER 01 "Zero dose"
    IF CALC:Hib_doses_received = 0

    RULE 01/01 "0 dose: To do at 2m old"
      IF CALC:Age>=15d
      DO Recommended
        Status DUE
        Age 2m
    END RULE 01/01
  END FOLDER 01

  FOLDER 02 "Last dose is not a booster"
    IF CALC:Hib_last_dose_is_booster = false

    FOLDER 021 "One dose"
      IF CALC:Hib_doses_received = 1

      RULE 021/01 "Booster-, 1 dose: To do from 4m old and 1m after LD"
        IF CALC:Age>=2m
        DO Recommended
          Status DUE
          Age 4m
          Delay 1m from CALC:Hib_last_dose_date
      END RULE 021/01
    END FOLDER 021

    FOLDER 022 "Two doses"
      IF CALC:Hib_doses_received = 2

      RULE 022/01 "Booster-, 2 doses: To do from 6m old and 1m after LD"
        IF CALC:Age>=2m
        DO Recommended
          Status DUE
          Age 6m
          Delay 1m from CALC:Hib_last_dose_date
      END RULE 022/01
    END FOLDER 022

    FOLDER 023 "Three doses"
      IF CALC:Hib_doses_received = 3

      RULE 023/01 "Booster-, 3 doses: To do from 12-15m old and 6m after LD"
        IF CALC:Age>=2m
        DO Recommended
          Status DUE
          Age 12m..15m
          Delay 6m from CALC:Hib_last_dose_date
      END RULE 023/01
    END FOLDER 023

    FOLDER 024 "Four doses"
      IF CALC:Hib_doses_received = 4

      RULE 024/01 "Booster-, 4 doses, [2-23m]: Up to date"
        IF CALC:Age in 2m..23m
        DO Recommended
          Status COMPLETED
      END RULE 024/01
    END FOLDER 024
  END FOLDER 02
END FOLDER 0

FOLDER 1 "≥ 24m Old"
  IF CALC:Age>=24m

  FOLDER 11 "Zéro dose"
    IF CALC:Hib_doses_received = 0

    RULE 12/01 "0 dose, [24-48m] old: Special case"
      IF CALC:Age in 24m..48m
      DO Exception
      MESSAGES  MSG131 MSG206
    END RULE 12/01
  END FOLDER 11

  FOLDER 12 "One to three doses"
    IF ALL OF
    CALC:Hib_doses_received>=1
    CALC:Hib_doses_received<=3
    CALC:Hib_last_dose_is_booster = false

    RULE 12/01 "Booster-, 1 to 3 doses, ≥ 24m: Special case"
      IF CALC:Age>=24m
      DO Exception
      MESSAGES  MSG131 MSG207
    END RULE 12/01
  END FOLDER 12

  FOLDER 13 "Four doses or more"
    IF ANY OF
    CALC:Hib_doses_received>=4
    CALC:Hib_last_dose_is_booster = true

    RULE 12/01 "≥ 4 doses or LD is a booster, ≥ 24m: Up to date"
      IF CALC:Age>=24m
      DO Recommended
        Status COMPLETED
    END RULE 12/01
  END FOLDER 13
END FOLDER 1

FOLDER 8 "Contraindications and special cases"

  RULE 08/01 "Case  « Refusal to vaccinate against this disease » checked: Special case + message"
    IF COND:C675 "Refusal of Haemophilus influenzae type b vaccination" = true
    DO Exception
    MESSAGES  MSG19 MSG20
  END RULE 08/01
END FOLDER 8

FOLDER 9 "Further information"

  RULE 09/01 "If to do, 0 dose: Mandatory vaccination"
    WHEN Recommended
    IF CALC:Hib_doses_received = 0
    DO Neutral
    MESSAGES  MSG69
  END RULE 09/01

  RULE 9/02 "If To do, ≤ 4 doses, Booster-: message vaccination scheme"
    WHEN Recommended
    IF ALL OF
      CALC:Age>=1m
      CALC:Hib_doses_received<=4
      CALC:Hib_last_dose_is_booster = false
    DO Neutral
    MESSAGES  MSG131
  END RULE 9/02

  RULE 9/03 "If to do, ≤ 20m old: message to do with DTaP-IPV-Hib-HvB"
    WHEN Recommended
    IF CALC:Age<=20m
    DO Neutral
    MESSAGES  MSG134
  END RULE 9/03
END FOLDER 9
END TARGET

MESSAGE MSG131 Justification ANY PRIO 10
  "The primary vaccination schedule consists of 4 doses: 2, 4 and 6 months, then between 12 and 15 months. "@en
 END MESSAGE MSG131

MESSAGE MSG207 Summary ANY PRIO 0
  "The vaccination programme for Haemophilus influenzae type B was started but not completed. The protection acquired is incomplete, and it is now too late to continue the vaccination schedule."@en
 END MESSAGE MSG207

MESSAGE MSG134 Other PRO PRIO 0
  "Vaccine recommended for use: DTaP-IPV-Hib-HvB.<br>
Ex : INFANRIX HEXA."@en
 END MESSAGE MSG134

MESSAGE MSG19 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG19

MESSAGE MSG20 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been ticked in the health profile (‘Refusal of vaccination’ section)."@en
 END MESSAGE MSG20

MESSAGE MSG206 Summary ANY PRIO 0
  "Vaccination against Haemophilus influenzae type B should have been given during the first year of life. It is now too late."@en
 END MESSAGE MSG206

MESSAGE MSG69 Summary ANY PRIO 0
  "This vaccination is compulsory in Latvia, from the age of 2 months."@en
 END MESSAGE MSG69
