CALC MenA_doses_received IS HIST(MenA,0,count)
CALC MenA_last_vaccine IS HIST(MenA,-1,vaccine)

TARGET MenA

FOLDER 0 "ACWY"

  FOLDER 1 "RF+"
    IF ALL OF
    SYNTH:MEN-RF "MEN-RF - All risk factors for meningococus" = true
    CALC:Age>=18y

    RULE 1 "≥ 18y old, 0 dose, RF+: To do ASAP"
      IF CALC:MenA_doses_received = 0
      DO Recommended
        Status DUE
        Age 18y
      MESSAGES  MSG570
    END RULE 1

    FOLDER 11 "LD is NIMENRIX, MENVEO or MENQUADFI"
      IF ANY OF
      CALC:MenA_last_vaccine = VAC0486 # NIMENRIX
      CALC:MenA_last_vaccine = VAC0594 #MenQuadfi
      CALC:MenA_last_vaccine = VAC0141 #MENVEO

      RULE 11/01 "≥ 18y od, 1 dose ACWY, RF+: Up to date"
        IF CALC:MenA_doses_received = 1
        DO Recommended
          Status COMPLETED
      END RULE 11/01
    END FOLDER 11
  END FOLDER 1

  FOLDER 2 "RF-"
    IF ALL OF
    SYNTH:MEN-RF "MEN-RF - All risk factors for meningococus" = false
    CALC:Age>=18y

    RULE 01 "≥ 18y old, 0 dose, RF-: Possible"
      IF CALC:MenA_doses_received = 0
      DO Suggested
      MESSAGES  MSG572 MSG574
    END RULE 01

    RULE 1 "≥ 18y od, 1 dose, RF-: Up to date"
      IF CALC:MenA_doses_received = 1
      DO Recommended
        Status COMPLETED
    END RULE 1
  END FOLDER 2

  FOLDER 9 "Further information"

    RULE 01 "If to do, Vaccines available"
      WHEN Recommended
      IF CALC:Age>=18y
      DO Neutral
      MESSAGES  MSG571
    END RULE 01

    RULE 02 "If reco, Sources"
      IF CALC:Age>=18y
      DO Neutral
    END RULE 02

    FOLDER 91 "Excel files"

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

MESSAGE MSG571 Other PRO PRIO 0
  "Vaccines available: Nimenrix, MenQuadfi, Menveo (Men A, C, W135, Y) "@en
 END MESSAGE MSG571

MESSAGE MSG572 Comments ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for people at risk.<br>
Risk groups include people with: liver diseases, malignant tumors, weakened immune system, rheumatic diseases, atypical hemolytic uremic syndrome and people treated with eculizumab or ravulizumab due to paroxysmal nocturnal hemoglobinuria, as well as people particularly exposed to infection due to their lifestyle (frequent travel, staying in crowds, contact with infected people)."@en
 END MESSAGE MSG572

MESSAGE MSG573 Comments ANY PRIO 0
  "Meningococcal vaccination is particularly recommended for people aged 65 and over."@en
 END MESSAGE MSG573

MESSAGE MSG574 Summary ANY PRIO 0
  "Vaccination against menincococcal infections is possible but not particularly recommended."@en
 END MESSAGE MSG574

MESSAGE MSG540 Justification ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for people treated withimmunosupresive treatment  because they are at increased risk of meningococcal infection."@en
 END MESSAGE MSG540

MESSAGE MSG541 Justification ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for people with rheumatic disease  because they are at increased risk of meningococcal infection."@en
 END MESSAGE MSG541

MESSAGE MSG542 Justification ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for people treated with eculizumab or ravulizumab (treatment for Marchiafava-Micheli anaemia) because they are at increased risk of meningococcal infection."@en
 END MESSAGE MSG542

MESSAGE MSG554 Justification ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for people travelling to endemic areas because they are at increased risk of meningococcal infection."@en
 END MESSAGE MSG554

MESSAGE MSG555 Justification ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for laboratory workers because they are at increased risk of meningococcal infection."@en
 END MESSAGE MSG555

MESSAGE MSG570 Details ANY PRIO 0
  "A single dose of vaccine against strains A, C, W, and Y should be administered. In some individuals, an additional dose of vaccine may be considered as part of the primary vaccination series."@en
 END MESSAGE MSG570

MESSAGE MSG538 Justification ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for people before a bone marrow transplant because they are at increased risk of meningococcal infection."@en
 END MESSAGE MSG538

MESSAGE MSG539 Justification ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for people after a bone marrow transplant because they are at increased risk of meningococcal infection."@en
 END MESSAGE MSG539

MESSAGE MSG543 Justification ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for people with atypical hemolytic-uremic syndrome (aHUS)  because they are at increased risk of meningococcal infection."@en
 END MESSAGE MSG543

MESSAGE MSG544 Justification ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for health professionals because they are at increased risk of meningococcal infection."@en
 END MESSAGE MSG544

MESSAGE MSG547 Justification ANY PRIO 0
  "Vaccination against meningococcal disease  is especially recommended for people with malignant tumour because they are at increased risk of serious complications associated with meningococcal infections."@en
 END MESSAGE MSG547

MESSAGE MSG548 Justification ANY PRIO 0
  "Vaccination against against meningococcal disease  is especially recommended for people staying in nursery schools because staying in such groups increases the risk of meningococcal infection."@en
 END MESSAGE MSG548

MESSAGE MSG549 Justification ANY PRIO 0
  "Vaccination against against meningococcal disease  is especially recommended for people staying in nurseries because staying in such groups increases the risk of meningococcal infection."@en
 END MESSAGE MSG549

MESSAGE MSG550 Justification ANY PRIO 0
  "Vaccination against against meningococcal disease  is especially recommended for people staying in dormitories because staying in such groups increases the risk of meningococcal infection."@en
 END MESSAGE MSG550

MESSAGE MSG551 Justification ANY PRIO 0
  "Vaccination against against meningococcal disease  is especially recommended for people staying in residence halls because staying in such groups increases the risk of meningococcal infection."@en
 END MESSAGE MSG551

MESSAGE MSG552 Justification ANY PRIO 0
  "Vaccination against against meningococcal disease  is especially recommended for people staying in barracks because staying in such groups increases the risk of meningococcal infection."@en
 END MESSAGE MSG552

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

MESSAGE MSG534 Justification ANY PRIO 0
  "Vaccination against meningococcal disease  is especially recommended for people with chronic kidney disease because they are at increased risk of serious complications associated with meningococcal infections."@en
 END MESSAGE MSG534

MESSAGE MSG535 Justification ANY PRIO 0
  "Vaccination against meningococcal disease  is especially recommended for people with chronic liver disease because they are at increased risk of serious complications associated with meningococcal infections."@en
 END MESSAGE MSG535

MESSAGE MSG536 Justification ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for people with anatomical or functional asplenia because they are at increased risk of meningococcal infection."@en
 END MESSAGE MSG536

MESSAGE MSG537 Justification ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for people with HIV infection because they are at increased risk of meningococcal infection."@en
 END MESSAGE MSG537

MESSAGE MSG553 Justification ANY PRIO 0
  "Vaccination against meningococcal disease is especially recommended for people having close professional or family contact with a sick person or infectious material because they are at increased risk of meningococcal infection."@en
 END MESSAGE MSG553
