CALC RSV_doses_received IS HIST(RSV,0,count)	
CALC RSV_last_dose_date IS HIST(RSV,-1,date)
CALC RSV_received_vaccines IS HIST(RSV,0,vaccine)

SYNTH RSV-RF-ADULT "VRS-RF-ADULT - Adult risk factors" IS ANY OF
  SYNTH:COMMON-SOT-HSCT "COMMON - Solid organ or stem cell transplantation" = true
  COND:C958 "Diabetes" = true
  SYNTH:COMMON-KIDNEY "COMMON-KIDNEY - Chronic kidney disease" = true
  SYNTH:COMMON-K-HEMA "COMMON-K-HEMA - Hematological malignancies" = true
  COND:C1109 "Cardiovascular insufficiency" = true
  COND:C547 "Coronary artery disease" = true
  COND:C410 "Severe rhythm disorder" = true
  COND:C1037 "Other serious cardiovascular disease" = true
  COND:C281 "Chronic obstructive pulmonary disease (COPD)" = true
  COND:C142 "Other chronic respiratory disease" = true
  COND:C1009 "Lives in a home for the elderly" = true
  SYNTH:COMMON-ASTHM "COMMON-ASTHM - Asthma severe or not" = true

SYNTH RSV-PREGNANCY-START "VRS - Beginning of pregnancy-LD [32-36w]" IS ALL OF
  INTERVAL(COND:C1081 "Pregnancy start date",CALC:RSV_last_dose_date)>=32w
  INTERVAL(COND:C1081 "Pregnancy start date",CALC:RSV_last_dose_date)<=36w

SYNTH PREGNANCY_ONGOING "MATERNITY-PREGNANCY - Pregnancy in progress" IS ALL OF
  COND:C1081 "Pregnancy start date" in 1d..39w
  SYNTH:PREGNANCY_OVER "MATERNITY-PREGNANCY - Pregnancy over" = false

SYNTH PREGNANCY_OVER "MATERNITY-PREGNANCY - Pregnancy over" IS ANY OF
  COND:C1081 "Pregnancy start date">=40w
  COND:C1032 "Date of delivery">=0d

SYNTH RSV-SEASON "VRS-SEASON - Pregnant with delivery in VRS season" IS ANY OF
  SYNTH:RSV-SEASON-1 "VRS-SEASON-1 - Start of pregnancy between Dec 01 2023 and June 30, 2024 (delivery between Sept 1st, 2024 and Mar 30, 2025)" = true
  SYNTH:RSV-SEASON-2 "VRS-SEASON-2 - Start of pregnancy between Dec 01 2024 and June 30, 2025 (delivery between Sept 1st, 2025 and Mar 30, 2026) " = true
  SYNTH:RSV-SEASON-3 "VRS-SEASON-3 - Start of pregnancy between Dec 01 2025 and June 30, 2026 (delivery between Sept 1st, 2026 and Mar 30, 2027)" = true

SYNTH RSV-SEASON-3 "VRS-SEASON-3 - Start of pregnancy between Dec 01 2025 and June 30, 2026 (delivery between Sept 1st, 2026 and Mar 30, 2027)" IS ALL OF
  COND:C1081 "Pregnancy start date">=2025-12-01
  COND:C1081 "Pregnancy start date"<=2026-06-30

SYNTH RSV-SEASON-2 "VRS-SEASON-2 - Start of pregnancy between Dec 01 2024 and June 30, 2025 (delivery between Sept 1st, 2025 and Mar 30, 2026) " IS ALL OF
  COND:C1081 "Pregnancy start date">=2024-12-01
  COND:C1081 "Pregnancy start date"<=2025-06-30

SYNTH RSV-SEASON-1 "VRS-SEASON-1 - Start of pregnancy between Dec 01 2023 and June 30, 2024 (delivery between Sept 1st, 2024 and Mar 30, 2025)" IS ALL OF
  COND:C1081 "Pregnancy start date">=2023-12-01
  COND:C1081 "Pregnancy start date"<=2024-06-30

TARGET RSV

FOLDER 2 "[18-49y] old"
  IF CALC:Age in 18y..49y

  FOLDER 21 "Current pregnancy +"
    IF SYNTH:PREGNANCY_ONGOING "MATERNITY-PREGNANCY - Pregnancy in progress" = true

    RULE 21/01 "Pregnant woman preferring child immunization at birth"
      IF COND:C1102 "Pregnancy: preference for RSV immunization of the child at birth" = true
      DO Exception
      MESSAGES  MSG222
    END RULE 21/01

    FOLDER 211 "Start of pregnancy between Dec 01 and June 30 (delivery between Sept 1st and Mar 30)"
      IF SYNTH:RSV-SEASON "VRS-SEASON - Pregnant with delivery in VRS season" = true

      FOLDER 2111 "Zero dose"
        IF CALC:RSV_doses_received = 0

        RULE 211-1/01 "Current pregnancy ≤ 36w, 0 dose: To do between 32 to 36w"
          IF ALL OF
            INTERVAL(COND:C1081 "Pregnancy start date",BASE:eval)<=36w
            SYNTH:RSV-SEASON "VRS-SEASON - Pregnant with delivery in VRS season" = true
          DO Recommended
            Status DUE
            Delay 32w..36w from COND:C1081 "Pregnancy start date"
          MESSAGES  MSG210 MSG211 MSG212 MSG213
        END RULE 211-1/01

        RULE 211-1/02 "Current pregnancy ≥ 37w, 0 dose: Specal case = Too late"
          IF INTERVAL(COND:C1081 "Pregnancy start date",BASE:eval)>=37w
          DO Exception
          MESSAGES  MSG214
        END RULE 211-1/02
      END FOLDER 2111

      FOLDER 2112 "One dose"
        IF ALL OF
        CALC:RSV_doses_received = 1
        CALC:RSV_received_vaccines contains VAC104 # ABRYSVO

        RULE 211-2/01 "Current pregnancy, Beginning of pregnancy-LD [32-36w]: Up to date"
          IF SYNTH:RSV-PREGNANCY-START "VRS - Beginning of pregnancy-LD [32-36w]" = true
          DO Recommended
            Status COMPLETED
        END RULE 211-2/01

        RULE 211-2/02 "Current pregnancy, Beginning of pregnancy-LD ≤ 31w: Special case"
          IF ALL OF
            SYNTH:RSV-PREGNANCY-START "VRS - Beginning of pregnancy-LD [32-36w]" = false
            COND:C1081 "Pregnancy start date" in 1d..31w
          DO Exception
          MESSAGES  MSG237 MSG216
        END RULE 211-2/02

        RULE 211-2/03 "Current pregnancy, Beginning of pregnancy-LD ≥37w: Special case"
          IF ALL OF
            SYNTH:RSV-PREGNANCY-START "VRS - Beginning of pregnancy-LD [32-36w]" = false
            COND:C1081 "Pregnancy start date">=37w
          DO Exception
          MESSAGES  MSG238 MSG216
        END RULE 211-2/03
      END FOLDER 2112

      FOLDER 2113 "Two doses or more"
        IF CALC:RSV_doses_received>=2

        RULE 211-3/01 "Current pregnancy, ≥ 2 doses: Special case"
          IF SYNTH:RSV-PREGNANCY-START "VRS - Beginning of pregnancy-LD [32-36w]" = true
          DO Exception
          MESSAGES  MSG215
        END RULE 211-3/01
      END FOLDER 2113
    END FOLDER 211

    FOLDER 212 "Start of pregnancy between June 17 and Nov 16 (delivery between Apr 01 and Aug 31)"
      IF SYNTH:RSV-SEASON "VRS-SEASON - Pregnant with delivery in VRS season" = false

      RULE 212/01 "Current pregnancy, due before RSV season: Special case"
        IF BASE:sex = f
        DO Exception
        MESSAGES  MSG217 MSG218
      END RULE 212/01
    END FOLDER 212
  END FOLDER 21
END FOLDER 2

FOLDER 3 "[50-59y] old, RF+"
  IF ALL OF
  CALC:Age in 50y..59y
  CALC:RSV_doses_received = 0
  SYNTH:RSV-RF-ADULT "VRS-RF-ADULT - Adult risk factors" = true

  RULE 3/01 "[50-59y] old, 0 dose, RF+: To do ASAP"
    IF ALL OF
      CALC:RSV_doses_received = 0
      SYNTH:RSV-RF-ADULT "VRS-RF-ADULT - Adult risk factors" = true
    DO Recommended
      Status DUE
      Age 65y
  END RULE 3/01
END FOLDER 3

FOLDER 4 "≥ 60y old"
  IF CALC:Age>=60y

  RULE 4/01 "≥ 60y, 0 dose: To do ASAP"
    IF CALC:RSV_doses_received = 0
    DO Recommended
      Status DUE
      Age 60y
  END RULE 4/01
END FOLDER 4

FOLDER 9 "Further information"

  RULE 9/01 "If to do, [18-49y] old, Pregnancy in progress: Message = Vaccines that can be used (Abrysvo) AND refund 100%"
    WHEN Recommended
    IF ALL OF
      CALC:Age in 18y..49y
      SYNTH:PREGNANCY_ONGOING "MATERNITY-PREGNANCY - Pregnancy in progress" = true
    DO Neutral
    MESSAGES  MSG48 MSG236 MSG233
  END RULE 9/01

  RULE 9/02 "If to do, [50-59y] old: Message = Vaccines that can be used (Arexvy)"
    WHEN Recommended
    IF CALC:Age in 50y..59y
    DO Neutral
    MESSAGES  MSG232
  END RULE 9/02

  RULE 9/03 "If to do, ≥ 60y old: Message = Vaccines that can be used (Arexvy / Abrysvo)"
    WHEN Recommended
    IF CALC:Age>=60y
    DO Neutral
    MESSAGES  MSG204
  END RULE 9/03

  RULE 9/04 "If to do, ≥ 60y old: Message"
    WHEN Recommended
    IF CALC:Age>=60y
    DO Neutral
    MESSAGES  MSG231
  END RULE 9/04

  FOLDER 91 "Excel files"

    RULE 91/03 "If to do, ≥ 65y old: Refund 100%"
      WHEN Recommended
      IF CALC:Age>=65y
      DO Neutral
      MESSAGES  MSG48
    END RULE 91/03

    RULE 91/04 "If to do, [60-64y] old: Refund 50%"
      WHEN Recommended
      IF CALC:Age in 60y..64y
      DO Neutral
      MESSAGES  MSG3
    END RULE 91/04

    RULE 91/06 "If To do, Pregnancy in progress: Message - Refund 100%"
      WHEN Recommended
      IF SYNTH:PREGNANCY_ONGOING "MATERNITY-PREGNANCY - Pregnancy in progress" = true
      DO Neutral
      MESSAGES  MSG48 MSG234 MSG209
    END RULE 91/06

    RULE 91/07 "If to do, Allergy to any component of vaccine: Message + alert"
      IF ALL OF
        COND:C1161 "Allergy from a previous vaccine administration" = true
        CALC:Age>=18y
      DO Neutral
      MESSAGES  MSG51 MSG165 MSG166 MSG104
    END RULE 91/07

    RULE 91/09 "If To do, [50-59y] old, Heart diseases: Message"
      WHEN Recommended
      IF ALL OF
        CALC:Age in 50y..59y
        COND:C1109 "Cardiovascular insufficiency" = true
      DO Neutral
      MESSAGES  MSG351
    END RULE 91/09

    RULE 91/10 "If To do, [50-59y] old, Coronary artery disease: Message"
      WHEN Recommended
      IF ALL OF
        CALC:Age in 50y..59y
        COND:C547 "Coronary artery disease" = true
      DO Neutral
      MESSAGES  MSG352
    END RULE 91/10

    RULE 91/11 "If To do, [50-59y] old, Cardiac arrhythmias: Message"
      WHEN Recommended
      IF ALL OF
        CALC:Age in 50y..59y
        COND:C410 "Severe rhythm disorder" = true
      DO Neutral
      MESSAGES  MSG353
    END RULE 91/11

    RULE 91/12 "If To do, [50-59y] old, Others heart diseases: Message"
      WHEN Recommended
      IF ALL OF
        CALC:Age in 50y..59y
        COND:C1037 "Other serious cardiovascular disease" = true
      DO Neutral
      MESSAGES  MSG354
    END RULE 91/12

    RULE 91/13 "If To do, [50-59y] old, Chronic obstructive pulmonary disease: Message"
      WHEN Recommended
      IF ALL OF
        CALC:Age in 50y..59y
        COND:C281 "Chronic obstructive pulmonary disease (COPD)" = true
      DO Neutral
      MESSAGES  MSG355
    END RULE 91/13

    RULE 91/14 "If To do, [50-59y] old, Asthma: Message"
      WHEN Recommended
      IF ALL OF
        CALC:Age in 50y..59y
        SYNTH:COMMON-ASTHM "COMMON-ASTHM - Asthma severe or not" = true
      DO Neutral
      MESSAGES  MSG356
    END RULE 91/14

    RULE 91/15 "If To do, [50-59y] old, Others lung diseases: Message"
      WHEN Recommended
      IF ALL OF
        CALC:Age in 50y..59y
        COND:C142 "Other chronic respiratory disease" = true
      DO Neutral
      MESSAGES  MSG357
    END RULE 91/15

    RULE 91/16 "If To do, [50-59y] old, People after bone-marrow transplant: Message"
      WHEN Recommended
      IF ALL OF
        CALC:Age in 50y..59y
        SYNTH:COMMON-HSCT "COMMON - Stem cell transplantation" = true
      DO Neutral
      MESSAGES  MSG358
    END RULE 91/16

    RULE 91/17 "If To do, [50-59y] old, People after organ transplantation: Message"
      WHEN Recommended
      IF ALL OF
        CALC:Age in 50y..59y
        SYNTH:COMMON-SOT "COMMON - Solid organ transplantation" = true
      DO Neutral
      MESSAGES  MSG359
    END RULE 91/17

    RULE 91/18 "If To do, [50-59y] old, Diabete: Message"
      WHEN Recommended
      IF ALL OF
        CALC:Age in 50y..59y
        COND:C958 "Diabetes" = true
      DO Neutral
      MESSAGES  MSG360
    END RULE 91/18

    RULE 91/19 "If To do, [50-59y] old, Chronic kidney diseases: Message"
      WHEN Recommended
      IF ALL OF
        CALC:Age in 50y..59y
        SYNTH:COMMON-KIDNEY "COMMON-KIDNEY - Chronic kidney disease" = true
      DO Neutral
      MESSAGES  MSG361
    END RULE 91/19

    RULE 91/20 "If To do, [50-59y] old, Hematological malignancies: Message"
      WHEN Recommended
      IF ALL OF
        CALC:Age in 50y..59y
        SYNTH:COMMON-K-HEMA "COMMON-K-HEMA - Hematological malignancies" = true
      DO Neutral
      MESSAGES  MSG362
    END RULE 91/20

    RULE 91/21 "If To do, [50-59y] old, Nursing homes: Message"
      WHEN Recommended
      IF ALL OF
        CALC:Age in 50y..59y
        COND:C1009 "Lives in a home for the elderly" = true
      DO Neutral
      MESSAGES  MSG363
    END RULE 91/21
  END FOLDER 91
END FOLDER 9
END TARGET

MESSAGE MSG232 Other PRO PRIO 0
  "Vaccine available: Arexvy."@en
 END MESSAGE MSG232

MESSAGE MSG231 Justification ANY PRIO 0
  "RSV vaccine is especially recommended for people aged 60 and older, because age is a risk factor for severe course, hospitalization and development of complications of RSV infection. Additionally, older people may be a source of infection for a longer period of time."@en
 END MESSAGE MSG231

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

MESSAGE MSG237 Summary ANY PRIO 0
  "The vaccination was carried out too early (before 32 weeks of pregnancy): the mother's vaccination conditions do not guarantee protection for the infant."@en
 END MESSAGE MSG237

MESSAGE MSG216 Justification ANY PRIO 0
  "Since the mother's vaccination conditions do not guarantee the protection of the infant, it is preferable to protect the infant directly at birth with anti-RSV antibodies."@en
 END MESSAGE MSG216

MESSAGE MSG222 Summary ANY PRIO 0
  "The mother prefers to have the newborn immunized with anti-RSV antibodies rather than being vaccinated against RSV herself."@en
 END MESSAGE MSG222

MESSAGE MSG214 Summary ANY PRIO 0
  "A little late to protect the infant by vaccinating the mother: prefer immunization of the infant with anti-RSV antibodies."@en
 END MESSAGE MSG214

MESSAGE MSG217 Details ANY PRIO 0
  "The virus's circulation period extends from the beginning of September to the end of March."@en
 END MESSAGE MSG217

MESSAGE MSG218 Summary ANY PRIO 0
  "RSV vaccination for infant protection is not recommended, as delivery will take place outside the RSV epidemic period (from early September to late March). Plan to provide direct protection for the infant with an injection of RSV antibodies during the epidemic period."@en
 END MESSAGE MSG218

MESSAGE MSG238 Summary ANY PRIO 0
  "The vaccination was carried out too late (after 36 weeks of pregnancy): the mother's vaccination conditions do not guarantee protection for the infant."@en
 END MESSAGE MSG238

MESSAGE MSG215 Summary ANY PRIO 0
  "The conditions for protecting the child after vaccination of the mother with more than one dose of RSV vaccine are not known: it is recommended to protect the infant directly with anti-RSV antibodies."@en
 END MESSAGE MSG215

MESSAGE MSG48 Other ANY PRIO 10
  "Refund: 100%."@en
 END MESSAGE MSG48

MESSAGE MSG234 Justification ANY PRIO 0
  "RSV vaccine is especially recommended for pregnatn (betweeen 32-36 weeks of pregnancy), as this vaccination will also provide additional protection against severe RSV infection for baby."@en
 END MESSAGE MSG234

MESSAGE MSG209 Comments ANY PRIO 0
  "Vaccination with Abrysvo during pregnancy helps protect the child against RSV bronchiolitis, as antibodies against this virus are transmitted through the placenta to the baby."@en
 END MESSAGE MSG209

MESSAGE MSG204 Other PRO PRIO 0
  "Vaccines that can be used: Arexvy or Abrysvo."@en
 END MESSAGE MSG204

MESSAGE MSG210 Comments ANY PRIO 0
  "For pregnant women at risk of premature delivery or whose immune response to vaccination is insufficient (immunocompromised state) or whose transplacental transfer of antibodies is reduced (people living with HIV infection or suffering from membrane disease), maternal vaccination may not be the best preventive option and the use of monoclonal antibodies at the birth of the child should be preferred."@en
 END MESSAGE MSG210

MESSAGE MSG211 Summary ANY PRIO 10
  "Vaccination is recommended between 32 and 36 weeks of pregnancy."@en
 END MESSAGE MSG211

MESSAGE MSG212 Summary PRO PRIO 0
  "If the mother prefers that her baby be protected after birth by administering anti-RSV antibodies, indicate this in the questionnaire (under 'Maternity')."@en
 END MESSAGE MSG212

MESSAGE MSG213 Summary PATIENT PRIO 0
  "If you would prefer your baby to be protected after birth by administering RSV antibodies, please indicate this in the questionnaire ('Maternity')."@en
 END MESSAGE MSG213

MESSAGE MSG3 Other ANY PRIO 10
  "Refund: 50%."@en
 END MESSAGE MSG3

MESSAGE MSG359 Justification ANY PRIO 0
  "RSV vaccine is especially recommended for people aged 50-59 after organ transplantation, because of increased risk of RSV infection. Additionally, people with weakened immune systems may be a source of infection for a longer period of time."@en
 END MESSAGE MSG359

MESSAGE MSG360 Justification ANY PRIO 0
  "RSV vaccine is especially recommended for diabetes aged 50-59, because comorbidities increase the risk of severe RSV infection, hospitalization, and even death."@en
 END MESSAGE MSG360

MESSAGE MSG351 Justification ANY PRIO 0
  "RSV vaccine is especially recommended for people aged 50-59 suffering from cardiac failure, because comorbidities in the cardiological area increase the risk of severe RSV infection, hospitalization and even death."@en
 END MESSAGE MSG351

MESSAGE MSG362 Justification ANY PRIO 0
  "RSV vaccine is especially recommended for people aged 50-59 suffering from hematological malignancies,  because comorbidities increase the risk of severe RSV infection, hospitalization, and even death."@en
 END MESSAGE MSG362

MESSAGE MSG352 Justification ANY PRIO 0
  "RSV vaccine is especially recommended for people aged 50-59 suffering from coronary artery disease, because comorbidities in the cardiological area increase the risk of severe RSV infection, hospitalization and even death."@en
 END MESSAGE MSG352

MESSAGE MSG353 Justification ANY PRIO 0
  "RSV vaccine is especially recommended for people aged 50-59 suffering from cardiac arrhythmias, because comorbidities in the cardiological area increase the risk of severe RSV infection, hospitalization and even death."@en
 END MESSAGE MSG353

MESSAGE MSG354 Justification ANY PRIO 0
  "RSV vaccine is especially recommended for people aged 50-59 suffering from heart diseases, because comorbidities in the cardiological area increase the risk of severe RSV infection, hospitalization and even death."@en
 END MESSAGE MSG354

MESSAGE MSG355 Justification ANY PRIO 0
  "RSV vaccine is especially recommended for people aged 50-59 suffering from chronic obstructive pulmonary disease, because comorbidities in the pulmonology area increase the risk of severe RSV infection, hospitalization, and even death."@en
 END MESSAGE MSG355

MESSAGE MSG361 Justification ANY PRIO 0
  "RSV vaccine is especially recommended for people aged 50-59 suffering from chronic kidney diseases,  because comorbidities increase the risk of severe RSV infection, hospitalization, and even death."@en
 END MESSAGE MSG361

MESSAGE MSG363 Justification ANY PRIO 0
  "RSV vaccine is especially recommended for people aged 50-59 living in nursing homes, because RSV virus may cause as many as 10–20% of pneumonia cases in nursing homes."@en
 END MESSAGE MSG363

MESSAGE MSG357 Justification ANY PRIO 0
  "RSV vaccine is especially recommended for people aged 50-59 suffering from lung disease, because comorbidities in the pulmonology area increase the risk of severe RSV infection, hospitalization, and even death."@en
 END MESSAGE MSG357

MESSAGE MSG358 Justification ANY PRIO 0
  "RSV vaccine is especially recommended for people aged 50-59 after bone-marrow transplant, because of increased risk of RSV infection. Additionally, people with weakened immune systems may be a source of infection for a longer period of time."@en
 END MESSAGE MSG358

MESSAGE MSG236 Summary ANY PRIO 0
  "Vaccination against RSV is particularly recommended."@en
 END MESSAGE MSG236

MESSAGE MSG233 Other PRO PRIO 0
  "Vaccine available: Abrysvo."@en
 END MESSAGE MSG233

MESSAGE MSG356 Justification ANY PRIO 0
  "RSV vaccine is especially recommended for people aged 50-59 suffering from asthma, because comorbidities in the pulmonology area increase the risk of severe RSV infection, hospitalization, and even death."@en
 END MESSAGE MSG356
