CALC HPV_doses_received IS HIST(HPV,0,count)
CALC HPV_age_at_first_dose IS INTERVAL(BASE:dob,HIST(HPV,1,date))
CALC HPV_last_dose_date IS HIST(HPV,-1,date)
CALC HPV_last_vaccine IS HIST(HPV,-1,vaccine)
CALC HPV_d1d2 IS INTERVAL(HIST(HPV,1,date),HIST(HPV,2,date))
CALC HPV_d2d3 IS INTERVAL(HIST(HPV,2,date),HIST(HPV,3,date))
CALC HPV_d1d3 IS INTERVAL(HIST(HPV,1,date),HIST(HPV,3,date))


TARGET HPV
FOLDER 0 "Zero dose"
  IF CALC:HPV_doses_received = 0

  RULE 0/01 "[18-45y] old, 0 dose: To do ASAP"
    IF ALL OF
      CALC:HPV_doses_received = 0
      CALC:Age>=18y
    DO Recommended
      Status DUE
      Age 18y
  END RULE 0/01
END FOLDER 0

FOLDER 1 "[18-45y] old - Gardasil 9"
  IF ALL OF
  CALC:Age in 18y..45y
  CALC:HPV_last_vaccine = VAC0523 #GARDASIL 9

  FOLDER 11 "One dose"
    IF CALC:HPV_doses_received = 1

    RULE 11/01 "[18-45y] old, 1 dose ≤ 13m: To do in 2m (Scheme 0-2-6m)"
      IF CALC:HPV_doses_received = 1
      DO Recommended
        Status DUE
        Age 18y
        Delay 2m from CALC:HPV_last_dose_date
    END RULE 11/01
  END FOLDER 11

  FOLDER 12 "Two doses"
    IF CALC:HPV_doses_received = 2

    RULE 12/01 "[18-45y] old, 2 doses, d1d2 ≥ 1m, LD ≤ 12m: To do in 4m (Scheme 0-2-6m)"
      IF CALC:HPV_d1d2>=1m
      DO Recommended
        Status DUE
        Age 18y
        Delay 4m from CALC:HPV_last_dose_date
    END RULE 12/01

    RULE 12/03 "[18-45y] old, 2 doses Gardasil, d1d2 < 1m: To do in 4m (Scheme 0-2-6m) + message Incorrect vaccination schedule"
      IF ALL OF
        CALC:HPV_d1d2<1m
        CALC:HPV_doses_received = 2
      DO Recommended
        Status DUE
        Age 18y
        Delay 4m from CALC:HPV_last_dose_date
      MESSAGES  MSG313 MSG118
    END RULE 12/03
  END FOLDER 12

  FOLDER 13 "Three doses"
    IF CALC:HPV_doses_received = 3

    RULE 13/01 "[18-45y] old, 3 doses Gardasil, d1d2 ≥ 1m, d2d3 ≥ 3m: Up to date"
      IF ALL OF
        CALC:HPV_d1d2>=1m
        CALC:HPV_d2d3>=3m
      DO Recommended
        Status COMPLETED
    END RULE 13/01

    RULE 13/02 "[18-45y] old, 3 doses Gardasil, d1d2 < 1m: Up to date + message Incorrect vaccination schedule"
      IF ALL OF
        CALC:HPV_d1d2<1m
        CALC:HPV_doses_received = 3
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG313 MSG118
    END RULE 13/02

    RULE 13/03 "[18-45y] old, 3 doses Gardasil, d2d3 < 3m: Up to date + message Incorrect vaccination schedule"
      IF ALL OF
        CALC:HPV_doses_received = 3
        CALC:HPV_d2d3<3m
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG313 MSG123
    END RULE 13/03

    RULE 13/04 "[18-45y] old, 3 doses Gardasil, d1d3 > 12m: Up to date + message Incorrect vaccination schedule"
      IF ALL OF
        CALC:HPV_doses_received = 3
        CALC:HPV_d1d3>=12m
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG313 MSG304
    END RULE 13/04
  END FOLDER 13
END FOLDER 1

FOLDER 2 "[18-45y] old - Cervarix"
  IF ALL OF
  CALC:Age in 18y..45y
  CALC:HPV_last_vaccine = VAC0044 #CERVARIX

  FOLDER 21 "One dose"
    IF CALC:HPV_doses_received = 1

    RULE 21/01 "[18-45y] old, 1 dose ≤ 13m: To do in 2m (Scheme 0-2-6m)"
      IF CALC:HPV_doses_received = 1
      DO Recommended
        Status DUE
        Age 18y
        Delay 1m from CALC:HPV_last_dose_date
      MESSAGES  MSG305
    END RULE 21/01
  END FOLDER 21

  FOLDER 22 "Two doses"
    IF CALC:HPV_doses_received = 2

    RULE 22/01 "[18-45y] old, 2 doses, d1d2 ≥ 1m, LD ≤ 12m: To do in 4m (Scheme 0-2-6m)"
      IF CALC:HPV_d1d2>=1m
      DO Recommended
        Status DUE
        Age 18y
        Delay 5m from CALC:HPV_last_dose_date
      MESSAGES  MSG306
    END RULE 22/01

    RULE 22/03 "[18-45y] old, 2 doses Cervarix, d1d2 < 1m: To do in 5m (Scheme 0-1-6m) + message Incorrect vaccination schedule"
      IF ALL OF
        CALC:HPV_d1d2<1m
        CALC:HPV_doses_received = 2
      DO Recommended
        Status DUE
        Age 18y
        Delay 5m from CALC:HPV_last_dose_date
      MESSAGES  MSG313 MSG307
    END RULE 22/03
  END FOLDER 22

  FOLDER 33 "Three doses"
    IF CALC:HPV_doses_received = 3

    RULE 33/01 "[18-45y] old, 3 doses Cervarix, d1d2 ≥ 1m, d1d3 ≥ 5m: Up to date"
      IF ALL OF
        CALC:HPV_d1d2>=1m
        CALC:HPV_d1d3>=5m
      DO Recommended
        Status COMPLETED
    END RULE 33/01

    RULE 33/02 "[18-45y] old, 3 doses Cervarix, d1d2 < 1m: Up to date + message Incorrect vaccination schedule"
      IF ALL OF
        CALC:HPV_d1d2<1m
        CALC:HPV_doses_received = 3
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG313 MSG307
    END RULE 33/02

    RULE 33/03 "[18-45y] old, 3 doses Cervarix, d1d3 < 5m: Up to date + message Incorrect vaccination schedule"
      IF ALL OF
        CALC:HPV_doses_received = 3
        CALC:HPV_d1d3<5m
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG313 MSG308
    END RULE 33/03
  END FOLDER 33
END FOLDER 2

FOLDER 3 "Four doses or more"

  RULE 3/01 "[18-45y] old, ≥4 doses: Up to date"
    IF CALC:HPV_doses_received>=4
    DO Recommended
      Status COMPLETED
  END RULE 3/01
END FOLDER 3

FOLDER 4 "≥ 46y old"
  IF CALC:Age>=46y

  RULE 4/01 "≥ 45y old, 1 dose: special case - Too late"
    IF CALC:HPV_doses_received = 1
    DO Exception
    MESSAGES  MSG126
  END RULE 4/01

  RULE 4/02 "≥ 45y old, 2 doses, 1st dose ≤ 14y old: Up to date"
    IF ALL OF
      CALC:HPV_doses_received = 2
      CALC:HPV_age_at_first_dose<=14y
    DO Recommended
      Status COMPLETED
  END RULE 4/02

  RULE 4/03 "≥ 45y old, 2 doses, 1st dose ≥15y old: Too late"
    IF ALL OF
      CALC:HPV_doses_received = 2
      CALC:HPV_age_at_first_dose>=15y
    DO Exception
    MESSAGES  MSG125
  END RULE 4/03

  RULE 4/04 "≥ 45y old, ≥ 3 doses: Up to date"
    IF CALC:HPV_doses_received>=3
    DO Recommended
      Status COMPLETED
  END RULE 4/04
END FOLDER 4

FOLDER 9 "Further information"

  RULE 9/01 "0 dose: Vaccine to use"
    WHEN Recommended
    IF CALC:HPV_doses_received = 0
    DO Neutral
    MESSAGES  MSG310
  END RULE 9/01

  RULE 9/02 "≥ 1 dose, LD is Gardasil: Vaccine to use"
    WHEN Recommended
    IF ALL OF
      CALC:HPV_doses_received>=1
      CALC:HPV_last_vaccine = VAC0523 #GARDASIL 9
    DO Neutral
    MESSAGES  MSG311
  END RULE 9/02

  RULE 9/03 "≥ 1 dose, LD is Cervarix, [18-45y] old: Remb 50%"
    WHEN Recommended
    IF ALL OF
      CALC:HPV_doses_received>=1
      CALC:HPV_last_vaccine = VAC0044 #CERVARIX
      CALC:Age in 18y..45y
    DO Neutral
    MESSAGES  MSG3
  END RULE 9/03

  RULE 9/04 "≥ 1 dose, LD is Cervarix: Vaccine to use"
    WHEN Recommended
    IF ALL OF
      CALC:HPV_doses_received>=1
      CALC:HPV_last_vaccine = VAC0044 #CERVARIX
    DO Neutral
    MESSAGES  MSG312
  END RULE 9/04

  RULE 9/05 "If to do with Gardasil, [18-29y] old: message"
    WHEN Recommended
    IF ALL OF
      CALC:Age in 18y..29y
      CALC:HPV_last_vaccine = VAC0523 #GARDASIL 9
    DO Neutral
    MESSAGES  MSG117 MSG121
  END RULE 9/05

  RULE 9/06 "If to do with Cervarix, [18-29y] old: message"
    WHEN Recommended
    IF ALL OF
      CALC:Age in 18y..29y
      CALC:HPV_last_vaccine = VAC0044 #CERVARIX
    DO Neutral
    MESSAGES  MSG117 MSG309
  END RULE 9/06

  RULE 9/07 "If to do, [30-45y] old, 0 dose: message - Special case"
    IF ALL OF
      CALC:Age in 30y..45y
      CALC:HPV_doses_received = 0
    DO Suggested
    MESSAGES  MSG119 MSG120
  END RULE 9/07

  RULE 9/08 "If to do with Cervarix, [30-45y] old, ≥ 1 dose: message"
    WHEN Recommended
    IF ALL OF
      CALC:Age in 30y..45y
      CALC:HPV_doses_received>=1
      CALC:HPV_last_vaccine = VAC0044 # CERVARIX
    DO Neutral
    MESSAGES  MSG309
  END RULE 9/08

  RULE 9/09 "If to do with Gardasil, [30-45y] old, ≥ 1 dose: message"
    WHEN Recommended
    IF ALL OF
      CALC:Age in 30y..45y
      CALC:HPV_doses_received>=1
      CALC:HPV_last_vaccine = VAC0523 # GARDASIL 9
    DO Neutral
    MESSAGES  MSG121
  END RULE 9/09

  RULE 9/10 "If to do, [18-29y] old: message"
    WHEN Recommended
    IF CALC:Age in 18y..29y
    DO Neutral
    MESSAGES  MSG559
  END RULE 9/10

  RULE 9/11 "If to do, [30-45y] old: message"
    WHEN Recommended
    IF CALC:Age in 30y..45y
    DO Neutral
    MESSAGES  MSG558
  END RULE 9/11

  RULE 9/12 "If to do: message information with others vaccines"
    WHEN Recommended
    IF CALC:Age>=18y
    DO Neutral
    MESSAGES  MSG103
  END RULE 9/12

  FOLDER 91 "Excel files"

    RULE 91/01 "If to do, Allergy to any component of vaccine: Message"
      WHEN Recommended
      IF COND:C1161 "Allergy from a previous vaccine administration" = true
      DO Neutral
      MESSAGES  MSG51 MSG165 MSG166 MSG124
    END RULE 91/01

    RULE 91/02 "If to do, Use of immunosuppressive drugs: message information"
      WHEN Recommended
      IF SYNTH:COMMON-TTT-ID "COMMON-TTT-ID - Treatment inducing immunosuppression" = true
      DO Neutral
      MESSAGES  MSG102
    END RULE 91/02

    RULE 91/03 "If to do, HIV: message information"
      WHEN Recommended
      IF COND:C24 "HIV infection" = true
      DO Neutral
      MESSAGES  MSG101
    END RULE 91/03

    RULE 91/04 "If to do, Diagnosed and treated pre-cancerous conditions of the cervix: message information"
      WHEN Recommended
      IF COND:C1255 "Precancerous conditions of the cervix treated" = true
      DO Neutral
      MESSAGES  MSG364
    END RULE 91/04
  END FOLDER 91
END FOLDER 9
END TARGET

MESSAGE MSG312 Other ANY PRIO 0
  "Vaccines that can be used: Cervarix (continue with the same vaccine)."@en
 END MESSAGE MSG312

MESSAGE MSG313 Alert ANY PRIO 0
  "Vaccination schedule not followed: protection may not be guaranteed."@en
 END MESSAGE MSG313

MESSAGE MSG123 Justification PRO PRIO 0
  "The vaccination schedule was not followed: the third dose should have been administered at least three months after the second, and ideally four months after that. It is important to avoid shortening the interval between doses when planning vaccinations, and they must always be carried out according to the established schedule. Specialist advice is required."@en
 END MESSAGE MSG123

MESSAGE MSG125 Justification ANY PRIO 0
  "The 2-dose schedule is only valid if the first dose was administered before the age of 15 years. Since the schedule was started after the age of 15 years, it is not complete, but continued vaccination is no longer recommended."@en
 END MESSAGE MSG125

MESSAGE MSG102 Justification ANY PRIO 0
  "Immunodeficiencies are the strongest known risk factor for the acquisition, persistence and progression of HPV infections to lesions (precancerous conditions, cancers, papillary lesions). Therefore, immunoincompetent individuals may benefit from HPV vaccination."@en
 END MESSAGE MSG102

MESSAGE MSG118 Justification PRO PRIO 0
  "The vaccination schedule was not followed: the second dose should have been administered at least one month after the first, ideally two months later. It is important to avoid shortening the interval between doses when planning vaccinations, and they must always be carried out according to the established schedule. Specialist advice is required."@en
 END MESSAGE MSG118

MESSAGE MSG126 Justification ANY PRIO 0
  "The schedule is not complete but continued vaccination is no longer recommended."@en
 END MESSAGE MSG126

MESSAGE MSG101 Justification ANY PRIO 0
  "Immunodeficiencies are the strongest known risk factor for the acquisition, persistence and progression of HPV infections to lesions (precancerous conditions, cancers, papillary lesions). Therefore, immunoincompetent individuals may benefit from HPV vaccination."@en
 END MESSAGE MSG101

MESSAGE MSG119 Justification ANY PRIO 0
  "Persons older than those scheduled for free vaccination under the Immunisation Programme may also benefit from HPV vaccination and should be vaccinated in accordance with the cheracteristics of medicinal products for all registered vaccines. <br>Prior medical advice is required."@en
 END MESSAGE MSG119

MESSAGE MSG120 Summary ANY PRIO 0
  "For people aged 30 to 45, a consultation with your doctor is necessary."@en
 END MESSAGE MSG120

MESSAGE MSG3 Other ANY PRIO 10
  "Refund: 50%."@en
 END MESSAGE MSG3

MESSAGE MSG51 Alert ANY PRIO 0
  "Warning: allergy - see comments before any vaccine administration."@en
 END MESSAGE MSG51

MESSAGE MSG165 Comments PATIENT PRIO 0
  "An allergy to a previous vaccine administration has been reported. You must clearly inform the healthcare professional before any new vaccination, regardless of the vaccine administered."@en
 END MESSAGE MSG165

MESSAGE MSG166 Comments PRO PRIO 0
  "An allergy to a previous vaccine administration has been reported. Before any new vaccination, carefully check the origin of the previous allergy and adapt the course of action. Seek specialist advice if in doubt."@en
 END MESSAGE MSG166

MESSAGE MSG124 Justification ANY PRIO 20
  "NOTE! Persons who have developed symptoms indicating hypersensitivity after the first dose of the vaccine should not receive subsequent doses of the vaccine."@en
 END MESSAGE MSG124

MESSAGE MSG305 Comments ANY PRIO 0
  "If flexibility in the vaccination schedule is needed, the second dose can be administered 1 to 2.5 months after the first dose."@en
 END MESSAGE MSG305

MESSAGE MSG304 Justification PRO PRIO 0
  "The vaccination schedule has not been followed: all three doses must be administered within one year. Specialist advice is required."@en
 END MESSAGE MSG304

MESSAGE MSG307 Justification PRO PRIO 0
  "The vaccination schedule was not followed: the second dose should have been administered at least one month after the first. It is important to avoid shortening the interval between doses when planning vaccinations, and vaccinations should always be carried out according to the established schedule. Specialist advice is required."@en
 END MESSAGE MSG307

MESSAGE MSG306 Comments ANY PRIO 0
  "If flexibility in the vaccination schedule is needed, the second dose can be administered 5 to 12 months after the first dose."@en
 END MESSAGE MSG306

MESSAGE MSG308 Justification PRO PRIO 0
  "The vaccination schedule was not followed: the third dose should have been administered at least five months after the first. It is important to avoid shortening the interval between doses when planning vaccinations, and vaccinations should always be carried out according to the established schedule. Specialist advice is required."@en
 END MESSAGE MSG308

MESSAGE MSG309 Justification ANY PRIO 0
  "For individuals aged 15 years and older at the time of the first injection, Carvarix vaccine should be administered in a 3-dose schedule (at 0, 1, and 6 months). <br>
The second dose should be administered at least one month after the first dose, and the third dose should be administered at least 5 months after the first dose. <br>
The need for a booster dose has not been established."@en
 END MESSAGE MSG309

MESSAGE MSG117 Comments ANY PRIO 0
  "For maximum effect, the vaccine should be given to people before contact with the virus, i.e. before sexual initiation. The greatest efficacy has been shown in girls vaccinated up to 19 years of age, lesser but also significant in women up to 29 years of age."@en
 END MESSAGE MSG117

MESSAGE MSG364 Justification ANY PRIO 0
  "A body of evidence has emerged showing a lower recurrence rate of cervical precancerous lesions in HPV-vaccinated women than in unvaccinated women."@en
 END MESSAGE MSG364

MESSAGE MSG558 Comments ANY PRIO 0
  "Persons older than those scheduled for free vaccination under the Immunisation Programme may also benefit from HPV vaccination and should be vaccinated in accordance with the cheracteristics of medicinal products for all registered vaccines."@en
 END MESSAGE MSG558

MESSAGE MSG559 Comments ANY PRIO 0
  "For maximum effect, the vaccine should be given to people before contact with the virus, i.e. before sexual initiation. The greatest efficacy has been shown in girls vaccinated up to 19 years of age, lesser but also significant in women up to 29 years of age.Persons older than those scheduled for free vaccination under the Immunisation Programme may also benefit from HPV vaccination and should be vaccinated in accordance with the cheracteristics of medicinal products for all registered vaccines."@en
 END MESSAGE MSG559

MESSAGE MSG121 Justification ANY PRIO 10
  "For individuals 15 years of age and older at the time of the first injection, Gardasil 9 vaccine should be administered in a 3-dose schedule (at 0, 2, 6 months). <br>
The second dose should be administered at least 1 month after the first dose, and the third dose should be administered at least 3 months after the second dose. All three doses should be administered within 1 year.<br>
The need for a booster dose has not been established."@en
 END MESSAGE MSG121

MESSAGE MSG311 Other ANY PRIO 0
  "Vaccine can be used: Gardasil 9 (continue with the same vaccine)."@en
 END MESSAGE MSG311

MESSAGE MSG310 Other ANY PRIO 0
  "Vaccines that can be used: Gardasil 9 or Cervarix.<br>
Please note that Cervarix is reimbursed at 50% for individuals aged 18 to 45.<br>
Gardasil 9 is not reimbursed."@en
 END MESSAGE MSG310

MESSAGE MSG103 Other ANY PRIO 0
  "HPV vaccines can be administered concurrently or at any interval with other vaccines, but to a different site - for example, the opposite arm, or with a minimum distance of 2.5 cm from the site of the first vaccine."@en
 END MESSAGE MSG103
