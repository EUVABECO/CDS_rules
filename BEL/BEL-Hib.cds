TARGET Hib

FOLDER 0 "Common (Hib-specific [15d-24m] old)"
  IF CALC:Age in 15d..24m

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

      RULE 021/01 "Booster-, 1 dose: To do from 3m old and 1m after LD"
        IF CALC:Age>=2m
        DO Recommended
          Status DUE
          Age 3m
          Delay 1m from CALC:Hib_last_dose_date
      END RULE 021/01
    END FOLDER 021

    FOLDER 022 "Two doses"
      IF CALC:Hib_doses_received = 2

      RULE 022/01 "Booster-, 2 doses: To do from 4m old and 1m after LD"
        IF CALC:Age>=2m
        DO Recommended
          Status DUE
          Age 4m
          Delay 1m from CALC:Hib_last_dose_date
      END RULE 022/01
    END FOLDER 022

    FOLDER 023 "Three doses"
      IF CALC:Hib_doses_received = 3

      RULE 023/01 "Booster-, 3 doses: To do from 15m old and 6m after LD"
        IF CALC:Age>=2m
        DO Recommended
          Status DUE
          Age 15m
          Delay 6m from CALC:Hib_last_dose_date
      END RULE 023/01
    END FOLDER 023

    FOLDER 024 "Four doses"
      IF CALC:Hib_doses_received = 4

      RULE 024/01 "Booster-, 4 doses, [2-24m]: Up to date"
        IF CALC:Age in 2m..24m
        DO Recommended
          Status COMPLETED
      END RULE 024/01
    END FOLDER 024
  END FOLDER 02

  FOLDER 08 "Contraindications and special cases"

    RULE 08/01 "Case  « Refusal to vaccinate against this disease » checked: Special case + message"
      IF COND:C675 "Refusal of Haemophilus influenzae type b vaccination" = true
      DO Exception
      MESSAGES  MSG6 MSG7
    END RULE 08/01
  END FOLDER 08

  FOLDER 09 "Further information"

    RULE 9/02 "If To do, ≤ 4 doses, Booster-: message vaccination scheme"
      WHEN Recommended
      IF ALL OF
        CALC:Age>=1m
        CALC:Hib_doses_received<=4
        CALC:Hib_last_dose_is_booster = false
      DO Neutral
      MESSAGES  MSG5
    END RULE 9/02

    RULE 9/03 "If to do, ≤ 20m old: message to do with DTaP-IPV-Hib-HvB"
      WHEN Recommended
      IF CALC:Age<=20m
      DO Neutral
      MESSAGES  MSG3
    END RULE 9/03
  END FOLDER 09
END FOLDER 0
END TARGET

MESSAGE MSG6 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG6

MESSAGE MSG7 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been checked in the health profile (section “Refusal of vaccination”)."@en
 END MESSAGE MSG7

MESSAGE MSG3 Other PRO PRIO 0
  "Vaccines that can be used: Vaxelis, Hexyon (DTaP-IPV-Hib-HvB)"@en
 END MESSAGE MSG3

MESSAGE MSG5 Comments ANY PRIO 0
  "The infant vaccination schedule includes a 3-dose primary vaccination (2, 3 and 4 months), followed by a booster dose at 15 months."@en
 END MESSAGE MSG5

MESSAGE MSG346 Details PATIENT PRIO 0
  "--"@en
 END MESSAGE MSG346
