CALC Pneu_doses_received IS HIST(Pneumo,0,count)
CALC Pneu_last_dose_date IS HIST(Pneumo,-1,date)
CALC last_valences_ids IS HIST(Pneumo,-1,valences)
	
SYNTH PNEU-ALL-RF "PNEU-ALL-RF - All risk factors" IS ANY OF
  SYNTH:PNEU-MAND-18-19 "RF for mandatory 18-19y old" = true
  COND:C1240 "Haemoglobinopathies" = true
  SYNTH:COMMON-LIVER  "Chronic liver diseases" = true
  COND:C24 "HIV infection" = true
  COND:C1166 "Leukemia" = true
  COND:C1164 "Hodgkin's disease" = true
  COND:C578 "Ongoing chemotherapy for solid tumor (cancer)" = true
  SYNTH:COMMON-K  "Generalized malignancy with chronic steroid therapy" = true
  COND:C153 "Radiotherapy in progress for solid tumor (cancer)" = true
  COND:C1168 "Multiple Myeloma" = true
  COND:C1000 "Excessive alcohol use" = true
  COND:C54 "Smoker" = true

SYNTH PNEU-LD-13-15 "PNEU-LD-13/15 - Last dose is 13 or 15 conjugated vaccine" IS ALL OF
  CALC:last_valences_ids contains VPC-03
  CALC:last_valences_ids contains no VPC-08

SYNTH PNEU-LD-23 "PNEU-LD-23 - Last dose is unconjgated vaccine like PNEUMO 23" IS ALL OF 
  CALC:last_valences_ids contains VPP-05

SYNTH PNEU-LD-20 "PNEU-LD-20 - Last dose is PREVENAR 20" IS ALL OF
  CALC:last_valences_ids contains VPC-08
  CALC:last_valences_ids contains no VPC-09N

SYNTH PNEU-MAND-18-19 "PNEU-MAND-18-19 - RF for mandatory 18-19y old" IS ANY OF
  SYNTH:COMMON-HEART "COMMON-HEART - Chronic heart diseases" = true
  COND:C1239 "Congenital spherocytosis" = true
  COND:C479 "Thrombocytopenia" = true
  SYNTH:COMMON-LUNG "COMMON-LUNG - Chronic lung diseases" = true
  SYNTH:COMMON-KIDNEY "COMMON-KIDNEY - Chronic kidney disease" = true
  COND:C6 "Nephrotic syndrome" = true
  COND:C958 "Diabetes" = true
  COND:C34 "Osteo-meningeal breach" = true
  SYNTH:COMMON-CID "COMMON-CID - Congenital immunodeficiencies" = true
  COND:C404 "Cancer or hematological malignancy" = true
  COND:C35 "Candidate for implantation or holder of a cochlear implant" = true
  COND:C2 "Cyanogenic congenital heart disease" = true
  COND:C1241 "Other acquired immunodeficiency" = true
  COND:C36 "Spleen removal or non-functioning" = true
  SYNTH:COMMON-SOT-HSCT "COMMON - Solid organ or stem cell transplantation" = true
  SYNTH:COMMON-ID-TTMT "COMMON-ID - Before or after immunosuppressive treatment" = true

SYNTH PNEU-OVER65 "PNEU-OVER65 - RF leading to reimbursement in people aged 65 and over" IS ANY OF
  SYNTH:COMMON-HEART "COMMON-HEART - Chronic heart diseases" = true
  COND:C1240 "Haemoglobinopathies" = true
  SYNTH:COMMON-LUNG "COMMON-LUNG - Chronic lung diseases" = true
  SYNTH:COMMON-LIVER "COMMON-LIVER - Chronic liver diseases" = true
  SYNTH:COMMON-KIDNEY "COMMON-KIDNEY - Chronic kidney disease" = true
  COND:C958 "Diabetes" = true
  COND:C34 "Osteo-meningeal breach" = true
  SYNTH:COMMON-CID "COMMON-CID - Congenital immunodeficiencies" = true
  COND:C1241 "Other acquired immunodeficiency" = true
  COND:C24 "HIV infection" = true
  SYNTH:COMMON-SOT-HSCT "COMMON - Solid organ or stem cell transplantation" = true
  SYNTH:COMMON-ID-TTMT "COMMON-ID - Before or after immunosuppressive treatment" = true
  COND:C1166 "Leukemia " = true
  COND:C1164 "Hodgkin's disease" = true
  COND:C578 "Ongoing chemotherapy for solid tumor (cancer)" = true
  COND:C1253 "Radiotherapy in progress for solid tumor (cancer)" = true
  COND:C1168 "Multiple Myeloma" = true
  COND:C35 "Candidate for implantation or holder of a cochlear implant" = true
  SYNTH:COMMON-K "COMMON-K - Generalized malignancy with chronic steroid therapy " = true

SYNTH PNEU-MAND-ALL "PNEU-MAND-ALL - RF for mandatory ≥ 20y old" IS ANY OF
  COND:C36 "Spleen removal or non-functioning" = true
  SYNTH:COMMON-SOT-HSCT "COMMON - Solid organ or stem cell transplantation" = true

TARGET Pneumo

FOLDER 1 "RF+"
  IF SYNTH:PNEU-ALL-RF "PNEU-ALL-RF - All risk factors" = true

  FOLDER 10 "Zero dose"
    IF CALC:Pneu_doses_received = 0

    RULE 0/01 "≥ 18y old, 0 dose: To do ASAP with PCV13 or 20."
      IF CALC:Age>=18y
      DO Recommended
        Status DUE
        Age 18y
      MESSAGES  MSG560
    END RULE 0/01
  END FOLDER 10

  FOLDER 11 "One dose or more"
    IF CALC:Pneu_doses_received>=1

    RULE 1/01 "≥ 18y old, LD PCV20: Up to date"
      IF ALL OF
        CALC:Age>=18y
        SYNTH:PNEU-LD-20 "PNEU-LD-20 - Last dose is PREVENAR 20" = true
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG567 MSG566
    END RULE 1/01

    RULE 1/02 "≥ 18y old, LD dose PCV13: To do with PCV20 1y after LD"
      IF ALL OF
        CALC:Age>=18y
        SYNTH:PNEU-LD-13-15 "PNEU-LD-13/15 - Last dose is 13 or 15 conjugated vaccine" = true
      DO Recommended
        Status DUE
        Delay 12m from CALC:Pneu_last_dose_date
      MESSAGES  MSG561 MSG562
    END RULE 1/02

    RULE 1/03 "≥ 18y old, LD PPSV23: To do with PCV20 5y after LD"
      IF ALL OF
        CALC:Age>=18y
        SYNTH:PNEU-LD-23 "PNEU-LD-23 - Last dose is unconjgated vaccine like PNEUMO 23" = true
      DO Recommended
        Status DUE
        Delay 5y from CALC:Pneu_last_dose_date
      MESSAGES  MSG564 MSG563
    END RULE 1/03
  END FOLDER 11
END FOLDER 1

FOLDER 2 "RF-"
  IF SYNTH:PNEU-ALL-RF "PNEU-ALL-RF - All risk factors" = false

  RULE 2/01 "≥ 18y old, RF-, LD dose PCV20: Up to date"
    IF ALL OF
      CALC:Age>=18y
      SYNTH:PNEU-LD-20 "PNEU-LD-20 - Last dose is PREVENAR 20" = true
    DO Recommended
      Status COMPLETED
    MESSAGES  MSG567 MSG566
  END RULE 2/01
END FOLDER 2

FOLDER 9 "Further information"

  RULE 9/01 "If to do, [18-19y] old, RF+: Mandatory vaccination + 100%"
    WHEN Recommended
    IF ALL OF
      CALC:Age in 18y..19y
      SYNTH:PNEU-MAND-18-19 "PNEU-MAND-18-19 - RF for mandatory 18-19y old" = true
    DO Neutral
    MESSAGES  MSG590 MSG348
  END RULE 9/01

  RULE 9/02 "If to do, ≥20y old, RF+ for mandatory: Mandatory vaccination + 100%"
    WHEN Recommended
    IF ALL OF
      SYNTH:PNEU-MAND-ALL "PNEU-MAND-ALL - RF for mandatory ≥ 20y old" = true
      CALC:Age>=20y
    DO Neutral
    MESSAGES  MSG590 MSG348
  END RULE 9/02

  RULE 9/03 "If to do, ≥65y old OR RF+ for 50%:  50%"
    WHEN Recommended
    IF ALL OF
      SYNTH:PNEU-OVER65 "PNEU-OVER65 - RF leading to reimbursement in people aged 65 and over" = true
      CALC:Age>=65y
    DO Neutral
    MESSAGES  MSG48
  END RULE 9/03

  FOLDER 91 "Excel file"

    RULE 91/07 "If to do, Allergy to any component of vaccine: Message"
      WHEN Recommended
      IF COND:C1161 "Allergy from a previous vaccine administration" = true
      DO Neutral
      MESSAGES  MSG51 MSG165 MSG166 MSG124
    END RULE 91/07

    RULE 91/09 "If to do, Chronic heart disease"
      WHEN Recommended
      IF SYNTH:COMMON-HEART "COMMON-HEART - Chronic heart diseases" = true
      DO Neutral
      MESSAGES  MSG314
    END RULE 91/09

    RULE 91/10 "If to do, Congenital heart defects"
      WHEN Recommended
      IF COND:C2 "Cyanogenic congenital heart disease" = true
      DO Neutral
    END RULE 91/10

    RULE 91/11 "If to do, Congenital spherocytosis"
      WHEN Recommended
      IF COND:C1239 "Congenital spherocytosis" = true
      DO Neutral
    END RULE 91/11

    RULE 91/12 "If to do, Idiopathic thrombocytopenia"
      WHEN Recommended
      IF COND:C479 "Thrombocytopenia" = true
      DO Neutral
    END RULE 91/12

    RULE 91/13 "If to do, Hemoglobinopathies"
      WHEN Recommended
      IF COND:C1240 "Haemoglobinopathies" = true
      DO Neutral
      MESSAGES  MSG368
    END RULE 91/13

    RULE 91/14 "If to do, Chronic lumg disease"
      WHEN Recommended
      IF SYNTH:COMMON-LUNG "COMMON-LUNG - Chronic lung diseases" = true
      DO Neutral
      MESSAGES  MSG315
    END RULE 91/14

    RULE 91/15 "If to do, Chronic liver disease"
      WHEN Recommended
      IF SYNTH:COMMON-LIVER "COMMON-LIVER - Chronic liver diseases" = true
      DO Neutral
      MESSAGES  MSG316
    END RULE 91/15

    RULE 91/16 "If to do, Cirrhosis"
      WHEN Recommended
      IF COND:C956 "Cirrhosis" = true
      DO Neutral
      MESSAGES  MSG317
    END RULE 91/16

    RULE 91/17 "If to do, Other chronic kidney disease"
      WHEN Recommended
      IF SYNTH:COMMON-KIDNEY "COMMON-KIDNEY - Chronic kidney disease" = true
      DO Neutral
      MESSAGES  MSG318
    END RULE 91/17

    RULE 91/18 "If to do, Nephrotic syndrome "
      WHEN Recommended
      IF COND:C6 "Nephrotic syndrome" = true
      DO Neutral
      MESSAGES  MSG319
    END RULE 91/18

    RULE 91/19 "If to do, Diabete"
      WHEN Recommended
      IF COND:C958 "Diabetes" = true
      DO Neutral
      MESSAGES  MSG320
    END RULE 91/19

    RULE 91/20 "If to do, Cerebrospinal fluid leak"
      WHEN Recommended
      IF COND:C34 "Osteo-meningeal breach" = true
      DO Neutral
      MESSAGES  MSG321
    END RULE 91/20

    RULE 91/22 "If to do, Asplenia, Splenic dysfunction"
      WHEN Recommended
      IF COND:C36 "Spleen removal or non-functioning" = true
      DO Neutral
    END RULE 91/22

    RULE 91/24 "If to do, Congenital immunodeficiencies"
      WHEN Recommended
      IF SYNTH:COMMON-CID "COMMON-CID - Congenital immunodeficiencies" = true
      DO Neutral
      MESSAGES  MSG322
    END RULE 91/24

    RULE 91/25 "If to do, Acquired immune deficiencies"
      WHEN Recommended
      IF COND:C1241 "Other acquired immunodeficiency" = true
      DO Neutral
      MESSAGES  MSG349
    END RULE 91/25

    RULE 91/26 "If to do, HIV: message information"
      WHEN Recommended
      IF COND:C24 "HIV infection" = true
      DO Neutral
      MESSAGES  MSG324
    END RULE 91/26

    RULE 91/28 "If to do, Individuals before or after immunosuppressive or biologic treatment: message information"
      WHEN Recommended
      IF SYNTH:COMMON-ID-TTMT "COMMON-ID - Before or after immunosuppressive treatment" = true
      DO Neutral
      MESSAGES  MSG545
    END RULE 91/28

    RULE 91/29 "If to do, People after organ or tissue transplantation"
      WHEN Recommended
      IF SYNTH:COMMON-SOT-HSCT "COMMON - Solid organ or stem cell transplantation" = true
      DO Neutral
      MESSAGES  MSG326
    END RULE 91/29

    RULE 91/30 "If to do, Cancers"
      WHEN Recommended
      IF COND:C404 "Cancer or hematological malignancy" = true
      DO Neutral
      MESSAGES  MSG343
    END RULE 91/30

    RULE 91/31 "If to do, Leukemia"
      WHEN Recommended
      IF COND:C1166 "Leukemia " = true
      DO Neutral
      MESSAGES  MSG344
    END RULE 91/31

    RULE 91/32 "If to do, Hodgkin's disease"
      WHEN Recommended
      IF COND:C1164 "Hodgkin's disease" = true
      DO Neutral
      MESSAGES  MSG342
    END RULE 91/32

    RULE 91/33 "If to do, Generalized malignancy associated with immunosuppressive treatment"
      WHEN Recommended
      IF COND:C578 "Ongoing chemotherapy for solid tumor (cancer)" = true
      DO Neutral
      MESSAGES  MSG345
    END RULE 91/33

    RULE 91/34 "If to do, Generalized malignancy with chronic steroid therapy "
      WHEN Recommended
      IF SYNTH:COMMON-K "COMMON-K - Generalized malignancy with chronic steroid therapy " = true
      DO Neutral
      MESSAGES  MSG346
    END RULE 91/34

    RULE 91/35 "If to do, Generalized malignancy with radiation therapy"
      WHEN Recommended
      IF COND:C1253 "Radiotherapy in progress for solid tumor (cancer)" = true
      DO Neutral
      MESSAGES  MSG347
    END RULE 91/35

    RULE 91/36 "If to do, Multiple myeloma "
      WHEN Recommended
      IF COND:C1168 "Multiple Myeloma" = true
      DO Neutral
      MESSAGES  MSG341
    END RULE 91/36

    RULE 91/37 "If to do, People addicted to alcohol"
      WHEN Recommended
      IF COND:C1000 "Excessive alcohol use" = true
      DO Neutral
      MESSAGES  MSG340
    END RULE 91/37

    RULE 91/38 "If to do, Cigarette smokers"
      WHEN Recommended
      IF COND:C54 "Smoker" = true
      DO Neutral
      MESSAGES  MSG339
    END RULE 91/38

    RULE 91/39 "If to do, People before or after cochlear implantation"
      WHEN Recommended
      IF COND:C35 "Candidate for implantation or holder of a cochlear implant" = true
      DO Neutral
      MESSAGES  MSG338
    END RULE 91/39
  END FOLDER 91
END FOLDER 9
END TARGET

MESSAGE MSG322 Justification ANY PRIO 0
  "Pneumococcal vaccination is recommended for people with congenital immunodeficiencies, as this group of patients is at much higher risk of serious bacterial infections, including those caused by pneumococci."@en
 END MESSAGE MSG322

MESSAGE MSG321 Justification ANY PRIO 0
  "Pneumococcal vaccination is extremely important for people with cerebrospinal fluid leakage, as these individuals are at risk for serious bacterial infections."@en
 END MESSAGE MSG321

MESSAGE MSG368 Justification PATIENT PRIO 0
  "Pneumococcal vaccination is recommended for people with hemoglobinopathies, as these conditions can weaken the immune system and increase the risk of serious infections."@en
 END MESSAGE MSG368

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

MESSAGE MSG324 Justification ANY PRIO 0
  "Pneumococcal vaccination is recommended for people with HIV infection, as this group of patients has a much higher risk of serious pneumococcal infections. HIV infection leads to a weakened immune system, which makes the body more susceptible to infections, including those caused by pneumococci. "@en
 END MESSAGE MSG324

MESSAGE MSG340 Justification ANY PRIO 0
  "Pneumococcal vaccination is recommended for alcohol addicts, as their immune systems are often weakened, increasing the risk of serious infections."@en
 END MESSAGE MSG340

MESSAGE MSG342 Justification ANY PRIO 0
  "Pneumococcal vaccination is recommended for people with Hodgkin's disease, as these patients are at increased risk of serious bacterial infections.Pneumococcal infections can lead to dangerous complications such as pneumonia and sepsis, which can be severe in immunocompromised patients. "@en
 END MESSAGE MSG342

MESSAGE MSG338 Justification ANY PRIO 0
  "Pneumococcal vaccination is especially recommended for people with cochlear implants, as these individuals are at higher risk for serious infections. Cochlear implants can pose an additional risk of infection, especially in the inner ear. "@en
 END MESSAGE MSG338

MESSAGE MSG341 Justification ANY PRIO 0
  "Pneumococcal vaccination is recommended for people with multiple myeloma, as these patients are at increased risk for serious bacterial infections. Multiple myeloma often leads to a weakened immune system, making the body more susceptible to infections, including those caused by pneumococci."@en
 END MESSAGE MSG341

MESSAGE MSG343 Justification ANY PRIO 0
  "Pneumococcal vaccination is recommended for people with cancer, as their immune systems are often weakened, increasing the risk of serious infections."@en
 END MESSAGE MSG343

MESSAGE MSG320 Justification ANY PRIO 0
  "Pneumococcal vaccination is recommended for people with diabetes, as this group of patients is at increased risk of serious complications from pneumococcal infections."@en
 END MESSAGE MSG320

MESSAGE MSG316 Justification ANY PRIO 0
  "Pneumococcal vaccination is important for people with chronic liver disease, as their immune systems are often weakened, increasing the risk of serious infections."@en
 END MESSAGE MSG316

MESSAGE MSG345 Justification ANY PRIO 0
  "Pneumococcal vaccination is recommended for people with generalized cancer associated with immunosuppressive therapy because these patients are at increased risk of serious infections. Immunosuppressive therapy, which often accompanies cancer therapy, weakens the immune system, making the body more susceptible to infections, including those caused by pneumococci."@en
 END MESSAGE MSG345

MESSAGE MSG349 Justification ANY PRIO 0
  "Pneumococcal vaccination is recommended for people with acquired immunodeficiencies, as this group of patients is at much higher risk of serious infections, including those caused by pneumococci. "@en
 END MESSAGE MSG349

MESSAGE MSG344 Justification ANY PRIO 0
  "Pneumococcal vaccination is recommended for people with leukemia, as these patients are at increased risk of serious bacterial infections. "@en
 END MESSAGE MSG344

MESSAGE MSG347 Justification ANY PRIO 0
  "Pneumococcal vaccination is recommended for people with generalized cancer who are undergoing radiation therapy, as this group of patients has a significantly increased risk of serious infections. Radiation therapy, used to treat cancer, can weaken the immune system, making the body more susceptible to infections, including those caused by pneumococci."@en
 END MESSAGE MSG347

MESSAGE MSG326 Justification ANY PRIO 0
  "Pneumococcal vaccination is recommended for organ and tissue transplant patients, since their immune systems are significantly weakened as a result of immunosuppression. Transplant patients are at increased risk of serious infections, including those caused by pneumococci."@en
 END MESSAGE MSG326

MESSAGE MSG319 Justification ANY PRIO 0
  "Pneumococcal vaccination is recommended for people with nephrotic syndrome, as these patients have an increased risk of serious infections.Pneumococcal vaccination is especially recommended for people with diabetes, as this group of patients has an increased risk of serious pneumococcal infections."@en
 END MESSAGE MSG319

MESSAGE MSG318 Justification ANY PRIO 0
  "Pneumococcal vaccination is recommended for people with chronic kidney disease, as their immune systems are often weakened, increasing the risk of serious infections."@en
 END MESSAGE MSG318

MESSAGE MSG561 Comments ANY PRIO 0
  "Vaccination will be considered complete after administration of the PCV20 vaccine, at least one year after PCV13. Alternatively, PPSV23 can be administered at least 8 weeks after PCV13. However, a PCV20 booster will be required at least 5 years after this dose."@en
 END MESSAGE MSG561

MESSAGE MSG562 Summary ANY PRIO 0
  "To be done 12 months after the last dose with PCV20. See comments."@en
 END MESSAGE MSG562

MESSAGE MSG564 Summary ANY PRIO 0
  "To be done 5 years after the last dose. See comments."@en
 END MESSAGE MSG564

MESSAGE MSG563 Comments ANY PRIO 0
  "Administer PCV20 or PPSV23 at least 5 years after the PPSV23 dose; PCV20 is the preferred option as it does not require subsequent boosters."@en
 END MESSAGE MSG563

MESSAGE MSG567 Summary ANY PRIO 0
  "The vaccination schedule is considered complete: no booster is necessary."@en
 END MESSAGE MSG567

MESSAGE MSG566 Justification ANY PRIO 0
  "PCV20 is given as a single dose, there is no need to administer PPSV23 after PCV20. "@en
 END MESSAGE MSG566

MESSAGE MSG346 Justification ANY PRIO 0
  "Pneumococcal vaccination is recommended for people with generalized cancer and chronic steroid therapy, as this group of patients has a significantly increased risk of serious infections. Chronic steroid therapy, used to treat cancer, weakens the immune system, making the body more susceptible to infections, including those caused by pneumococci."@en
 END MESSAGE MSG346

MESSAGE MSG545 Justification ANY PRIO 0
  "Pneumococcal vaccination is recommended for people before or after immunosuppressive or biologic treatment. These people are at increased risk of pneumococcal infections due to a weakened immune system, which can lead to serious health consequences."@en
 END MESSAGE MSG545

MESSAGE MSG590 Other ANY PRIO 0
  "Refund: 100% (only for PREVENAR 13)."@en
 END MESSAGE MSG590

MESSAGE MSG348 Summary ANY PRIO 0
  "Vaccination against pneumococcus is mandatory."@en
 END MESSAGE MSG348

MESSAGE MSG48 Other ANY PRIO 10
  "Refund: 100%."@en
 END MESSAGE MSG48

MESSAGE MSG317 Justification ANY PRIO 0
  "Pneumococcal vaccination is extremely important for people with cirrhosis, as their bodies are more susceptible to infection. Cirrhosis weakens the immune system, which increases the risk of serious diseases caused by pneumococci."@en
 END MESSAGE MSG317

MESSAGE MSG560 Comments ANY PRIO 0
  "For persons over 18 years of age from risk groups, one dose of Prevenar conjugate vaccine (13-valent, PCV13) is recommended first, and then Pneumovax 23 (23-valent, PPSV23) can be vaccinated at least 8 weeks apart. <br>
Alternatively, 1 dose of PCV20 conjugate vaccine can be administered. "@en
 END MESSAGE MSG560

MESSAGE MSG339 Justification ANY PRIO 0
  "Pneumococcal vaccination is recommended for cigarette smokers, as this group has an increased risk of serious infections. Smoking weakens the immune system and leads to chronic lung disease, making the body more susceptible to infection."@en
 END MESSAGE MSG339

MESSAGE MSG315 Justification ANY PRIO 0
  "Pneumococcal vaccination is strongly recommended for people with chronic lung disease. These people are at increased risk of pneumococcal infections, which can lead to serious complications."@en
 END MESSAGE MSG315

MESSAGE MSG314 Justification ANY PRIO 0
  "Pneumococcal vaccination is recommended for people with chronic heart disease, as these individuals are at increased risk of serious complications from pneumococcal infections. "@en
 END MESSAGE MSG314
