CALC INF_doses_received IS HIST(INF,0,count)
CALC INF_last_dose_date IS HIST(INF,-1,date)

SYNTH FLU-RF-ADLT "FLU-RF-ADLT - Risk factors for severe influenza in adults" IS ANY OF
  SYNTH:PREGNANCY_ONGOING "PREGNANCY - Pregnancy in progress" = true
  SYNTH:AFFECTIONS-CHR-LUNG-ADLT "AFFECTIONS-CHR-LUNG-ADLT - Chronic lung disease in adults" = true
  SYNTH:AFFECTIONS-CHR-HEART-ADLT "AFFECTIONS-CHR-HEART-ADLT - Chronic heart disease in adults" = true
  SYNTH:AFFECTIONS-CHR-META-ADLT "AFFECTIONS-CHR-META-ADLT - Chronic metabolic disorders in adults" = true
  SYNTH:AFFECTIONS-CHR-URO-ADLT "AFFECTIONS-CHR-URO-ADLT - Chronic kidney disease in adults" = true
  SYNTH:AFFECTIONS-CHR-ID-ADLT "AFFECTIONS-CHR-ID-ADLT - ID in adults" = true
  SYNTH:AFFECTIONS-CHR-PSY-ADLT "AFFECTIONS-CHR-PSY-ADLT - Psychiatric disorders in adults" = true
  COND:C1099 "Health professional in contact with patients" = true
  COND:C1100 "Professionals from long-term social care centres in contact with the public" = true
  COND:C1101 "Long-term care centre users" = true
  CALC:Age>=60y

SYNTH FLU-RF-CHILD "FLU-RF-CHILD - Risk factors for severe influenza in children" IS ANY OF
  SYNTH:AFFECTIONS-CHR-HEART-CHILD "AFFECTIONS-CHR-HEART-CHILD - Chronic heart disease in children" = true
  SYNTH:AFFECTIONS-CHR-LUNG-CHILD "AFFECTIONS-CHR-LUNG-CHILD - Chronic lung disease in children" = true
  SYNTH:AFFECTIONS-CHR-META-CHILD "AFFECTIONS-CHR-META-CHILD - Chronic metabolic disorders in children" = true
  SYNTH:AFFECTIONS-CHR-URO-CHILD "AFFECTIONS-CHR-URO-CHILD - Chronic kidney disease in children" = true
  SYNTH:AFFECTIONS-CHR-ID-CHILD "AFFECTIONS-CHR-ID-CHILD - ID in children" = true
  COND:C1097 "Long-term treatment with acetylsalicylic acid" = true


TARGET Influenza

FOLDER 1 "5 to 23 months old"
  IF CALC:Age in 5m..23m

  RULE 1/01 "5-23m,  0 dose: To do from 6m old, between 01/10 et 01/03"
    IF CALC:INF_doses_received = 0
    DO Recommended
      Status DUE
      Age 6m..23m
  END RULE 1/01

  RULE 1/02 "5-23m,  1 dose: To do from 4w after LD"
    IF CALC:INF_doses_received = 1
    DO Recommended
      Status DUE
      Delay 4w from CALC:INF_last_dose_date
  END RULE 1/02

  RULE 1/03 "5-23m,  ≥2 doses: To do 6m after LD, between 01/10 et 01/03"
    IF CALC:INF_doses_received>=2
    DO Recommended
      Status DUE
      Delay 6m from CALC:INF_last_dose_date
  END RULE 1/03
END FOLDER 1

FOLDER 2 "24 months to 17 years old with risk factors"
  IF ALL OF
  CALC:Age in 24m..17y
  SYNTH:FLU-RF-CHILD "FLU-RF-CHILD - Risk factors for severe influenza in children" = true

  FOLDER 21 "24m to 8y old"
    IF CALC:Age in 24m..8y

    RULE 21/01 "24m-8y,  0 dose: To do from 24m old, between 01/10 et 01/03"
      IF CALC:INF_doses_received = 0
      DO Recommended
        Status DUE
        Age 24m..8y
    END RULE 21/01

    RULE 21/02 "24m-8y,  1 dose: To do from 4w after LD"
      IF CALC:INF_doses_received = 1
      DO Recommended
        Status DUE
        Delay 4w from CALC:INF_last_dose_date
    END RULE 21/02

    RULE 21/03 "24m-8y,  ≥2 doses: To do 6m after LD, between 01/10 et 01/03"
      IF CALC:INF_doses_received>=2
      DO Recommended
        Status DUE
        Delay 6m from CALC:INF_last_dose_date
    END RULE 21/03
  END FOLDER 21

  FOLDER 22 "[9-17y] old"
    IF CALC:Age in 9y..17y

    RULE 22/01 "[9-17y], ≥ 0 dose: To do 6m after LD, between 01/10 et 01/03"
      IF CALC:INF_doses_received>=0
      DO Recommended
        Status DUE
        Delay 6m from CALC:INF_last_dose_date
    END RULE 22/01
  END FOLDER 22
END FOLDER 2

FOLDER 3 "≥ 18 years old with risk factors"
  IF ALL OF
  CALC:Age>=18y
  SYNTH:FLU-RF-ADLT "FLU-RF-ADLT - Risk factors for severe influenza in adults" = true

  RULE 3/01 "≥18,  ≥0 dose: To do each year, 6m after LD, between 01/10 and 01/03"
    IF CALC:INF_doses_received>=0
    DO Recommended
      Status DUE
      Age 18y
      Delay 6m from CALC:INF_last_dose_date
  END RULE 3/01
END FOLDER 3

FOLDER 4 "≥ 24 months old without risk factors "
  IF ALL OF
  CALC:Age>=24m
  SYNTH:FLU-RF-CHILD "FLU-RF-CHILD - Risk factors for severe influenza in children" = false
  SYNTH:FLU-RF-ADLT "FLU-RF-ADLT - Risk factors for severe influenza in adults" = false

  RULE 4/01 "≥24m, ≥ 1 dose, Without risk factors: Possible vaccination"
    IF CALC:INF_doses_received>=1
    DO Suggested
    MESSAGES  MSG88 MSG87
  END RULE 4/01
END FOLDER 4

FOLDER 8 "Contraindications and special cases"

  FOLDER 81 "Contraindications"

    RULE 81/01 "Case « Contraindication to influenza vaccination » checked: Contraindication + message"
      IF ALL OF
        CALC:Age>=5m
        COND:C1022 "Contraindication to influenza vaccination" = true
      DO Contraindicated
      MESSAGES  MSG13 MSG14
    END RULE 81/01
  END FOLDER 81

  FOLDER 82 "Special cases"

    RULE 82/01 "Case  « Refusal to vaccinate against this disease » checked: Special case + message"
      IF ALL OF
        COND:C622 "Refusal of flu vaccination" = true
        CALC:Age>=5m
      DO Exception
      MESSAGES  MSG19 MSG20
    END RULE 82/01
  END FOLDER 82
END FOLDER 8

FOLDER 9 "Further information"

  RULE 9/01 "If To do, 6-23m OR Risk factors+: reimbursement"
    WHEN Recommended
    IF ANY OF
      CALC:Age in 5m..23m
      SYNTH:FLU-RF-CHILD "FLU-RF-CHILD - Risk factors for severe influenza in children" = true
      SYNTH:FLU-RF-ADLT "FLU-RF-ADLT - Risk factors for severe influenza in adults" = true
    DO Neutral
    MESSAGES  MSG74
  END RULE 9/01

  RULE 9/011 "If To do, 6m-8y, [0-1] dose: 2 doses with interval 4w"
    WHEN Recommended
    IF ALL OF
      CALC:Age in 5m..8y
      CALC:INF_doses_received<=1
    DO Neutral
    MESSAGES  MSG363
  END RULE 9/011

  RULE 9/02 "6-23m, If To do: mandatory vaccination"
    WHEN Recommended
    IF CALC:Age in 6m..23m
    DO Neutral
    MESSAGES  MSG82 MSG75 MSG76
  END RULE 9/02

  RULE 9/03 "24m-17y, If To do: for patients with risk factors"
    WHEN Recommended
    IF CALC:Age in 24m..17y
    DO Neutral
    MESSAGES  MSG83 MSG84
  END RULE 9/03

  RULE 9/04 "≥18y, If To do: for patients with risk factors"
    WHEN Recommended
    IF CALC:Age>=18y
    DO Neutral
    MESSAGES  MSG86 MSG85
  END RULE 9/04
END FOLDER 9
END TARGET

MESSAGE MSG86 Justification ANY PRIO 0
  "This vaccination is recommended in Latvia for adults aged 18 and over who belong to the following risk groups:<br>
- pregnant women;<br>
- healthcare professionals in contact with patients;<br>
- professionals of long-term social care centres in contact with the public;<br>
- users of long-term social care centres;<br>
- persons aged 60 and over;<br>
- persons with chronic lung diseases;<br>
- persons with chronic cardiovascular diseases, regardless of the cause;<br>
- persons with chronic metabolic diseases;<br>
- persons with chronic kidney disease;<br>
- persons with immunosuppression;<br>
- persons receiving immunosuppressive treatment;<br>
- persons with mental illness.<br>
<br>
See https://www.spkc.gov.lv/lv/valsts-apmaksata-vakcinacija-pret-sezonalo-gripu"@en
 END MESSAGE MSG86

MESSAGE MSG85 Summary ANY PRIO 0
  "Vaccination recommended in Latvia, from the age of 18, in the presence of risk factors."@en
 END MESSAGE MSG85

MESSAGE MSG88 Justification ANY PRIO 0
  "Although not a risk group, vaccination can be carried out every year, between October and February."@en
 END MESSAGE MSG88

MESSAGE MSG87 Summary ANY PRIO 0
  "Vaccination available every year."@en
 END MESSAGE MSG87

MESSAGE MSG19 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG19

MESSAGE MSG20 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been ticked in the health profile (‘Refusal of vaccination’ section)."@en
 END MESSAGE MSG20

MESSAGE MSG82 Justification ANY PRIO 0
  "Vaccination is compulsory in Latvia between the ages of 6 and 23 months, and includes 1 dose each year during the epidemic period (between October and February)."@en
 END MESSAGE MSG82

MESSAGE MSG75 Comments ANY PRIO 0
  "In addition to vaccination, we recommend adopting hygiene measures such as frequent hand washing, using disposable tissues and wearing a mask if you have flu-like symptoms, to reduce transmission."@en
 END MESSAGE MSG75

MESSAGE MSG76 Alert ANY PRIO 0
  "This vaccination is compulsory in Latvia, between the ages of 6m and 23 months."@en
 END MESSAGE MSG76

MESSAGE MSG74 Comments ANY PRIO 0
  "The vaccine is fully reimbursed by the national health system each year."@en
 END MESSAGE MSG74

MESSAGE MSG13 Alert ANY PRIO 0
  "Vaccination contraindicated by the doctor."@en
 END MESSAGE MSG13

MESSAGE MSG14 Justification ANY PRIO 0
  "The box indicating a contraindication for this disease has been ticked in the health profile (‘Contraindicated vaccinations’ section)."@en
 END MESSAGE MSG14

MESSAGE MSG363 Summary ANY PRIO 0
  "In children under 9 years of age who have not been previously vaccinated, a second dose of 0.5 mL should be injected after an interval of at least 4 weeks."@en
 END MESSAGE MSG363

MESSAGE MSG83 Summary ANY PRIO 0
  "Vaccination recommended in Latvia, between the ages of 24 months and 17 years, in the presence of risk factors."@en
 END MESSAGE MSG83

MESSAGE MSG84 Justification ANY PRIO 0
  "This vaccination is recommended in Latvia for children aged between 24 months and 17 years (inclusive) who belong to the following risk groups:<br>
- children with chronic lung disease;<br>
- children with chronic cardiovascular disease, whatever the cause;<br>
- children with chronic metabolic diseases;<br>
- children with chronic kidney disease;<br>
- immunocompromised children;<br>
- children receiving immunosuppressive treatment;<br>
- children receiving long-term therapy with acetylsalicylic acid.<br>
<br>
See https://www.spkc.gov.lv/lv/valsts-apmaksata-vakcinacija-pret-sezonalo-gripu"@en
 END MESSAGE MSG84
