CALC MenC_doses_received IS HIST(MenC,0,count)

CALC MenC_first_dose_date IS HIST(MenC,1,date)
CALC MenC_age_at_first_dose IS INTERVAL(BASE:dob,CALC:MenC_first_dose_date)
CALC MenC_first_vaccine IS HIST(MenC,1,vaccine)

CALC MenC_penultimate_dose_date IS HIST(MenC,-2,date)

CALC MenC_last_dose_date IS HIST(MenC,-1,date)
CALC MenC_age_at_last_dose IS INTERVAL(BASE:dob,CALC:MenC_last_dose_date)
CALC MenC_last_valences IS HIST(MenC,-1,valences)

CALC  MenC_d1d2 IS INTERVAL(CALC:MenC_first_dose_date,HIST(MenC,2,date))	


TARGET MenC
FOLDER - "General rules"

  RULE 9/08 "If To do, Coagulation disorders: Message"
    WHEN Recommended
    IF SYNTH:COAG_DISORDERS "COMMON - coagulation disorders" = true
    DO Neutral
    MESSAGES  MSG338 MSG339
  END RULE 9/08
END FOLDER -

FOLDER 0 "Common AWY (Copie)"

  FOLDER 1 "RF+ HSCT- (Copie)"
    IF ANY OF
    SYNTH:MEN_RF_WO_HSCT "MEN-RF : All Risk factors for invasive meningococcal infections (Med / Pro / Other - without HSCT)" = true
    SYNTH:MEN_RF_3 "MEN-RF-3 : Haematopoietic stem cell transplants" = false

    RULE 1/01 "RF+, LD = unconjugated : To do 2y after LD"
      IF SYNTH:MEN-NC "MEN-NC Dernière valence reçu est un vaccin non conjugué ACWY ou AC" = true
      DO Recommended
        Status DUE
        Delay 2y from CALC:MenC_last_dose_date
      MESSAGES  MSG237 MSG238
    END RULE 1/01

    FOLDER 11 "Zero dose (Copie)"
      IF CALC:MenC_doses_received = 0

      RULE 11/01 "[6w-5m] old, RF+, HSCT-, 0 dose: To do 1 dose from 2m old (Primovaccination 2 doses ACWY conj)"
        IF CALC:Age in 6w..5m
        DO Recommended
          Status DUE
          Age 2m
        MESSAGES  MSG235
      END RULE 11/01

      RULE 11/02 "≥ 6m old, RF+, HSCT-, 0 dose: To do 1 dose ASAP (Primovaccination with 1 dose ACWY conj)"
        IF CALC:Age>=6m
        DO Recommended
          Status DUE
          Age 6w
        MESSAGES  MSG232
      END RULE 11/02
    END FOLDER 11

    FOLDER 12 "One dose conjugated QV (Copie)"
      IF ALL OF
      SYNTH:MEN-ACWY-Conj = true
      CALC:MenC_doses_received = 1

      RULE 12/01 "≤ 11m old, RF+, HSCT-, 1 dose conjugated QV, d1 [6w-5m]: To do 2m after LD"
        IF ALL OF
          CALC:MenC_age_at_first_dose in 6w..5m
          CALC:Age<=11m
        DO Recommended
          Status DUE
          Delay 2m from CALC:MenC_last_dose_date
        MESSAGES  MSG235
      END RULE 12/01

      RULE 12/02 "≤ 11m old, RF+, HSCT-, 1 dose conjugated QV, d1 [6-11m]: To do after 12m old, 2m after LD"
        IF ALL OF
          CALC:MenC_age_at_first_dose in 6m..11m
          CALC:Age<=11m
        DO Recommended
          Status DUE
          Age 12m
          Delay 2m from CALC:MenC_last_dose_date
        MESSAGES  MSG232
      END RULE 12/02

      RULE 12/03 "≥ 12m old, RF+, HSCT-, 1 dose conjugated QV, d1 ≤ 11m: To do booster after 12m old, 2m after LD"
        IF ALL OF
          CALC:MenC_age_at_first_dose<=11m
          CALC:Age>=12m
        DO Recommended
          Status DUE
          Age 12m
          Delay 2m from CALC:MenC_last_dose_date
        MESSAGES  MSG300
      END RULE 12/03

      RULE 12/04 "≥ 12m old, RF+, HSCT-, 1 dose conjugated QV, d1 ≥ 12m old: To do booster 5y after LD"
        IF CALC:MenC_age_at_first_dose>=12m
        DO Recommended
          Status DUE
          Delay 5y from CALC:MenC_last_dose_date
        MESSAGES  MSG252
      END RULE 12/04
    END FOLDER 12

    FOLDER 13 "Two doses  or more conjugated QV (Copie)"
      IF ALL OF
      SYNTH:MEN-ACWY-Conj = true
      CALC:MenC_doses_received>=2

      RULE 13/01 " RF+, HSCT-, ≥ 2 doses, LD is conjugated QV, LD ≤ 11m old: To do booster after 12m old,  2m after LD"
        IF CALC:MenC_age_at_last_dose<=11m
        DO Recommended
          Status DUE
          Age 12m
          Delay 2m from CALC:MenC_last_dose_date
        MESSAGES  MSG274
      END RULE 13/01

      RULE 13/02 " RF+, HSCT-, ≥ 2 doses, LD is conjugated QV, LD ≥ 12m old: To do booster 5y after LD"
        IF CALC:MenC_age_at_last_dose>=12m
        DO Recommended
          Status DUE
          Delay 5y from CALC:MenC_last_dose_date
        MESSAGES  MSG266
      END RULE 13/02
    END FOLDER 13
  END FOLDER 1

  FOLDER 2 "HSCT+ (Copie)"
    IF SYNTH:MEN_RF_3 "MEN-RF-3 : Haematopoietic stem cell transplants" = true

    RULE 2/01 "Message to HSCT concerning the invalidity of previous doses, ≥ 1 dose, diff d1-HSCT ≥ 1d"
      IF ALL OF
        COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)">=1d
        CALC:Age>=6w
        INTERVAL(CALC:MenC_first_dose_date,COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)")>=1d
      DO Neutral
      MESSAGES  MSG250 MSG251
    END RULE 2/01

    RULE 2/02 "Message to HSCT if LD administered less than 12 months after HSCT"
      IF INTERVAL(COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)",CALC:MenC_last_dose_date) in 1d..11m
      DO Recommended
        Status DUE
        Age 12m
        Delay 6m from CALC:MenC_last_dose_date
      MESSAGES  MSG270
    END RULE 2/02

    FOLDER 21 "Zero dose (Copie)"
      IF CALC:MenC_doses_received = 0

      RULE 21/01 "≤ 11m, 0 dose, HSCT+: To do after 12m old, [12-18m] after HSCT"
        IF ALL OF
          COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)">=1d
          CALC:MenC_doses_received = 0
          CALC:Age<=11m
        DO Recommended
          Status DUE
          Age 12m
          Delay 12m..18m from COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)"
        MESSAGES  MSG297
      END RULE 21/01

      RULE 21/02 "≥ 12m, 0 dose, HSCT+: To do [12-18m] after HSCT"
        IF ALL OF
          COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)">=1d
          CALC:MenC_doses_received = 0
          CALC:Age>=12m
        DO Recommended
          Status DUE
          Delay 12m..18m from COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)"
        MESSAGES  MSG264
      END RULE 21/02
    END FOLDER 21

    FOLDER 22 "One dose or more (LD = conjugated) (Copie)"
      IF ALL OF
      CALC:MenC_doses_received>=1
      CALC:MenC_last_valences contains MCV-A

      FOLDER 221 "LD before HSCT (Copie)"
        IF INTERVAL(CALC:MenC_last_dose_date,COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)")>=1d

        RULE 221/01 "LD before HSCT: To do [12-18m] after HSCT (Pre-HSCT doses do not count)"
          IF CALC:MenC_doses_received>=1
          DO Recommended
            Status DUE
            Delay 12m..18m from COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)"
        END RULE 221/01
      END FOLDER 221

      FOLDER 222 "LD after HSCT (Copie)"
        IF INTERVAL(COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)",CALC:MenC_last_dose_date)>=1d

        RULE 222/01 "HSCT+, Only 1 dose after HSCT, 0 dose before, LD ≥ 4w after HSCT: To do after 12m old, 6m after LD"
          IF ALL OF
            CALC:MenC_doses_received = 1
            INTERVAL(COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)",CALC:MenC_last_dose_date)>=4w
          DO Recommended
            Status DUE
            Age 12m
            Delay 6m from CALC:MenC_last_dose_date
          MESSAGES  MSG244
        END RULE 222/01

        RULE 222/02 "HSCT+, Only 1 dose after HSCT, ≥1 dose before, BLD before HSCT, LD ≥ 4w after HSCT: To do 6m after LD"
          IF ALL OF
            INTERVAL(CALC:MenC_penultimate_dose_date,COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)")>=1d
            INTERVAL(COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)",CALC:MenC_last_dose_date)>=4w
          DO Recommended
            Status DUE
            Delay 6m from CALC:MenC_last_dose_date
          MESSAGES  MSG244
        END RULE 222/02

        RULE 222/03 "HSCT+, ≥ 2 doses after HSCT, BLD ≥ 4w after HSCT, BLD-LD ≥ 4w: To do booster 5y after LD"
          IF ALL OF
            CALC:Age>=12m
            CALC:MenC_doses_received>=2
            INTERVAL(COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)",CALC:MenC_penultimate_dose_date)>=4w
            INTERVAL(CALC:MenC_penultimate_dose_date,CALC:MenC_last_dose_date)>=4w
          DO Recommended
            Status DUE
            Delay 5y from CALC:MenC_last_dose_date
          MESSAGES  MSG252
        END RULE 222/03

        RULE 222/04 "HSCT+, ≥ 1 dose, BLD ≤ 3w after HSCT: Special case - vaccination too soon after HSCT"
          IF INTERVAL(COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)",CALC:MenC_penultimate_dose_date) in 1d..3w
          DO Exception
          MESSAGES  MSG289
        END RULE 222/04

        RULE 222/05 "HSCT+, ≥ 1 dose, LD ≤ 3w after HSCT: Special case - vaccination too soon after HSCT"
          IF INTERVAL(COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)",CALC:MenC_last_dose_date) in 1d..3w
          DO Exception
          MESSAGES  MSG292
        END RULE 222/05
      END FOLDER 222
    END FOLDER 22
  END FOLDER 2

  FOLDER 8 "Contraindications and special cases (Copie)"

    RULE 8/01 "Pregnant : message contraindicate"
      WHEN Recommended
      IF SYNTH:PREGNANCY_ONGOING "PREGNANCY - Pregnancy in progress" = true
      DO Contraindicated
      MESSAGES  MSG260 MSG261 MSG262
    END RULE 8/01

    RULE 8/02 "First dose too early (≤ 5w)"
      IF CALC:MenC_age_at_first_dose<=5w
      DO Exception
      MESSAGES  MSG272
    END RULE 8/02

    RULE 8/03 "Case  « Refusal to vaccinate against this disease » checked: Special case + message"
      IF ALL OF
        CALC:Age>=2m
        COND:C618 "Refusal of Meningococcal ACWY Vaccination" = true
      DO Exception
      MESSAGES  MSG268 MSG271
    END RULE 8/03
  END FOLDER 8

  FOLDER 9 "Further information (Copie)"

    FOLDER 91 "Common messages ACWY (Copie)"

      RULE 91/01 "If to do, RF+: Justification for vaccination"
        WHEN Recommended
        IF ALL OF
          CALC:Age>=1d
          SYNTH:MEN_RF_W_HSCT "MEN-RF : All Risk factors for invasive meningococcal infections (med / Pro / Others / HSCT)" = true
        DO Neutral
        MESSAGES  MSG265
      END RULE 91/01

      RULE 91/03 "d1d2 : Too short interval"
        IF CALC:MenC_d1d2<4w
        DO Neutral
        MESSAGES  MSG246
      END RULE 91/03

      RULE 91/04 "1 dose MENVEO before 2y old: message not before 24m (Only for C)"
        IF ALL OF
          CALC:MenC_age_at_first_dose<=23m
          CALC:MenC_first_vaccine = VAC0141 #MENVEO
        DO Neutral
        MESSAGES  MSG258
      END RULE 91/04

      RULE 91/06 "If reco: General rationale for meningococcal vaccination"
        IF CALC:Age>=1d
        DO Neutral
        MESSAGES  MSG309
      END RULE 91/06
    END FOLDER 91

    FOLDER 92 "Usable vaccines (Copie)"

      FOLDER 921 "HSCT- (Je ne sais pas trop ce qu'il faut conserver...) (Copie)"
        IF SYNTH:MEN_RF_3 "MEN-RF-3 : Haematopoietic stem cell transplants" = false

        RULE 921/01 "If to do, RF+, HSCT-, ≤ 11m old: Nimenrix"
          WHEN Recommended
          IF ALL OF
            CALC:Age<=11m
            SYNTH:MEN_RF_WO_HSCT "MEN-RF : All Risk factors for invasive meningococcal infections (Med / Pro / Other - without HSCT)" = true
          DO Neutral
          MESSAGES  MSG273
        END RULE 921/01

        RULE 921/02 "If to do, RF+, HSCT-, ≤ 11m old, 1 dose, LD ≤ 5m old: Nimenrix"
          WHEN Recommended
          IF ALL OF
            CALC:Age<=11m
            CALC:MenC_age_at_last_dose<=5m
            SYNTH:MEN_RF_WO_HSCT "MEN-RF : All Risk factors for invasive meningococcal infections (Med / Pro / Other - without HSCT)" = true
          DO Neutral
          MESSAGES  MSG273
        END RULE 921/02

        RULE 921/03 "If to do, RF+, HSCT-, ≤ 11m old, 1 dose, LD ≥ 6m old: Nimenrix, Menquadfi"
          WHEN Recommended
          IF ALL OF
            CALC:Age<=11m
            CALC:MenC_age_at_last_dose>=6m
            SYNTH:MEN_RF_WO_HSCT "MEN-RF : All Risk factors for invasive meningococcal infections (Med / Pro / Other - without HSCT)" = true
          DO Neutral
        END RULE 921/03

        RULE 921/04 "If to do, RF+, HSCT-, [12-23m] old: Nimenrix, Menquadfi"
          WHEN Recommended
          IF ALL OF
            CALC:Age in 12m..23m
            SYNTH:MEN_RF_WO_HSCT "MEN-RF : All Risk factors for invasive meningococcal infections (Med / Pro / Other - without HSCT)" = true
          DO Neutral
          MESSAGES  MSG282
        END RULE 921/04

        RULE 921/05 "If to do, RF+, HSCT-, ≥ 24m old: Nimenrix, Menquadfi, Menveo"
          WHEN Recommended
          IF ALL OF
            CALC:Age>=24m
            SYNTH:MEN_RF_WO_HSCT "MEN-RF : All Risk factors for invasive meningococcal infections (Med / Pro / Other - without HSCT)" = true
          DO Neutral
          MESSAGES  MSG234
        END RULE 921/05
      END FOLDER 921

      FOLDER 922 "HSCT+ (Copie)"
        IF SYNTH:MEN_RF_3 "MEN-RF-3 : Haematopoietic stem cell transplants" = true

        RULE 922/01 "[12-23m] old, Message to HSCT recipients: vaccines that can be used if required"
          WHEN Recommended
          IF CALC:Age in 12m..23m
          DO Recommended
            Status DUE
          MESSAGES  MSG282
        END RULE 922/01

        RULE 922/02 "≥ 24m old, Message to HSCT recipients: vaccines that can be used if required"
          WHEN Recommended
          IF CALC:Age>=24m
          DO Recommended
            Status DUE
          MESSAGES  MSG234
        END RULE 922/02
      END FOLDER 922
    END FOLDER 92
  END FOLDER 9
END FOLDER 0
END TARGET

MESSAGE MSG265 Comments ANY PRIO 0
  "Vaccination recommended in the presence of one of the following risk factors:<br>
- Military;<br>
- Research laboratory personnel working specifically on meningococcus;<br>
- Adolescents and young adults aged 15 to 24 living in dormitories;<br>
- Adolescents and young adults aged 15 to 24 who smoke;<br>
- Persons with terminal complement deficiency or receiving anti-C5 treatment, particularly persons treated with eculizumab (SOLIRIS®) or ravulizumab (ULTROMIRIS®). These persons must be monitored post-vaccination due to the possible risk of haemolysis;<br>
- Persons with properdin deficiency;<br>
- Persons with anatomical or functional asplenia;<br>
- People who have received a hematopoietic stem cell transplant;<br>
- Persons infected with HIV."@en
 END MESSAGE MSG265

MESSAGE MSG266 Justification ANY PRIO 0
  "Risk factor for serious meningococcal infection: booster vaccination 5 years after the last dose with a quadrivalent meningococcal conjugate vaccine."@en
 END MESSAGE MSG266

MESSAGE MSG237 Summary ANY PRIO 0
  "Non-conjugated vaccines provide protection for a shorter period and are less effective than conjugated vaccines."@en
 END MESSAGE MSG237

MESSAGE MSG238 Justification ANY PRIO 0
  "If the person has previously received an ACWY non-conjugated polysaccharide tetravalent vaccine or an A+C non-conjugated polysaccharide vaccine, a delay of 2 years is recommended before vaccinating them with an ACWY conjugated tetravalent vaccine."@en
 END MESSAGE MSG238

MESSAGE MSG274 Justification ANY PRIO 0
  "After a vaccination schedule comprising 2 doses received before the age of 12 months, a booster vaccination is recommended from the age of 12 months with an interval of at least 2 months after the 2nd dose."@en
 END MESSAGE MSG274

MESSAGE MSG300 Summary ANY PRIO 0
  "Last dose administered before 12 months of age: an additional dose is recommended at least 2 months after the previous one and from 12 months of age."@en
 END MESSAGE MSG300

MESSAGE MSG260 Alert PATIENT PRIO 0
  "During your pregnancy, vaccination only if the risk of exposure is clearly defined."@en
 END MESSAGE MSG260

MESSAGE MSG261 Alert PRO PRIO 0
  "During pregnancy, vaccination only if the risk of exposure is clearly defined."@en
 END MESSAGE MSG261

MESSAGE MSG262 Justification ANY PRIO 0
  "There are no clinical data on the use of meningococcal vaccines in pregnant women. However, given the seriousness of meningococcal disease, pregnancy should not preclude vaccination when the risk of exposure is clearly defined."@en
 END MESSAGE MSG262

MESSAGE MSG282 Other PRO PRIO 10
  "Vaccine usable : MENQUADFI, NIMENRIX. "@en
 END MESSAGE MSG282

MESSAGE MSG338 Summary ANY PRIO 0
  "The administration of the vaccine should be performed only subcutaneously: see comments."@en
 END MESSAGE MSG338

MESSAGE MSG339 Comments ANY PRIO 0
  "All injectable vaccines carry a risk of intramuscular haematoma in patients with thrombocytopenia, coagulation disorders or receiving anticoagulant therapy. In general, vaccines should be administered with caution to such patients. Whenever possible, subcutaneous administration should be preferred."@en
 END MESSAGE MSG339

MESSAGE MSG234 Other PRO PRIO 10
  "Vaccines usable : MENQUADFI, MENVEO ou NIMENRIX. "@en
 END MESSAGE MSG234

MESSAGE MSG273 Other PRO PRIO 10
  "Vaccine usable : NIMENRIX."@en
 END MESSAGE MSG273

MESSAGE MSG309 Justification ANY PRIO 5
  "Vaccination helps prevent serious meningococcal infections (meningitis and septicemia), which can lead to permanent after-effects (deafness, neurological disorders) or death. In addition, vaccination limits the circulation of bacteria in the population."@en
 END MESSAGE MSG309

MESSAGE MSG268 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against these diseases has been checked in the health profile (section “Refusal of vaccination”)."@en
 END MESSAGE MSG268

MESSAGE MSG271 Alert ANY PRIO 0
  "Vaccination against meningococcal ACWY was refused."@en
 END MESSAGE MSG271

MESSAGE MSG258 Alert ANY PRIO 0
  "The MENVEO vaccine should not be administered before the age of 24 months."@en
 END MESSAGE MSG258

MESSAGE MSG235 Details ANY PRIO 0
  "Started between 6 weeks and 5 months, the vaccination schedule against ACWY meningococcus includes two doses spaced two months apart of the NIMENRIX vaccine, then a booster from the age of 12 months, respecting an interval of two months with the previous dose."@en
 END MESSAGE MSG235

MESSAGE MSG232 Details ANY PRIO 0
  "Started between 6 and 11 months, vaccination against meningococcus A, C, W and Y includes one dose then a booster from the age of 12 months, respecting a minimum interval of two months with the previous dose.<br>
Started from the age of 12 months, it includes a single dose.<br>
Booster shots are then necessary every 5 years in the event of a risk factor."@en
 END MESSAGE MSG232

MESSAGE MSG252 Summary ANY PRIO 0
  "Vaccination booster every 5 years in people at risk."@en
 END MESSAGE MSG252

MESSAGE MSG292 Alert ANY PRIO 0
  "The last dose was administered too soon after the transplant (less than 4 weeks later): specialist advice is recommended."@en
 END MESSAGE MSG292

MESSAGE MSG244 Summary ANY PRIO 0
  "In people who have received hematopoietic stem cell transplants, the post-transplant vaccination schedule consists of 2 doses spaced 6 months apart."@en
 END MESSAGE MSG244

MESSAGE MSG246 Summary ANY PRIO 0
  "The interval between the first two doses is too short."@en
 END MESSAGE MSG246

MESSAGE MSG272 Alert ANY PRIO 0
  "Misuse: First dose was administered too early. Specialist medical advice required."@en
 END MESSAGE MSG272

MESSAGE MSG270 Alert ANY PRIO 0
  "There should normally be a delay of at least 12 months between the date of the transplant and the administration of the vaccine: specialist advice is recommended."@en
 END MESSAGE MSG270

MESSAGE MSG264 Summary ANY PRIO 0
  "Vaccination is recommended 12 to 18 months after hematopoietic stem cell transplant."@en
 END MESSAGE MSG264

MESSAGE MSG297 Summary ANY PRIO 0
  "Vaccination is recommended from one year of age, 12 to 18 months after hematopoietic stem cell transplant."@en
 END MESSAGE MSG297

MESSAGE MSG289 Alert ANY PRIO 0
  "The penultimate dose was administered much too soon after the transplant (less than 4 weeks later): specialist advice is recommended."@en
 END MESSAGE MSG289

MESSAGE MSG250 Summary ANY PRIO 0
  "Doses of vaccine received prior to a bone marrow transplant are not taken into account."@en
 END MESSAGE MSG250

MESSAGE MSG251 Justification ANY PRIO 0
  "In the event of a bone marrow transplant, the immune system is reset, so to speak, and vaccination must therefore be restarted from the beginning."@en
 END MESSAGE MSG251
