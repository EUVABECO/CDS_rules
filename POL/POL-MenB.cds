CALC MenB_doses_received IS HIST(MenB,0,count)
CALC MenB_penultimate_dose_date IS HIST(MenB,-2,date)

CALC MenB_last_dose_date IS HIST(MenB,-1,date)
CALC MenB_last_vaccine IS HIST(MenB,-1,vaccine)

CALC  MenB_d1d2 IS INTERVAL(HIST(MenB,1,date),HIST(MenB,2,date))
CALC  MenB_d2d3 IS INTERVAL(HIST(MenB,2,date),HIST(MenB,3,date))

TARGET MenB

FOLDER 0 "ACWY et B"

  FOLDER 1 "RF+ (Copie)"
    IF ALL OF
    SYNTH:MEN-RF "MEN-RF - All risk factors for meningococus" = true
    CALC:Age>=18y

    RULE 1 "≥ 18y old, 0 dose, RF+: To do ASAP"
      IF CALC:MenB_doses_received = 0
      DO Recommended
        Status DUE
        Age 18y
      MESSAGES  MSG586 MSG587
    END RULE 1

    FOLDER 11 "LD is BEXSERO"
      IF CALC:MenB_last_vaccine = VAC0495 # BEXSERO

      RULE 11/01 "≥ 18y od, 1 dose BEXSERO, RF+: To do 4w after LD"
        IF CALC:MenB_doses_received = 1
        DO Recommended
          Status DUE
          Delay 4w from CALC:MenB_last_dose_date
        MESSAGES  MSG584 MSG576
      END RULE 11/01

      RULE 11/02 "≥ 18y od, ≥ 2 doses BEXSERO, RF+, add-dd ≥ 4w: Up to date"
        IF ALL OF
          CALC:MenB_doses_received>=2
          INTERVAL(CALC:MenB_penultimate_dose_date,CALC:MenB_last_dose_date)>=4w
        DO Recommended
          Status COMPLETED
        MESSAGES  MSG585 MSG577
      END RULE 11/02

      RULE 11/03 "≥ 18y od, ≥ 2 doses BEXSERO, RF+, add-dd ≤ 3w: To do 1m after LD"
        IF ALL OF
          CALC:MenB_doses_received>=2
          INTERVAL(CALC:MenB_penultimate_dose_date,CALC:MenB_last_dose_date)<=3w
        DO Recommended
          Status DUE
          Delay 1m from CALC:MenB_last_dose_date
        MESSAGES  MSG578
      END RULE 11/03
    END FOLDER 11

    FOLDER 12 "LD is TRUMENBA"
      IF CALC:MenB_last_vaccine = VAC0582 #TRUMENBA

      RULE 11/01 "≥ 18y od, 1 dose TRUMENBA, RF+: To do 6m after LD"
        IF CALC:MenB_doses_received = 1
        DO Recommended
          Status DUE
          Delay 6m from CALC:MenB_last_dose_date
        MESSAGES  MSG580 MSG579
      END RULE 11/01

      RULE 11/02 "≥ 18y od, 2 doses TRUMENBA, RF+, d1d2 ≤ 4m: Do do 4m after LD"
        IF ALL OF
          CALC:MenB_doses_received = 2
          CALC:MenB_d1d2<=4m
        DO Recommended
          Status DUE
          Delay 4m from CALC:MenB_last_dose_date
        MESSAGES  MSG581 MSG580
      END RULE 11/02

      RULE 11/03 "≥ 18y od, 2 doses TRUMENBA, RF+, d1d2 ≥ 5m: Up to date"
        IF ALL OF
          CALC:MenB_doses_received = 2
          CALC:MenB_d1d2>=5m
        DO Recommended
          Status COMPLETED
        MESSAGES  MSG585 MSG580 MSG577
      END RULE 11/03

      RULE 11/04 "≥ 18y od, 3 doses TRUMENBA, RF+, d1d2 ≤ 4m, d2d3 ≥ 4m: Up to date"
        IF ALL OF
          CALC:MenB_doses_received = 3
          CALC:MenB_d1d2 in 4w..4m
          CALC:MenB_d2d3>=4m
        DO Recommended
          Status COMPLETED
        MESSAGES  MSG585 MSG580 MSG577
      END RULE 11/04

      RULE 11/05 "≥ 18y od, < 4 doses TRUMENBA, RF+, d1d2 ≤ 3w: To do 6m after LD"
        IF ALL OF
          CALC:MenB_doses_received<4
          CALC:MenB_d1d2<=3w
        DO Recommended
          Status DUE
          Delay 6m from CALC:MenB_last_dose_date
        MESSAGES  MSG580 MSG582
      END RULE 11/05
    END FOLDER 12
  END FOLDER 1

  FOLDER 2 "RF- (Copie)"
    IF ALL OF
    SYNTH:MEN-RF "MEN-RF - All risk factors for meningococus" = false
    CALC:Age>=18y

    RULE 01 "≥ 18y old, 0 dose, RF-: Possible"
      IF CALC:MenB_doses_received = 0
      DO Suggested
      MESSAGES  MSG572 MSG574
    END RULE 01

    RULE 02 "≥ 18y od, 1 dose, RF-: Possible"
      IF CALC:MenB_doses_received = 1
      DO Suggested
      MESSAGES  MSG572 MSG574
    END RULE 02

    RULE 03 "≥ 18y od, ≥ 2 doses, RF-: Up to date"
      IF CALC:MenB_doses_received>=2
      DO Recommended
        Status COMPLETED
    END RULE 03
  END FOLDER 2

  FOLDER 9 "Further information (Copie)"

    RULE 01 "If to do, 0 dose, Vaccines available"
      WHEN Recommended
      IF ALL OF
        CALC:Age>=18y
        CALC:MenB_doses_received = 0
      DO Neutral
      MESSAGES  MSG583
    END RULE 01

    RULE 02 "If to do, ≥ 1 dose BEXSERO, Vaccines available"
      WHEN Recommended
      IF ALL OF
        CALC:Age>=18y
        CALC:MenB_doses_received>=1
        CALC:MenB_last_vaccine = VAC0495# BEXSERO
      DO Neutral
      MESSAGES  MSG588
    END RULE 02

    RULE 02 "If to do, ≥ 1 dose TRUMENBA, Vaccines available"
      WHEN Recommended
      IF ALL OF
        CALC:Age>=18y
        CALC:MenB_doses_received>=1
        CALC:MenB_last_vaccine = VAC0582 # TRUMENBA
      DO Neutral
      MESSAGES  MSG589
    END RULE 02

    RULE 04 "If reco, Sources"
      IF CALC:Age>=18y
      DO Neutral
    END RULE 04

    FOLDER 91 "Excel files (Copie)"

      RULE 91/03 "If to do, [18-64y] old, RF+: Message"
        IF ALL OF
          CALC:Age in 18y..64y
          SYNTH:MEN-RF "MEN-RF - All risk factors for meningococus" = true
        DO Neutral
        MESSAGES  MSG572
      END RULE 91/03

      RULE 91/04 "If to do, ≥ 65y old: Message"
        IF CALC:Age>=65y
        DO Neutral
        MESSAGES  MSG573
      END RULE 91/04

      RULE 91/05 "If to do, Allergy to any component of vaccine: Message + alert"
        IF ALL OF
          COND:C1161 "Allergy from a previous vaccine administration" = true
          CALC:Age>=18y
        DO Neutral
        MESSAGES  MSG51 MSG165 MSG166 MSG104
      END RULE 91/05

      RULE 91/07 "If to do, Chronic kidney disease: Message"
        WHEN Recommended
        IF SYNTH:COMMON-KIDNEY "COMMON-KIDNEY - Chronic kidney disease" = true
        DO Neutral
        MESSAGES  MSG534
      END RULE 91/07

      RULE 91/08 "If to do, Chronic liver disease"
        WHEN Recommended
        IF SYNTH:COMMON-LIVER "COMMON-LIVER - Chronic liver diseases" = true
        DO Neutral
        MESSAGES  MSG535
      END RULE 91/08

      RULE 91/09 "If to do, Malgnant tumour"
        WHEN Recommended
        IF COND:C404 "Cancer or hematological malignancy" = true
        DO Neutral
        MESSAGES  MSG547
      END RULE 91/09

      RULE 91/10 "If to do, Asplenia, Splenic dysfunction"
        WHEN Recommended
        IF COND:C36 "Spleen removal or non-functioning" = true
        DO Neutral
        MESSAGES  MSG536
      END RULE 91/10

      RULE 91/12 "If to do, HIV: Message"
        WHEN Recommended
        IF COND:C24 "HIV infection" = true
        DO Neutral
        MESSAGES  MSG537
      END RULE 91/12

      RULE 91/13 "If to do, before a bone marrow transplant: Message"
        WHEN Recommended
        IF COND:C415 "Waiting for a hematopoietic stem cell transplant (marrow transplant)" = true
        DO Neutral
        MESSAGES  MSG538
      END RULE 91/13

      RULE 91/14 "If to do, after a bone marrow transplant: Message"
        WHEN Recommended
        IF SYNTH:COMMON-HSCT "COMMON - Stem cell transplantation" = true
        DO Neutral
        MESSAGES  MSG539
      END RULE 91/14

      RULE 91/15 "If to do, immunosupresive treatment: Message"
        WHEN Recommended
        IF SYNTH:COMMON-TTT-ID "COMMON-TTT-ID - Treatment inducing immunosuppression" = true
        DO Neutral
        MESSAGES  MSG540
      END RULE 91/15

      RULE 91/16 "If to do, Rheumatic disease: Message"
        WHEN Recommended
        IF SYNTH:COMMON-RHU "COMMON-RHU - Rheumatic disease" = true
        DO Neutral
        MESSAGES  MSG541
      END RULE 91/16

      RULE 91/17 "If to do,  Eculizumab or Ravulizumab treatment for Marchiafava-Micheli anaemia: Message"
        WHEN Recommended
        IF COND:C541 "Anti-C5 treatment: Soliris® (Eculizumab) or Ultomiris® (ravulizumab)" = true
        DO Neutral
        MESSAGES  MSG542
      END RULE 91/17

      RULE 91/18 "If to do, Atypical hemolytic-uremic syndrome (aHUS): Message"
        WHEN Recommended
        IF COND:C1257 "Haemolytic uraemic syndrome (HUS)" = true
        DO Neutral
        MESSAGES  MSG543
      END RULE 91/18

      RULE 91/19 "If to do, nursery school"
        WHEN Recommended
        IF COND:C1259 "Children in nursery school" = true
        DO Neutral
        MESSAGES  MSG548
      END RULE 91/19

      RULE 91/20 "If to do, nursery"
        WHEN Recommended
        IF COND:C1260 "Children in nursery" = true
        DO Neutral
        MESSAGES  MSG549
      END RULE 91/20

      RULE 91/21 "If to do, dormitories"
        WHEN Recommended
        IF COND:C1170 "Dormitory accommodation" = true
        DO Neutral
        MESSAGES  MSG550
      END RULE 91/21

      RULE 91/22 "If to do, residence halls"
        WHEN Recommended
        IF COND:C1262 "Accommodation in a university residence." = true
        DO Neutral
        MESSAGES  MSG551
      END RULE 91/22

      RULE 91/23 "If to do, barracks"
        WHEN Recommended
        IF COND:C1263 "Housed in barracks" = true
        DO Neutral
        MESSAGES  MSG552
      END RULE 91/23

      RULE 91/24 "If to do, people having close family contact with a sick person or infectious material"
        WHEN Recommended
        IF COND:C1264 "Close contact with a case of invasive meningococcal infection" = true
        DO Neutral
        MESSAGES  MSG553
      END RULE 91/24

#      RULE 91/26 "People travelling to endemic areas"
#        IF SYST:patient_destinations = cf354ad7-86bf-423c-bd4c-0220f504457e
#        DO Neutral
#        MESSAGES  MSG554
#      END RULE 91/26

      RULE 91/27 "If to do, Health professionals: Message"
        WHEN Recommended
        IF SYNTH:COMMON-MED-STAFF "COMMON-MED-STAFF - Medical staff" = true
        DO Neutral
        MESSAGES  MSG544
      END RULE 91/27

      RULE 91/28 "If to do, Laboratory workers"
        WHEN Recommended
        IF COND:C249 "Works in a medical biology laboratory" = true
        DO Neutral
        MESSAGES  MSG555
      END RULE 91/28
    END FOLDER 91
  END FOLDER 9
END FOLDER 0
END TARGET

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

MESSAGE MSG585 Summary ANY PRIO 0
  "Plan a booster dose if risk factors are present."@en
 END MESSAGE MSG585

MESSAGE MSG580 Details ANY PRIO 10
  "The primary vaccination schedule with TRUMENBA vaccine includes either 2 doses administered 6 months apart, or 3 doses: 2 doses administered at least 1 month apart, followed by a third dose administered at least 4 months after the second."@en
 END MESSAGE MSG580

MESSAGE MSG577 Comments ANY PRIO 0
  "For individuals at ongoing risk of exposure to meningococcal infection, a booster dose should be considered."@en
 END MESSAGE MSG577

MESSAGE MSG578 Summary ANY PRIO 0
  "The interval between doses of BEXSERO vaccine should be at least one month. An additional dose is required."@en
 END MESSAGE MSG578

MESSAGE MSG572 Comments ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for people at risk.<br>
Risk groups include people with: liver diseases, malignant tumors, weakened immune system, rheumatic diseases, atypical hemolytic uremic syndrome and people treated with eculizumab or ravulizumab due to paroxysmal nocturnal hemoglobinuria, as well as people particularly exposed to infection due to their lifestyle (frequent travel, staying in crowds, contact with infected people)."@en
 END MESSAGE MSG572

MESSAGE MSG541 Justification ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for people with rheumatic disease  because they are at increased risk of meningococcal infection."@en
 END MESSAGE MSG541

MESSAGE MSG543 Justification ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for people with atypical hemolytic-uremic syndrome (aHUS)  because they are at increased risk of meningococcal infection."@en
 END MESSAGE MSG543

MESSAGE MSG535 Justification ANY PRIO 0
  "Vaccination against meningococcal disease  is especially recommended for people with chronic liver disease because they are at increased risk of serious complications associated with meningococcal infections."@en
 END MESSAGE MSG535

MESSAGE MSG536 Justification ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for people with anatomical or functional asplenia because they are at increased risk of meningococcal infection."@en
 END MESSAGE MSG536

MESSAGE MSG583 Other PRO PRIO 0
  "Vaccines available: BEXSERO, TRUMENBA."@en
 END MESSAGE MSG583

MESSAGE MSG574 Summary ANY PRIO 0
  "Vaccination against menincococcal infections is possible but not particularly recommended."@en
 END MESSAGE MSG574

MESSAGE MSG542 Justification ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for people treated with eculizumab or ravulizumab (treatment for Marchiafava-Micheli anaemia) because they are at increased risk of meningococcal infection."@en
 END MESSAGE MSG542

MESSAGE MSG549 Justification ANY PRIO 0
  "Vaccination against against meningococcal disease  is especially recommended for people staying in nurseries because staying in such groups increases the risk of meningococcal infection."@en
 END MESSAGE MSG549

MESSAGE MSG573 Comments ANY PRIO 0
  "Meningococcal vaccination is particularly recommended for people aged 65 and over."@en
 END MESSAGE MSG573

MESSAGE MSG588 Other PRO PRIO 0
  "Continue with the BEXSERO vaccine."@en
 END MESSAGE MSG588

MESSAGE MSG589 Other PRO PRIO 0
  "Continue with the TRUMENBA vaccine."@en
 END MESSAGE MSG589

MESSAGE MSG586 Summary ANY PRIO 0
  "Start a 2-dose primary vaccination course with the BEXSERO vaccine."@en
 END MESSAGE MSG586

MESSAGE MSG587 Details ANY PRIO 0
  "The primary vaccination schedule for BEXSERO vaccine consists of two doses administered one month apart. In case of stock shortages of BEXSERO vaccine, TRUMENBA vaccine can be used according to a two-dose (0-6 months) or three-dose (0-1-5 months) primary vaccination schedule."@en
 END MESSAGE MSG587

MESSAGE MSG584 Summary ANY PRIO 0
  "The primary vaccination course with the BEXSERO vaccine consists of two doses spaced one month apart."@en
 END MESSAGE MSG584

MESSAGE MSG576 Details ANY PRIO 0
  "The primary vaccination course with BEXSERO vaccine consists of two doses. The interval between doses should not be less than one month."@en
 END MESSAGE MSG576

MESSAGE MSG554 Justification ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for people travelling to endemic areas because they are at increased risk of meningococcal infection."@en
 END MESSAGE MSG554

MESSAGE MSG555 Justification ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for laboratory workers because they are at increased risk of meningococcal infection."@en
 END MESSAGE MSG555

MESSAGE MSG538 Justification ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for people before a bone marrow transplant because they are at increased risk of meningococcal infection."@en
 END MESSAGE MSG538

MESSAGE MSG544 Justification ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for health professionals because they are at increased risk of meningococcal infection."@en
 END MESSAGE MSG544

MESSAGE MSG547 Justification ANY PRIO 0
  "Vaccination against meningococcal disease  is especially recommended for people with malignant tumour because they are at increased risk of serious complications associated with meningococcal infections."@en
 END MESSAGE MSG547

MESSAGE MSG550 Justification ANY PRIO 0
  "Vaccination against against meningococcal disease  is especially recommended for people staying in dormitories because staying in such groups increases the risk of meningococcal infection."@en
 END MESSAGE MSG550

MESSAGE MSG551 Justification ANY PRIO 0
  "Vaccination against against meningococcal disease  is especially recommended for people staying in residence halls because staying in such groups increases the risk of meningococcal infection."@en
 END MESSAGE MSG551

MESSAGE MSG552 Justification ANY PRIO 0
  "Vaccination against against meningococcal disease  is especially recommended for people staying in barracks because staying in such groups increases the risk of meningococcal infection."@en
 END MESSAGE MSG552

MESSAGE MSG537 Justification ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for people with HIV infection because they are at increased risk of meningococcal infection."@en
 END MESSAGE MSG537

MESSAGE MSG553 Justification ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for people having close professional or family contact with a sick person or infectious material because they are at increased risk of meningococcal infection."@en
 END MESSAGE MSG553

MESSAGE MSG540 Justification ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for people treated withimmunosupresive treatment  because they are at increased risk of meningococcal infection."@en
 END MESSAGE MSG540

MESSAGE MSG539 Justification ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for people after a bone marrow transplant because they are at increased risk of meningococcal infection."@en
 END MESSAGE MSG539

MESSAGE MSG534 Justification ANY PRIO 0
  "Vaccination against meningococcal disease  is especially recommended for people with chronic kidney disease because they are at increased risk of serious complications associated with meningococcal infections."@en
 END MESSAGE MSG534

MESSAGE MSG548 Justification ANY PRIO 0
  "Vaccination against against meningococcal disease  is especially recommended for people staying in nursery schools because staying in such groups increases the risk of meningococcal infection."@en
 END MESSAGE MSG548

MESSAGE MSG579 Summary ANY PRIO 0
  "The primary vaccination course with the TRUMENBA vaccine includes two doses spaced 6 months apart."@en
 END MESSAGE MSG579

MESSAGE MSG581 Summary ANY PRIO 0
  "Administer a 3rd dose 4 months after the last dose."@en
 END MESSAGE MSG581

MESSAGE MSG582 Summary ANY PRIO 0
  "The interval between the first 2 doses of TRUMENBA should be at least one month. An additional dose is required."@en
 END MESSAGE MSG582
