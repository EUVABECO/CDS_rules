SYNTH VRS-RF-ADULT "VRS-RF-ADULT - Adult risk factors" IS ANY OF
  COND:C39 "Chronic respiratory failure" = true
  COND:C304 "Severe asthma under continuous treatment" = true
  COND:C126 "Asthma (other than severe and under continuous treatment)" = true
  COND:C281 "Chronic obstructive pulmonary disease (COPD)" = true
  SYNTH:COMMON-BMI "COMMON-BMI - BMI ≥ 40" = true
  COND:C17 "Chronic renal failure on dialysis" = true
  COND:C1095 "Other chronic kidney diseases" = true
  SYNTH:COMMON-RF-ID "COMMON-RF-ID - ID risk factors contraindicating vaccination with live vaccines" = true
  COND:C54 "Smoker" = true
  COND:C547 "Coronary artery disease" = true
  COND:C958 "Diabetes" = true
  COND:C200 "History of stroke" = true
  COND:C1009 "Lives in a home for the elderly" = true
  COND:C3 "Severe heart failure" = true
  COND:C50 "Moderate heart failure" = true

SYNTH VRS-RF-CHILD "VRS-RF-CHILD - Child medical risk factors" IS ANY OF
  COND:C127 "Mucoviscidosis" = true
  COND:C128 "Bronchopulmonary dysplasia" = true
  COND:C39 "Chronic respiratory failure" = true
  COND:C2 "Cyanogenic congenital heart disease" = true
  SYNTH:VRS-PREMAT "VRS - Premature infant 30 weeks gestation or less AND less than 6 months old" = true
  COND:C859 "Trisomy 21" = true
  COND:C198 "Myopathy or other severe neuromuscular disorder" = true
  SYNTH:COMMON-RF-ID "COMMON-RF-ID - ID risk factors contraindicating vaccination with live vaccines" = true

SYNTH VRS-PREMAT "VRS - Premature infant 30 weeks gestation or less AND less than 6 months old" IS ALL OF
  COND:C995 "Number of weeks of amenorrhoea at birth for a premature baby"<=32
  CALC:Age<=6m

SYNTH VRS-PREGNANCY-DOSE-30-38 "VRS - Beginning of pregnancy-LD [30-38WA]" IS ALL OF
  INTERVAL(COND:C52 "Pregnancy - Date of last period",CALC:RSV_last_dose_date)>=30w
  INTERVAL(COND:C52 "Pregnancy - Date of last period",CALC:RSV_last_dose_date)<=38w

SYNTH VRS-SEASON "VRS-SEASON - Pregnant with delivery in VRS season" IS ANY OF
  SYNTH:VRS-SEASON-1 "VRS-SEASON-1 - Start of pregnancy between Nov 17 2023 and June 16, 2024 (delivery between Sept 1st, 2024 and Mar 31, 2025)" = true
  SYNTH:VRS-SEASON-2 "VRS-SEASON-2 - Start of pregnancy between Nov 17 2024 and June 16, 2025 (delivery between Sept 1st, 2025 and Mar 31, 2026) " = true
  SYNTH:VRS-SEASON-3 "VRS-SEASON-3 - Start of pregnancy between Nov 17 2025 and June 16, 2026 (delivery between Sept 1st, 2026 and Mar 31, 2027)" = true

SYNTH VRS-SEASON-3 "VRS-SEASON-3 - Start of pregnancy between Nov 17 2025 and June 16, 2026 (delivery between Sept 1st, 2026 and Mar 31, 2027)" IS ALL OF
  COND:C52 "Pregnancy - Date of last period">=2025-11-17
  COND:C52 "Pregnancy - Date of last period"<=2026-06-16

SYNTH VRS-SEASON-2 "VRS-SEASON-2 - Start of pregnancy between Nov 17 2024 and June 16, 2025 (delivery between Sept 1st, 2025 and Mar 31, 2026) " IS ALL OF
  COND:C52 "Pregnancy - Date of last period">=2024-11-17
  COND:C52 "Pregnancy - Date of last period"<=2025-06-16

SYNTH VRS-SEASON-1 "VRS-SEASON-1 - Start of pregnancy between Nov 17 2023 and June 16, 2024 (delivery between Sept 1st, 2024 and Mar 31, 2025)" IS ALL OF
  COND:C52 "Pregnancy - Date of last period">=2023-11-17
  COND:C52 "Pregnancy - Date of last period"<=2024-06-16

SYNTH VRS-PREGNANCY-DOSE-28-38 "VRS -  Vaccinated between the 28th and 38th weeks of pregnancy and at least 15 days before delivery" IS ALL OF
  INTERVAL(COND:C52 "Pregnancy - Date of last period",CALC:RSV_last_dose_date)>=30w
  INTERVAL(COND:C52 "Pregnancy - Date of last period",CALC:RSV_last_dose_date)<=40w
  SYNTH:VRS-DELVERY-15D "VRS-SCH - At least 15 days between the date of vaccination and the date of delivery" = true

SYNTH VRS-DELVERY-15D "VRS-SCH - At least 15 days between the date of vaccination and the date of delivery" IS ALL OF 
  INTERVAL(CALC:RSV_last_dose_date,COND:C1032 "Date of delivery")>=15d

SYNTH PREGNANCY_ONGOING "COMMON-PREGNANCY - Pregnancy in progress" IS ALL OF
  COND:C52 "Pregnancy - Date of last period" in 1d..41w
  SYNTH:PREGNANCY_OVER "COMMON-PREGNANCY - Pregnancy over" = false

SYNTH PREGNANCY_OVER "COMMON-PREGNANCY - Pregnancy over" IS ANY OF
  COND:C52 "Pregnancy - Date of last period">=42w
  COND:C1032 "Date of delivery">=0d

SYNTH VRS-PREMA "VRS-PREMA - Premature child OR duration of pregnancy ≤ 30 weeks gestation" IS ANY OF
  COND:C300 "Child born prematurely" = true
  COND:C995 "Number of weeks of amenorrhoea at birth for a premature baby"<=32

SYNTH VRS-VACCMOTHER "VRS-VACCMOTHER - Born to a mother vaccinated against RSV during pregnancy, not premature, vaccine administered more than 15 days before birth" IS ALL OF
  COND:C1086 "Child born to a mother vaccinated against RSV during pregnancy" = true
  SYNTH:VRS-PREMA "VRS-PREMA - Premature child OR duration of pregnancy ≤ 30 weeks gestation" = false
  INTERVAL(COND:C1124 "Date of administration of the RSV vaccine to the mother during pregnancy",BASE:dob)>=15d

SYNTH VRS-LOW-PROTECTION "VRS-SCH - 0 dose or LD ≥ 6m" IS ANY OF
  CALC:RSV_doses_received = 0
  CALC:RSV_time_since_last_dose>=6m

CALC RSV_doses_received IS HIST(RSV,0,count)	
CALC RSV_received_vaccines IS HIST(RSV,0,vaccine)

CALC RSV_last_dose_date IS HIST(RSV,-1,date)
CALC RSV_time_since_last_dose IS INTERVAL (CALC:RSV_last_dose_date,BASE:eval)	

TARGET VRS
FOLDER 1 "≤ 23m old "
  IF CALC:Age<=23m

  FOLDER 11 "Child born to a vaccinated mother"
    IF SYNTH:VRS-VACCMOTHER "VRS-VACCMOTHER - Born to a mother vaccinated against RSV during pregnancy, not premature, vaccine administered more than 15 days before birth" = true

    RULE 11/01 "≤ 11m old, Child born to a vaccinated mother: Up to date"
      IF ALL OF
        CALC:Age<=11m
        SYNTH:VRS-VACCMOTHER "VRS-VACCMOTHER - Born to a mother vaccinated against RSV during pregnancy, not premature, vaccine administered more than 15 days before birth" = true
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG341 MSG329
    END RULE 11/01

    RULE 11/02 "[12-23m] old, Child born to a vaccinated mother, RF+, 0 dose or LD ≥ 6m: To do ASAP"
      IF ALL OF
        CALC:Age in 12m..23m
        SYNTH:VRS-RF-CHILD "VRS-RF-CHILD - Child medical risk factors" = true
        SYNTH:VRS-LOW-PROTECTION "VRS-SCH - 0 dose or LD ≥ 6m" = true
      DO Recommended
        Status DUE
        Age 12m
      MESSAGES  MSG342 MSG336
    END RULE 11/02
  END FOLDER 11

  FOLDER 12 "Child born to an unvaccinated mother"
    IF SYNTH:VRS-VACCMOTHER "VRS-VACCMOTHER - Born to a mother vaccinated against RSV during pregnancy, not premature, vaccine administered more than 15 days before birth" = false

    FOLDER 121 "Zero dose"
      IF CALC:RSV_doses_received = 0

      FOLDER 1211 "RF -"
        IF SYNTH:VRS-RF-CHILD "VRS-RF-CHILD - Child medical risk factors" = false

        RULE 121-11.1/01 "RF-, Unvaccinated mother: To do ASAP between 01/09 and 31/03"
          IF ALL OF
            CALC:RSV_doses_received = 0
            SYNTH:VRS-RF-CHILD "VRS-RF-CHILD - Child medical risk factors" = false
          DO Recommended
            Status DUE
          MESSAGES  MSG316 MSG313
        END RULE 121-11.1/01
      END FOLDER 1211

      FOLDER 1212 "RF +"
        IF SYNTH:VRS-RF-CHILD "VRS-RF-CHILD - Child medical risk factors" = true

        RULE 121-2/01 "RF+, Unvaccinated mother: To do between 01/09 and 31/03"
          IF CALC:Age<=23m
          DO Recommended
            Status DUE
          MESSAGES  MSG316
        END RULE 121-2/01
      END FOLDER 1212
    END FOLDER 121

    FOLDER 122 "One dose or more"
      IF CALC:RSV_doses_received>=1

      RULE 122/01 "≥ 1 dose: Up to date"
        IF CALC:RSV_doses_received>=1
        DO Recommended
          Status COMPLETED
      END RULE 122/01
    END FOLDER 122
  END FOLDER 12

  FOLDER 13 "Messages"

    RULE 11/02 "Child eligible in 2024-2025 and born to a mother vaccinated against RSV for less than 13 days at the time of delivery: message"
      IF ANY OF
        INTERVAL(COND:C1124 "Date of administration of the RSV vaccine to the mother during pregnancy",BASE:dob)<=13d
        SYNTH:VRS-PREMA "VRS-PREMA - Premature child OR duration of pregnancy ≤ 30 weeks gestation" = true
      DO Neutral
      MESSAGES  MSG330
    END RULE 11/02
  END FOLDER 13
END FOLDER 1

FOLDER 2 "[24m-59y] old"
  IF CALC:Age in 24m..59y

  FOLDER 21 "Current pregnancy +"
    IF SYNTH:PREGNANCY_ONGOING "COMMON-PREGNANCY - Pregnancy in progress" = true

    RULE 21/01 "Pregnant woman preferring child immunization at birth"
      IF ALL OF
        COND:C1102 "Pregnancy: preference for RSV immunization of the child at birth" = true
        SYNTH:PREGNANCY_ONGOING "COMMON-PREGNANCY - Pregnancy in progress" = true
      DO Exception
      MESSAGES  MSG333
    END RULE 21/01

    FOLDER 211 "Start of pregnancy between Nov 17 and June 16 (delivery between Sept 1st and Mar 31)"
      IF SYNTH:VRS-SEASON "VRS-SEASON - Pregnant with delivery in VRS season" = true

      FOLDER 2111 "Zero dose"
        IF CALC:RSV_doses_received = 0

        RULE 211-1/01 "Current pregnancy ≤ 38WA, 0 dose: To do between 30 to 38WA"
          IF ALL OF
            INTERVAL(COND:C52 "Pregnancy - Date of last period",BASE:eval)<=38w
            SYNTH:VRS-SEASON "VRS-SEASON - Pregnant with delivery in VRS season" = true
          DO Recommended
            Status DUE
            Delay 30w..38w from COND:C52 "Pregnancy - Date of last period"
          MESSAGES  MSG340 MSG321 MSG337 MSG322
        END RULE 211-1/01

        RULE 211-1/02 "Current pregnancy ≥ 37w, 0 dose: Specal case = Too late"
          IF INTERVAL(COND:C52 "Pregnancy - Date of last period",BASE:eval)>=39w
          DO Exception
          MESSAGES  MSG335
        END RULE 211-1/02
      END FOLDER 2111

      FOLDER 2112 "One dose"
        IF ALL OF
        CALC:RSV_doses_received = 1
        CALC:RSV_received_vaccines contains VAC1047 # ABRYSVO

        RULE 211-2/01 "Current pregnancy, Beginning of pregnancy-LD [28-36w]: Up to date"
          IF SYNTH:VRS-PREGNANCY-DOSE-30-38 "VRS - Beginning of pregnancy-LD [30-38WA]" = true
          DO Recommended
            Status COMPLETED
        END RULE 211-2/01

        RULE 211-2/02 "Current pregnancy, Beginning of pregnancy-LD [0-27w] or-≥37w: Special case"
          IF SYNTH:VRS-PREGNANCY-DOSE-30-38 "VRS - Beginning of pregnancy-LD [30-38WA]" = false
          DO Exception
          MESSAGES  MSG338
        END RULE 211-2/02
      END FOLDER 2112

      FOLDER 2113 "Two doses or more"
        IF CALC:RSV_doses_received>=2

        RULE 211-3/01 "Current pregnancy, ≥ 2 doses: Special case"
          IF SYNTH:VRS-PREGNANCY-DOSE-30-38 "VRS - Beginning of pregnancy-LD [30-38WA]" = true
          DO Exception
          MESSAGES  MSG323
        END RULE 211-3/01
      END FOLDER 2113
    END FOLDER 211

    FOLDER 212 "Start of pregnancy between June 17 and Nov 16 (delivery between Apr 01 and Aug 31)"
      IF SYNTH:VRS-SEASON "VRS-SEASON - Pregnant with delivery in VRS season" = false

      RULE 212/01 "Current pregnancy, due before RSV season: Special case"
        IF BASE:sex = f
        DO Exception
        MESSAGES  MSG345 MSG320
      END RULE 212/01
    END FOLDER 212
  END FOLDER 21

  FOLDER 22 "Current pregnancy -"
    IF SYNTH:PREGNANCY_ONGOING "COMMON-PREGNANCY - Pregnancy in progress" = false

    RULE 22/01 "Proper immunization during pregnancy, Prenancy ≤ 15m: Up to date"
      IF ALL OF
        SYNTH:VRS-PREGNANCY-DOSE-28-38 "VRS -  Vaccinated between the 28th and 38th weeks of pregnancy and at least 15 days before delivery" = true
        CALC:RSV_doses_received = 1
        COND:C52 "Pregnancy - Date of last period"<=15m
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG326
    END RULE 22/01

    RULE 22/02 "Incorrect immunization during pregnancy,  Pregnancy ≤ 15m: Special case"
      IF ALL OF
        SYNTH:VRS-PREGNANCY-DOSE-28-38 "VRS -  Vaccinated between the 28th and 38th weeks of pregnancy and at least 15 days before delivery" = false
        COND:C52 "Pregnancy - Date of last period"<=15m
      DO Exception
      MESSAGES  MSG339
    END RULE 22/02

    RULE 22/03 "Pregnancy ≥ 16m, ≥ 1 dose: Special case"
      IF ALL OF
        CALC:RSV_doses_received>=1
        COND:C52 "Pregnancy - Date of last period">=16m
      DO Exception
      MESSAGES  MSG328
    END RULE 22/03
  END FOLDER 22
END FOLDER 2

FOLDER 3 "[60-74y] old"
  IF ALL OF
  CALC:Age in 60y..74y
  CALC:RSV_doses_received = 0

  RULE 3/01 "[60-74y] old, 0 dose, RF+: To do ASAP"
    IF ALL OF
      CALC:RSV_doses_received = 0
      SYNTH:VRS-RF-ADULT "VRS-RF-ADULT - Adult risk factors" = true
    DO Recommended
      Status DUE
      Age 65y
    MESSAGES  MSG310 MSG343
  END RULE 3/01
END FOLDER 3

FOLDER 4 "Information complémentaire"

  RULE 4/05 "Current pregnancy: Information message regarding the choice of immunization type"
    WHEN Recommended
    IF SYNTH:PREGNANCY_ONGOING "COMMON-PREGNANCY - Pregnancy in progress" = true
    DO Neutral
    MESSAGES  MSG334 MSG327
  END RULE 4/05

  RULE 4/06 "Between 28 and 36w gestation: Message information"
    IF INTERVAL(COND:C52 "Pregnancy - Date of last period",BASE:eval) in 30w..38w
    DO Neutral
    MESSAGES  MSG324
  END RULE 4/06

  RULE R-1 "If to do: Informationa boiut season"
    WHEN Recommended
    IF CALC:Age>=1d
    DO Neutral
    MESSAGES  MSG345
  END RULE R-1
END FOLDER 4

FOLDER 4 "≥ 75y old"
  IF CALC:Age>=75y

  RULE 4/01 "≥ 75y, 0 dose: To do ASAP"
    IF CALC:RSV_doses_received = 0
    DO Recommended
      Status DUE
      Age 75y
    MESSAGES  MSG344
  END RULE 4/01
END FOLDER 4

FOLDER V "Vaccin utilisable"

  RULE V/1 "0-23m - Produit utilisable : BEYFORTUS"
    WHEN Recommended
    IF CALC:Age<=23m
    DO Neutral
    MESSAGES  MSG332
  END RULE V/1

  RULE V/3 "≥ 60a - Produit utilisable : AREXVY ou ABRYSVO"
    WHEN Recommended
    IF CALC:Age>=60y
    DO Neutral
    MESSAGES  MSG311
  END RULE V/3
END FOLDER V
END TARGET

MESSAGE MSG344 Justification ANY PRIO 0
  "The Health Council recommends RSV vaccination for all people over 75 years of age, particularly those with a risk factor or a state of fragility."@en
 END MESSAGE MSG344

MESSAGE MSG310 Justification ANY PRIO 0
  "The Health Council recommends RSV vaccination for people aged 60 to 74 with at least one risk factor for developing a severe form of RSV disease (see comments), immunocompromised people, including those with solid cancer or malignant haematological disease, those on immunosuppressive treatment, people who have undergone a solid organ transplant or an allogeneic haematopoietic stem cell transplant and, finally, people living in a nursing home."@en
 END MESSAGE MSG310

MESSAGE MSG343 Comments ANY PRIO 0
  "Risk factors for developing a severe or complicated form of RSV:<br>
- Immunodeficient patients;<br>
- People with chronic kidney disease;<br>
- People with severe obesity (BMI ≥ 40);<br>
- Patients with chronic respiratory diseases (COPD, asthma, bronchiectasis, interstitial lung diseases, chronic respiratory failure);<br>
- People with chronic heart failure or coronary artery disease;<br>
- Diabetic patients;<br>
- People with a history of stroke;<br>
- Smokers."@en
 END MESSAGE MSG343

MESSAGE MSG311 Other PRO PRIO 0
  "Vaccines that can be used: AREXVY or ABRYSVO."@en
 END MESSAGE MSG311

MESSAGE MSG316 Comments ANY PRIO 0
  "All infants, with or without risk factors, are eligible for immunization with nirsevimab (Beyfortus) before the start of the RSV season. Prevention is also indicated in children aged 1 to 2 years during their second RSV season if they have risk factors for severe infections: <br>
- Chronic lung disease of prematurity requiring medical management (chronic corticosteroid therapy, diuretic therapy, or supplemental oxygen) at any time during the six months preceding the start of the second RSV season;<br>
- Hemodynamically significant congenital heart disease;<br>
- Immunosuppressive states;<br>
- Down syndrome;<br>
- Cystic fibrosis;<br>
- Neuromuscular disease;<br>
- Congenital airway anomalies."@en
 END MESSAGE MSG316

MESSAGE MSG313 Justification ANY PRIO 0
  "Give a single intramuscular injection of nirsevimab (Beyfortus).<br>
The dose administered is 50 mg if the weight is less than 5 kg and 100 mg if the weight is greater than or equal to 5 kg."@en
 END MESSAGE MSG313

MESSAGE MSG324 Comments ANY PRIO 0
  "Vaccination with ABRYSVO during pregnancy helps protect the child against RSV bronchiolitis, because antibodies against this virus are transmitted through the placenta to the baby."@en
 END MESSAGE MSG324

MESSAGE MSG340 Comments ANY PRIO 0
  "For pregnant women at risk of premature delivery or whose immune response to vaccination is insufficient (immunocompromised state) or whose transplacental transfer of antibodies is reduced (people living with HIV infection or suffering from membranous disease), maternal vaccination may not be the best preventive option and the use of monoclonal antibodies at the birth of the child should be preferred."@en
 END MESSAGE MSG340

MESSAGE MSG321 Summary ANY PRIO 10
  "Vaccination is recommended between 28 and 36 weeks of gestation."@en
 END MESSAGE MSG321

MESSAGE MSG337 Summary PRO PRIO 0
  "If the mother prefers that her baby be protected after birth by the administration of anti-RSV antibodies, indicate this in the questionnaire (in 'Maternity')."@en
 END MESSAGE MSG337

MESSAGE MSG322 Summary PATIENT PRIO 0
  "If you prefer that your baby be protected after birth by the administration of anti-RSV antibodies, indicate this in the questionnaire ('Maternity')."@en
 END MESSAGE MSG322

MESSAGE MSG335 Summary ANY PRIO 0
  "A little late to protect the infant by vaccinating the mother: prefer immunization of the infant with anti-RSV antibodies."@en
 END MESSAGE MSG335

MESSAGE MSG323 Summary ANY PRIO 0
  "The conditions for protecting the child after vaccination of the mother with more than one dose of RSV vaccine are not known: it is recommended to protect the infant directly with anti-RSV antibodies."@en
 END MESSAGE MSG323

MESSAGE MSG338 Summary ANY PRIO 0
  "The mother's vaccination conditions do not guarantee protection of the infant: it is preferable to protect the infant directly with anti-RSV antibodies."@en
 END MESSAGE MSG338

MESSAGE MSG345 Details ANY PRIO 0
  "The virus's circulation period extends from the beginning of September to the end of March."@en
 END MESSAGE MSG345

MESSAGE MSG320 Summary ANY PRIO 0
  "RSV vaccination for infant protection is not recommended, as delivery will occur outside the RSV epidemic period. Plan for direct protection of the infant with an injection of anti-RSV antibodies during the epidemic period (September to March)."@en
 END MESSAGE MSG320

MESSAGE MSG326 Summary ANY PRIO 0
  "Child protected by mother's antibodies."@en
 END MESSAGE MSG326

MESSAGE MSG334 Comments PATIENT PRIO 0
  "<strong>You have 2 options to protect your child against RSV bronchiolitis:</strong><br> 1. Vaccinate yourself against RSV (ABRYSVO vaccine) during your pregnancy: thanks to this vaccine, the mother produces antibodies against the virus which are transmitted by the placenta to the baby.<br> 2. Immunize the baby at birth by injecting anti-RSV antibodies (Beyfortus).<br>"@en
 END MESSAGE MSG334

MESSAGE MSG327 Comments PRO PRIO 0
  "<strong>The mother has two options to protect her child against RSV bronchiolitis:</strong><br> 1. Get vaccinated against RSV (ABRYSVO vaccine) during pregnancy: thanks to this vaccine, the mother produces antibodies against the virus which are transmitted by the placenta to the baby.<br> 2. Immunize the baby at birth by injecting anti-RSV antibodies (Beyfortus).<br>"@en
 END MESSAGE MSG327

MESSAGE MSG333 Summary ANY PRIO 0
  "The mother prefers to have the newborn immunized with anti-RSV antibodies rather than being vaccinated against RSV herself."@en
 END MESSAGE MSG333

MESSAGE MSG330 Summary ANY PRIO 0
  "If the birth occurs within 14 days of the mother's vaccination or in the event of premature birth, catch-up by passive immunization with monoclonal antibodies is recommended."@en
 END MESSAGE MSG330

MESSAGE MSG332 Other PRO PRIO 0
  "Usable product: BEYFORTUS (Neutralizing monoclonal antibody directed against RSV)."@en
 END MESSAGE MSG332

MESSAGE MSG341 Comments ANY PRIO 0
  "In some specific cases, however, administration of nirsevimab (Beyfortus) to infants born to vaccinated mothers may be considered:<br>
- Infants at sufficiently increased risk of severe RSV disease born to mothers vaccinated late in the season (between January and March);<br>
- Infants born to vaccinated mothers born within two weeks of vaccine administration during pregnancy;<br>
- Pregnant women who may have an inadequate immune response to vaccination (immunocompromised state) or who have reduced transplacental transfer of antibodies (persons living with HIV infection or suffering from membrane disease);<br>
- Infants who have undergone cardiopulmonary bypass or neonatal exchange transfusion resulting in loss of maternal antibodies."@en
 END MESSAGE MSG341

MESSAGE MSG329 Summary ANY PRIO 0
  "Mother vaccinated against RSV during pregnancy: the child is protected for the first year of life."@en
 END MESSAGE MSG329

MESSAGE MSG342 Comments ANY PRIO 0
  "The recommended dose is then 200 mg of nirsevimab (Beyfortus), administered as two 100 mg injections given at the same time at different injection sites. Only one administration of nirsevimab is recommended per season (except for children undergoing heart surgery with cardiopulmonary bypass, as explained in the product package insert)."@en
 END MESSAGE MSG342

MESSAGE MSG336 Justification ANY PRIO 0
  "Children aged 1 to 2 years are eligible for nirsevimab (Beyfortus) immunization during their second RSV season if they have risk factors for severe infections: <br>
- Chronic lung disease of prematurity requiring medical management (chronic corticosteroid therapy, diuretic therapy, or supplemental oxygen) at any time during the six months preceding the start of the second RSV season;<br>
- Hemodynamically significant congenital heart disease;<br>
- Immunosuppressive states;<br>
- Down syndrome;<br>
- Cystic fibrosis;<br>
- Neuromuscular disease;<br>
- Congenital airway anomalies."@en
 END MESSAGE MSG336

MESSAGE MSG339 Summary ANY PRIO 0
  "The mother's vaccination conditions do not guarantee protection of the infant: it is preferable to protect the infant directly with anti-RSV antibodies."@en
 END MESSAGE MSG339

MESSAGE MSG328 Summary ANY PRIO 0
  "In adults under 65 years of age, the individual protection against RSV provided by vaccination is not yet known. The only indication to date concerns the vaccination of pregnant women to protect the child at birth."@en
 END MESSAGE MSG328

MESSAGE MSG346 Details PATIENT PRIO 0
  "--"@en
 END MESSAGE MSG346
