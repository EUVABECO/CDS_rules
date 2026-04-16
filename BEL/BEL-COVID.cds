CALC Covid_doses_received IS HIST(COVID,0,count)
CALC Covid_first_dose_date IS HIST(COVID,1,date)
CALC Covid_second_dose_date IS HIST(COVID,2,date)
CALC Covid_last_dose_date IS HIST(COVID,-1,date)
CALC Covid_last_dose_valences IS HIST(COVID,-1,valences)
CALC Covid_time_since_last_dose IS INTERVAL(CALC:Covid_last_dose_date,BASE:eval)

SYNTH LASTEXPO "LASTEXPO - Dernière exposition à l'Ag est un vaccin" IS ANY OF
  INTERVAL(COND:C919 "Date of last COVID-19",CALC:Covid_last_dose_date)>=1d
  SYNTH:COV-ATCD "COV-ATCD - Au moins un ATCD covid (V/F)" = false

SYNTH COV-ATCD "COV-ATCD - Au moins un ATCD covid (V/F)" IS ALL OF COND:C919 "Date of last COVID-19">=1d

SYNTH PREGNANCY_ONGOING "COMMON-PREGNANCY - Pregnancy in progress" IS ALL OF
  COND:C52 "Pregnancy - Date of last period" in 1d..41w
  SYNTH:PREGNANCY_OVER "COMMON-PREGNANCY - Pregnancy over" = false

SYNTH PREGNANCY_OVER "COMMON-PREGNANCY - Pregnancy over" IS ANY OF
  COND:C52 "Pregnancy - Date of last period">=42w
  COND:C1032 "Date of delivery">=0d

SYNTH COV-SCH-XBB "COV-SCH-XBB Dernière dose reçue est un vaccin XBB" IS ANY OF
  CALC:Covid_last_dose_valences contains Covid-ARNm-S-OMI-XBB-1-5-3
  CALC:Covid_last_dose_valences contains Covid-ARNm-S-OMI-XBB-1-5-10
  CALC:Covid_last_dose_valences contains Covid-ARNm-S-OMI-XBB-1-5-30

SYNTH COV-EXPO "Au moins une exposition à l'antigène" IS ANY OF
  CALC:Covid_doses_received >= 1
  SYNTH:COV-ATCD = true
  
SYNTH COV-LASTEXPO "COV-LASTEXPO - Dernière exposition à l'Ag est la covid" IS ANY OF
  INTERVAL(CALC:Covid_last_dose_date,COND:C919 "Date of last COVID-19")>=1d
  SYNTH:COV-LASTEXPO-1 "COV-LASTEXPO-1 Intermédiaire - Au moins 1 covid et 0 dose" = true

SYNTH COV-LASTEXPO-1 "COV-LASTEXPO-1 Intermédiaire - Au moins 1 covid et 0 dose" IS ALL OF
  SYNTH:COV-ATCD "COV-ATCD - Au moins un ATCD covid (V/F)" = true
  CALC:Covid_doses_received = 0

SYNTH COV-RF-ID "COV-RF-ID - ID fortes pour vaccination des ID contre la Covid 19" IS ANY OF
  COND:C917 "Strong immunosuppressive treatment (covid)" = true
  COND:C932 "Date of a solid organ transplant (kidney, heart, liver or lungs)">=1d
  COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)">=1d
  COND:C578 "Ongoing chemotherapy for solid tumor (cancer)" = true
  COND:C594 "Ongoing chemotherapy for hematological malignancy (leukemia)" = true
  COND:C1231 "Immunocompromised person" = true

TARGET COVID
FOLDER - "General rules"

  RULE 01 "rejouer"
    IF CALC:Age>=1d
    DO Neutral
    MESSAGES  MSG346
  END RULE 01
END FOLDER -

FOLDER 1 "[6-59m] old"
  IF CALC:Age in 0m..4y

  FOLDER 11 "RF+"
    IF SYNTH:FLU-RF-ALL "Risk factors for severe influenza and COVID-19 (Group 1 + 2 + 3 + 4)" = true

    FOLDER 111 "No history of COVID-19"
      IF SYNTH:COV-ATCD "COV-ATCD - Au moins un ATCD covid (V/F)" = false

      RULE 111/01 "[6m-4y] old, 0 dose, RF+, History-: To do from 6m old"
        IF CALC:Covid_doses_received = 0
        DO Recommended
          Status DUE
          Age 6m
        MESSAGES  MSG224
      END RULE 111/01

      RULE 111/02 "[6m-4y] old, 1 dose, RF+, History-: To do 3w after LD"
        IF CALC:Covid_doses_received = 1
        DO Recommended
          Status DUE
          Age 6m
          Delay 3w from CALC:Covid_last_dose_date
        MESSAGES  MSG216
      END RULE 111/02

      RULE 111/03 "[6m-4y] old, 2 doses, RF+, History-: To do 8w after LD"
        IF CALC:Covid_doses_received = 2
        DO Recommended
          Status DUE
          Age 6m
          Delay 8w from CALC:Covid_last_dose_date
        MESSAGES  MSG223
      END RULE 111/03
    END FOLDER 111

    FOLDER 112 "History of COVID-19"
      IF SYNTH:COV-ATCD "COV-ATCD - Au moins un ATCD covid (V/F)" = true

      RULE 112/01 "[6m-4y] old, 0 dose, RF+, History+:  To do 6m after history"
        IF CALC:Covid_doses_received = 0
        DO Recommended
          Status DUE
          Age 6m
          Delay 6m from COND:C919 "Date of last COVID-19"
        MESSAGES  MSG237
      END RULE 112/01

      RULE 112/02 "[6m-4y] old, 1 dose, RF+, History+, Last exposure = vaccine, COVID-LD ≥ 10s: To do 3w after LD"
        IF ALL OF
          CALC:Covid_doses_received = 1
          SYNTH:LASTEXPO "LASTEXPO - Dernière exposition à l'Ag est un vaccin" = true
          INTERVAL(COND:C919 "Date of last COVID-19",CALC:Covid_last_dose_date)>=10w
        DO Recommended
          Status DUE
          Age 6m
          Delay 3w from CALC:Covid_last_dose_date
        MESSAGES  MSG213 MSG214 MSG215
      END RULE 112/02

      RULE 112/03 "[6m-4y] old, 1 dose, RF+, History+, Last exposure = vaccine, d-COVID [0-9w]: To do 3m (13w) after last COVID"
        IF ALL OF
          CALC:Covid_doses_received = 1
          SYNTH:LASTEXPO "LASTEXPO - Dernière exposition à l'Ag est un vaccin" = true
          INTERVAL(COND:C919 "Date of last COVID-19",CALC:Covid_first_dose_date) in 1d..9w
        DO Recommended
          Status DUE
          Age 6m
          Delay 13w from COND:C919 "Date of last COVID-19"
        MESSAGES  MSG213 MSG240 MSG215
      END RULE 112/03

      RULE 112/04 "[6m-4y] old, 1 dose, RF+, History+, Last exposure = covid: To do 3m after COVID"
        IF ALL OF
          CALC:Covid_doses_received = 1
          SYNTH:COV-LASTEXPO "COV-LASTEXPO - Dernière exposition à l'Ag est la covid" = true
        DO Recommended
          Status DUE
          Age 6m
          Delay 3m from COND:C919 "Date of last COVID-19"
        MESSAGES  MSG213 MSG228 MSG229
      END RULE 112/04

      RULE 112/05 "[6m-4y] old, 2 dose, RF+, History+, Last exposure = vaccine, COVID-LD ≥ 5w:  To do 8w after LD"
        IF ALL OF
          CALC:Covid_doses_received = 2
          SYNTH:LASTEXPO "LASTEXPO - Dernière exposition à l'Ag est un vaccin" = true
          INTERVAL(COND:C919 "Date of last COVID-19",CALC:Covid_second_dose_date)>=5w
        DO Recommended
          Status DUE
          Age 6m
          Delay 8w from CALC:Covid_last_dose_date
        MESSAGES  MSG213 MSG235 MSG215
      END RULE 112/05

      RULE 112/06 "[6m-4y] old, 2 doses, RF+, History+, Last exposure = vaccine, COVID-LD [0-4w]: To do 3m (13w) after COVID"
        IF ALL OF
          CALC:Covid_doses_received = 2
          SYNTH:LASTEXPO "LASTEXPO - Dernière exposition à l'Ag est un vaccin" = true
          INTERVAL(COND:C919 "Date of last COVID-19",CALC:Covid_second_dose_date) in 1d..4w
        DO Recommended
          Status DUE
          Age 6m
          Delay 13w from COND:C919 "Date of last COVID-19"
        MESSAGES  MSG213 MSG215 MSG226
      END RULE 112/06

      RULE 112/07 "[6m-4y] old, 2 doses, RF+, History+, Last exposure = covid: To do 3m after COVID"
        IF ALL OF
          SYNTH:COV-LASTEXPO "COV-LASTEXPO - Dernière exposition à l'Ag est la covid" = true
          CALC:Covid_doses_received = 2
        DO Recommended
          Status DUE
          Age 6m
          Delay 3m from COND:C919 "Date of last COVID-19"
        MESSAGES  MSG213 MSG228 MSG239
      END RULE 112/07
    END FOLDER 112
  END FOLDER 11

  FOLDER 12 "RF+ or RF-"

    RULE 12/01 "[6-59m] old, ≥ 3 doses: Up to date"
      IF CALC:Covid_doses_received>=3
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG211
    END RULE 12/01
  END FOLDER 12
END FOLDER 1

FOLDER 2 "≥ 60m old"
  IF CALC:Age>=5y

  FOLDER 21 "RF-"
    IF SYNTH:FLU-RF-ALL "Risk factors for severe influenza and COVID-19 (Group 1 + 2 + 3 + 4)" = false

    FOLDER 211 "No history of COVID-19"
      IF SYNTH:COV-EXPO = false

      RULE 211/01 "[5m-64y], 0 dose, RF-, History: Possible"
        IF CALC:Age>=5y
        DO Suggested
        MESSAGES  MSG222
      END RULE 211/01
    END FOLDER 211

    FOLDER 212 "History of COVID-19"
      IF SYNTH:COV-EXPO = true

      FOLDER 1121 "Last exposure = vaccine"
        IF SYNTH:LASTEXPO "LASTEXPO - Dernière exposition à l'Ag est un vaccin" = true

        RULE 1121/1 "[5m-64y], 0 dose, RF-, History+, Last exposure =. vaccine, LD ≤ 5m: Possible 6m after LD"
          IF CALC:Covid_time_since_last_dose<=5m
          DO Suggested
          MESSAGES  MSG233
        END RULE 1121/1

        RULE 1121/2 "[5m-64y], 0 dose, RF-, History+, Last exposure = vaccine not XBB, LD ≥ 6m: Possible"
          IF ALL OF
            SYNTH:COV-SCH-XBB "COV-SCH-XBB Dernière dose reçue est un vaccin XBB" = false
            CALC:Covid_time_since_last_dose>=6m
          DO Suggested
          MESSAGES  MSG194
        END RULE 1121/2

        RULE 1121/3 "[5m-64y], 0 dose, RF-, History+, Last exposure = vaccine XBB: Up to date"
          IF SYNTH:COV-SCH-XBB "COV-SCH-XBB Dernière dose reçue est un vaccin XBB" = true
          DO Recommended
            Status COMPLETED
          MESSAGES  MSG231
        END RULE 1121/3
      END FOLDER 1121

      FOLDER 1122 "Last exposure = COVID-19"
        IF SYNTH:COV-LASTEXPO "COV-LASTEXPO - Dernière exposition à l'Ag est la covid" = true

        RULE 1122/1 "[5m-64y], 0 dose, RF-, History+, Last exposure = COVID-19, COVID-19 ≤ 5m: Possible 6m after last COVID-19"
          IF COND:C919 "Date of last COVID-19"<=5m
          DO Suggested
          MESSAGES  MSG227
        END RULE 1122/1

        RULE 1122/2 "[5m-64y], 0 dose, RF-, History+, Last exposure = COVID-19, COVID-19 ≥ 6m: Possible 6m after last COVID-19"
          IF COND:C919 "Date of last COVID-19">=6m
          DO Suggested
          MESSAGES  MSG230
        END RULE 1122/2
      END FOLDER 1122
    END FOLDER 212
  END FOLDER 21

  FOLDER 22 "RF+"
    IF SYNTH:FLU-RF-ALL "Risk factors for severe influenza and COVID-19 (Group 1 + 2 + 3 + 4)" = true

    FOLDER 221 "No history of COVID-19"
      IF SYNTH:COV-EXPO = false

      RULE 221/1 "≥ 5y, RF+, History-, 0 dose: To do from 60m old"
        IF CALC:Age>=59m
        DO Recommended
          Status DUE
          Age 60m
      END RULE 221/1
    END FOLDER 221

    FOLDER 222 "History of COVID-19"
      IF SYNTH:COV-EXPO = true

      FOLDER 1221 "Last exposure = vaccine"
        IF SYNTH:LASTEXPO "LASTEXPO - Dernière exposition à l'Ag est un vaccin" = true

        FOLDER 12211 "ID -"
          IF SYNTH:COV-RF-ID "COV-RF-ID - ID fortes pour vaccination des ID contre la Covid 19" = false

          RULE 122-11/01 "≥ 5y old, ID-, RF+, History+, Last exposure = vaccine not XBB: To do 6m after LD"
            IF SYNTH:COV-SCH-XBB "COV-SCH-XBB Dernière dose reçue est un vaccin XBB" = false
            DO Recommended
              Status DUE
              Delay 6m from CALC:Covid_last_dose_date
            MESSAGES  MSG219 MSG243
          END RULE 122-11/01

          RULE 122-11/02 "≥ 5y old, ID-, RF+, History+, Last exposure = vaccine XBB: To do 12m after LD"
            IF SYNTH:COV-SCH-XBB "COV-SCH-XBB Dernière dose reçue est un vaccin XBB" = true
            DO Recommended
              Status DUE
              Delay 1y from CALC:Covid_last_dose_date
            MESSAGES  MSG195 MSG244
          END RULE 122-11/02
        END FOLDER 12211

        FOLDER 12212 "ID +"
          IF SYNTH:COV-RF-ID "COV-RF-ID - ID fortes pour vaccination des ID contre la Covid 19" = true

          RULE 122-12/01 "≥ 5y old, ID+, RF+, History+, Last exposure = vaccine: To do 4m after LD"
            IF CALC:Age>=5y
            DO Recommended
              Status DUE
              Delay 4m from CALC:Covid_last_dose_date
            MESSAGES  MSG212
          END RULE 122-12/01
        END FOLDER 12212
      END FOLDER 1221

      FOLDER 1222 "Last exposure = COVID-19"
        IF SYNTH:COV-LASTEXPO "COV-LASTEXPO - Dernière exposition à l'Ag est la covid" = true

        FOLDER 12221 "ID -"
          IF SYNTH:COV-RF-ID "COV-RF-ID - ID fortes pour vaccination des ID contre la Covid 19" = false

          RULE 122-21/01 "≥ 5y old, ID-, RF+, History+, Last exposure = COVID-19: To do 6m after COVID-19"
            IF CALC:Age>=5y
            DO Recommended
              Status DUE
              Delay 6m from COND:C919 "Date of last COVID-19"
            MESSAGES  MSG209
          END RULE 122-21/01
        END FOLDER 12221

        FOLDER 12222 "ID +"
          IF SYNTH:COV-RF-ID "COV-RF-ID - ID fortes pour vaccination des ID contre la Covid 19" = true

          RULE 122-22/01 "≥ 5y old, ID+, RF+, History+, Last exposure = COVID-19: To do 4m after COVID-19"
            IF CALC:Age>=5y
            DO Recommended
              Status DUE
              Delay 4m from COND:C919 "Date of last COVID-19"
            MESSAGES  MSG221
          END RULE 122-22/01
        END FOLDER 12222
      END FOLDER 1222
    END FOLDER 222
  END FOLDER 22
END FOLDER 2

FOLDER 8 "Contraindications and special cases"

  RULE 8/01 "Case « Contraindication to COVID-19 vaccination » checked: Contraindication + message"
    IF COND:C968 "Contraindication to vaccination against covid 19" = true
    DO Contraindicated
    MESSAGES  MSG14 MSG15
  END RULE 8/01

  RULE 8/02 "Case  « Refusal to vaccinate against this disease » checked: Special case + message"
    IF COND:C865 "Refusal to vaccinate against covid 19" = true
    DO Exception
    MESSAGES  MSG6 MSG7
  END RULE 8/02
END FOLDER 8

FOLDER 9 "Further information"

  RULE 9/01 "if to do, [6m-4y] old: Information about scheme"
    WHEN Recommended
    IF CALC:Age in 6m..4y
    DO Neutral
    MESSAGES  MSG217
  END RULE 9/01

  RULE 9/02 "≥ 12y old, ID+: Messages information"
    IF ALL OF
      SYNTH:COV-RF-ID "COV-RF-ID - ID fortes pour vaccination des ID contre la Covid 19" = true
      CALC:Age>=12y
    DO Neutral
    MESSAGES  MSG199 MSG201 MSG202
  END RULE 9/02

  RULE 9/04 "≥ 55y old: Message d'information"
    WHEN Recommended
    IF CALC:Age>=55y
    DO Neutral
    MESSAGES  MSG220
  END RULE 9/04

  RULE 9/05 "Pregnancy in progress: Message information"
    WHEN Recommended
    IF SYNTH:PREGNANCY_ONGOING "COMMON-PREGNANCY - Pregnancy in progress" = true
    DO Neutral
    MESSAGES  MSG205 MSG206 MSG207 MSG208
  END RULE 9/05

  RULE 9/06 "Pregnancy in progress (≤ 15w):- Message d'alerte"
    WHEN Recommended
    IF COND:C52 "Pregnancy - Date of last period" in 1d..15w
    DO Neutral
    MESSAGES  MSG204
  END RULE 9/06
END FOLDER 9
END TARGET

MESSAGE MSG213 Justification ANY PRIO 0
  "In the event of SARS-CoV-2 infection, whether it occurs before the start of the vaccination schedule, between the 1st and 2nd injection or between the 2nd and 3rd injection, the administration of the 3 doses remains recommended to obtain optimal protection. It is recommended to respect an interval of at least 3 months (13 weeks) between the date of infection and the next vaccination."@en
 END MESSAGE MSG213

MESSAGE MSG215 Summary ANY PRIO 10
  "It is recommended to continue the 3-dose vaccination schedule in case of a history of COVID-19."@en
 END MESSAGE MSG215

MESSAGE MSG226 Justification ANY PRIO 0
  "In this case, the 2nd vaccine dose was administered less than 5 weeks after the history of COVID-19: the 3rd dose must be administered at least 3 months (i.e. 13 weeks) after the history (which will also respect the 8-week period between the last 2 vaccine doses)."@en
 END MESSAGE MSG226

MESSAGE MSG205 Comments ANY PRIO 0
  "Vaccination against COVID-19 is well tolerated in pregnant women and can be carried out from the first trimester."@en
 END MESSAGE MSG205

MESSAGE MSG206 Summary ANY PRIO 0
  "Vaccination is recommended for all pregnant women with a risk factor with an mRNA vaccine."@en
 END MESSAGE MSG206

MESSAGE MSG207 Justification PATIENT PRIO 0
  "Vaccination protects you from severe COVID-19 and the risk of being hospitalized. In addition, it also protects the infant thanks to antibodies that have crossed the placenta."@en
 END MESSAGE MSG207

MESSAGE MSG208 Justification PRO PRIO 0
  "Vaccination protects pregnant women against severe forms of COVID-19 and reduces the risk of hospitalization or death. In addition, specific antibodies against SARS-CoV-2 cross the placental barrier and provide neonatal protection."@en
 END MESSAGE MSG208

MESSAGE MSG195 Justification ANY PRIO 0
  "In the absence of immunosuppression and for people who have already received vaccination with the COMIRNATY XBB.1.5 vaccine, next vaccination recommended from one year after the last dose."@en
 END MESSAGE MSG195

MESSAGE MSG244 Summary ANY PRIO 0
  "In the absence of immunosuppression, vaccination recommended from 12 months after the last dose."@en
 END MESSAGE MSG244

MESSAGE MSG228 Justification ANY PRIO 100
  "In the event of COVID-19 infection, a period of 3 months must be respected between the infection and the injection."@en
 END MESSAGE MSG228

MESSAGE MSG229 Summary ANY PRIO 0
  "It is recommended to continue the 3-dose vaccination schedule in case of a history of COVID-19: take a 2nd dose 3 months after infection."@en
 END MESSAGE MSG229

MESSAGE MSG235 Justification ANY PRIO 0
  "In this case, the history of COVID-19 dates back at least 5 weeks: a 3rd dose administered 8 weeks after the 2nd dose will therefore be administered at least 3 months (i.e. 13 weeks) after the history."@en
 END MESSAGE MSG235

MESSAGE MSG212 Justification ANY PRIO 0
  "Due to the existence of immunosuppression, the vaccine can be administered from 4 months after the last dose (instead of 6 months in the absence of immunosuppression)."@en
 END MESSAGE MSG212

MESSAGE MSG204 Alert ANY PRIO 0
  "Vaccination is possible from the first trimester."@en
 END MESSAGE MSG204

MESSAGE MSG209 Justification ANY PRIO 0
  "In the absence of immunosuppression, vaccination recommended from 6 months after the last history of COVID-19."@en
 END MESSAGE MSG209

MESSAGE MSG194 Summary ANY PRIO 1
  "In the absence of risk factors, vaccination with a suitable mRNA vaccine is possible without being particularly recommended, as more than 6 months have passed since the last dose received."@en
 END MESSAGE MSG194

MESSAGE MSG222 Justification ANY PRIO 0
  "In the absence of risk factors, vaccination is possible without being particularly recommended."@en
 END MESSAGE MSG222

MESSAGE MSG221 Justification ANY PRIO 0
  "Due to the existence of immunosuppression, the vaccine can be administered from 4 months after the last history of covid (instead of 6 months in the absence of immunosuppression)."@en
 END MESSAGE MSG221

MESSAGE MSG233 Summary ANY PRIO 0
  "In the absence of risk factors, vaccination with a suitable mRNA vaccine is possible without being particularly recommended, after a period of 6 months after the last dose received."@en
 END MESSAGE MSG233

MESSAGE MSG224 Summary ANY PRIO 0
  "Start a 3-dose vaccination schedule with a suitable mRNA vaccine."@en
 END MESSAGE MSG224

MESSAGE MSG230 Summary ANY PRIO 0
  "In the absence of risk factors, vaccination is possible with a suitable mRNA vaccine, but is not particularly recommended, as more than 6 months have passed since the last infection."@en
 END MESSAGE MSG230

MESSAGE MSG219 Summary ANY PRIO 0
  "In the absence of immunosuppression, vaccination recommended from 6 months after the last dose."@en
 END MESSAGE MSG219

MESSAGE MSG243 Justification ANY PRIO 0
  "In the absence of immunosuppression and for persons who have already been vaccinated, but not with the COMIRNATY XBB.1.5 vaccine, the next vaccination is recommended six months after the last dose."@en
 END MESSAGE MSG243

MESSAGE MSG231 Justification ANY PRIO 0
  "In the absence of risk factors, vaccination with a suitable mRNA vaccine may be considered from one year after the last dose received according to the recommendations in force at that time."@en
 END MESSAGE MSG231

MESSAGE MSG227 Summary ANY PRIO 0
  "In the absence of risk factors, vaccination is possible with a suitable mRNA vaccine but is not particularly recommended, after a period of 6 months after the last infection."@en
 END MESSAGE MSG227

MESSAGE MSG220 Justification ANY PRIO 0
  "The risk of severe COVID-19 disease increases exponentially with age. Vaccination is particularly effective in preventing severe forms of the disease."@en
 END MESSAGE MSG220

MESSAGE MSG240 Justification ANY PRIO 9
  "In this case, the 1st vaccine dose was administered less than 10 weeks after the history of COVID-19: the 2nd dose must be administered at least 3 months (i.e. 13 weeks) after the history (which will also respect the 3-week period between the first 2 vaccine doses)."@en
 END MESSAGE MSG240

MESSAGE MSG239 Summary ANY PRIO 0
  "It is recommended to continue the 3-dose vaccination schedule in case of a history of COVID-19: take a 3rd dose 3 months after infection."@en
 END MESSAGE MSG239

MESSAGE MSG217 Justification ANY PRIO 0
  "In children aged 6 months to 4 years with a risk factor for severe COVID-19, start a primary vaccination course with 3 doses as soon as possible with the vaccine diluted 1/10: 2 doses spaced 3 weeks apart, followed by one dose 8 weeks later. The advice of the pediatrician is recommended."@en
 END MESSAGE MSG217

MESSAGE MSG216 Summary ANY PRIO 0
  "Continue the 3-dose primary vaccination schedule: give a 2nd dose 3 weeks after the previous one."@en
 END MESSAGE MSG216

MESSAGE MSG214 Justification ANY PRIO 9
  "In this case, the history of COVID-19 dates back at least 10 weeks: a 2nd dose administered 3 weeks after the 1st dose will therefore be administered at least 3 months (i.e. 13 weeks) after the history."@en
 END MESSAGE MSG214

MESSAGE MSG199 Justification PATIENT PRIO 0
  "In cases of severe immunodeficiency, vaccination is less effective: it is therefore necessary to supplement it with appropriate precautions: wear a mask; ventilate for 10 minutes every hour; wash your hands; respect physical distancing."@en
 END MESSAGE MSG199

MESSAGE MSG201 Summary PRO PRIO 0
  "Insist on respecting barrier measures and on vaccinating those around you."@en
 END MESSAGE MSG201

MESSAGE MSG202 Justification ANY PRIO 0
  "In cases of severe immunosuppression, vaccination is less effective: it is therefore necessary to remind immunosuppressed people of the importance of hygiene measures (wearing a mask, regular ventilation, hand washing and respecting physical distancing)."@en
 END MESSAGE MSG202

MESSAGE MSG223 Summary ANY PRIO 0
  "Continue the 3-dose primary vaccination schedule with a 3rd dose 8 weeks after the previous dose."@en
 END MESSAGE MSG223

MESSAGE MSG6 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG6

MESSAGE MSG7 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been checked in the health profile (section “Refusal of vaccination”)."@en
 END MESSAGE MSG7

MESSAGE MSG346 Details PATIENT PRIO 0
  "--"@en
 END MESSAGE MSG346

MESSAGE MSG237 Summary ANY PRIO 0
  "Due to a history of COVID-19, the 3-dose vaccination schedule should be started 3 months after infection."@en
 END MESSAGE MSG237

MESSAGE MSG14 Alert ANY PRIO 0
  "Vaccination contraindicated by the doctor."@en
 END MESSAGE MSG14

MESSAGE MSG15 Justification ANY PRIO 0
  "The box indicating a contraindication for this disease has been checked in the health profile (section “Contraindicated vaccinations”)."@en
 END MESSAGE MSG15

MESSAGE MSG211 Summary ANY PRIO 0
  "At least 3 doses received: vaccination schedule completed."@en
 END MESSAGE MSG211
