SYNTH TBE-D1-TICO "TBE-D1-TICO - 1st dose is inactivated whole vaccine against TBE, Neudörfl strain (TICO, FSME) child or adult dose" IS ANY OF
  SYNTH:TBE-D1-TICO-CHILD "TBE-D1-TICO-CHILD - 1st dose Tico child or equivalent" = true
  SYNTH:TBE-D1-TICO-ADLT "TBE-D1-TICO-ADLT - 1st dose Tico adult or equivalent" = true

SYNTH TBE-D1-TICO-CHILD "TBE-D1-TICO-CHILD - 1st dose Tico child or equivalent" IS ALL OF
  CALC:TBE_first_dose_valences contains TBE-Neudorfl-PED

SYNTH TBE-D1-TICO-ADLT "TBE-D1-TICO-ADLT - 1st dose Tico adult or equivalent" IS ALL OF
  CALC:TBE_first_dose_valences contains TBE-Neudorfl-ADU

SYNTH TBE-D2-TICO "TBE-D2-TICO - 2nd dose is inactivated whole vaccine against TBE, Neudörfl strain (TICO, FSME) child or adult dose" IS ANY OF
  SYNTH:TBE-D2-TICO-CHILD "TBE-D2-TICO-CHILD - 2nd dose Tico child or equivalent" = true
  SYNTH:TBE-D2-TICO-ADLT "TBE-D2-TICO-ADLT - 2nd dose Tico adult or equivalent" = true

SYNTH TBE-D2-TICO-ADLT "TBE-D2-TICO-ADLT - 2nd dose Tico adult or equivalent" IS ALL OF 
  CALC:TBE_second_dose_valences contains TBE-Neudorfl-ADU

SYNTH TBE-D2-TICO-CHILD "TBE-D2-TICO-CHILD - 2nd dose Tico child or equivalent" IS ALL OF
  CALC:TBE_second_dose_valences contains TBE-Neudorfl-PED

SYNTH TBE-RF "TBE - Risk factors for TBE" IS ANY OF
  COND:C1039 "Regular practice of canoeing, rafting, triathlon or other nature sports" = true
  COND:C1069 "Outdoor exposure (running, camping, hiking, working outdoors)" = true


CALC TBE_doses_received IS HIST(TBE,0,count)

CALC TBE_first_dose_valences IS HIST(TBE,1,valences)
CALC TBE_first_dose_age IS INTERVAL(BASE:dob,HIST(TBE,1,date))
CALC TBE_time_since_first_dose IS INTERVAL(HIST(TBE,1,date),BASE:eval)

CALC TBE_second_dose_valences IS HIST(TBE,2,valences)

CALC TBE_last_dose_date IS HIST(TBE,-1,date)
CALC TBE_last_dose_vaccine IS HIST(TBE,-1,vaccine)
CALC TBE_last_dose_valences IS HIST(TBE,-1,valences)
CALC TBE_last_dose_booster IS HIST(TBE,-1,booster)

CALC TBE_d1d2 IS INTERVAL(HIST(TBE,1,date),HIST(TBE,1,date))


TARGET TBE
FOLDER 0 "Zero dose and Risky travel"
  IF ALL OF
  CALC:TBE_doses_received = 0
  COND:C1028 "TBE - Travel plan to a region at risk of tick-borne encephalitis" = true

  RULE 0/01 "≥ 12m old, 0 dose, Risky travel: Possible"
    IF ALL OF
      CALC:Age>=12m
      SYNTH:TBE-RF "TBE - Risk factors for TBE" = false
    DO Suggested
    MESSAGES  MSG296 MSG297
  END RULE 0/01

  RULE 0/02 "≥ 12m old, 0 dose, Risky travel / RF: DUE ASAP"
    IF ALL OF
      CALC:Age>=12m
      SYNTH:TBE-RF "TBE - Risk factors for TBE" = true
    DO Recommended
      Status DUE
      Age 12m
    MESSAGES  MSG296 MSG297
  END RULE 0/02
END FOLDER 0

FOLDER 1 "FSME (or TICOVAC)"
  IF ANY OF
  CALC:TBE_last_dose_valences contains TBE-Neudorfl
  CALC:TBE_last_dose_valences contains TBE-Neudorfl-PED
  CALC:TBE_last_dose_valences contains TBE-Neudorfl-ADU

  FOLDER 11 "One dose"
    IF CALC:TBE_doses_received = 1

    RULE 11/01 "≥ 12m old, 1 dose FSME: To do 1 to 3m after LD"
      IF CALC:Age>=12m
      DO Recommended
        Status DUE
        Delay 1m..3m from CALC:TBE_last_dose_date
      MESSAGES  MSG271
    END RULE 11/01

    RULE 11/02 "≥ 12m old, 1 dose FSME, d1 ≤ 14d: message accelerated scheme possible with 1dose 14d after LD"
      IF ALL OF
        CALC:Age>=12m
        CALC:TBE_time_since_first_dose_act<=14d
      DO Neutral
      MESSAGES  MSG268 MSG269
    END RULE 11/02
  END FOLDER 11

  FOLDER 12 "Two doses"
    IF CALC:TBE_doses_received = 2

    RULE 12/01 "≥ 12m old, 2 doses FSME: To do 5 to 12m after LD"
      IF CALC:Age>=12m
      DO Recommended
        Status DUE
        Delay 5m..12m from CALC:TBE_last_dose_date
      MESSAGES  MSG289
    END RULE 12/01
  END FOLDER 12

  FOLDER 13 "Three doses"
    IF CALC:TBE_doses_received = 3

    RULE 13/01 "3 doses FSME: To do 3y after LD"
      IF CALC:Age>=12m
      DO Recommended
        Status DUE
        Delay 3y from CALC:TBE_last_dose_date
      MESSAGES  MSG281
    END RULE 13/01
  END FOLDER 13

  FOLDER 14 "Four doses and more OR LD is a booster"
    IF ANY OF
    CALC:TBE_doses_received>=4
    CALC:TBE_last_dose_booster = true

    RULE 14/01 "≥ 4 doses FSME OR LD is a booster: To do 10y after LD"
      IF CALC:Age>=12m
      DO Recommended
        Status DUE
        Delay 10y from CALC:TBE_last_dose_date
      MESSAGES  MSG279
    END RULE 14/01
  END FOLDER 14
END FOLDER 1

FOLDER 5 "ENCEPUR (≥ 12y old)"
  IF CALC:TBE_last_dose_vaccine = VAC0079# ENCEPUR

  FOLDER 51 "One dose"
    IF CALC:TBE_doses_received = 1

    RULE 51/01 "≥ 12y old, 1 dose Encepur: To to 1 to 3m after LD"
      IF CALC:Age>=12y
      DO Recommended
        Status DUE
        Delay 1m..3m from CALC:TBE_last_dose_date
      MESSAGES  MSG271
    END RULE 51/01

    RULE 51/02 "≥12y old, 1 dose Encepur, d1 ≤ 7d: message accelerated scheme possible with 1dose 7d after LD"
      IF ALL OF
        CALC:Age>=12y
        CALC:TBE_time_since_first_dose_act<=7d
      DO Neutral
      MESSAGES  MSG272 MSG273
    END RULE 51/02
  END FOLDER 51

  FOLDER 52 "Two doses"
    IF CALC:TBE_doses_received = 2

    RULE 25/01 "≥ 12y old, 2 doses Encepur, d1d2 ≤ 14d: To do 21d after LD (accelerated scheme)"
      IF ALL OF
        CALC:Age>=12y
        CALC:TBE_d1d2<=14d
      DO Recommended
        Status DUE
        Delay 21d from CALC:TBE_last_dose_date
      MESSAGES  MSG288
    END RULE 25/01

    RULE 25/02 "≥ 12y old, 2 doses Encepur, d1d2 ≥ 15d: To do 9 to 12m after LD"
      IF ALL OF
        CALC:TBE_d1d2>=15d
        CALC:Age>=12y
      DO Recommended
        Status DUE
        Delay 9m..12m from CALC:TBE_last_dose_date
      MESSAGES  MSG278
    END RULE 25/02
  END FOLDER 52

  FOLDER 53 "Three doses"
    IF CALC:TBE_doses_received = 3

    FOLDER 531 "Standard schedule"

      RULE 531/01 "≥ 12y old, LD Encepur, d1d2 ≥ 15d (Standard schedule): To do 1st booter 3y after LD"
        IF CALC:Age in 12y..49y
        DO Recommended
          Status DUE
          Delay 3y from CALC:TBE_last_dose_date
        MESSAGES  MSG282 MSG283
      END RULE 531/01
    END FOLDER 531

    FOLDER 532 "Accelerated schedule"
      IF CALC:TBE_d1d2<=14d

      RULE 532/01 "≥ 12y old, LD Encepur, d1d2 ≤ 14d (Accelerated schedule): To do 1st booter 12 to 18m after LD"
        IF CALC:Age in 12y..49y
        DO Recommended
          Status DUE
          Delay 12m..18m from CALC:TBE_last_dose_date
        MESSAGES  MSG276 MSG277
      END RULE 532/01
    END FOLDER 532
  END FOLDER 53

  FOLDER 54 "Four doses and more"
    IF CALC:TBE_doses_received>=4

    RULE 54/01 "[12-49y] old, LD Encepur: To do booter 5y after LD"
      IF CALC:Age in 12y..49y
      DO Recommended
        Status DUE
        Delay 5y from CALC:TBE_last_dose_date
      MESSAGES  MSG286
    END RULE 54/01

    RULE 54/02 "≥ 50y old, LD Encepur: To do booter 3y after LD"
      IF CALC:Age>=50y
      DO Recommended
        Status DUE
        Delay 3y from CALC:TBE_last_dose_date
      MESSAGES  MSG285
    END RULE 54/02
  END FOLDER 54
END FOLDER 5

FOLDER 8 "Contraindications and special cases"

  FOLDER 81 "Contraindications"
  END FOLDER 81

  FOLDER 82 "Special cases"

    RULE 82/01 "Case  « Refusal to vaccinate against this disease » checked: Special case + message"
      IF COND:C627 "Refusal of tick-borne encephalitis vaccination" = true
      DO Exception
      MESSAGES  MSG6 MSG7
    END RULE 82/01
  END FOLDER 82
END FOLDER 8

FOLDER 9 "Further information"

  RULE 9/01 "If To do, Ticovac 0,25 mL (OR FSME Junior), 1 dose ≤ 11m old: message alert d1 to early"
    WHEN Recommended
    IF ALL OF
      CALC:TBE_first_dose_age<=11m
      SYNTH:TBE-D1-TICO-CHILD "TBE-D1-TICO-CHILD - 1st dose Tico child or equivalent" = true
    DO Neutral
    MESSAGES  MSG280
  END RULE 9/01

  RULE 9/02 "If To do, Ticovac OR FSME, d1d2 ≤ 12d: message alert interval too short"
    WHEN Recommended
    IF ALL OF
      CALC:TBE_d1d2<=12d
      SYNTH:TBE-D1-TICO "TBE-D1-TICO - 1st dose is inactivated whole vaccine against TBE, Neudörfl strain (TICO, FSME) child or adult dose" = true
      SYNTH:TBE-D2-TICO "TBE-D2-TICO - 2nd dose is inactivated whole vaccine against TBE, Neudörfl strain (TICO, FSME) child or adult dose" = true
    DO Neutral
    MESSAGES  MSG274
  END RULE 9/02

  RULE 9/05 "If To do, ≥ 3 doses: Message possibility of changing vaccine after primary vaccination"
    WHEN Recommended
    IF CALC:TBE_doses_received>=4
    DO Neutral
    MESSAGES  MSG287
  END RULE 9/05
END FOLDER 9
END TARGET

MESSAGE MSG268 Summary ANY PRIO 0
  "Accelerated schedule possible with a 2nd dose 14 days after the first dose."@en
 END MESSAGE MSG268

MESSAGE MSG269 Justification ANY PRIO 0
  "If a rapid immunological response is required, the second injection can be given 2 weeks after the first. After the first two injections, sufficient protection for the current tick season is expected."@en
 END MESSAGE MSG269

MESSAGE MSG272 Summary ANY PRIO 0
  "Accelerated schedule possible with a 2nd dose 7 days after the first dose."@en
 END MESSAGE MSG272

MESSAGE MSG273 Justification ANY PRIO 0
  "If it is necessary to obtain a rapid immunological response, the second injection can be performed 1 week after the first."@en
 END MESSAGE MSG273

MESSAGE MSG274 Alert ANY PRIO 0
  "The interval between the first and second doses of FSME should not have been less than 13 days."@en
 END MESSAGE MSG274

MESSAGE MSG271 Justification ANY PRIO 0
  "To be done one to three months after the first dose."@en
 END MESSAGE MSG271

MESSAGE MSG296 Justification ANY PRIO 0
  "Vaccination is recommended if you are travelling to a region where tick-borne encephalitis is common (Central Europe, Eastern and Northern Europe, northern Central Asia, northern China, northern Japan), and: <br>
- you are planning many outdoor activities during the tick season such as camping, trekking, hunting or walking,<br>
- or if you are staying there for a longer period or regularly."@en
 END MESSAGE MSG296

MESSAGE MSG297 Summary ANY PRIO 0
  "If your travel has risk factors for Japanese encephalitis, then vaccination is recommended. See comments for more information."@en
 END MESSAGE MSG297

MESSAGE MSG280 Alert ANY PRIO 0
  "The FSME Junior vaccine should not have been given before 12 months of age."@en
 END MESSAGE MSG280

MESSAGE MSG281 Summary ANY PRIO 0
  "Vaccination booster 3 years after the 3rd dose."@en
 END MESSAGE MSG281

MESSAGE MSG6 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG6

MESSAGE MSG7 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been checked in the health profile (section “Refusal of vaccination”)."@en
 END MESSAGE MSG7

MESSAGE MSG282 Justification ANY PRIO 0
  "As part of a standard schedule, carry out the first booster vaccination 3 years after the last primary vaccination dose."@en
 END MESSAGE MSG282

MESSAGE MSG283 Summary ANY PRIO 0
  "Standard vaccination schedule."@en
 END MESSAGE MSG283

MESSAGE MSG276 Justification ANY PRIO 0
  "As part of an accelerated schedule, give the first booster vaccination 12 months to 18 months after the last primary vaccination dose."@en
 END MESSAGE MSG276

MESSAGE MSG277 Summary ANY PRIO 0
  "Accelerated vaccination schedule."@en
 END MESSAGE MSG277

MESSAGE MSG285 Summary ANY PRIO 0
  "Vaccination booster 3 years after the last dose."@en
 END MESSAGE MSG285

MESSAGE MSG278 Summary ANY PRIO 0
  "Classic scheme with Encepur."@en
 END MESSAGE MSG278

MESSAGE MSG289 Justification ANY PRIO 0
  "Do the 3rd dose of primary vaccination with age-appropriate FSME."@en
 END MESSAGE MSG289

MESSAGE MSG279 Summary ANY PRIO 0
  "Vaccination booster 10 years after the last dose."@en
 END MESSAGE MSG279

MESSAGE MSG286 Summary ANY PRIO 0
  "Vaccination booster 5 years after the last dose."@en
 END MESSAGE MSG286

MESSAGE MSG287 Comments PRO PRIO 0
  "According to official recommendations from the World Health Organization (WHO), after the primary vaccination with a vaccine against tick-borne encephalitis, another vaccine can be administered as a booster dose."@en
 END MESSAGE MSG287

MESSAGE MSG288 Summary ANY PRIO 0
  "Accelerated diagram with Encepur."@en
 END MESSAGE MSG288
