CALC Shingles_doses_received IS HIST(Shingles,0,count)
CALC Shingles_gE_received IS HIST(Singles-gE,0,count)

CALC Shingles_last_dose_date IS HIST(Shingles,-1,date)
CALC Shingles_last_dose_age IS INTERVAL(BASE:dob,CALC:Shingles_last_dose_date)
CALC Shingles_last_valences IS HIST(Shingles,-1,valences)

CALC Shingles_vaccines_received IS HIST(Shingles,0,vaccine)


SYNTH SHIN-RF "SHIN-RF - All risk factors for shingles" IS ANY OF
  SYNTH:SHIN-RF-REFUND "SHIN-RF-REFUND -  50 to 100% refund" = true
  SYNTH:SHIN-RF-NOREFUND "SHIN-RF-NOREFUND - 0% refund" = true

SYNTH SHIN-RF-REFUND "SHIN-RF-REFUND -  50 to 100% refund" IS ANY OF
  COND:C958 "Diabetes" = true
  COND:C1159 "Rheumatoid arthritis" = true
  COND:C1160 "Psoriasis" = true
  COND:C1162 "Psoriatic arthritis" = true
  COND:C471 "Chronic inflammatory bowel disease" = true
  COND:C1163 "Ankylosing spondylitis" = true
  COND:C427 "Multiple sclerosis" = true
  COND:C424 "Systemic lupus erythematosus" = true
  COND:C1164 "Hodgkin's disease" = true
  COND:C1166 "Leukemia " = true
  COND:C1167 "Lymphoma" = true
  COND:C1168 "Multiple Myeloma" = true
  COND:C1169 "Metastatic cancer" = true
  COND:C24 "HIV infection" = true
  SYNTH:COMMON-HEART "COMMON-HEART - Chronic heart diseases" = true
  SYNTH:COMMON-LUNG "COMMON-LUNG - Chronic lung diseases" = true
  SYNTH:COMMON-RENAL  "COMMON-RENAL - Chronic renal failure" = true
  SYNTH:COMMON-SOT "COMMON - Solid organ transplantation" = true
  SYNTH:COMMON-HSCT "COMMON - Stem cell transplantation" = true
  SYNTH:COMMON-TTT-ID "COMMON-TTT-ID - Treatment inducing immunosuppression" = true
  COND:C24 "HIV infection" = true

SYNTH SHIN-RF-NOREFUND "SHIN-RF-NOREFUND - 0% refund" IS ANY OF
  SYNTH:COMMON-LIVER  "Chronic liver diseases" = true
  COND:C1095 "Other chronic kidney diseases" = true
  COND:C1158 "Chronic depression disorder" = true
  COND:C1165 "Other autoimmune disease" = true

TARGET Shingles

FOLDER 0 "Zero dose"
  IF CALC:Shingles_doses_received = 0

  RULE 0/1 "[18-49y]old, RF-: Possible vaccination"
    IF ALL OF
      CALC:Age in 18y..49y
      SYNTH:SHIN-RF "SHIN-RF - All risk factors for shingles" = false
    DO Suggested
  END RULE 0/1

  RULE 0/2 "≥ 50y old: DUE from 50y old, 1y after shingles"
    IF CALC:Age>=50y
    DO Recommended
      Status DUE
      Age 50y
      Delay 1y from COND:C1084 "Date of the last shingles episode"
    MESSAGES  MSG88
  END RULE 0/2

  RULE 0/2 "≥ 18y old, RF+: To do from 18y old, 1y after shingles"
    IF ALL OF
      CALC:Age>=18y
      SYNTH:SHIN-RF "SHIN-RF - All risk factors for shingles" = true
    DO Recommended
      Status DUE
      Age 18y
      Delay 1y from COND:C1084 "Date of the last shingles episode"
  END RULE 0/2
END FOLDER 0

FOLDER 1 "One dose"
  IF CALC:Shingles_doses_received = 1

  FOLDER 11 "Zostavax"
    IF CALC:Shingles_vaccines_received contains only VAC0161 # ZOSTAVAX

    RULE 11/01 "Zostavax 1 dose, RF-, LD ≥ 50y old: Up to date + message"
      IF ALL OF
        CALC:Shingles_last_dose_age>=50y
        SYNTH:SHIN-RF "SHIN-RF - All risk factors for shingles" = false
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG85
    END RULE 11/01

    RULE 11/02 "Zostavax 1 dose, RF+, LD ≥ 50y old: To do Shingrix 1y after LD"
      IF ALL OF
        CALC:Shingles_last_dose_age>=50y
        SYNTH:SHIN-RF "SHIN-RF - All risk factors for shingles" = true
      DO Recommended
        Status DUE
        Delay 1y from CALC:Shingles_last_dose_date
      MESSAGES  MSG75
    END RULE 11/02

    RULE 11/03 "Zostavax 1 dose, RF+, LD ≥ 50y old: To do Shingrix 1y after shingles"
      IF ALL OF
        CALC:Shingles_last_dose_age>=50y
        SYNTH:SHIN-RF "SHIN-RF - All risk factors for shingles" = true
      DO Recommended
        Status DUE
        Delay 1y from COND:C1084 "Date of the last shingles episode"
      MESSAGES  MSG75
    END RULE 11/03
  END FOLDER 11

  FOLDER 12 "Shingrix"
    IF  CALC:Shingles_vaccines_received contains only VAC0567 # SHINGRIX

    RULE 12/01 "Shingrix 1 dose , ID+, LD ≥ 18y old: To do 1-2m after LD"
      IF ALL OF
        CALC:Shingles_last_dose_age>=18y
        SYNTH:COMMON-ID "COMMON-ID - Immunodépression sauf attente de transplantation (CI aux vaccins vivants)" = true
      DO Recommended
        Status DUE
        Delay 1m..2m from CALC:Shingles_last_dose_date
      MESSAGES  MSG77
    END RULE 12/01

    RULE 12/02 "Shingrix 1 dose , ID+, LD ≥ 18y old: To do 1-2m after LD, Shingles after LD: To do 1y after shingles"
      IF ALL OF
        SYNTH:COMMON-ID "COMMON-ID - Immunodépression sauf attente de transplantation (CI aux vaccins vivants)" = true
        CALC:Shingles_last_dose_age>=18y
      DO Recommended
        Status DUE
        Delay 1y from COND:C1084 "Date of the last shingles episode"
      MESSAGES  MSG77
    END RULE 12/02

    RULE 12/03 "Shingrix 1 dose , ID-, LD ≥ 18y old: To do 2-6m after LD"
      IF ALL OF
        CALC:Shingles_last_dose_age>=18y
        SYNTH:COMMON-ID "COMMON-ID - Immunodépression sauf attente de transplantation (CI aux vaccins vivants)" = false
      DO Recommended
        Status DUE
        Delay 2m..6m from CALC:Shingles_last_dose_date
    END RULE 12/03

    RULE 12/04 "Shingrix 1 dose , ID-, LD ≥ 18y old, Singles after LD: To do 1y after shingles"
      IF ALL OF
        SYNTH:COMMON-ID "COMMON-ID - Immunodépression sauf attente de transplantation (CI aux vaccins vivants)" = false
        CALC:Shingles_last_dose_age>=18y
      DO Recommended
        Status DUE
        Delay 1y from COND:C1084 "Date of the last shingles episode"
    END RULE 12/04
  END FOLDER 12
END FOLDER 1

FOLDER 2 "Two doses or more"
  IF CALC:Shingles_doses_received>=2

  RULE 2/01 "Zostavax ≥2 doses, LD ≥ 50y old: Up to date"
    IF ALL OF
      CALC:Shingles_last_dose_age>=50y
	  CALC:Shingles_vaccines_received contains only VAC0161 # ZOSTAVAX
    DO Recommended
      Status COMPLETED
  END RULE 2/01

  RULE 2/02 "≥2 doses (Shingrix 1 dose), LD ≥ 50y old: To do 2-6m after LD"
    IF ALL OF
      CALC:Shingles_last_dose_age>=50y
      CALC:Shingles_gE_received = 1
	  CALC:Shingles_last_valences contains Shingles-gE
    DO Recommended
      Status DUE
      Delay 2m..6m from CALC:Shingles_last_dose_date
  END RULE 2/02

  RULE 2/03 "≥2 doses (Shingrix ≥2 doses), LD ≥ 18y old : Up to date"
    IF ALL OF
      CALC:Shingles_last_dose_age>=18y
      CALC:Shingles_gE_received>=2
    DO Recommended
      Status COMPLETED
  END RULE 2/03
END FOLDER 2

FOLDER 4 "Messages"

  RULE 4/02 "Justifications vaccination shingles"
    IF CALC:Age>=50y
    DO Neutral
    MESSAGES  MSG78 MSG79 MSG80
  END RULE 4/02

  RULE 4/05 "Shingles ≤ 11m: Message = 1y after shingles"
    WHEN Recommended
    IF COND:C1084 "Date of the last shingles episode"<=11m
    DO Neutral
    MESSAGES  MSG76
  END RULE 4/05
END FOLDER 4

FOLDER 6 "Recommended vaccine"

  RULE 6/04 "Vaccin utilisable"
    WHEN Recommended
    IF CALC:Age>=18y
    DO Neutral
    MESSAGES  MSG82
  END RULE 6/04
END FOLDER 6

FOLDER 8 "Contraindication"
END FOLDER 8

FOLDER 9 "Further information"

  RULE 9/27 "If to do, [18y-64y] old, RF+:  refund: 50%"
    WHEN Recommended
    IF ALL OF
      SYNTH:SHIN-RF-REFUND "SHIN-RF-REFUND -  50 to 100% refund" = true
      CALC:Age in 18y..64y
    DO Neutral
    MESSAGES  MSG3
  END RULE 9/27

  RULE 9/28 "If to do, ≥ 65y old, RF+:  refund: 100%"
    WHEN Recommended
    IF ALL OF
      SYNTH:SHIN-RF-REFUND "SHIN-RF-REFUND -  50 to 100% refund" = true
      CALC:Age>=65y
    DO Neutral
    MESSAGES  MSG48
  END RULE 9/28

  FOLDER 91 "Excel files"

    RULE 91/03 "Allergy to any component of vaccine: Message"
      IF ALL OF
        COND:C1161 "Allergy from a previous vaccine administration" = true
        CALC:Age>=18y
      DO Neutral
      MESSAGES  MSG51 MSG165 MSG166 MSG104
    END RULE 91/03

    RULE 91/08 "If to do, Chronic heart disease - 50 to 100% refund"
      WHEN Recommended
      IF SYNTH:COMMON-HEART "COMMON-HEART - Chronic heart diseases" = true
      DO Neutral
      MESSAGES  MSG89
    END RULE 91/08

    RULE 91/09 "If to do, Chronic lumg disease - 50 to 100% refund"
      WHEN Recommended
      IF SYNTH:COMMON-LUNG "COMMON-LUNG - Chronic lung diseases" = true
      DO Neutral
      MESSAGES  MSG90
    END RULE 91/09

    RULE 91/10 "If to do, Chronic liver disease"
      WHEN Recommended
      IF SYNTH:COMMON-LIVER "COMMON-LIVER - Chronic liver diseases" = true
      DO Neutral
      MESSAGES  MSG91
    END RULE 91/10

    RULE 91/11 "If to do, Chronic renal failure - 50 to 100% refund"
      WHEN Recommended
      IF SYNTH:COMMON-RENAL  "COMMON-RENAL - Chronic renal failure" = true
      DO Neutral
      MESSAGES  MSG92
    END RULE 91/11

    RULE 91/12 "If to do, Other chronic kidney disease"
      WHEN Recommended
      IF COND:C1095 "Other chronic kidney diseases" = true
      DO Neutral
      MESSAGES  MSG93
    END RULE 91/12

    RULE 91/13 "If to do, Diabete - 50 to 100% refund"
      WHEN Recommended
      IF COND:C958 "Diabetes" = true
      DO Neutral
      MESSAGES  MSG94
    END RULE 91/13

    RULE 91/14 "If to do, Depression disorder"
      WHEN Recommended
      IF COND:C1158 "Chronic depression disorder" = true
      DO Neutral
      MESSAGES  MSG95
    END RULE 91/14

    RULE 91/15 "If to do, Rheumatoid arthritis - 50 to 100% refund"
      WHEN Recommended
      IF COND:C1159 "Rheumatoid arthritis" = true
      DO Neutral
      MESSAGES  MSG96
    END RULE 91/15

    RULE 91/16 "If to do, Psoriasis - 50 to 100% refund"
      WHEN Recommended
      IF COND:C1160 "Psoriasis" = true
      DO Neutral
      MESSAGES  MSG105
    END RULE 91/16

    RULE 91/17 "If to do, Psoriatic arthritis - 50 to 100% refund"
      WHEN Recommended
      IF COND:C1162 "Psoriatic arthritis" = true
      DO Neutral
      MESSAGES  MSG97
    END RULE 91/17

    RULE 91/18 "If to do, Inflammatory bowel disease - 50 to 100% refund"
      WHEN Recommended
      IF COND:C471 "Chronic inflammatory bowel disease" = true
      DO Neutral
      MESSAGES  MSG106
    END RULE 91/18

    RULE 91/19 "If to do, Ankylosing spondylitis - 50 to 100% refund"
      WHEN Recommended
      IF COND:C1163 "Ankylosing spondylitis" = true
      DO Neutral
      MESSAGES  MSG107
    END RULE 91/19

    RULE 91/20 "If to do, Multiple sclerosis - 50 to 100% refund"
      WHEN Recommended
      IF COND:C427 "Multiple sclerosis" = true
      DO Neutral
      MESSAGES  MSG108
    END RULE 91/20

    RULE 91/21 "If to do, Systemic lupus erythematosus - 50 to 100% refund"
      WHEN Recommended
      IF COND:C424 "Systemic lupus erythematosus" = true
      DO Neutral
      MESSAGES  MSG109
    END RULE 91/21

    RULE 91/22 "If to do, Hodgkin's disease - 50 to 100% refund"
      WHEN Recommended
      IF COND:C1164 "Hodgkin's disease" = true
      DO Neutral
      MESSAGES  MSG350
    END RULE 91/22

    RULE 91/23 "If to do, Other autoimmune disease"
      WHEN Recommended
      IF COND:C1165 "Other autoimmune disease" = true
      DO Neutral
      MESSAGES  MSG111
    END RULE 91/23

    RULE 91/24 "If to do, Leukemia - 50 to 100% refund"
      WHEN Recommended
      IF COND:C1166 "Leukemia " = true
      DO Neutral
      MESSAGES  MSG112
    END RULE 91/24

    RULE 91/25 "If to do, Lymphoma - 50 to 100% refund"
      WHEN Recommended
      IF COND:C1167 "Lymphoma" = true
      DO Neutral
      MESSAGES  MSG113
    END RULE 91/25

    RULE 91/26 "If to do, Multiple Myeloma - 50 to 100% refund"
      WHEN Recommended
      IF COND:C1168 "Multiple Myeloma" = true
      DO Neutral
      MESSAGES  MSG114
    END RULE 91/26

    RULE 91/27 "If to do, Metastatic cancer - 50 to 100% refund"
      WHEN Recommended
      IF COND:C1169 "Metastatic cancer" = true
      DO Neutral
      MESSAGES  MSG115
    END RULE 91/27

    RULE 91/28 "If to do, Iatrogenic immunosuppression - 50 to 100% refund"
      WHEN Recommended
      IF SYNTH:COMMON-TTT-ID "COMMON-TTT-ID - Treatment inducing immunosuppression" = true
      DO Neutral
      MESSAGES  MSG116
    END RULE 91/28

    RULE 91/29 "If to do, HIV - 50 to 100% refund"
      WHEN Recommended
      IF COND:C24 "HIV infection" = true
      DO Neutral
      MESSAGES  MSG98
    END RULE 91/29

    RULE 91/30 "If to do, Solid organ transplantation (liver, kidney, lung, pancreas) - 50 to 100% refund"
      WHEN Recommended
      IF SYNTH:COMMON-SOT "COMMON - Solid organ transplantation" = true
      DO Neutral
      MESSAGES  MSG99
    END RULE 91/30

    RULE 91/31 "If to do, Hematopoietic stem cell transplant (HPSCT) - 50 to 100% refund"
      WHEN Recommended
      IF SYNTH:COMMON-HSCT "COMMON - Stem cell transplantation" = true
      DO Neutral
      MESSAGES  MSG100
    END RULE 91/31
  END FOLDER 91
END FOLDER 9
END TARGET

MESSAGE MSG113 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for people with lymphoma because they are at increased risk of developing the disease. Vaccination is the most effective way to protect against herpes zoster and its complications."@en
 END MESSAGE MSG113

MESSAGE MSG96 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for people with rheumatoid arthritis because they are at increased risk of developing the disease. Vaccination is the most effective way to protect against herpes zoster and its complications."@en
 END MESSAGE MSG96

MESSAGE MSG82 Other PRO PRIO 0
  "Recommended vaccine: SHINGRIX."@en
 END MESSAGE MSG82

MESSAGE MSG116 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for people with iatrogenic immunosuppression because they are at increased risk of developing the disease. Vaccination is the most effective way to protect against herpes zoster and its complications."@en
 END MESSAGE MSG116

MESSAGE MSG107 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for people with ankylosing spondylitis because they are at increased risk of developing the disease. Vaccination is the most effective way to protect against herpes zoster and its complications."@en
 END MESSAGE MSG107

MESSAGE MSG88 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for people aged 50 and older because they are at increased risk of developing the disease. They are also more vulnerable to complications, primarily postherpetic neuralgia. Vaccination is the most effective way to protect against herpes zoster and its complications."@en
 END MESSAGE MSG88

MESSAGE MSG106 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for people with inflammatory bowel disease because they are at increased risk of developing the disease. Vaccination is the most effective way to protect against herpes zoster and its complications."@en
 END MESSAGE MSG106

MESSAGE MSG92 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for people with chronic renal failure because they are at increased risk of developing the disease. Vaccination is the most effective way to protect against herpes zoster and its complications."@en
 END MESSAGE MSG92

MESSAGE MSG78 Comments ANY PRIO 0
  "It is estimated that around 1 in 2 people worldwide have had at least one episode of shingles by the age of 85. Shingles is caused by the varicella-zoster virus (VZV). After infection with chickenpox in childhood, the virus can remain ‘dormant’ in certain nerve ganglia. With age, fatigue, illness or for no apparent reason, it can reactivate in the form of shingles. People over 50 are the most affected. The older you get, the more frequent and severe shingles becomes, as the immune system becomes less effective at keeping the virus ‘under control’."@en
 END MESSAGE MSG78

MESSAGE MSG79 Justification PATIENT PRIO 0
  "Vaccination is recommended for adults aged 50 and over, whether or not they have already had chickenpox, to reduce the risk of shingles and, above all, the risk of postherpetic neuralgia (pain that can be very debilitating and persist after the onset of shingles)."@en
 END MESSAGE MSG79

MESSAGE MSG80 Justification PRO PRIO 0
  "Vaccination is recommended for adults aged 50 and over, whether or not they have already had chickenpox, to reduce the risk of shingles and, above all, the risk of postherpetic neuralgia."@en
 END MESSAGE MSG80

MESSAGE MSG97 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for people with psoriatic arthritis because they are at increased risk of developing the disease. Vaccination is the most effective way to protect against herpes zoster and its complications."@en
 END MESSAGE MSG97

MESSAGE MSG91 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for people with chronic liver diseases because they are at increased risk of developing the disease. Vaccination is the most effective way to protect against herpes zoster and its complications."@en
 END MESSAGE MSG91

MESSAGE MSG94 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for diabetes because they are at increased risk of developing the disease. Vaccination is the most effective way to protect against herpes zoster and its complications."@en
 END MESSAGE MSG94

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

MESSAGE MSG112 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for people with leukaemia because they are at increased risk of developing the disease. Vaccination is the most effective way to protect against herpes zoster and its complications."@en
 END MESSAGE MSG112

MESSAGE MSG115 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for people with metastatic cancer because they are at increased risk of developing the disease. Vaccination is the most effective way to protect against herpes zoster and its complications."@en
 END MESSAGE MSG115

MESSAGE MSG105 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for people with psoriasis because they are at increased risk of developing the disease. Vaccination is the most effective way to protect against herpes zoster and its complications."@en
 END MESSAGE MSG105

MESSAGE MSG95 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for people with depression disorder because they are at increased risk of developing the disease. Vaccination is the most effective way to protect against herpes zoster and its complications."@en
 END MESSAGE MSG95

MESSAGE MSG89 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for people with chronic heart diseases because they are at increased risk of developing the disease. Vaccination is the most effective way to protect against herpes zoster and its complications."@en
 END MESSAGE MSG89

MESSAGE MSG111 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for people with the other autoimmune disease because they are at increased risk of developing the disease. Vaccination is the most effective way to protect against herpes zoster and its complications."@en
 END MESSAGE MSG111

MESSAGE MSG76 Comments ANY PRIO 0
  "In people with a history of shingles who are eligible for the shingles vaccination recommendation, SHINGRIX vaccine should be administered at least one year after the shingles episode."@en
 END MESSAGE MSG76

MESSAGE MSG100 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for people after Hematopoietic stem cell transplant (HPSCT) because they are at increased risk of developing the disease. Vaccination is the most effective way to protect against herpes zoster and its complications."@en
 END MESSAGE MSG100

MESSAGE MSG98 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for people with HIV infection because they are at increased risk of developing the disease. Vaccination is the most effective way to protect against herpes zoster and its complications."@en
 END MESSAGE MSG98

MESSAGE MSG93 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for people with chronic kidney diseases because they are at increased risk of developing the disease. Vaccination is the most effective way to protect against herpes zoster and its complications."@en
 END MESSAGE MSG93

MESSAGE MSG109 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for people with systemic lupus erythematosus because they are at increased risk of developing the disease. Vaccination is the most effective way to protect against herpes zoster and its complications."@en
 END MESSAGE MSG109

MESSAGE MSG114 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for people with multiple myeloma because they are at increased risk of developing the disease. Vaccination is the most effective way to protect against herpes zoster and its complications."@en
 END MESSAGE MSG114

MESSAGE MSG99 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for people after solid organ transplantation (liver, kidney, lung, pancreas) because they are at increased risk of developing the disease. Vaccination is the most effective way to protect against herpes zoster and its complications.
Post-transplant patients should consult their doctor to determine an appropriate vaccination schedule, taking into account their health status and immunosuppressive treatment."@en
 END MESSAGE MSG99

MESSAGE MSG108 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for people with multiple sclerosis because they are at increased risk of developing the disease. Vaccination is the most effective way to protect against herpes zoster and its complications."@en
 END MESSAGE MSG108

MESSAGE MSG75 Justification ANY PRIO 0
  "For individuals eligible for a shingles vaccine recommendation and with a history of shingles or vaccination with ZOSTAVAX, a complete regimen with SHINGRIX vaccine is recommended after at least one year after vaccination or infection."@en
 END MESSAGE MSG75

MESSAGE MSG350 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for people with Hodgkin's disease because they are at increased risk of developing the disease. Vaccination is the most effective way to protect against herpes zoster and its complications."@en
 END MESSAGE MSG350

MESSAGE MSG90 Justification ANY PRIO 0
  "Herpes zosteris vaccine is especially recommended for people with chronic lung diseases because they are at increased risk of developing the disease. Vaccination is the most effective way to protect against herpes zoster and its complications."@en
 END MESSAGE MSG90

MESSAGE MSG3 Other ANY PRIO 10
  "Refund: 50%."@en
 END MESSAGE MSG3

MESSAGE MSG77 Justification ANY PRIO 0
  "In special circumstances where immunity needs to be acquired rapidly, such as in immunocompromised individuals, the second dose can be administered as early as one month after the first dose."@en
 END MESSAGE MSG77

MESSAGE MSG85 Comments ANY PRIO 0
  "The SHINGRIX vaccine, in addition to a previous vaccination with ZOSTAVAX or a history of shingles, is only recommended for people eligible for vaccination against shingles (which is not the case here, according to the information provided)."@en
 END MESSAGE MSG85

MESSAGE MSG48 Other ANY PRIO 10
  "Refund: 100%."@en
 END MESSAGE MSG48
