CALC Diph_doses_received IS HIST(DIPH,0,count)

CALC Diph_age_at_first_dose IS INTERVAL(BASE:dob,HIST(DIPH,1,date))	

CALC Diph_last_dose_is_booster IS HIST(DIPH,-1,booster)
CALC Diph_last_dose_date IS HIST(DIPH,-1,date)
CALC Diph_age_at_last_dose IS INTERVAL(BASE:dob,CALC:Diph_last_dose_date)	
CALC Diph_time_since_last_dose IS INTERVAL(CALC:Diph_last_dose_date,BASE:eval)

CALC Diph_delta_between_last_acts IS INTERVAL(HIST(DIPH,-2,date),CALC:Diph_last_dose_date)

TARGET Diphtheria
FOLDER - "General rules"

  RULE 01 "rejouer"
    IF CALC:Age>=1d
    DO Neutral
    MESSAGES  MSG346
  END RULE 01
END FOLDER -

FOLDER 0 "Common DTaP (Copie)"

  FOLDER 1 "[1m-17y] old (Copie)"
    IF CALC:Age in 1m..17y

    FOLDER 01 "Zero dose (Copie)"
      IF CALC:Diph_doses_received = 0

      RULE 01/01 "0 dose: To do at 2m old"
        IF CALC:Age>=15d
        DO Recommended
          Status DUE
          Age 2m
      END RULE 01/01
    END FOLDER 01

    FOLDER 02 "Last dose is not a booster (Copie)"
      IF CALC:Diph_last_dose_is_booster = false

      FOLDER 021 "One dose (Copie)"
        IF CALC:Diph_doses_received = 1

        RULE 021/01 "Booster-, 1 dose: To do from 3m old and 1m after LD"
          IF CALC:Age>=2m
          DO Recommended
            Status DUE
            Age 3m
            Delay 1m from CALC:Diph_last_dose_date
        END RULE 021/01
      END FOLDER 021

      FOLDER 022 "Two doses (Copie)"
        IF CALC:Diph_doses_received = 2

        RULE 022/01 "Booster-, 2 doses: To do from 4m old and 1m after LD"
          IF CALC:Age>=2m
          DO Recommended
            Status DUE
            Age 4m
            Delay 1m from CALC:Diph_last_dose_date
        END RULE 022/01
      END FOLDER 022

      FOLDER 023 "Three doses (Copie)"
        IF CALC:Diph_doses_received = 3

        RULE 023/01 "Booster-, 3 doses: To do from 15m old and 6m after LD"
          IF CALC:Age>=2m
          DO Recommended
            Status DUE
            Age 15m
            Delay 6m from CALC:Diph_last_dose_date
        END RULE 023/01
      END FOLDER 023

      FOLDER 024 "Four doses (Copie)"
        IF CALC:Diph_doses_received = 4

        RULE 024/01 "Booster-, 4 doses: To do from 5-6y old and 4y after LD"
          IF CALC:Age>=2m
          DO Recommended
            Status DUE
            Age 5y..6y
            Delay 4y from CALC:Diph_last_dose_date
        END RULE 024/01
      END FOLDER 024

      FOLDER 025 "Five doses (Copie)"
        IF CALC:Diph_doses_received = 5

        RULE 025/01 "Booster-, 5 doses: To do from 15-16y old and 5y after LD"
          IF CALC:Age>=2m
          DO Recommended
            Status DUE
            Age 15y..16y
            Delay 5y from CALC:Diph_last_dose_date
        END RULE 025/01
      END FOLDER 025

      FOLDER 026 "Six doses and more (Copie)"
        IF CALC:Diph_doses_received>=6

        RULE 026/01 "Booster-, ≥6 doses: To do from 18y old and 10y after LD"
          IF CALC:Age>=2m
          DO Recommended
            Status DUE
            Age 18y
            Delay 10y from CALC:Diph_last_dose_date
        END RULE 026/01
      END FOLDER 026
    END FOLDER 02

    FOLDER 03 "Last dose is a booster and LD ≥ 5y old (Copie)"
      IF ALL OF
      CALC:Diph_last_dose_is_booster = true
      CALC:Diph_age_at_last_dose>=5y

      RULE 03/01 "Booster+, LD ≤ 14y old: To do 15-16y old, 5y after LD"
        IF CALC:Diph_age_at_first_dose<=14y
        DO Recommended
          Status DUE
          Age 15y..16y
          Delay 5y from CALC:Diph_last_dose_date
      END RULE 03/01

      RULE 03/02 "Booster+, LD ≥ 15y old: To do 10y after LD"
        IF CALC:Diph_age_at_last_dose>=15y
        DO Recommended
          Status DUE
          Age 18y
          Delay 10y from CALC:Diph_last_dose_date
        MESSAGES  MSG41
      END RULE 03/02
    END FOLDER 03
  END FOLDER 1

  FOLDER 2 "≥ 18y old (Copie)"
    IF CALC:Age>=18y

    FOLDER 21 "Zero dose (Copie)"
      IF CALC:Diph_doses_received = 0

      RULE 21/01 "0 dose: To do at 18y"
        IF CALC:Age>=18y
        DO Recommended
          Status DUE
          Age 18y
      END RULE 21/01
    END FOLDER 21

    FOLDER 22 "Last dose is not a booster (Copie)"
      IF CALC:Diph_last_dose_is_booster = false

      FOLDER 221 "One dose (Copie)"
        IF CALC:Diph_doses_received = 1

        RULE 221/01 "Booster-, 1 dose: To do from 4-6w after LD"
          IF CALC:Age>=18y
          DO Recommended
            Status DUE
            Age 3m
            Delay 4w..8w from CALC:Diph_last_dose_date
        END RULE 221/01
      END FOLDER 221

      FOLDER 222 "Two doses (Copie)"
        IF CALC:Diph_doses_received = 2

        RULE 222/01 "Booster-, 2 doses: To do 1y after LD"
          IF CALC:Age>=18y
          DO Recommended
            Status DUE
            Delay 12m from CALC:Diph_last_dose_date
        END RULE 222/01
      END FOLDER 222

      FOLDER 223 "Three doses or more (Copie)"
        IF CALC:Diph_doses_received>=3

        RULE 223/01 "Booster-, ≥3 doses, PD-LD ≤ 19y, LD ≤ 19y: To do from 10y after LD"
          IF ALL OF
            CALC:Age>=18y
            CALC:Diph_time_since_last_dose<=19y
            CALC:Diph_delta_between_last_acts<=19y
          DO Recommended
            Status DUE
            Delay 10y from CALC:Diph_last_dose_date
          MESSAGES  MSG41
        END RULE 223/01

        RULE 223/02 "Booster-, ≥3 doses, LD ≥ 20y: To do ASAP"
          IF ALL OF
            CALC:Age>=18y
            CALC:Diph_time_since_last_dose>=20y
          DO Recommended
            Status DUE
            Age 18y
          MESSAGES  MSG40
        END RULE 223/02

        RULE 223/03 "Booster-, ≥3 doses, PD-LD ≥ 20y: To do 6m after LD"
          IF ALL OF
            CALC:Age>=18y
            CALC:Diph_delta_between_last_acts>=20y
          DO Recommended
            Status DUE
            Age 18y
            Delay 6m from CALC:Diph_last_dose_date
          MESSAGES  MSG40 MSG42
        END RULE 223/03
      END FOLDER 223
    END FOLDER 22

    FOLDER 23 "Last dose is a booster (Copie)"
      IF CALC:Diph_last_dose_is_booster = true

      RULE 23/01 "Booster+, 1 dose, LD ≤ 19y: To do from 10y after LD"
        IF ALL OF
          CALC:Diph_doses_received = 1
          CALC:Diph_time_since_last_dose<=19y
        DO Recommended
          Status DUE
          Delay 10y from CALC:Diph_last_dose_date
        MESSAGES  MSG41
      END RULE 23/01

      RULE 23/02 "Booster+, 1 dose, LD ≥ 20y: To do ASAP + message"
        IF ALL OF
          CALC:Diph_time_since_last_dose>=20y
          CALC:Diph_doses_received = 1
        DO Recommended
          Status DUE
          Age 18y
        MESSAGES  MSG40
      END RULE 23/02

      RULE 23/03 "Booster+, ≥ 2 doses, PD-LD ≤ 19y: To do from 10y after LD"
        IF ALL OF
          CALC:Diph_delta_between_last_acts<=19y
          CALC:Diph_doses_received>=2
        DO Recommended
          Status DUE
          Delay 10y from CALC:Diph_last_dose_date
        MESSAGES  MSG41
      END RULE 23/03

      RULE 23/04 "Booster+, ≥ 2 doses, PD-LD ≥ 20y: To do 6m after LD"
        IF ALL OF
          CALC:Diph_delta_between_last_acts>=20y
          CALC:Diph_doses_received>=2
        DO Recommended
          Status DUE
          Age 18y
          Delay 6m from CALC:Diph_last_dose_date
        MESSAGES  MSG40 MSG42
      END RULE 23/04
    END FOLDER 23
  END FOLDER 2

  FOLDER 8 "Contraindications and special cases (Copie)"

    RULE 08/01 "Case  « Refusal to vaccinate against this disease » checked: Special case + message"
      IF COND:C613 "Refusal of vaccination against diphtheria-tetanus-polio and/or pertussis" = true
      DO Exception
      MESSAGES  MSG6 MSG7
    END RULE 08/01
  END FOLDER 8

  FOLDER 9 "Further information (Copie)"

    RULE 9/01 "If to do, 0 dose: Mandatory vaccination for children attending a childcare facility approved by ONE"
      WHEN Recommended
      IF ALL OF
        CALC:Diph_doses_received = 0
        COND:C1103 "Attend a childcare facility approved by the Office of Birth and Childhood (ONE)" = true
      DO Neutral
      MESSAGES  MSG8
    END RULE 9/01

    RULE 9/02 "If To do, ≤ 17y old, ≤ 4 doses, Booster-: message vaccination scheme"
      WHEN Recommended
      IF ALL OF
        CALC:Age in 1m..17y
        CALC:Diph_doses_received<=4
        CALC:Diph_last_dose_is_booster = false
      DO Neutral
      MESSAGES  MSG5
    END RULE 9/02

    RULE 9/03 "If To do, ≥ 18y old, ≤ 2 doses, Booster-: message vaccination scheme"
      WHEN Recommended
      IF ALL OF
        CALC:Age>=19y
        CALC:Diph_doses_received<=2
        CALC:Diph_last_dose_is_booster = false
      DO Neutral
      MESSAGES  MSG39
    END RULE 9/03

    RULE 9/04 "If to do, ≤ 20m old: message to do with DTaP-IPV-Hib-HvB"
      WHEN Recommended
      IF CALC:Age<=20m
      DO Neutral
      MESSAGES  MSG3
    END RULE 9/04

    RULE 9/05 "If to do, [5-10y] old: message to do with DTaP-IPV"
      WHEN Recommended
      IF CALC:Age in 5y..10y
      DO Neutral
      MESSAGES  MSG1
    END RULE 9/05

    RULE 9/06 "If to do, [11-15y] old: message to do with Tdap-IPV"
      WHEN Recommended
      IF CALC:Age in 11y..15y
      DO Neutral
      MESSAGES  MSG4
    END RULE 9/06

    RULE 9/07 "If to do, ≥ 16y old: message to do with Td"
      WHEN Recommended
      IF CALC:Age>=16y
      DO Neutral
      MESSAGES  MSG2
    END RULE 9/07

    RULE 9/08 "≤ 24y, 1 dose, Is a booster: Message"
      WHEN Recommended
      IF ALL OF
        CALC:Diph_last_dose_is_booster = true
        CALC:Diph_doses_received = 1
        CALC:Age<=24y
      DO Neutral
      MESSAGES  MSG44
    END RULE 9/08

    RULE 9/09 "≥ 25y, 1 dose, Is a booster: Message"
      WHEN Recommended
      IF ALL OF
        CALC:Diph_last_dose_is_booster = true
        CALC:Diph_doses_received = 1
        CALC:Age>=25y
      DO Neutral
      MESSAGES  MSG43
    END RULE 9/09
  END FOLDER 9
END FOLDER 0
END TARGET

MESSAGE MSG44 Comments ANY PRIO 0
  "Only one dose of vaccine was recorded as a booster, indicating that the primary vaccination course was completed and the intervals were respected."@en
 END MESSAGE MSG44

MESSAGE MSG40 Comments ANY PRIO 0
  "It is recommended:<br>
1 dose of vaccine for a delay of between 10 and 20 years,<br>
2 doses of vaccine administered 6 months apart, if the delay exceeds 20 years."@en
 END MESSAGE MSG40

MESSAGE MSG5 Comments ANY PRIO 0
  "The infant vaccination schedule includes a 3-dose primary vaccination (2, 3 and 4 months), followed by a booster dose at 15 months."@en
 END MESSAGE MSG5

MESSAGE MSG6 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG6

MESSAGE MSG7 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been checked in the health profile (section “Refusal of vaccination”)."@en
 END MESSAGE MSG7

MESSAGE MSG346 Details PATIENT PRIO 0
  "--"@en
 END MESSAGE MSG346

MESSAGE MSG8 Alert ANY PRIO 0
  "Vaccination compulsory from the age of 2 months for children attending a childcare facility approved by ONE."@en
 END MESSAGE MSG8

MESSAGE MSG41 Summary ANY PRIO 0
  "Give a booster dose 10 days after the last dose."@en
 END MESSAGE MSG41

MESSAGE MSG42 Summary ANY PRIO 0
  "Significant delay: take an additional dose 6 months after the previous one."@en
 END MESSAGE MSG42

MESSAGE MSG4 Other PRO PRIO 0
  "Vaccines that can be used:<br>
Tdap : Boostrix, Triaxis<br>
Td-IPV : Revaxis<br>
Tdap-IPV : Boostrix Polio, Repevax"@en
 END MESSAGE MSG4

MESSAGE MSG3 Other PRO PRIO 0
  "Vaccines that can be used: Vaxelis, Hexyon (DTaP-IPV-Hib-HvB)"@en
 END MESSAGE MSG3

MESSAGE MSG1 Other PRO PRIO 0
  "Vaccines that can be used:<br>
DTaP-IPV: Infanrix-IPV, Tetravac"@en
 END MESSAGE MSG1

MESSAGE MSG2 Other PRO PRIO 0
  "Vaccines that can be used:<br>
Tdap : Boostrix, Triaxis<br>
Td-IPV : Revaxis<br>
Tdap-IPV : Boostrix Polio, Repevax"@en
 END MESSAGE MSG2

MESSAGE MSG39 Comments ANY PRIO 0
  "If an adult has not received the complete basic vaccination during childhood and adolescence, three doses of vaccine are recommended. The first two doses will be given 4 to 6 weeks apart, and the third dose one year later."@en
 END MESSAGE MSG39

MESSAGE MSG43 Comments ANY PRIO 0
  "Only one dose of vaccine was recorded as a booster, indicating that the primary vaccination course was completed and the intervals were respected. In the absence of information on the previous dose, it is not possible to establish a catch-up schedule. If the interval between the penultimate and the last dose exceeds 20 years, it is advisable to administer two doses of vaccine spaced 6 months apart. Thereafter, boosters should be given every 10 years."@en
 END MESSAGE MSG43
