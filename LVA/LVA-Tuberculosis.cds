CALC Tub_doses_received IS HIST(BCG,0,count)

SYNTH Tub_Test_done IS ANY OF COND:C988 "IDR(mm)" >= 0

TARGET Tuberculosis
FOLDER 1 "Zero dose - ≤ 15y old"
  IF ALL OF
  CALC:Tub_doses_received = 0
  CALC:Age<=15y

  FOLDER 11 " ≤ 1 month old"
    IF CALC:Age<=1m

    RULE 11/01 "0 dose, ≤1m old: To do  from birth"
      IF ALL OF
        CALC:Age<=1m
        CALC:Tub_doses_received = 0
      DO Recommended
        Status OVERDUE
    END RULE 11/01
  END FOLDER 11

  FOLDER 12 " ≥ 2 months old"
    IF CALC:Age>=2m

    FOLDER 121 "TST is not done"
      IF SYNTH:Tub_Test_done = false

      RULE 121/01 "≥ 2m old , TST not done: Special case - Start with a tuberculin test"
        IF CALC:Age>=2m
        DO Exception
        MESSAGES  MSG72 MSG71
      END RULE 121/01
    END FOLDER 121

    FOLDER 122 "TST done"
      IF SYNTH:Tub_Test_done = true

      RULE 122/01 "≥ 2m old , TST ≤ 5 mm: To do ASAP"
        IF COND:C988 "IDR (mm)"<=6
        DO Recommended
          Status OVERDUE
      END RULE 122/01

      RULE 122/02 "≥ 2m old , TST ≥ 6 mm: Special case - Carry out a work-up"
        IF COND:C988 "IDR (mm)">=6
        DO Exception
        MESSAGES  MSG31
      END RULE 122/02
    END FOLDER 122
  END FOLDER 12
END FOLDER 1

FOLDER 2 "One dose or more"
  IF CALC:Tub_doses_received>=1

  RULE 2/01 "1 dose: Up to date"
    IF CALC:Tub_doses_received>=1
    DO Recommended
      Status COMPLETED
  END RULE 2/01
END FOLDER 2

FOLDER 8 "Contraindications and special cases"

  FOLDER 81 "Contraindications"

    RULE 81/01 "ID: Contraindication"
      IF SYNTH:COMMON-RF-ID "COMMON-RF-ID - ID risk factors contraindicating vaccination with live vaccines" = true
      DO Contraindicated
      MESSAGES  MSG227
    END RULE 81/01

    RULE 81/02 "HIV: Contraindication"
      IF COND:C24 "HIV infection" = true
      DO Contraindicated
      MESSAGES  MSG228
    END RULE 81/02

    RULE 81/03 "HSCT: Contraindication"
      IF COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)">=1d
      DO Contraindicated
      MESSAGES  MSG337
    END RULE 81/03
  END FOLDER 81

  FOLDER 82 "Special cases"

    RULE 82/01 "Case  « Refusal to vaccinate against this disease » checked: Special case + message"
      WHEN Recommended
      IF COND:C623 "Refusal of vaccination against tuberculosis (BCG)" = true
      DO Exception
      MESSAGES  MSG19 MSG20
    END RULE 82/01
  END FOLDER 82
END FOLDER 8

FOLDER 9 "Further information"

  RULE 9/02 "0 dose, [0-1m] old, If to do: Mandatory vaccination"
    WHEN Recommended
    IF ALL OF
      CALC:Age in 1d..1m
      CALC:Tub_doses_received = 0
    DO Neutral
    MESSAGES  MSG70
  END RULE 9/02
END FOLDER 9
END TARGET

MESSAGE MSG337 Summary ANY PRIO 0
  "BCG vaccination is strictly contraindicated in patients who have received a hematopoietic stem cell transplant."@en
 END MESSAGE MSG337

MESSAGE MSG72 Summary ANY PRIO 0
  "Have a TST prior to vaccination."@en
 END MESSAGE MSG72

MESSAGE MSG71 Justification ANY PRIO 0
  "In the absence of vaccination and from the age of 2 months, vaccination must be preceded by a TST."@en
 END MESSAGE MSG71

MESSAGE MSG19 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG19

MESSAGE MSG20 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been ticked in the health profile (‘Refusal of vaccination’ section)."@en
 END MESSAGE MSG20

MESSAGE MSG227 Summary ANY PRIO 0
  "Congenital or acquired immunodeficiency is a definitive contraindication to vaccination against tuberculosis."@en
 END MESSAGE MSG227

MESSAGE MSG31 Alert ANY PRIO 0
  "Positive TST: carry out a work-up."@en
 END MESSAGE MSG31

MESSAGE MSG70 Alert ANY PRIO 0
  "In Latvia, vaccination is compulsory from birth."@en
 END MESSAGE MSG70

MESSAGE MSG228 Summary ANY PRIO 0
  "BCG vaccination is strictly contraindicated in HIV-infected patients, regardless of CD4 lymphocyte count."@en
 END MESSAGE MSG228
