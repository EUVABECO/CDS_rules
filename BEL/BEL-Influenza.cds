
CALC INF_last_dose_date IS HIST(INF,-1,date)
CALC INF_time_since_last_dose IS INTERVAL(CALC:INF_last_dose_date,BASE:eval)

TARGET Influenza
FOLDER - "General rules"

  RULE 01 "rejouer"
    IF CALC:Age>=1d
    DO Neutral
    MESSAGES  MSG346
  END RULE 01
END FOLDER -

FOLDER 0 "0 dose"
  IF CALC:INF_doses_received = 0

  RULE 0/01 "[6m-64y] old, 0 dose, RF+ : To do from 6m old, Between Oct 15th and Febr 1st"
    IF ALL OF
      CALC:Age in 6m..64y
      CALC:INF_doses_received = 0
      SYNTH:FLU-RF-ALL "FLU-RF-ALL - Risk factors for severe influenza and COVID-19 (Group 1 + 2 + 3 + 4)" = true
    DO Recommended
      Status DUE
      Age 6m
  END RULE 0/01

  RULE 0/02 "[6m-64y] old, 0 dose, RF- : Possible"
    IF ALL OF
      CALC:Age in 6m..64y
      CALC:INF_doses_received = 0
      SYNTH:FLU-RF-ALL "FLU-RF-ALL - Risk factors for severe influenza and COVID-19 (Group 1 + 2 + 3 + 4)" = false
    DO Suggested
    MESSAGES  MSG144
  END RULE 0/02

  RULE 0/03 "≥ 64,5y old, 0 dose: To do from 65y old Between Oct 15th and Febr 1st"
    IF ALL OF
      CALC:Age>=774m
      CALC:INF_doses_received = 0
    DO Recommended
      Status DUE
      Age 65y
  END RULE 0/03
END FOLDER 0

FOLDER 1 "1 dose"
  IF CALC:INF_doses_received = 1

  RULE 1/01 "[6m-8y] old, 1 dose, LD ≤ 5m: To do 1m after LD"
    IF ALL OF
      CALC:INF_doses_received = 1
      CALC:Age in 6m..8y
      CALC:INF_time_since_last_dose<=5m
    DO Recommended
      Status DUE
      Delay 1m from CALC:INF_last_dose_date
  END RULE 1/01

  FOLDER 11 "RF +"
    IF SYNTH:FLU-RF-ALL "FLU-RF-ALL - Risk factors for severe influenza and COVID-19 (Group 1 + 2 + 3 + 4)" = true

    RULE 11/01 "[6m-8y] old, 1 dose, RF+: To do Between Oct 15th and Febr 1st, 6m after LD"
      IF ALL OF
        CALC:Age in 6m..8y
        CALC:INF_doses_received = 1
      DO Recommended
        Status DUE
        Delay 6m from CALC:INF_last_dose_date
    END RULE 11/01

    RULE 11/02 "[9-64y] old, 1 dose, RF+: To do Between Oct 15th and Febr 1st, 6m after LD"
      IF ALL OF
        CALC:Age in 9y..64y
        CALC:INF_doses_received = 1
      DO Recommended
        Status DUE
        Delay 6m from CALC:INF_last_dose_date
    END RULE 11/02

    RULE 11/03 "≥ 65y old, 1 dose, RF+: To do from 65y old, Between Oct 15th and Febr 1st, 6m after LD"
      IF ALL OF
        CALC:Age>=65y
        CALC:INF_doses_received = 1
      DO Recommended
        Status DUE
        Age 65y
        Delay 6m from CALC:INF_last_dose_date
    END RULE 11/03
  END FOLDER 11

  FOLDER 12 "RF -"
    IF ALL OF
    SYNTH:FLU-RF-ALL "FLU-RF-ALL - Risk factors for severe influenza and COVID-19 (Group 1 + 2 + 3 + 4)" = false
    CALC:Age<=64y

    RULE 12/01 "[6m-8y] old, 1 dose , RF-, LD ≥ 8m: Possible"
      IF ALL OF
        CALC:Age in 6m..8y
        CALC:INF_doses_received = 1
        CALC:INF_time_since_last_dose>=8m
      DO Suggested
      MESSAGES  MSG146 MSG147 MSG148
    END RULE 12/01

    RULE 12/02 "[9-64y] old, 1 dose, RF-, LD ≤ 7m: Up to date"
      IF ALL OF
        CALC:Age in 9y..64y
        CALC:INF_doses_received = 1
        CALC:INF_time_since_last_dose<=7m
      DO Recommended
        Status COMPLETED
    END RULE 12/02

    RULE 12/03 "[9-64y] old, 1 dose, RF-, LD ≥ 8m: Possible"
      IF ALL OF
        CALC:Age in 9y..64y
        CALC:INF_time_since_last_dose>=8m
      DO Suggested
      MESSAGES  MSG144 MSG145
    END RULE 12/03
  END FOLDER 12
END FOLDER 1

FOLDER 2 "2 doses et plus"
  IF CALC:INF_doses_received>=2

  FOLDER 21 "RF +"
    IF SYNTH:FLU-RF-ALL "FLU-RF-ALL - Risk factors for severe influenza and COVID-19 (Group 1 + 2 + 3 + 4)" = true

    RULE 21/01 "≥ 6m old, ≥  2 doses, RF+: To do Between Oct 15th and Febr 1st, 6m after LD"
      IF CALC:Age>=6m
      DO Recommended
        Status DUE
        Delay 6m from CALC:INF_last_dose_date
    END RULE 21/01
  END FOLDER 21

  FOLDER 22 "RF -"
    IF SYNTH:FLU-RF-ALL "FLU-RF-ALL - Risk factors for severe influenza and COVID-19 (Group 1 + 2 + 3 + 4)" = false

    RULE 22/01 "[6m-64y] od, ≥ 2 doses, RF-, LD ≤ 7m: Up to date"
      IF ALL OF
        CALC:Age in 6m..64y
        CALC:INF_time_since_last_dose<=7m
      DO Recommended
        Status COMPLETED
    END RULE 22/01

    RULE 22/02 "[6m-64y] old, ≥ 2 doses, RF-, LD ≥ 8m: Possible"
      IF ALL OF
        CALC:Age in 6m..64y
        CALC:INF_time_since_last_dose>=8m
      DO Suggested
      MESSAGES  MSG144 MSG145
    END RULE 22/02
  END FOLDER 22
END FOLDER 2

FOLDER 8 "Contraindications and special cases"

  RULE 8/01 "Case « Contraindication to flu vaccination » checked: Contraindication + message"
    IF COND:C1022 "Contraindication to influenza vaccination" = true
    DO Contraindicated
    MESSAGES  MSG14 MSG15
  END RULE 8/01

  RULE 8/02 "Case  « Refusal to vaccinate against this disease » checked: Special case + message"
    IF COND:C622 "Refusal of flu vaccination" = true
    DO Exception
    MESSAGES  MSG6 MSG7
  END RULE 8/02
END FOLDER 8

FOLDER 9 "Further information"

  RULE 9/01 "If to do, ≥ 65y old: Summary - Annual vaccination from age 65"
    IF CALC:Age>=65y
    DO Neutral
    MESSAGES  MSG143
  END RULE 9/01

  RULE 9/02 "If to do, [6m-8y] old, [0-1] dose: Summary - 2 doses 1m apart"
    IF ALL OF
      CALC:Age in 6m..8y
      CALC:INF_doses_received<=1
    DO Neutral
    MESSAGES  MSG140
  END RULE 9/02

  RULE 9/03 "If to do, ≥ 6m: Flu Information Messages"
    IF CALC:Age>=6m
    DO Neutral
    MESSAGES  MSG136 MSG137
  END RULE 9/03

  RULE 9/04 "If to do, ≥ 6m, ≥1 dose: Flu Information Messages"
    IF ALL OF
      CALC:Age>=6m
      CALC:INF_doses_received>=1
    DO Neutral
    MESSAGES  MSG139
  END RULE 9/04

  RULE 9/05 "If to do, ≥ 6m, RF+ (Not Pro and not BMI not ≥ 65y old): Summary - Vaccination recommended due to risk factors"
    IF ALL OF
      CALC:Age in 6m..64y
      SYNTH:FLU-RF-ALL "FLU-RF-ALL - Risk factors for severe influenza and COVID-19 (Group 1 + 2 + 3 + 4)" = true
      SYNTH:FLU-RF-GRP2 "FLU-RF-GRP2 - Occupational risk factors for vaccination against Covid 19 and flu" = false
      SYNTH:COMMON-BMI "COMMON-BMI - BMI ≥ 40" = false
    DO Neutral
    MESSAGES  MSG134
  END RULE 9/05

  RULE 9/06 "If to do, ≥ 6m, BMI ≥ 40, Justify - Vaccination recommended due to high BMI"
    IF ALL OF
      CALC:Age>=6m
      SYNTH:COMMON-BMI "COMMON-BMI - BMI ≥ 40" = true
    DO Neutral
    MESSAGES  MSG135
  END RULE 9/06

  RULE 9/07 "[50-64y] old, Alcool / Tabac / BMU ≥ 30: Justify - "
    IF SYNTH:FLU-RF-GRP4 "FLU-RF-GRP4 - [50-64y] old + (Tabac / Alcool / BMI ≥ 30)" = true
    DO Neutral
    MESSAGES  MSG149
  END RULE 9/07

  RULE 9/08 "If to do, ≥ 6m, Pro: Summary - Vaccination recommended due to profession"
    IF ALL OF
      CALC:Age>=6m
      SYNTH:FLU-RF-GRP2 "FLU-RF-GRP2 - Occupational risk factors for vaccination against Covid 19 and flu" = true
    DO Neutral
    MESSAGES  MSG141 MSG142
  END RULE 9/08

  RULE 9/09 "Show weight and height, BMI ≥ 30, [50-64y] old"
    IF ALL OF
      COND:C962 "Weight (kg)">=1
      COND:C963 "Height (cm)">=1
      CALC:Age in 50y..64y
      CALC:BMI >=30
    DO Neutral
  END RULE 9/09

  RULE 9/10 "Show weight and height, BMI ≥ 40"
    IF ALL OF
      COND:C962 "Weight (kg)">=1
      CALC:Age>=6m
      COND:C963 "Height (cm)">=1
      SYNTH:COMMON-BMI "COMMON-BMI - BMI ≥ 40" = true
    DO Neutral
  END RULE 9/10
END FOLDER 9
END TARGET

MESSAGE MSG146 Justification ANY PRIO 0
  "Vaccination is strongly recommended for children with a risk factor for serious influenza. Vaccination can nevertheless be carried out in the absence of a risk factor to reduce the risk of influenza and its consequences (school absenteeism)."@en
 END MESSAGE MSG146

MESSAGE MSG147 Summary PRO PRIO 0
  "In children under 9 years of age, the primary flu vaccination consists of 2 doses 1 month apart. The deadline for the 2nd dose has now passed: continuation of the vaccination schedule should be assessed based on the existence of risk factors."@en
 END MESSAGE MSG147

MESSAGE MSG148 Summary PATIENT PRIO 0
  "In children under 9 years of age, the primary flu vaccination consists of 2 doses 1 month apart. The deadline for the 2nd dose has now passed: ask your doctor for advice."@en
 END MESSAGE MSG148

MESSAGE MSG135 Justification ANY PRIO 0
  "Flu vaccination is recommended because high body mass index (obesity) is a risk factor for severe flu."@en
 END MESSAGE MSG135

MESSAGE MSG139 Other ANY PRIO 0
  "Due to variations in influenza viruses, revaccination every year, before the flu season, is necessary to benefit from optimal protection."@en
 END MESSAGE MSG139

MESSAGE MSG6 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG6

MESSAGE MSG7 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been checked in the health profile (section “Refusal of vaccination”)."@en
 END MESSAGE MSG7

MESSAGE MSG144 Justification ANY PRIO 0
  "Before the age of 65, vaccination is strongly recommended if there is a risk factor. But it is possible for anyone who wishes to do so in order to avoid the disease and its consequences (inconvenience, delay in schooling, inability to work, etc.)."@en
 END MESSAGE MSG144

MESSAGE MSG145 Summary ANY PRIO 0
  "Even in the absence of risk factors, influenza vaccination can be carried out every flu season."@en
 END MESSAGE MSG145

MESSAGE MSG346 Details PATIENT PRIO 0
  "--"@en
 END MESSAGE MSG346

MESSAGE MSG136 Comments ANY PRIO 0
  "Co-infection with seasonal influenza virus and SARS-COV-2 virus (responsible for COVID-19) may increase the risk of complications."@en
 END MESSAGE MSG136

MESSAGE MSG137 Justification ANY PRIO 0
  "The flu, which should not be confused with a cold or chill, is a respiratory infection with high fever, chills, muscle and back pain, and headaches. The symptoms of seasonal flu are very similar to those of COVID-19. The flu is especially dangerous because of the complications it can cause. These complications are mainly pneumonias that occur more frequently in the elderly and in people with other illnesses that predispose them to pneumonia. During flu periods, hospitalizations and deaths from pneumonia increase significantly. Vaccination against the flu helps reduce the risk of complications."@en
 END MESSAGE MSG137

MESSAGE MSG143 Summary ANY PRIO 0
  "Annual vaccination from the age of 65, between the beginning of October and the end of January."@en
 END MESSAGE MSG143

MESSAGE MSG140 Summary ANY PRIO 0
  "In children under 9 years of age, the primary flu vaccination consists of 2 doses 1 month apart."@en
 END MESSAGE MSG140

MESSAGE MSG134 Summary ANY PRIO 0
  "Influenza vaccination is strongly recommended because of the existence of a risk factor for severe influenza."@en
 END MESSAGE MSG134

MESSAGE MSG14 Alert ANY PRIO 0
  "Vaccination contraindicated by the doctor."@en
 END MESSAGE MSG14

MESSAGE MSG15 Justification ANY PRIO 0
  "The box indicating a contraindication for this disease has been checked in the health profile (section “Contraindicated vaccinations”)."@en
 END MESSAGE MSG15

MESSAGE MSG149 Justification ANY PRIO 0
  "Vaccination is recommended for people between 50 and 65 years old with one of the following risk factors:<br>
- BMI ≥ 30<br>
- excessive alcohol consumption<br>
- Smoking<br>"@en
 END MESSAGE MSG149

MESSAGE MSG141 Summary ANY PRIO 0
  "Influenza vaccination is strongly recommended for healthcare professionals."@en
 END MESSAGE MSG141

MESSAGE MSG142 Justification ANY PRIO 0
  "Vaccinating healthcare professionals against influenza helps protect vulnerable patients at risk of severe influenza."@en
 END MESSAGE MSG142
