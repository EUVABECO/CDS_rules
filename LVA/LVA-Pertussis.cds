CALC Per_doses_received IS HIST(Per,0,count)
CALC Per_last_dose_is_booster IS HIST(Per,-1,booster)
CALC Per_last_dose_date IS HIST(Per,-1,date)
CALC Per_age_at_last_dose IS INTERVAL(BASE:dob,CALC:Per_last_dose_date)
CALC Per_time_since_last_dose IS INTERVAL(CALC:Per_last_dose_date,BASE:eval)

SYNTH Per_vaccination_during_pregnancy "PERT - Vaccination during pregnancy (Between the 22nd and 36th week of pregnancy)" IS ALL OF
INTERVAL(COND:C1081 "Pregnancy start date",CALC:Per_last_dose_date) in 22w..36w
 
SYNTH Per_low_protection "PERT - 0 dose ou 1 dose ≥ 6 month" IS ANY OF
  CALC:Per_doses_received = 0
  CALC:Per_time_since_last_dose >=6m

TARGET Pertussis

FOLDER 0 "Common (Polio-Pertussis specific [15d-16y] old)"
  IF CALC:Age in 15d..16y

  FOLDER 01 "Zero dose"
    IF CALC:Per_doses_received = 0

    RULE 01/01 "0 dose: To do at 2m old"
      IF CALC:Age>=15d
      DO Recommended
        Status DUE
        Age 2m
    END RULE 01/01
  END FOLDER 01

  FOLDER 02 "Last dose is not a booster"
    IF CALC:Per_last_dose_is_booster = false

    FOLDER 021 "One dose"
      IF CALC:Per_doses_received = 1

      RULE 021/01 "Booster-, 1 dose: To do from 4m old and 1m after LD"
        IF CALC:Age>=2m
        DO Recommended
          Status DUE
          Age 4m
          Delay 1m from CALC:Per_last_dose_date
      END RULE 021/01
    END FOLDER 021

    FOLDER 022 "Two doses"
      IF CALC:Per_doses_received = 2

      RULE 022/01 "Booster-, 2 doses: To do from 6m old and 1m after LD"
        IF CALC:Age>=2m
        DO Recommended
          Status DUE
          Age 6m
          Delay 1m from CALC:Per_last_dose_date
      END RULE 022/01
    END FOLDER 022

    FOLDER 023 "Three doses"
      IF CALC:Per_doses_received = 3

      RULE 023/01 "Booster-, 3 doses: To do from 12-15m old and 6m after LD"
        IF CALC:Age>=2m
        DO Recommended
          Status DUE
          Age 12m..15m
          Delay 6m from CALC:Per_last_dose_date
      END RULE 023/01
    END FOLDER 023

    FOLDER 024 "Four doses"
      IF CALC:Per_doses_received = 4

      RULE 024/01 "Booster-, 4 doses, Schoolchild-: To do from 7y old and 5y after LD"
        IF ALL OF
          CALC:Age>=2m
          COND:C1093 "School child" = false
        DO Recommended
          Status DUE
          Age 7y
          Delay 5y from CALC:Per_last_dose_date
      END RULE 024/01

      RULE 024/02 "Booster-, 4 doses, Schoolchild+: To do from 6y old and 5y after LD"
        IF ALL OF
          CALC:Age>=2m
          COND:C1093 "School child" = true
        DO Recommended
          Status DUE
          Age 6y
          Delay 5y from CALC:Per_last_dose_date
        MESSAGES  MSG29
      END RULE 024/02
    END FOLDER 024

    FOLDER 025 "Five doses"
      IF CALC:Per_doses_received = 5

      RULE 025/01 "Booster-, 5 doses,  [2m-16y] old: To do from 14y old (Polio-specific) !!!"
        IF CALC:Age in 2m..16y
        DO Recommended
          Status DUE
          Age 14y
      END RULE 025/01
    END FOLDER 025
  END FOLDER 02

  FOLDER 03 "Last dose is a booster OR ≥ 6 doses"
    IF ANY OF
    CALC:Per_last_dose_is_booster = true
    CALC:Per_doses_received>=6

    RULE 03/01 "Booster+, LD [5-13y] old: DUE 14y old and 5y after LD"
      IF CALC:Per_age_at_last_dose in 5y..13y
      DO Recommended
        Status DUE
        Age 14y
        Delay 5y from CALC:Per_last_dose_date
    END RULE 03/01
  END FOLDER 03
END FOLDER 0

FOLDER 1 "[17-45y] old"
  IF CALC:Age in 17y..45y

  FOLDER 11 "Pregnancy in progress +"
    IF SYNTH:PREGNANCY_ONGOING "PREGNANCY - Pregnancy in progress" = true

    RULE 1/01 "Pregnant+, Date pregnancy ≤ 36w, 0 dose or dose ≥ 6m: To do between the 22th and 36th week of gestation"
      IF ALL OF
        SYNTH:Per_low_protection "PERT - 0 dose ou 1 dose ≥ 6 month" = true
        COND:C1081 "Pregnancy start date"<=36w
      DO Recommended
        Status DUE
        Delay 22w..36w from COND:C1081 "Pregnancy start date"
      MESSAGES  MSG209 MSG211 MSG210 MSG208
    END RULE 1/01

    RULE 1/02 "Pregnant+, Date pregnancy ≤ 36w, Date of last period > LD : To do 6m after LD"
      IF ALL OF
        INTERVAL(CALC:Per_last_dose_date,COND:C1081 "Pregnancy start date")>=1d
        COND:C1081 "Pregnancy start date"<=36w
      DO Recommended
        Status DUE
        Delay 6m from CALC:Per_last_dose_date
    END RULE 1/02

    RULE 1/03 "Pregnant+, Date pregnancy ≤ 36s, LD [0-23w] after date of last period : Special case = Too early"
      IF ALL OF
        INTERVAL(COND:C1081 "Pregnancy start date",CALC:Per_last_dose_date) in 1d..21w
        COND:C1081 "Pregnancy start date"<=36w
      DO Exception
      MESSAGES  MSG214 MSG213
    END RULE 1/03

    RULE 1/04 "Pregnant+, LD [24-38w] after date of last period : Up to date"
      IF SYNTH:Per_vaccination_during_pregnancy "PERT - Vaccination during pregnancy (Between the 22nd and 36th week of pregnancy)" = true
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG209 MSG211 MSG210 MSG215
    END RULE 1/04

    RULE 1/05 "Pregnant+, Date pregnancy ≥ 37w, 0 dose during pregnant: Special case = Too late!"
      IF ALL OF
        SYNTH:Per_vaccination_during_pregnancy "PERT - Vaccination during pregnancy (Between the 22nd and 36th week of pregnancy)" = false
        COND:C1081 "Pregnancy start date">=37w
      DO Exception
      MESSAGES  MSG213 MSG212
    END RULE 1/05
  END FOLDER 11

  FOLDER 12 "Delivery within the past 5 weeks"
    IF ALL OF
    SYNTH:PREGNANCY_OVER "PREGNANCY - Pregnancy over" = true
    COND:C1032 "Date of delivery"<=4w

    RULE 12/01 "Pregnancy is over, 0 dose during pregnant, childbirth less 1m ago: Special case = message"
      IF SYNTH:Per_vaccination_during_pregnancy "PERT - Vaccination during pregnancy (Between the 22nd and 36th week of pregnancy)" = false
      DO Exception
      MESSAGES  MSG213 MSG212
    END RULE 12/01

    RULE 12/02 "Pregnancy is over, 1 dose during pregnant: Up to date"
      IF SYNTH:Per_vaccination_during_pregnancy "PERT - Vaccination during pregnancy (Between the 22nd and 36th week of pregnancy)" = true
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG216
    END RULE 12/02
  END FOLDER 12

  FOLDER 13 "Pregnancy in progress - AND No due date or delivery 5w or more"
    IF ALL OF
    SYNTH:PREGNANCY_ONGOING "PREGNANCY - Pregnancy in progress" = false
	COND:C1032 "Date of delivery">=5w

    RULE 13/01 "≤ 5 doses AND LD is not a booster: Special case"
      IF ALL OF
        CALC:Per_doses_received<=5
        CALC:Per_last_dose_is_booster = false
      DO Exception
      MESSAGES  MSG217
    END RULE 13/01

    RULE 13/02 "≥ 6 doses or LD is a booster: Up to date"
      IF ANY OF
        CALC:Per_doses_received>=6
        CALC:Per_last_dose_is_booster = true
      DO Recommended
        Status COMPLETED
    END RULE 13/02

    RULE 13/03 "≥ 6 doses or LD is a booster, LD ≥ 10y: Message"
      IF CALC:Per_time_since_last_dose>=10y
      DO Neutral
      MESSAGES  MSG218
    END RULE 13/03
  END FOLDER 13
END FOLDER 1

FOLDER 2 "≥ 46y old"
  IF CALC:Age>=46y

  RULE 2/01 "≤ 5 doses AND LD is not a booster: Special case"
    IF ALL OF
      CALC:Per_doses_received<=5
      CALC:Per_last_dose_is_booster = false
    DO Exception
    MESSAGES  MSG217
  END RULE 2/01

  RULE 2/02 "≥ 6 doses or LD is a booster: Up to date"
    IF ANY OF
      CALC:Per_doses_received>=6
      CALC:Per_last_dose_is_booster = true
    DO Recommended
      Status COMPLETED
  END RULE 2/02

  RULE 2/03 "≥ 6 doses or LD is a booster, LD ≥ 10y: Message"
    IF CALC:Per_time_since_last_dose>=10y
    DO Neutral
    MESSAGES  MSG218
  END RULE 2/03
END FOLDER 2

FOLDER 8 "Contraindications and special cases"

  RULE 08/01 "Case  « Refusal to vaccinate against this disease » checked: Special case + message"
    IF COND:C613 "Refusal of vaccination against diphtheria-tetanus-polio and/or pertussis" = true
    DO Exception
    MESSAGES  MSG19 MSG20
  END RULE 08/01
END FOLDER 8

FOLDER 9 "Further information"

  RULE 09/01 "If to do, 0 dose: Mandatory vaccination"
    WHEN Recommended
    IF ALL OF
      CALC:Per_doses_received = 0
      SYNTH:PREGNANCY_ONGOING "PREGNANCY - Pregnancy in progress" = false
    DO Neutral
    MESSAGES  MSG69
  END RULE 09/01

  RULE 9/02 "If To do, ≤ 4 doses, Booster-: message vaccination scheme"
    WHEN Recommended
    IF ALL OF
      CALC:Age>=1m
      CALC:Per_doses_received<=4
      CALC:Per_last_dose_is_booster = false
      SYNTH:PREGNANCY_ONGOING "PREGNANCY - Pregnancy in progress" = false
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
END FOLDER 9

END TARGET

MESSAGE MSG134 Other PRO PRIO 0
  "Vaccine recommended for use: DTaP-IPV-Hib-HvB.<br>
Ex : INFANRIX HEXA."@en
 END MESSAGE MSG134

MESSAGE MSG136 Other PRO PRIO 0
  "Vaccine recommended for use: Tdap-IPV.<br>
Ex : Boostrix Polio, Repevax."@en
 END MESSAGE MSG136

MESSAGE MSG217 Summary ANY PRIO 0
  "The vaccination schedule is not complete but there is no indication for vaccination."@en
 END MESSAGE MSG217

MESSAGE MSG218 Summary ANY PRIO 0
  "Since the last dose was more than 10 years ago, vaccination is probably no longer effective, but it is also not recommended."@en
 END MESSAGE MSG218

MESSAGE MSG29 Summary ANY PRIO 0
  "For schoolchildren, from the age of 6."@en
 END MESSAGE MSG29

MESSAGE MSG214 Alert ANY PRIO 0
  "Pregnant woman vaccinated too early in pregnancy (before the 21th week of gestation): those around her must be vaccinated to protect the infant."@en
 END MESSAGE MSG214

MESSAGE MSG213 Justification ANY PRIO 0
  "Babies are not vaccinated until they are two months old and are therefore unprotected during this period. If the pregnant woman has not been vaccinated during the expected period (22th to 36th week of pregnancy), it is necessary to consider vaccinating the infant's entourage."@en
 END MESSAGE MSG213

MESSAGE MSG19 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG19

MESSAGE MSG20 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been ticked in the health profile (‘Refusal of vaccination’ section)."@en
 END MESSAGE MSG20

MESSAGE MSG209 Justification ANY PRIO 0
  "Pertussis vaccination is recommended for pregnant women between the 22nd and 36th week of pregnancy in order to increase the passive transplacental transfer of maternal antibodies and to ensure optimal protection of the newborn.<br>This vaccination must be carried out during each pregnancy.<br>A woman who has been vaccinated against pertussis before her pregnancy must also be vaccinated during pregnancy so that the antibodies transferred by transplacental passage can effectively protect the newborn."@en
 END MESSAGE MSG209

MESSAGE MSG211 Comments PATIENT PRIO 0
  "Babies cannot be vaccinated before they are two months old and are therefore unprotected during this time. The best way to protect your unborn baby is to vaccinate yourself, which will extend the protection to your child. This vaccination is safe for both the pregnant woman and the baby.<br> The whooping cough vaccination should be done during every pregnancy, to ensure that enough antibodies are passed on to the future newborn."@en
 END MESSAGE MSG211

MESSAGE MSG210 Comments PRO PRIO 0
  "It is recommended to vaccinate infants from the age of 8 weeks: they are therefore unprotected during this period. The best way to protect the newborn or infant before he or she is vaccinated is to vaccinate the pregnant woman, from the second trimester, which will extend the protection to her child. This vaccination is safe for the pregnant woman and the child.<br> Vaccination against whooping cough must be carried out during each pregnancy, in order to ensure that a sufficient quantity of antibodies is transmitted to the future newborn."@en
 END MESSAGE MSG210

MESSAGE MSG215 Summary ANY PRIO 0
  "Up-to-date vaccination: the newborn will be protected at birth."@en
 END MESSAGE MSG215

MESSAGE MSG212 Alert ANY PRIO 0
  "Unvaccinated pregnant woman between the 22th and 36th week of gestation: those around her must be vaccinated to protect the infant."@en
 END MESSAGE MSG212

MESSAGE MSG216 Summary ANY PRIO 0
  "Up-to-date vaccination: the newborn is protected until his immunization at 2 months."@en
 END MESSAGE MSG216

MESSAGE MSG135 Other PRO PRIO 0
  "Vaccine recommended for use: DTaP-IPV.<br>
Ex : Infanrix-IPV, Tetraxim."@en
 END MESSAGE MSG135

MESSAGE MSG69 Summary ANY PRIO 0
  "This vaccination is compulsory in Latvia, from the age of 2 months."@en
 END MESSAGE MSG69

MESSAGE MSG131 Justification ANY PRIO 10
  "The primary vaccination schedule consists of 4 doses: 2, 4 and 6 months, then between 12 and 15 months. "@en
 END MESSAGE MSG131

MESSAGE MSG208 Summary ANY PRIO 0
  "Vaccination is recommended between 22 and 36 weeks of pregnancy."@en
 END MESSAGE MSG208
