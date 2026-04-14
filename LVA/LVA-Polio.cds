CALC Polio_doses_received IS HIST(POLIO,0,count)
CALC Polio_last_dose_date IS HIST(POLIO,-1,date)
CALC Polio_age_at_last_dose IS INTERVAL(BASE:dob,CALC:Polio_last_dose_date)
CALC Polio_last_dose_booster IS HIST(POLIO,-1,booster)

SYNTH Polio_UTD4 IS ALL OF
 CALC:Polio_doses_received >= 4
 CALC:Polio_age_at_last_dose >= 4y

SYNTH Polio_UTD3 IS ALL OF
 INTERVAL(HIST(POLIO,1,date),HIST(POLIO,2,date)) >= 3w
 INTERVAL(HIST(POLIO,2,date),HIST(POLIO,3,date)) >= 5m
 CALC:Age >= 18y
 
SYNTH Polio_UTD "POLIO Up-to-date: booster or ≥ 4 doses and age LD ≥ 4 years" IS ANY OF
 CALC:Polio_last_dose_booster = true
 SYNTH:Polio_UTD4 = true
 SYNTH:Polio_UTD3 = true
 
TARGET Polio
FOLDER - "General rules"
END FOLDER -

FOLDER 01 "Zero dose"
  IF CALC:Polio_doses_received = 0

  RULE 01/01 "0 dose: To do at 2m old"
    IF CALC:Age>=15d
    DO Recommended
      Status DUE
      Age 2m
  END RULE 01/01
END FOLDER 01

FOLDER 02 "Up-to-date"
  IF ANY OF
  CALC:Polio_last_dose_booster = true
  SYNTH:Polio_UTD = true

  RULE 02/01 "Booster-, 4 doses, LD ≥ age 4: up-to-date"
    IF CALC:Polio_age_at_last_dose>=4y
    DO Recommended
      Status COMPLETED
  END RULE 02/01
END FOLDER 02

FOLDER 03 "Not up-to-date and ≥ 1 dose"
  IF ALL OF
  SYNTH:Polio_UTD = false
  CALC:Polio_doses_received>=1

  FOLDER 031 "One dose"
    IF CALC:Polio_doses_received = 1

    RULE 031/01 "Booster-, 1 dose: To do from 4m old and 1m after LD"
      IF CALC:Age>=2m
      DO Recommended
        Status DUE
        Age 4m
        Delay 1m from CALC:Polio_last_dose_date
    END RULE 031/01
  END FOLDER 031

  FOLDER 032 "Two doses"
    IF CALC:Polio_doses_received = 2

    RULE 032/01 "Booster-, 2 doses: To do from 6m old and 1m after LD"
      IF CALC:Age>=2m
      DO Recommended
        Status DUE
        Age 6m
        Delay 1m from CALC:Polio_last_dose_date
    END RULE 032/01
  END FOLDER 032

  FOLDER 033 "Three doses"
    IF CALC:Polio_doses_received = 3

    RULE 033/01 "Booster-, 3 doses: To do from 12-15m old and 6m after LD"
      IF CALC:Age>=2m
      DO Recommended
        Status DUE
        Age 12m..15m
        Delay 6m from CALC:Polio_last_dose_date
    END RULE 033/01
  END FOLDER 033

  FOLDER 034 "≥ Four doses"
    IF CALC:Polio_doses_received>=4

    RULE 034/01 "Booster-, ≥ 4 doses, Not Up to date, Schoolchild-: To do from 7y old and 5y after LD"
      IF ALL OF
        CALC:Age>=2m
        COND:C1093 "School child" = false
      DO Recommended
        Status DUE
        Age 7y
        Delay 5y from CALC:Polio_last_dose_date
    END RULE 034/01

    RULE 034/02 "Booster-, ≥ 4 doses, Not Up to date, Schoolchild+: To do from 6y old and 5y after LD"
      IF ALL OF
        CALC:Age>=2m
        COND:C1093 "School child" = true
      DO Recommended
        Status DUE
        Age 6y
        Delay 5y from CALC:Polio_last_dose_date
      MESSAGES  MSG29
    END RULE 034/02
  END FOLDER 034
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
    IF CALC:Polio_doses_received = 0
    DO Neutral
    MESSAGES  MSG69
  END RULE 09/01

  RULE 09/02 "If To do, ≤ 4 doses, Booster-: message vaccination scheme"
    WHEN Recommended
    IF ALL OF
      CALC:Age<=23m
      CALC:Polio_doses_received<=4
      CALC:Polio_last_dose_booster = false
    DO Neutral
    MESSAGES  MSG131
  END RULE 09/02

  RULE 09/03 "If To do, ≤ 4 doses, Booster-: message vaccination scheme"
    WHEN Recommended
    IF ALL OF
      CALC:Age>=24m
      CALC:Polio_doses_received<=4
      CALC:Polio_last_dose_booster = false
    DO Neutral
    MESSAGES  MSG26
  END RULE 09/03

  RULE 09/03.1 "If To do, ≤ 4 doses, Booster-: message vaccination scheme"
    WHEN Recommended
    IF ALL OF
      CALC:Age>=24m
      CALC:Polio_doses_received>=4
      CALC:Polio_last_dose_booster = false
      CALC:Polio_age_at_last_dose<=3y
    DO Neutral
    MESSAGES  MSG99
  END RULE 09/03.1

  RULE 09/04 "If to do, ≤ 20m old: message to do with DTaP-IPV-Hib-HvB"
    WHEN Recommended
    IF CALC:Age<=20m
    DO Neutral
    MESSAGES  MSG134
  END RULE 09/04

  RULE 09/05 "If to do, [5-10y] old: message to do with DTaP-IPV"
    WHEN Recommended
    IF CALC:Age in 5y..10y
    DO Neutral
    MESSAGES  MSG135
  END RULE 09/05

  RULE 09/06 "If to do, [11-16y] old: message to do with Tdap-IPV"
    WHEN Recommended
    IF CALC:Age in 11y..16y
    DO Neutral
    MESSAGES  MSG136
  END RULE 09/06
END FOLDER 09
END TARGET

MESSAGE MSG29 Summary ANY PRIO 0
  "For schoolchildren, from the age of 6."@en
 END MESSAGE MSG29

MESSAGE MSG26 Comments ANY PRIO 0
  "Vaccination schedule: 3 doses of primary vaccination 1 month apart, followed by 1 booster dose 6 months later."@en
 END MESSAGE MSG26

MESSAGE MSG99 Justification ANY PRIO 0
  "The last dose was given before the age of 4: an additional dose is required to obtain long-term protection."@en
 END MESSAGE MSG99

MESSAGE MSG19 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG19

MESSAGE MSG20 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been ticked in the health profile (‘Refusal of vaccination’ section)."@en
 END MESSAGE MSG20

MESSAGE MSG135 Other PRO PRIO 0
  "Vaccine recommended for use: DTaP-IPV.<br>
Ex : Infanrix-IPV, Tetraxim."@en
 END MESSAGE MSG135

MESSAGE MSG134 Other PRO PRIO 0
  "Vaccine recommended for use: DTaP-IPV-Hib-HvB.<br>
Ex : INFANRIX HEXA."@en
 END MESSAGE MSG134

MESSAGE MSG131 Justification ANY PRIO 10
  "The primary vaccination schedule consists of 4 doses: 2, 4 and 6 months, then between 12 and 15 months. "@en
 END MESSAGE MSG131

MESSAGE MSG136 Other PRO PRIO 0
  "Vaccine recommended for use: Tdap-IPV.<br>
Ex : Boostrix Polio, Repevax."@en
 END MESSAGE MSG136

MESSAGE MSG69 Summary ANY PRIO 0
  "This vaccination is compulsory in Latvia, from the age of 2 months."@en
 END MESSAGE MSG69
