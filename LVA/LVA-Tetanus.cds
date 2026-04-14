CALC T_doses_received IS HIST(T,0,count)
CALC T_last_dose_is_booster IS HIST(T,-1,booster)
CALC T_last_dose_date IS HIST(T,-1,date)
CALC T_age_at_last_dose IS INTERVAL(BASE:dob,CALC:T_last_dose_date)

TARGET Tetanus

FOLDER 0 "Common"

  FOLDER 01 "Zero dose"
    IF CALC:T_doses_received  = 0

    RULE 01/01 "0 dose: To do at 2m old"
      IF CALC:Age>=15d
      DO Recommended
        Status DUE
        Age 2m
    END RULE 01/01
  END FOLDER 01

  FOLDER 02 "Last dose is not a booster"
    IF CALC:T_last_dose_is_booster = false

    FOLDER 021 "One dose"
      IF CALC:T_doses_received  = 1

      RULE 021/01 "Booster-, 1 dose: To do from 4m old and 1m after LD"
        IF CALC:Age>=2m
        DO Recommended
          Status DUE
          Age 4m
          Delay 1m from CALC:T_last_dose_date 
      END RULE 021/01
    END FOLDER 021

    FOLDER 022 "Two doses"
      IF CALC:T_doses_received  = 2

      RULE 022/01 "Booster-, 2 doses: To do from 6m old and 1m after LD"
        IF CALC:Age>=2m
        DO Recommended
          Status DUE
          Age 6m
          Delay 1m from CALC:T_last_dose_date 
      END RULE 022/01
    END FOLDER 022

    FOLDER 023 "Three doses"
      IF CALC:T_doses_received  = 3

      RULE 023/01 "Booster-, 3 doses: To do from 12-15m old and 6m after LD"
        IF CALC:Age>=2m
        DO Recommended
          Status DUE
          Age 12m..15m
          Delay 6m from CALC:T_last_dose_date 
      END RULE 023/01
    END FOLDER 023

    FOLDER 024 "Four doses"
      IF CALC:T_doses_received  = 4

      RULE 024/01 "Booster-, 4 doses, Schoolchild-: To do from 7y old and 5y after LD"
        IF ALL OF
          CALC:Age>=2m
          COND:C1093 "School child" = false
        DO Recommended
          Status DUE
          Age 7y
          Delay 5y from CALC:T_last_dose_date 
      END RULE 024/01

      RULE 024/02 "Booster-, 4 doses, Schoolchild+: To do from 6y old and 5y after LD"
        IF ALL OF
          CALC:Age>=2m
          COND:C1093 "School child" = true
        DO Recommended
          Status DUE
          Age 6y
          Delay 5y from CALC:T_last_dose_date 
        MESSAGES  MSG29
      END RULE 024/02
    END FOLDER 024

    FOLDER 025 "Five doses"
      IF CALC:T_doses_received  = 5

      RULE 025/01 "Booster-, 5 doses: To do from 14y old and 5y after LD"
        IF CALC:Age>=2m
        DO Recommended
          Status DUE
          Age 14y
          Delay 5y from CALC:T_last_dose_date 
      END RULE 025/01
    END FOLDER 025
  END FOLDER 02

  FOLDER 03 "Last dose is a booster OR ≥ 6 doses"
    IF ANY OF
    CALC:T_last_dose_is_booster = true
    CALC:T_doses_received >=6

    RULE 03/01 "Booster+, LD [5-13y] old: DUE 14y old and 5y after LD"
      IF CALC:T_age_at_last_dose  in 5y..13y
      DO Recommended
        Status DUE
        Age 14y
        Delay 5y from CALC:T_last_dose_date 
    END RULE 03/01

    RULE 03/02 "Booster+, LD[14-19y] old: To do from 25y old"
      IF ALL OF
        CALC:Age>=2m
        CALC:T_age_at_last_dose  in 14y..19y
      DO Recommended
        Status DUE
        Age 25y
    END RULE 03/02

    RULE 03/04 "Booster+, LD ≥ 20y old: To do 10y after LD"
      IF CALC:T_age_at_last_dose >=20y
      DO Recommended
        Status DUE
        Delay 10y from CALC:T_last_dose_date 
      MESSAGES  MSG117
    END RULE 03/04
  END FOLDER 03

  FOLDER 08 "Contraindications and special cases"

    RULE 08/01 "Case  « Refusal to vaccinate against this disease » checked: Special case + message"
      IF COND:C613 "Refusal of vaccination against diphtheria-tetanus-polio and/or pertussis" = true
      DO Exception
      MESSAGES  MSG19 MSG20
    END RULE 08/01
  END FOLDER 08

  FOLDER 09 "Further information"

    RULE 09/01 "If to do, 0 dose: Mandatory vaccination"
      WHEN Recommended
      IF CALC:T_doses_received  = 0
      DO Neutral
      MESSAGES  MSG69
    END RULE 09/01

    RULE 9/02 "If To do, ≤ 4 doses, Booster-: message vaccination scheme"
      WHEN Recommended
      IF ALL OF
        CALC:Age>=1m
        CALC:T_doses_received <=4
        CALC:T_last_dose_is_booster = false
      DO Neutral
      MESSAGES  MSG131
    END RULE 9/02

    RULE 9/03 "If to do, ≤ 20m old: message to do with DTaP-IPV-Hib-HvB"
      WHEN Recommended
      IF CALC:Age<=20m
      DO Neutral
      MESSAGES  MSG134
    END RULE 9/03

    RULE 9/04 "If to do, [5-10y] old: message to do with DTaP-IPV"
      WHEN Recommended
      IF CALC:Age in 5y..10y
      DO Neutral
      MESSAGES  MSG135
    END RULE 9/04

    RULE 9/05 "If to do, [11-15y] old: message to do with Tdap-IPV"
      WHEN Recommended
      IF CALC:Age in 11y..15y
      DO Neutral
      MESSAGES  MSG136
    END RULE 9/05

    RULE 9/06 "If to do, ≥ 16y old: message to do with Td"
      WHEN Recommended
      IF CALC:Age>=16y
      DO Neutral
      MESSAGES  MSG137
    END RULE 9/06
  END FOLDER 09
END FOLDER 0
END TARGET

MESSAGE MSG29 Summary ANY PRIO 0
  "For schoolchildren, from the age of 6."@en
 END MESSAGE MSG29

MESSAGE MSG135 Other PRO PRIO 0
  "Vaccine recommended for use: DTaP-IPV.<br>
Ex : Infanrix-IPV, Tetraxim."@en
 END MESSAGE MSG135

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

MESSAGE MSG136 Other PRO PRIO 0
  "Vaccine recommended for use: Tdap-IPV.<br>
Ex : Boostrix Polio, Repevax."@en
 END MESSAGE MSG136

MESSAGE MSG131 Justification ANY PRIO 10
  "The primary vaccination schedule consists of 4 doses: 2, 4 and 6 months, then between 12 and 15 months. "@en
 END MESSAGE MSG131

MESSAGE MSG137 Other PRO PRIO 0
  "Vaccine recommended for use: Td.<br>
Ex : Td Pur."@en
 END MESSAGE MSG137

MESSAGE MSG69 Summary ANY PRIO 0
  "This vaccination is compulsory in Latvia, from the age of 2 months."@en
 END MESSAGE MSG69

MESSAGE MSG117 Summary ANY PRIO 0
  "Booster vaccination 10 years after the last dose."@en
 END MESSAGE MSG117
