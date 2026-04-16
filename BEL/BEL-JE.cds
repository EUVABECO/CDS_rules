CALC JE_doses_received IS HIST(JE,0,count)
CALC JE_vaccines_received IS HIST(JE,0,vaccine)
CALC JE_last_dose_date IS HIST(JE,-1,date)
CALC JE_time_since_last_dose IS INTERVAL(CALC:JE_last_dose_date,BASE:eval)

TARGET JE

FOLDER 1 "One dose"
  IF CALC:JE_doses_received = 1

  RULE 1/01 "[2m-2y] old, 1 dose IXIARO: To do 0,25 mL 28d after LD"
    IF ALL OF
      CALC:Age in 2m..2y
      CALC:JE_vaccines_received contains VAC0073 # IXIARO
    DO Recommended
      Status DUE
      Delay 28d from CALC:JE_last_dose_date
    MESSAGES  MSG291
  END RULE 1/01

  RULE 1/02 "[3-17y] old, 1 dose IXIARO: To do  0,5 mL 28d after LD"
    IF ALL OF
      CALC:Age in 3y..17y
      CALC:JE_vaccines_received contains VAC0073 # IXIARO
    DO Recommended
      Status DUE
      Delay 28d from CALC:JE_last_dose_date
    MESSAGES  MSG294
  END RULE 1/02

  RULE 1/03 "[18-65y] old, 1 dose IXIARO, d1 ≤ 7d: To do 0,5 mL 7d after LD (accelerated diagram) or 28d after LD (classic diagram)"
    IF ALL OF
      CALC:Age in 18y..65y
      CALC:JE_vaccines_received contains VAC0073 # IXIARO
      CALC:JE_time_since_last_dose<=7d
    DO Recommended
      Status DUE
      Delay 7d from CALC:JE_last_dose_date
    MESSAGES  MSG293
  END RULE 1/03

  RULE 1/04 "[18-65y] old, 1 dose IXIARO, d1 ≥ 8d: To do 0,5 mL 28d after LD (classic diagram)"
    IF ALL OF
      CALC:Age in 18y..65y
      CALC:JE_vaccines_received contains VAC0073 # IXIARO
      CALC:JE_time_since_last_dose>=8d
    DO Recommended
      Status DUE
      Delay 28d from CALC:JE_last_dose_date
    MESSAGES  MSG294
  END RULE 1/04

  RULE 1/05 "≥ 66y old, 1 dose IXIARO: To do 0,5 mL 28d after LD"
    IF ALL OF
      CALC:Age>=66y
      CALC:JE_vaccines_received contains VAC0073 # IXIARO
    DO Recommended
      Status DUE
      Delay 28d from CALC:JE_last_dose_date
    MESSAGES  MSG294
  END RULE 1/05
END FOLDER 1

FOLDER 2 "Two doses"
  IF CALC:JE_doses_received = 2

  RULE 2/01 "[12m-2y] old, 2 doses IXIARO: Possible"
    IF ALL OF
      CALC:Age in 12m..2y
      CALC:JE_vaccines_received contains VAC0073 # IXIARO
    DO Suggested
    MESSAGES  MSG290
  END RULE 2/01

  RULE 2/02 "≥ 3y old,  2 doses IXIARO: Possible"
    IF ALL OF
      CALC:Age>=3y
      CALC:JE_vaccines_received contains VAC0073 # IXIARO
    DO Suggested
    MESSAGES  MSG292
  END RULE 2/02
END FOLDER 2

FOLDER 8 "Contraindications and special cases"
END FOLDER 8

FOLDER 9 "Further information"

  RULE 9/01 "If DUE, 1 dose IXIARO: Message"
    WHEN Recommended
    IF ALL OF
      CALC:JE_doses_received = 1
      CALC:JE_vaccines_received contains VAC0073 # IXIARO
    DO Neutral
    MESSAGES  MSG295
  END RULE 9/01
END FOLDER 9
END TARGET

MESSAGE MSG294 Summary ANY PRIO 0
  "Give a dose of 0.5 mL 28 days after the initial dose with IXIARO vaccine."@en
 END MESSAGE MSG294

MESSAGE MSG292 Summary ANY PRIO 0
  "If the risk persists, give a booster dose of 0.5 mL between 12 and 24 months after the second dose with the IXIARO vaccine."@en
 END MESSAGE MSG292

MESSAGE MSG290 Summary ANY PRIO 0
  "If the risk persists, give a booster dose of 0.25 mL between 12 and 24 months after the second dose with the IXIARO vaccine."@en
 END MESSAGE MSG290

MESSAGE MSG291 Summary ANY PRIO 0
  "Give a dose of 0.25 mL 28 days after the initial dose with IXIARO vaccine."@en
 END MESSAGE MSG291

MESSAGE MSG293 Summary ANY PRIO 0
  "Take a dose of 0.5 mL 7 days after the initial dose with the IXIARO vaccine - accelerated schedule - or 28 days after the initial dose for the classic schedule."@en
 END MESSAGE MSG293

MESSAGE MSG295 Comments ANY PRIO 0
  "Regardless of the vaccination schedule adopted, primary vaccination must be completed at least one week before potential exposure to the Japanese encephalitis virus."@en
 END MESSAGE MSG295
