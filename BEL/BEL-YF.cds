CALC YF_doses_received IS HIST(YF,0,count)

TARGET YF
FOLDER 1 "One dose"

  RULE 1/01 "≥ 6m old, 1 dose: Up to date"
    IF ALL OF
      CALC:YF_doses_received = 1
      CALC:Age>=6m
    DO Recommended
      Status COMPLETED
    MESSAGES  MSG245
  END RULE 1/01
END FOLDER 1

FOLDER 2 "Two doses or more"

  RULE 2/01 "≥ 6m old, ≥ 2 doses: Up to date"
    IF ALL OF
      CALC:Age>=6m
      CALC:YF_doses_received>=2
    DO Recommended
      Status COMPLETED
    MESSAGES  MSG246
  END RULE 2/01
END FOLDER 2

FOLDER 8 "Contraindications and special cases"

  RULE 8/01 "Case « Contraindication to yellow fever » checked: Contraindication + message"
    IF COND:C1013 "Contraindication to yellow fever vaccination" = true
    DO Contraindicated
    MESSAGES  MSG14 MSG15
  END RULE 8/01

  RULE 8/02 "Risk factors contraindicating vaccination with live viruses: Contraindication + message"
    IF SYNTH:COMMON-RF-ID "COMMON-RF-ID - ID risk factors contraindicating vaccination with live vaccines" = true
    DO Contraindicated
    MESSAGES  MSG34 MSG35
  END RULE 8/02

  RULE 8/03 "Pregnancy in progress: Contraindication + message"
    IF SYNTH:PREGNANCY_ONGOING "COMMON-PREGNANCY - Pregnancy in progress" = true
    DO Contraindicated
    MESSAGES  MSG16 MSG17
  END RULE 8/03

  RULE 8/04 "Case  « Refusal to vaccinate against this disease » checked: Special case + message"
    IF COND:C621 "Refusal of yellow fever vaccination" = true
    DO Exception
    MESSAGES  MSG6 MSG7
  END RULE 8/04
END FOLDER 8
END TARGET

MESSAGE MSG245 Summary ANY PRIO 0
  "An additional dose may be recommended in certain cases."@en
 END MESSAGE MSG245

MESSAGE MSG14 Alert ANY PRIO 0
  "Vaccination contraindicated by the doctor."@en
 END MESSAGE MSG14

MESSAGE MSG15 Justification ANY PRIO 0
  "The box indicating a contraindication for this disease has been checked in the health profile (section “Contraindicated vaccinations”)."@en
 END MESSAGE MSG15

MESSAGE MSG246 Summary ANY PRIO 0
  "An additional dose may be recommended in certain cases (immunosuppression)."@en
 END MESSAGE MSG246

MESSAGE MSG16 Justification ANY PRIO 0
  "Pregnancy temporarily contraindicates the use of live virus vaccines, such as measles, rubella, mumps, varicella, or yellow fever vaccines."@en
 END MESSAGE MSG16

MESSAGE MSG17 Alert ANY PRIO 0
  "Pregnancy temporarily contraindicates the use of live virus vaccines."@en
 END MESSAGE MSG17

MESSAGE MSG34 Justification ANY PRIO 0
  "Immunodeficiency contraindicates the use of live virus vaccines, such as measles, mumps, rubella, varicella or yellow fever vaccines."@en
 END MESSAGE MSG34

MESSAGE MSG35 Alert ANY PRIO 0
  "Immunodeficiency contraindicates the use of live virus vaccines."@en
 END MESSAGE MSG35

MESSAGE MSG6 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG6

MESSAGE MSG7 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been checked in the health profile (section “Refusal of vaccination”)."@en
 END MESSAGE MSG7

MESSAGE MSG346 Details PATIENT PRIO 0
  "--"@en
 END MESSAGE MSG346
