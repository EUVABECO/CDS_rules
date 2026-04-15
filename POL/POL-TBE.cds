CALC TBE_doses_received IS HIST(TBE,0,count)

CALC TBE_first_valences IS HIST(TBE,1,valences)
CALC TBE_first_dose_date IS HIST(TBE,1,date)
CALC TBE_first_dose_age IS INTERVAL(BASE:dob,CALC:TBE_first_dose_date)
CALC TBE_time_since_first_dose IS INTERVAL(HIST(TBE,1,date),BASE:eval)

CALC TBE_second_dose_valences IS HIST(TBE,2,valences)

CALC TBE_last_dose_date IS HIST(TBE,-1,date)
CALC TBE_last_dose_vaccine IS HIST(TBE,-1,vaccine)
CALC TBE_last_dose_booster IS HIST(TBE,-1,booster)
CALC TBE_last_dose_valences IS HIST(TBE,-1,valences)

CALC TBE_d1d2 IS INTERVAL(HIST(TBE,1,date),HIST(TBE,1,date))

SYNTH ET-LD-ENCEPUR "ET-LD-ENCEPUR - LD dose ENCEPUR or equivalent" IS ALL OF
  CALC:TBE_last_dose_valences contains TBE-K23

SYNTH ET-D1-TICO "ET-D1-TICO - 1st dose is inactivated whole vaccine against ET, Neudörfl strain (TICO, FSME) child or adult dose" IS ANY OF
  SYNTH:ET-D1-TICO-CHILD "ET-D1-TICO-CHILD - 1st dose Tico child or equivalent" = true
  SYNTH:ET-D1-TICO-ADLT "ET-D1-TICO-ADLT - 1st dose Tico adult or equivalent" = true

SYNTH ET-D1-TICO-CHILD "ET-D1-TICO-CHILD - 1st dose Tico child or equivalent" IS ALL OF
  CALC:TBE_first_dose_valences contains TBE-Neudorfl-PED

SYNTH ET-D1-TICO-ADLT "ET-D1-TICO-ADLT - 1st dose Tico adult or equivalent" IS ALL OF 
  CALC:TBE_first_dose_valences contains TBE-Neudorfl-ADU

SYNTH ET-D2-TICO "ET-D2-TICO - 2nd dose is inactivated whole vaccine against ET, Neudörfl strain (TICO, FSME) child or adult dose" IS ANY OF
  SYNTH:ET-D2-TICO-CHILD "ET-D2-TICO-CHILD - 2nd dose Tico child or equivalent" = true
  SYNTH:ET-D2-TICO-ADLT "ET-D2-TICO-ADLT - 2nd dose Tico adult or equivalent" = true

SYNTH ET-D2-TICO-ADLT "ET-D2-TICO-ADLT - 2nd dose Tico adult or equivalent" IS ALL OF 
  CALC:TBE_second_dose_valences contains TBE-Neudorfl-ADU

SYNTH ET-D2-TICO-CHILD "ET-D2-TICO-CHILD - 2nd dose Tico child or equivalent" IS ALL OF 
  CALC:TBE_second_dose_valences contains TBE-Neudorfl-PED

SYNTH ET-LD-FSME "ET-LD-FSME - LD dose FSME or equivalent" IS ALL OF 
  CALC:TBE_last_dose_valences contains TBE-Neudorfl-ADU

TARGET TBE
FOLDER 0 "Zero dose"
  IF CALC:TBE_doses_received = 0

  RULE 0/01 "≥18y old, 0 dose: DUE ASAP"
    IF CALC:Age>=18y
    DO Recommended
      Status DUE
      Age 18y
    MESSAGES  MSG292
  END RULE 0/01
END FOLDER 0

FOLDER 2 "FSME-IMMUN 0,5 mL"
  IF ANY OF
  CALC:TBE_last_dose_vaccine = VAC0038 #TICOVAC 0,5 mL
  CALC:TBE_last_dose_vaccine = VAC0575 #FSME-IMMUN

  FOLDER 21 "One dose"
    IF CALC:TBE_doses_received = 1

    RULE 21/01 " ≥ 18y old, 1 dose FSME-IMMUN: To do 1 to 3m after LD"
      IF CALC:Age>=18y
      DO Recommended
        Status DUE
        Delay 1m..3m from CALC:TBE_last_dose_date
      MESSAGES  MSG280
    END RULE 21/01

    RULE 21/02 "≥18y old, 1 dose FSME-IMMUN, d1 ≤ 14d: message accelerated scheme possible with 1dose 14d after LD"
      IF ALL OF
        CALC:TBE_time_since_first_dose<=14d
        CALC:Age>=18y
      DO Neutral
      MESSAGES  MSG257 MSG258
    END RULE 21/02
  END FOLDER 21

  FOLDER 22 "Two dose"
    IF CALC:TBE_doses_received = 2

    RULE 22/01 "≥ 18y old, 2 doses FSME-IMMUN: To do 5 to 12m after LD"
      IF CALC:Age>=18y
      DO Recommended
        Status DUE
        Delay 5m..12m from CALC:TBE_last_dose_date
      MESSAGES  MSG275
    END RULE 22/01
  END FOLDER 22

  FOLDER 23 "Three doses"
    IF CALC:TBE_doses_received = 3

    RULE 23/01 "3 doses FSME-IMMUN: To do 3y after LD"
      IF CALC:Age>=18y
      DO Recommended
        Status DUE
        Delay 3y from CALC:TBE_last_dose_date
      MESSAGES  MSG272
    END RULE 23/01
  END FOLDER 23

  FOLDER 24 "Four doses and more OR LD is a booster"
    IF ANY OF
    CALC:TBE_doses_received>=4
    CALC:TBE_last_dose_booster = true

    RULE 24/01 "≥ 4 doses FSME-IMMUN OR LD is a booster, [18-59y] old: To do 5y after LD"
      IF CALC:Age in 18y..59y
      DO Recommended
        Status DUE
        Delay 5y from CALC:TBE_last_dose_date
      MESSAGES  MSG291 MSG277
    END RULE 24/01

    RULE 24/02 "≥ 4 doses FSME-IMMUN OR LD is a booster, ≥ 60y old: To do 3y after LD"
      IF CALC:Age>=60y
      DO Recommended
        Status DUE
        Delay 3y from CALC:TBE_last_dose_date
      MESSAGES  MSG290 MSG276
    END RULE 24/02
  END FOLDER 24
END FOLDER 2

FOLDER 5 "Encepur Adults"
  IF CALC:TBE_last_dose_vaccine = VAC0079 # ENCEPUR

  FOLDER 51 "One dose"
    IF CALC:TBE_doses_received = 1

    RULE 51/01 "≥ 18y old, 1 dose Encepur: To to 1 to 3m after LD"
      IF CALC:Age>=18y
      DO Recommended
        Status DUE
        Delay 14d..3m from CALC:TBE_last_dose_date
      MESSAGES  MSG260
    END RULE 51/01

    RULE 51/02 "≥18y old, 1 dose Encepur, d1 ≤ 7d: message accelerated scheme possible with 1dose 7d after LD"
      IF ALL OF
        CALC:TBE_time_since_first_dose<=7d
        CALC:Age>=18y
      DO Neutral
      MESSAGES  MSG261 MSG262
    END RULE 51/02
  END FOLDER 51

  FOLDER 52 "Two doses"
    IF CALC:TBE_doses_received = 2

    RULE 25/01 "≥ 18y old, 2 doses Encepur, d1d2 ≤ 13d: To do 21d after dose 1 (accelerated scheme)"
      IF ALL OF
        CALC:Age>=18y
        CALC:TBE_d1d2<=13d
      DO Recommended
        Status DUE
        Delay 21d from CALC:TBE_first_dose_date
      MESSAGES  MSG279
    END RULE 25/01

    RULE 25/02 "≥ 18y old, 2 doses Encepur, d1d2 ≥ 14d: To do 9 to 12m after LD"
      IF ALL OF
        CALC:TBE_d1d2>=14d
        CALC:Age>=18y
      DO Recommended
        Status DUE
        Delay 9m..12m from CALC:TBE_last_dose_date
      MESSAGES  MSG269
    END RULE 25/02
  END FOLDER 52

  FOLDER 53 "Three doses"
    IF CALC:TBE_doses_received = 3

    FOLDER 531 "Standard schedule"
      IF CALC:TBE_d1d2>=14d

      RULE 531/01 "≥ 18y old, LD Encepur, d1d2 ≥ 14d (Standard schedule): To do 1st booter 3y after LD"
        IF CALC:Age>=18y
        DO Recommended
          Status DUE
          Delay 3y from CALC:TBE_last_dose_date
        MESSAGES  MSG273 MSG274
      END RULE 531/01
    END FOLDER 531

    FOLDER 532 "Accelerated schedule"
      IF CALC:TBE_d1d2<=13d

      RULE 532/01 "≥ 18y old, LD Encepur, d1d2 ≤ 13d (Accelerated schedule): To do 1st booter 12 to 18m after LD"
        IF CALC:Age>=18y
        DO Recommended
          Status DUE
          Delay 12m..18m from CALC:TBE_last_dose_date
        MESSAGES  MSG267 MSG268
      END RULE 532/01
    END FOLDER 532
  END FOLDER 53

  FOLDER 54 "Four doses and more"
    IF CALC:TBE_doses_received>=4

    RULE 54/01 "[18-49y] old, LD Encepur: To do booter 5y after LD"
      IF CALC:Age in 18y..49y
      DO Recommended
        Status DUE
        Delay 5y from CALC:TBE_last_dose_date
      MESSAGES  MSG288 MSG277
    END RULE 54/01

    RULE 54/02 "≥ 50y old, LD Encepur: To do booter 3y after LD"
      IF CALC:Age>=50y
      DO Recommended
        Status DUE
        Delay 3y from CALC:TBE_last_dose_date
      MESSAGES  MSG289 MSG276
    END RULE 54/02
  END FOLDER 54
END FOLDER 5

FOLDER 8 "Contraindications and special cases"

  FOLDER 81 "Contraindications"
  END FOLDER 81

  FOLDER 82 "Special cases"
  END FOLDER 82
END FOLDER 8

FOLDER 9 "Further information"

  RULE 9/01 "If To do, [1-2] doses, LD is ENCEPUR: message"
    WHEN Recommended
    IF ALL OF
      CALC:TBE_doses_received>0
      CALC:TBE_doses_received<3
      SYNTH:ET-LD-ENCEPUR "ET-LD-ENCEPUR - LD dose ENCEPUR or equivalent" = true
    DO Neutral
    MESSAGES  MSG294
  END RULE 9/01

  RULE 9/02 "If To do, [1-2] doses, LD is FSME: message"
    WHEN Recommended
    IF ALL OF
      CALC:TBE_doses_received>0
      CALC:TBE_doses_received<3
      SYNTH:ET-LD-FSME "ET-LD-FSME - LD dose FSME or equivalent" = true
    DO Neutral
    MESSAGES  MSG293
  END RULE 9/02

  RULE 9/03 "If To do, Ticovac OR FSME, d1d2 ≤ 12d: message alert interval too short"
    WHEN Recommended
    IF ALL OF
      CALC:TBE_d1d2<=12d
      SYNTH:ET-D1-TICO "ET-D1-TICO - 1st dose is inactivated whole vaccine against ET, Neudörfl strain (TICO, FSME) child or adult dose" = true
      SYNTH:ET-D2-TICO "ET-D2-TICO - 2nd dose is inactivated whole vaccine against ET, Neudörfl strain (TICO, FSME) child or adult dose" = true
    DO Neutral
    MESSAGES  MSG263
  END RULE 9/03

  RULE 9/04 "If To do, ≥ 3 doses: Message possibility of changing vaccine after primary vaccination"
    WHEN Recommended
    IF CALC:TBE_doses_received>=4
    DO Neutral
    MESSAGES  MSG278
  END RULE 9/04

  FOLDER 91 "Excel files"

    RULE 91/01 "If to do, Allergy to any component of vaccine: Message + alert"
      IF ALL OF
        COND:C1161 "Allergy from a previous vaccine administration" = true
        CALC:Age>=18y
      DO Neutral
      MESSAGES  MSG51 MSG165 MSG166 MSG104
    END RULE 91/01

    RULE 91/07 "If to do, Outdoor exposure: Message"
      WHEN Recommended
      IF COND:C1069 "Outdoor exposure (running, camping, hiking, working outdoors)" = true
      DO Neutral
      MESSAGES  MSG282 MSG281
    END RULE 91/07

    RULE 91/16 "If to do, People employed in forest exploitation: Message"
      WHEN Recommended
      IF COND:C155 "Forest Ranger" = true
      DO Neutral
      MESSAGES  MSG282 MSG283
    END RULE 91/16

    RULE 91/17 "If to do, Military: Message"
      WHEN Recommended
      IF COND:C1118 "Military" = true
      DO Neutral
      MESSAGES  MSG282 MSG284
    END RULE 91/17

    RULE 91/18 "If to do, Border guard officers: Message"
      WHEN Recommended
      IF COND:C1119 "Border guard" = true
      DO Neutral
      MESSAGES  MSG282 MSG286
    END RULE 91/18

    RULE 91/18 "If to do, Fire brigade officers: Message"
      WHEN Recommended
      IF COND:C92 "Fireman" = true
      DO Neutral
      MESSAGES  MSG282 MSG285
    END RULE 91/18

    RULE 91/20 "If to do, Farmers: Message"
      WHEN Recommended
      IF COND:C1238 "Farmer" = true
      DO Neutral
      MESSAGES  MSG287 MSG282
    END RULE 91/20
  END FOLDER 91
END FOLDER 9
END TARGET

MESSAGE MSG290 Comments ANY PRIO 0
  "From the age of 60, boosters with FSME-IMMUN are carried out every 3 years (instead of every 5 years before the age of 60)."@en
 END MESSAGE MSG290

MESSAGE MSG276 Summary ANY PRIO 0
  "Vaccination booster 3 years after the last dose."@en
 END MESSAGE MSG276

MESSAGE MSG292 Other ANY PRIO 0
  "Vaccines that can be used: FSME-IMMUN or ENCEPUR ADULTS."@en
 END MESSAGE MSG292

MESSAGE MSG291 Comments ANY PRIO 0
  "Up to the age of 59, boosters with FSME-IMMUN should be administered every 5 years. From the age of 60, boosters will be given every 3 years."@en
 END MESSAGE MSG291

MESSAGE MSG277 Summary ANY PRIO 0
  "Vaccination booster 5 years after the last dose."@en
 END MESSAGE MSG277

MESSAGE MSG287 Justification ANY PRIO 0
  "Tick-borne encephalitis vaccine is especially recommended for farmers. These people are at increased risk of infection because of time they spend outdoors."@en
 END MESSAGE MSG287

MESSAGE MSG282 Summary ANY PRIO 0
  "Vaccination against tick-borne encephalitis is particularly recommended."@en
 END MESSAGE MSG282

MESSAGE MSG286 Justification ANY PRIO 0
  "Tick-borne encephalitis vaccine is especially recommended for border guard officers. These people are at increased risk of infection because of time they spend outdoors."@en
 END MESSAGE MSG286

MESSAGE MSG272 Summary ANY PRIO 0
  "Vaccination booster 3 years after the 3rd dose."@en
 END MESSAGE MSG272

MESSAGE MSG51 Alert ANY PRIO 0
  "Warning: allergy - see comments before any vaccine administration."@en
 END MESSAGE MSG51

MESSAGE MSG165 Comments PATIENT PRIO 0
  "An allergy to a previous vaccine administration has been reported. You must clearly inform the healthcare professional before any new vaccination, regardless of the vaccine administered."@en
 END MESSAGE MSG165

MESSAGE MSG166 Comments PRO PRIO 0
  "An allergy to a previous vaccine administration has been reported. Before any new vaccination, carefully check the origin of the previous allergy and adapt the course of action. Seek specialist advice if in doubt."@en
 END MESSAGE MSG166

MESSAGE MSG104 Comments ANY PRIO 0
  "NOTE! It is important to consult a medical doctor before the next  vaccination in case of any allergic reaction."@en
 END MESSAGE MSG104

MESSAGE MSG294 Other ANY PRIO 0
  "Continue the primary vaccination schedule with ENCEPUR ADULTS."@en
 END MESSAGE MSG294

MESSAGE MSG281 Justification ANY PRIO 0
  "The tick-borne encephalitis vaccine is particularly recommended for joggers, walkers, mushroom pickers, hunters, campers, and, more generally, anyone who engages in outdoor activities and spends time in the forest. These people are at increased risk of infection."@en
 END MESSAGE MSG281

MESSAGE MSG283 Justification ANY PRIO 0
  "Tick-borne encephalitis vaccine is especially recommended for people employed in forest exploitation. These people are at increased risk of infection because of time they spend outdoors."@en
 END MESSAGE MSG283

MESSAGE MSG263 Alert ANY PRIO 0
  "The interval between the first and second doses of FSME-IMMUN (or TOCOVAC) should not have been less than 13 days."@en
 END MESSAGE MSG263

MESSAGE MSG280 Summary ANY PRIO 10
  "To be done between 1 and 3 months after the first dose with FSME-IMMUN."@en
 END MESSAGE MSG280

MESSAGE MSG257 Summary ANY PRIO 0
  "Accelerated schedule possible with a 2nd dose of the FSME-IMMUN vaccine 14 days after the first dose."@en
 END MESSAGE MSG257

MESSAGE MSG258 Justification ANY PRIO 0
  "If a rapid immunological response is required, the second injection can be given 2 weeks after the first. After the first two injections, sufficient protection is expected for the current tick season."@en
 END MESSAGE MSG258

MESSAGE MSG260 Summary ANY PRIO 10
  "To be administered with the ENCEPUR ADULTS vaccine between 14 days and three months after the first dose."@en
 END MESSAGE MSG260

MESSAGE MSG261 Summary ANY PRIO 0
  "Accelerated schedule possible with a 2nd dose of ENCEPUR ADULTS vaccine 7 days after the first dose."@en
 END MESSAGE MSG261

MESSAGE MSG262 Justification ANY PRIO 0
  "If it is necessary to obtain a rapid immunological response, the second injection can be performed 1 week after the first."@en
 END MESSAGE MSG262

MESSAGE MSG269 Summary ANY PRIO 0
  "Classic schedule starting with ENCEPUR ADULTS: take a dose between 9 and 12 months after the last dose."@en
 END MESSAGE MSG269

MESSAGE MSG273 Justification ANY PRIO 0
  "As part of a standard schedule with the ENCEPUR ADULTS vaccine, give the first booster vaccination 3 years after the last primary vaccination dose."@en
 END MESSAGE MSG273

MESSAGE MSG274 Summary ANY PRIO 0
  "Standard vaccination schedule."@en
 END MESSAGE MSG274

MESSAGE MSG267 Justification ANY PRIO 0
  "As part of an accelerated schedule with the ENCEPUR ADULTS vaccine, give the first booster vaccination 12 months to 18 months after the last primary vaccination dose."@en
 END MESSAGE MSG267

MESSAGE MSG268 Summary ANY PRIO 0
  "Accelerated vaccination schedule."@en
 END MESSAGE MSG268

MESSAGE MSG289 Comments ANY PRIO 0
  "From the age of 50, boosters with ENCEPUR Adults are carried out every 3 years (instead of every 5 years before the age of 50)."@en
 END MESSAGE MSG289

MESSAGE MSG288 Comments ANY PRIO 0
  "Up to the age of 49, boosters with ENCEPUR Adults should be given every 5 years. From the age of 50, boosters should be given every 3 years."@en
 END MESSAGE MSG288

MESSAGE MSG279 Summary ANY PRIO 0
  "Accelerated schedule started with ENCEPUR ADULTS: take the 3rd dose 21 days after the first dose."@en
 END MESSAGE MSG279

MESSAGE MSG275 Summary ANY PRIO 0
  "Regardless of the schedule (standard or accelerated), take the 3rd dose of the FSME-IMMUN vaccine 5 to 12 months after the last dose."@en
 END MESSAGE MSG275

MESSAGE MSG293 Other ANY PRIO 0
  "Continue the primary vaccination schedule with FSME-IMMUN."@en
 END MESSAGE MSG293

MESSAGE MSG278 Comments PRO PRIO 0
  " According to official recommendations from the World Health Organization (WHO), after the primary vaccination with a tick-borne encephalitis vaccine, another vaccine can be administered as a booster dose."@en
 END MESSAGE MSG278

MESSAGE MSG284 Justification ANY PRIO 0
  "Tick-borne encephalitis vaccine is especially recommended for people stationed in the military. These people are at increased risk of infection because of time they spend outdoors."@en
 END MESSAGE MSG284

MESSAGE MSG285 Justification ANY PRIO 0
  "Tick-borne encephalitis vaccine is especially recommended for fire brigade officers. These people are at increased risk of infection because of time they spend outdoors."@en
 END MESSAGE MSG285
