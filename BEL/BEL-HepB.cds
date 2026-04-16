CALC HepB_doses_received IS HIST(HepB,0,count)
CALC HepB_last_dose_is_booster IS HIST(HepB,-1,booster)
CALC HepB_last_dose_date IS HIST(HepB,-1,date)
CALC HepB_last_dose_age IS INTERVAL(BASE:dob,CALC:HepB_last_dose_date)
CALC HepB_penultimate_dose_date IS HIST(HepB,-2,date)

SYNTH HVB-RF-ALL "HVB-RF-ALL - Medical and Pro risk factors" IS ANY OF
  SYNTH:HVB-RF-MED  "Medical risk factors for hepatitis B" = true
  SYNTH:HVB-RF-PRO  "Profesional risk factors for hepatitis B" = true
  
SYNTH HVB-RF-MED "HVB-RF-MED - Medical risk factors for hepatitis B" IS ANY OF
  COND:C20 "Person likely to receive massive or iterative transfusions" = true
  COND:C19 "Waiting for an organ transplant (kidney, heart, liver or lung)" = true
  COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)" >= 1d
  COND:C932 "Date of a solid organ transplant (kidney, heart, liver or lungs)" >= 1d
  COND:123 "Sexual partner of a person infected with the hepatitis B virus " = true
  COND:121 "Multiple sexual partners " = true
  COND:114 "Parenteral drug abuse " = true
  COND:122 "Person infected with the hepatitis B virus or chronic carrier of the HBs antigen in the entourage " = true
  COND:41 "Chronic liver disease " = true
  COND:686 "Current or recent sexually transmitted infection (STI)" = true
  COND:957 "Major neuro-cognitive deficit " = true
  COND:958 "Diabetes " = true

SYNTH HVB-RF-PRO "HVB-RF-PRO - Profesional risk factors for hepatitis B" IS ANY OF
  COND:C249 "Works in a medical biology laboratory" = true
  COND:C56 "Physician" = true
  COND:C61 "Dental surgeon" = true
  COND:C62 "Nurse" = true
  COND:C662 "Thanatopractor" = true
  
 TARGET HepB
FOLDER 0 "Newborns of mothers infected with hepatitis B virus +"
  IF COND:C15 "Newborn of a mother with HBsAg" = true

  FOLDER 00 "Zero dose and age ≤ 6d"
    IF ALL OF
    CALC:HepB_doses_received = 0
    CALC:Age<=6d

    RULE 00/01 "Mother HBs+, 0 dose: To do within 12 hours of delivery"
      IF CALC:Age<=6d
      DO Recommended
        Status DUE
        Age 1d
      MESSAGES  MSG82
    END RULE 00/01
  END FOLDER 00

  FOLDER 01 "One dose"
    IF CALC:HepB_doses_received = 1

    RULE 01/01 "Mother HBs+, 1 dose: To do from 2m old"
      IF CALC:Age>=1w
      DO Recommended
        Status DUE
        Age 2m
    END RULE 01/01
  END FOLDER 01

  FOLDER 02 "Two dose"
    IF CALC:HepB_doses_received = 2

    RULE 02/01 "Mother HBs+, 2 doses: To do from 3m old and 1m after LD"
      IF CALC:Age>=2m
      DO Recommended
        Status DUE
        Age 3m
        Delay 1m from CALC:HepB_last_dose_date
    END RULE 02/01
  END FOLDER 02

  FOLDER 03 "Three doses"
    IF CALC:HepB_doses_received = 3

    RULE 03/01 "Mother HBs+, 3 doses: To do from 4m old and 1m after LD"
      IF CALC:Age>=2m
      DO Recommended
        Status DUE
        Age 4m
        Delay 1m from CALC:HepB_last_dose_date
    END RULE 03/01
  END FOLDER 03

  FOLDER 04 "Four doses"
    IF CALC:HepB_doses_received = 4

    RULE 04/01 "Mother HBs+, 4 doses: To do from 15m old and 6m after LD"
      IF CALC:Age>=2m
      DO Recommended
        Status DUE
        Age 15m
        Delay 6m from CALC:HepB_last_dose_date
    END RULE 04/01
  END FOLDER 04

  FOLDER 05 "Five doses and more"
    IF CALC:HepB_doses_received>=5

    RULE 05/01 "Mother HBs+, ≥ 5 doses: Up to date"
      IF CALC:Age>=2m
      DO Recommended
        Status COMPLETED
    END RULE 05/01
  END FOLDER 05
END FOLDER 0

FOLDER 1 "Newborns of mothers infected with hepatitis B virus - AND ≤ 23m old"
  IF ALL OF
  CALC:Age<=23m
  COND:C15 "Newborn of a mother with HBsAg" = false

  FOLDER 1 "Zero dose"
    IF CALC:HepB_doses_received = 0

    RULE 01/01 "0 dose: To do at 2m old"
      IF CALC:Age>=15d
      DO Recommended
        Status DUE
        Age 2m
    END RULE 01/01
  END FOLDER 1

  FOLDER 2 "Last dose is not a booster"
    IF CALC:HepB_last_dose_is_booster = false

    FOLDER 21 "One dose"
      IF CALC:HepB_doses_received = 1

      RULE 21/01 "Booster-, 1 dose: To do from 3m old and 1m after LD"
        IF CALC:Age>=2m
        DO Recommended
          Status DUE
          Age 3m
          Delay 1m from CALC:HepB_last_dose_date
      END RULE 21/01
    END FOLDER 21

    FOLDER 22 "Two doses"
      IF CALC:HepB_doses_received = 2

      RULE 22/01 "Booster-, 2 doses: To do from 4m old and 1m after LD"
        IF CALC:Age>=2m
        DO Recommended
          Status DUE
          Age 4m
          Delay 1m from CALC:HepB_last_dose_date
      END RULE 22/01
    END FOLDER 22

    FOLDER 23 "Three doses"
      IF CALC:HepB_doses_received = 3

      RULE 23/01 "Booster-, 3 doses: To do from 15m old and 6m after LD"
        IF CALC:Age>=2m
        DO Recommended
          Status DUE
          Age 15m
          Delay 6m from CALC:HepB_last_dose_date
      END RULE 23/01
    END FOLDER 23

    FOLDER 24 "Four doses or more"
      IF CALC:HepB_doses_received>=4

      RULE 24/01 "Booster-, ≥ 4 doses, [0-23m]: Up to date"
        IF CALC:Age in 2m..24m
        DO Recommended
          Status COMPLETED
      END RULE 24/01
    END FOLDER 24
  END FOLDER 2
END FOLDER 1

FOLDER 2 "[24m-10y] old"
  IF CALC:Age in 24m..10y

  RULE 2/01 "[24m-10y] old, [1-2] doses: Unfinished diagram - To do from 11y old, 6m after LD"
    IF ALL OF
      CALC:HepB_doses_received>=1
      CALC:HepB_doses_received<=2
    DO Recommended
      Status DUE
      Age 11y
      Delay 6m from CALC:HepB_last_dose_date
    MESSAGES  MSG154
  END RULE 2/01

  RULE 2/02 "[24m-10y] old, ≥ 3 doses: Up to date"
    IF CALC:HepB_doses_received>=3
    DO Recommended
      Status COMPLETED
  END RULE 2/02
END FOLDER 2

FOLDER 3 "[11-15y] old"
  IF CALC:Age in 11y..15y

  FOLDER 31 "Zero dose"
    IF CALC:HepB_doses_received = 0

    RULE 31/01 "[11-15y] old, 0 dose: To do at 11y with adult vaccine"
      IF CALC:Age>=11y
      DO Recommended
        Status DUE
        Age 11y
    END RULE 31/01
  END FOLDER 31

  FOLDER 32 "Last dose is not a booster"
    IF CALC:HepB_last_dose_is_booster = false

    FOLDER 321 "One dose"
      IF CALC:HepB_doses_received = 1

      RULE 321/01 "[11-15y] old, Booster-, 1 dose: To do 6m after LD (schema 0-6 with ENGERIX)"
        IF CALC:HepB_doses_received = 1
        DO Recommended
          Status DUE
          Delay 6m from CALC:HepB_last_dose_date
      END RULE 321/01
    END FOLDER 321

    FOLDER 322 "Two doses or more"
      IF CALC:HepB_doses_received>=2

      RULE 322/01 "[11-15y] old, Booster-, ≥ 2 doses, LD ≤ 10y old: To do 6m after LD"
        IF CALC:HepB_last_dose_age<=10y
        DO Recommended
          Status DUE
          Delay 6m from CALC:HepB_last_dose_date
      END RULE 322/01

      RULE 322/02 "[11-15y] old, Booster-, ≥ 2 doses, LD ≥ 11y old: Up to date"
        IF CALC:HepB_last_dose_age>=11y
        DO Recommended
          Status COMPLETED
      END RULE 322/02
    END FOLDER 322
  END FOLDER 32
END FOLDER 3

FOLDER 4 "16y old and more - RF+"
  IF ALL OF
  CALC:Age>=16y
  SYNTH:HVB-RF-ALL = true

  FOLDER 41 "Zero dose"
    IF CALC:HepB_doses_received = 0

    RULE 41/01 "≥ 16y old, 0 dose: To do ASAP"
      IF CALC:Age>=16y
      DO Recommended
        Status DUE
        Age 16y
    END RULE 41/01
  END FOLDER 41

  FOLDER 42 "Last dose is not a booster"
    IF CALC:HepB_last_dose_is_booster = false

    FOLDER 421 "One dose"
      IF CALC:HepB_doses_received = 1

      RULE 421/01 "≥ 16y old, Booster-, 1 dose: To do 1m after LD (schema 0-1-6 with ENGERIX or HBVaxPro)"
        IF CALC:Age>=16y
        DO Recommended
          Status DUE
          Delay 1m from CALC:HepB_last_dose_date
      END RULE 421/01
    END FOLDER 421

    FOLDER 422 "Two doses"
      IF CALC:HepB_doses_received = 2

      RULE 422/01 "≥ 16y old, Booster-, 2 doses: To do 1m after LD (schema 0-1-6 with ENGERIX or HBVaxPro)"
        IF CALC:Age>=16y
        DO Recommended
          Status DUE
          Delay 1m from CALC:HepB_last_dose_date
      END RULE 422/01

      RULE 422/02 "≥ 16y old, Booster-, 2 doses: To do 6m after d1 (schema 0-1-6 with ENGERIX or HBVaxPro)"
        IF CALC:Age>=11y
        DO Recommended
          Status DUE
          Delay 6m from CALC:HepB_penultimate_dose_date
      END RULE 422/02
    END FOLDER 422

    FOLDER 423 "Three doses or more"
      IF CALC:HepB_doses_received>=3

      RULE 423/01 "≥ 16y old, Booster-, ≥ 3 doses: Up to date"
        IF CALC:Age>=16y
        DO Recommended
          Status COMPLETED
      END RULE 423/01
    END FOLDER 423
  END FOLDER 42
END FOLDER 4

FOLDER 5 "Common"

  RULE 5/01 "≥ 24m, Booster+: Up to date"
    IF ALL OF
      CALC:Age>20m
      CALC:HepB_last_dose_is_booster = true
    DO Recommended
      Status COMPLETED
  END RULE 5/01
END FOLDER 5

FOLDER 8 "Contraindications and special cases"

  RULE 8/01 "Case  « Refusal to vaccinate against this disease » checked: Special case + message"
    IF COND:C614 "Refusal to vaccinate against hepatitis B" = true
    DO Exception
    MESSAGES  MSG6 MSG7
  END RULE 8/01
END FOLDER 8

FOLDER 9 "Further information"

  RULE 9/01 "If To do, ≤ 4 doses, Booster-, ≤ 24m old: message vaccination scheme"
    WHEN Recommended
    IF ALL OF
      CALC:Age in 15d..23m
      CALC:HepB_doses_received<=4
      CALC:HepB_last_dose_is_booster = false
    DO Neutral
    MESSAGES  MSG5
  END RULE 9/01

  RULE 9/02 "If To do, newborns of mothers infected with hepatitis B virus: message vaccination scheme"
    WHEN Recommended
    IF ALL OF
      CALC:HepB_doses_received<=4
      COND:C15 "Newborn of a mother with HBsAg" = true
    DO Neutral
    MESSAGES  MSG83
  END RULE 9/02

  RULE 9/03 "If to do, [8d-20m] old: message to do with DTaP-IPV-Hib-HvB"
    WHEN Recommended
    IF CALC:Age in 8d..20m
    DO Neutral
    MESSAGES  MSG3
  END RULE 9/03

  RULE 9/04 "If to do, ≤ 7d old, 0 dose, Mother Hbs+: message to do with Engerix B10"
    WHEN Recommended
    IF ALL OF
      CALC:Age<=7d
      CALC:HepB_doses_received = 0
      COND:C15 "Newborn of a mother with HBsAg" = true
    DO Neutral
    MESSAGES  MSG151
  END RULE 9/04

  RULE 9/05 "If To do, ≤ 3 doses, Booster-, ≥ 16y old: message vaccination scheme (0-1-6)"
    WHEN Recommended
    IF ALL OF
      CALC:HepB_doses_received<=3
      CALC:HepB_last_dose_is_booster = false
      CALC:Age>=16y
    DO Neutral
    MESSAGES  MSG79
  END RULE 9/05

  RULE 9/06 "If To do, [11-15y] old, 0 dose: Message = Information + vaccine recommended for use"
    WHEN Recommended
    IF ALL OF
      CALC:Age in 11y..15y
      CALC:HepB_doses_received = 0
    DO Neutral
    MESSAGES  MSG152 MSG80
  END RULE 9/06

  RULE 9/061 "If To do, [11-15y] old, ≥1 dose, LD ≥ 11y old: Message = Information + vaccine recommended for use"
    WHEN Recommended
    IF ALL OF
      CALC:Age in 11y..15y
      CALC:HepB_doses_received>=1
      CALC:HepB_last_dose_age>=11y
    DO Neutral
    MESSAGES  MSG152 MSG80
  END RULE 9/061

  RULE 9/062 "If To do, [11-15y] old, ≥1 dose, LD ≤ 10y old: Message = Information + vaccine recommended for use"
    WHEN Recommended
    IF ALL OF
      CALC:Age in 11y..15y
      CALC:HepB_doses_received>=1
      CALC:HepB_last_dose_age<=10y
    DO Neutral
    MESSAGES  MSG153 MSG80
  END RULE 9/062

  RULE 9/07 "If To do, ≥ 16y old: Message = Vaccine recommended for use"
    WHEN Recommended
    IF CALC:Age>=16y
    DO Neutral
    MESSAGES  MSG80
  END RULE 9/07

  RULE 9/08 "If To do, ≥ 16y old, Pro+: Message = mandatory vaccination against hepatitis B"
    IF ALL OF
      CALC:Age>=16y
      SYNTH:HVB-RF-PRO "HVB-RF-PRO - Profesional risk factors for hepatitis B" = true
    DO Neutral
    MESSAGES  MSG150
  END RULE 9/08
END FOLDER 9
END TARGET

MESSAGE MSG3 Other PRO PRIO 0
  "Vaccines that can be used: Vaxelis, Hexyon (DTaP-IPV-Hib-HvB)"@en
 END MESSAGE MSG3

MESSAGE MSG80 Other ANY PRIO 0
  "Vaccines that can be used: ENGERIX B."@en
 END MESSAGE MSG80

MESSAGE MSG82 Summary ANY PRIO 0
  "A dose of vaccine, within 12 hours of delivery and specific gamma globulins."@en
 END MESSAGE MSG82

MESSAGE MSG153 Justification ANY PRIO 0
  "A single-dose catch-up vaccination is planned for children and adolescents aged 11 to 15 who have not been fully vaccinated. The adult vaccine is then used."@en
 END MESSAGE MSG153

MESSAGE MSG346 Details PATIENT PRIO 0
  "--"@en
 END MESSAGE MSG346

MESSAGE MSG150 Justification ANY PRIO 0
  "In Belgium, vaccination against hepatitis B was made mandatory by royal decree in 1999 for all workers in services where examinations, medical or dental care are carried out. It concerns all persons who, through their profession, come into contact with blood or are exposed to a risk of contamination, namely:<br>
- Laboratory staff,<br>
- Nurses,<br>
- Doctors,<br>
- Staff responsible for embalming the deceased within funeral directors."@en
 END MESSAGE MSG150

MESSAGE MSG83 Justification ANY PRIO 0
  "To protect newborns of mothers infected with the hepatitis B virus, the following are injected:<br>
- 1 dose of vaccine, within 12 hours of delivery and specific gamma globulins;<br>
- 4 doses of a hexavalent vaccine (infant vaccination schedule)."@en
 END MESSAGE MSG83

MESSAGE MSG152 Justification ANY PRIO 0
  "A catch-up vaccination in 2 doses 6 months apart is planned for children and adolescents aged 11 to 15 who are not vaccinated. The adult vaccine is then used."@en
 END MESSAGE MSG152

MESSAGE MSG5 Comments ANY PRIO 0
  "The infant vaccination schedule includes a 3-dose primary vaccination (2, 3 and 4 months), followed by a booster dose at 15 months."@en
 END MESSAGE MSG5

MESSAGE MSG6 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG6

MESSAGE MSG7 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been checked in the health profile (section “Refusal of vaccination”)."@en
 END MESSAGE MSG7

MESSAGE MSG79 Comments ANY PRIO 0
  "The primary vaccination schedule is 3 doses: 0, 1, 6 months (two injections one month apart, followed by a third dose six months after the first injection)."@en
 END MESSAGE MSG79

MESSAGE MSG154 Justification ANY PRIO 0
  "For children whose vaccination schedule has not been completed, a catch-up with a dose of adult vaccine is planned between the ages of 11 and 15."@en
 END MESSAGE MSG154

MESSAGE MSG151 Other PRO PRIO 0
  "Vaccines that can be used: Engerix B junior."@en
 END MESSAGE MSG151
