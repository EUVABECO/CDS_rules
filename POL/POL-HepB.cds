CALC HepB_doses_received IS HIST(HepB,0,count)
CALC HepB_last_dose_date IS HIST(HepB,-1,date)

CALC HepB_d1d2 IS INTERVAL(HIST(HepB,1,date),HIST(HepB,2,date))
CALC HepB_d2d3 IS INTERVAL(HIST(HepB,2,date),HIST(HepB,3,date))
CALC HepB_d3d4 IS INTERVAL(HIST(HepB,3,date),HIST(HepB,4,date))
CALC HepB_d4d5 IS INTERVAL(HIST(HepB,4,date),HIST(HepB,5,date))
CALC HepB_d5d6 IS INTERVAL(HIST(HepB,5,date),HIST(HepB,6,date))

SYNTH HBV-RF IS ANY OF
  SYNTH:HBV-HRF = true
  SYNTH:HBV-LRF = true
  SYNTH:HBV-MANDATORY = true

SYNTH HBV-HRF "HBV-HRF - All hight risk factor for hepatitis B" IS ALL OF COND:C1123 "Waiting for surgery" = true

SYNTH HBV-LRF "HBV-RF - All low risk factor for hepatitis B" IS ANY OF
  COND:C958 "Diabetes" = true
  COND:C18 "Chronic renal failure NOT on dialysis" = true
  COND:C122 "Person infected with the hepatitis B virus or chronic carrier of the HBs antigen in the entourage" = true
  COND:C123 "Sexual partner of a person infected with the hepatitis B virus" = true
  COND:C124 "In detention in a penal institution" = true
  COND:C1266 "Professionals exposed to the risk of contact with blood" = true
  COND:C1268 "Unprotected sexual contact with a partner of unknown serostatus" = true

SYNTH HBV-MANDATORY "HBV-MANDATORY - Risk factors making vaccination mandatory" IS ANY OF
  COND:C1122 "Woman considering pregnancy" = true
  SYNTH:COMMON-SOT-HSCT "COMMON - Solid organ or stem cell transplantation" = true
  COND:C125 "Chronic hepatitis C virus infection" = true
  COND:C17 "Chronic renal failure on dialysis" = true
  COND:C36 "Spleen removal or non-functioning" = true
  COND:C1113 "Students of medical schools and universities providing education in medical fields" = true
  COND:C378 "Active health professional" = true

SYNTH HBV-DD "HBV-DD - Risk factors involving double dose vaccination" IS ANY OF
  SYNTH:COMMON-SOT-HSCT = true
  COND:C404 "Cancer or hematological malignancy" = true
  COND:C917 "Strong immunosuppressive treatment (covid) " = true
  COND:C413 "Other immunosuppressive therapy" = true
  COND:C17 "Chronic renal failure on dialysis " = true

TARGET HepB

FOLDER 1 "Risk factor -"
  IF SYNTH:HBV-RF "HBV-RF - All risk factor for hepatitis B (Low, hight and mandatory)" = false

  FOLDER 10 "Zero dose"
    IF CALC:HepB_doses_received = 0

    RULE 10/01 "RF-, ≥ 18y old, 0 dose: Possible vaccination (schema 0-1-6m)"
      IF CALC:Age>=18y
      DO Suggested
    END RULE 10/01
  END FOLDER 10

  FOLDER 11 "One dose"
    IF CALC:HepB_doses_received = 1

    RULE 11/01 "RF-, ≥ 18y old, 1 dose: To do 1m after LD  (schema 0-1-6m)"
      IF CALC:Age>=18y
      DO Recommended
        Status DUE
        Age 18y
        Delay 1m from CALC:HepB_last_dose_date
    END RULE 11/01
  END FOLDER 11

  FOLDER 12 "Two doses"
    IF CALC:HepB_doses_received = 2

    RULE 12/01 "RF-, ≥ 18y old, 2 doses: To do 5m after LD (schema 0-1-6m)"
      IF CALC:Age>=18y
      DO Recommended
        Status DUE
        Age 18y
        Delay 5m from CALC:HepB_last_dose_date
    END RULE 12/01
  END FOLDER 12

  FOLDER 13 "Tree doses or more"
    IF CALC:HepB_doses_received>=3

    RULE 12/01 "RF-, ≥ 18y old, 3 doses: Up to date"
      IF CALC:Age>=20y
      DO Recommended
        Status COMPLETED
    END RULE 12/01
  END FOLDER 13
END FOLDER 1

FOLDER 2 "Risk factor +"
  IF SYNTH:HBV-RF "HBV-RF - All risk factor for hepatitis B (Low, hight and mandatory)" = true

  FOLDER 20 "Zero dose"
    IF CALC:HepB_doses_received = 0

    RULE 20/01 "RF+, ≥ 18y old, 0 dose: To do ASAP (schema 0-1-6m)"
      IF CALC:Age>=18y
      DO Recommended
        Status DUE
        Age 18y
    END RULE 20/01
  END FOLDER 20

  FOLDER 21 "One dose"
    IF CALC:HepB_doses_received = 1

    RULE 21/01 "RF+, ≥ 18y old, 1 dose: To do 1m after LD  (schema 0-1-6m)"
      IF CALC:Age>=18y
      DO Recommended
        Status DUE
        Age 18y
        Delay 1m from CALC:HepB_last_dose_date
    END RULE 21/01
  END FOLDER 21

  FOLDER 22 "Two doses"
    IF CALC:HepB_doses_received = 2

    RULE 22/01 "RF+, ≥ 18y old, 2 doses: To do 5m after LD (schema 0-1-6m)"
      IF CALC:Age>=18y
      DO Recommended
        Status DUE
        Age 18y
        Delay 5m from CALC:HepB_last_dose_date
    END RULE 22/01
  END FOLDER 22

  FOLDER 23 "Three doses or more"
    IF CALC:HepB_doses_received>=3

    RULE 23/01 "RF+, ≥ 18y old, 3 doses: Up to date"
      IF CALC:Age>=18y
      DO Recommended
        Status COMPLETED
    END RULE 23/01
  END FOLDER 23
END FOLDER 2

FOLDER 3 "Risk factors involving double dose vaccination"
  IF SYNTH:HBV-DD "HBV-DD - Risk factors involving double dose vaccination" = true

  FOLDER 30 "Zero dose"
    IF CALC:HepB_doses_received = 0

    RULE 30/01 "DD+, ≥ 18y old, 0 dose: To do ASAP (schema 0-1-2-6m with double dose)"
      IF CALC:Age>=18y
      DO Recommended
        Status DUE
        Age 18y
    END RULE 30/01
  END FOLDER 30

  FOLDER 31 "One dose"
    IF CALC:HepB_doses_received = 1

    RULE 31/01 "DD+, ≥ 18y old, 1 dose: To do 1m after LD  (schema 0-1-2-6m with double dose)"
      IF CALC:Age>=18y
      DO Recommended
        Status DUE
        Age 18y
        Delay 1m from CALC:HepB_last_dose_date
    END RULE 31/01
  END FOLDER 31

  FOLDER 32 "Two dose"
    IF CALC:HepB_doses_received = 2

    RULE 32/01 "DD+, ≥ 18y old, 2 doses (1-1): To do 1m after LD  (schema 0-1-2-6m with double dose)"
      IF ALL OF
        CALC:Age>=18y
        CALC:HepB_d1d2 = 0d
      DO Recommended
        Status DUE
        Age 18y
        Delay 1m from CALC:HepB_last_dose_date
    END RULE 32/01

    RULE 32/02 "DD+, ≥ 18y old, 2 doses (2): To do 1m after LD  (schema 0-1-2-6m with double dose)"
      IF ALL OF
        CALC:Age>=18y
        CALC:HepB_d1d2>0d
      DO Recommended
        Status DUE
        Age 18y
        Delay 1m from CALC:HepB_last_dose_date
    END RULE 32/02
  END FOLDER 32

  FOLDER 33 "Three doses"
    IF CALC:HepB_doses_received = 3

    RULE 33/01 "DD+, ≥ 18y old, 3 doses (1)-(2): To do 1m after LD  (schema 0-1-2-6m with double dose)"
      IF ALL OF
        CALC:Age>=18y
        CALC:HepB_d1d2>0d
        CALC:HepB_d2d3 = 0d
      DO Recommended
        Status DUE
        Age 18y
        Delay 1m from CALC:HepB_last_dose_date
    END RULE 33/01

    RULE 33/02 "DD+, ≥ 18y old, 3 doses (1)-(1)-(1): To do 4m after LD  (schema 0-1-2-6m with double dose)"
      IF ALL OF
        CALC:Age>=18y
        CALC:HepB_d1d2>0d
        CALC:HepB_d2d3>0d
      DO Recommended
        Status DUE
        Age 18y
        Delay 4m from CALC:HepB_last_dose_date
    END RULE 33/02
  END FOLDER 33

  FOLDER 34 "Four doses "
    IF CALC:HepB_doses_received = 4

    RULE 34/01 "DD+, ≥ 18y old, 4 doses (1)-(1)-(1)-(1): Up to date (schema 0-1-2-6m with double dose)"
      IF ALL OF
        CALC:Age>=18y
        CALC:HepB_d1d2>0d
        CALC:HepB_d2d3>0d
        CALC:HepB_d3d4>0d
      DO Recommended
        Status COMPLETED
    END RULE 34/01

    RULE 34/02 "DD+, ≥ 18y old, 4 doses (1)-(1)-(2): To do in 4m after LD (schema 0-1-2-6m with double dose)"
      IF ALL OF
        CALC:Age>=18y
        CALC:HepB_d1d2>0d
        CALC:HepB_d2d3>0d
        CALC:HepB_d3d4 = 0d
      DO Recommended
        Status DUE
        Age 18y
        Delay 4m from CALC:HepB_last_dose_date
    END RULE 34/02

    RULE 34/03 "DD+, ≥ 18y old, 4 doses (2)-(2): To do in 1m after LD (schema 0-1-2-6m with double dose)"
      IF ALL OF
        CALC:Age>=18y
        CALC:HepB_d1d2 = 0d
        CALC:HepB_d2d3>0d
        CALC:HepB_d3d4 = 0d
      DO Recommended
        Status DUE
        Age 18y
        Delay 1m from CALC:HepB_last_dose_date
    END RULE 34/03
  END FOLDER 34

  FOLDER 35 "Five doses"
    IF CALC:HepB_doses_received = 5

    RULE 35/01 "DD+, ≥ 18y old, 5 doses (1)-(1)-(1)-(1)-(1): Up to date (schema 0-1-2-6m with double dose)"
      IF ALL OF
        CALC:Age>=18y
        CALC:HepB_d1d2>0d
        CALC:HepB_d2d3>0d
        CALC:HepB_d3d4>0d
        CALC:HepB_d4d5>0d
      DO Recommended
        Status COMPLETED
    END RULE 35/01

    RULE 35/02 "DD+, ≥ 18y old, 5 doses (1)-(1)-(1)-(2): Up to date (schema 0-1-2-6m with double dose)"
      IF ALL OF
        CALC:Age>=18y
        CALC:HepB_d1d2>0d
        CALC:HepB_d2d3>0d
        CALC:HepB_d3d4>0d
        CALC:HepB_d4d5 = 0d
      DO Recommended
        Status COMPLETED
    END RULE 35/02

    RULE 35/03 "DD+, ≥ 18y old, 5 doses (1)-(2)-(2): To do in 4m after LD (schema 0-1-2-6m with double dose)"
      IF ALL OF
        CALC:Age>=18y
        CALC:HepB_d1d2>0d
        CALC:HepB_d2d3 = 0d
        CALC:HepB_d3d4>0d
        CALC:HepB_d4d5 = 0d
      DO Recommended
        Status DUE
        Age 18y
        Delay 4m from CALC:HepB_last_dose_date
    END RULE 35/03
  END FOLDER 35

  FOLDER 36 "Six doses"
    IF CALC:HepB_doses_received = 6

    RULE 36/01 "DD+, ≥ 18y old, 6 doses (?)-(1)-(1): Up to date (schema 0-1-2-6m with double dose)"
      IF ALL OF
        CALC:Age>=18y
        CALC:HepB_d5d6>0d
        CALC:HepB_d4d5>0d
      DO Recommended
        Status COMPLETED
    END RULE 36/01

    RULE 36/02 "DD+, ≥ 18y old, 6 doses (2)-(2)-(2): To do in 4m after LD (schema 0-1-2-6m with double dose)"
      IF ALL OF
        CALC:Age>=18y
        CALC:HepB_d1d2 = 0d
        CALC:HepB_d2d3>0d
        CALC:HepB_d3d4 = 0d
        CALC:HepB_d4d5>0d
        CALC:HepB_d5d6 = 0d
      DO Recommended
        Status DUE
        Age 18y
        Delay 4m from CALC:HepB_last_dose_date
    END RULE 36/02
  END FOLDER 36

  FOLDER 37 "Seven or more"
    IF CALC:HepB_doses_received>=7

    RULE 37/01 "DD+, ≥ 18y old, ≥ 7 doses: Up to date (schema 0-1-2-6m with double dose)"
      IF CALC:Age>=18y
      DO Recommended
        Status COMPLETED
    END RULE 37/01
  END FOLDER 37
END FOLDER 3

FOLDER 9 "Further information"

  RULE 9/01 "If to do: Message = Vaccines that can be used"
    WHEN Recommended
    IF CALC:Age>=18y
    DO Neutral
    MESSAGES  MSG184
  END RULE 9/01

  RULE 9/02 "if to do, Low RF+: Information"
    WHEN Recommended
    IF SYNTH:HBV-LRF "HBV-RF - All low risk factor for hepatitis B" = true
    DO Neutral
    MESSAGES  MSG73
  END RULE 9/02

  RULE 9/05 "if to do, Hight RF+: Information"
    WHEN Recommended
    IF SYNTH:HBV-HRF "HBV-HRF - All hight risk factor for hepatitis B" = true
    DO Neutral
    MESSAGES  MSG70
  END RULE 9/05

  RULE 9/06 "if to do, Mandatory+: Information"
    WHEN Recommended
    IF SYNTH:HBV-MANDATORY "HBV-MANDATORY - Risk factors making vaccination mandatory" = true
    DO Neutral
    MESSAGES  MSG72
  END RULE 9/06

  RULE 9/07 "If to do, ≥ 60y old: Information"
    IF CALC:Age>=60y
    DO Neutral
    MESSAGES  MSG52
  END RULE 9/07

  FOLDER 91 "Excel files"

    RULE 91/06 "If to do, Women who have not yet been vaccinated and are planning a pregnancy: Information"
      WHEN Recommended
      IF COND:C1122 "Woman considering pregnancy" = true
      DO Neutral
      MESSAGES  MSG48 MSG53
    END RULE 91/06

    RULE 91/07 "If to do, Patients being prepared for surgery: Information"
      WHEN Recommended
      IF COND:C1123 "Waiting for surgery" = true
      DO Neutral
      MESSAGES  MSG48 MSG54
    END RULE 91/07

    RULE 91/08 "If to do, Allergy to any component of vaccine: Message"
      IF ALL OF
        COND:C1161 "Allergy from a previous vaccine administration" = true
        CALC:Age>=18y
      DO Neutral
      MESSAGES  MSG51 MSG165 MSG166 MSG104
    END RULE 91/08

    RULE 91/10 "If to do, Cancer: Information (double dose)"
      WHEN Recommended
      IF COND:C404 "Cancer or hematological malignancy" = true
      DO Neutral
      MESSAGES  MSG62 MSG63
    END RULE 91/10

    RULE 91/11 "If to do, Diabete: Information"
      WHEN Recommended
      IF COND:C958 "Diabetes" = true
      DO Neutral
      MESSAGES  MSG64
    END RULE 91/11

    RULE 91/12 "If to do, People on immunosuppressive therapy: Information (double dose)"
      WHEN Recommended
      IF SYNTH:COMMON-TTT-ID "COMMON-TTT-ID - Treatment inducing immunosuppression" = true
      DO Neutral
      MESSAGES  MSG62 MSG65
    END RULE 91/12

    RULE 91/13 "If to do, People after organ and tissue transplantation: Information (double dose)"
      WHEN Recommended
      IF SYNTH:COMMON-SOT-HSCT "COMMON - Solid organ or stem cell transplantation" = true
      DO Neutral
      MESSAGES  MSG48 MSG62 MSG55
    END RULE 91/13

    RULE 91/14 "If to do, People infected with hepatitis C virus: Information"
      WHEN Recommended
      IF COND:C125 "Chronic hepatitis C virus infection" = true
      DO Neutral
      MESSAGES  MSG48 MSG56
    END RULE 91/14

    RULE 91/15 "If to do, Renal failure: Information"
      WHEN Recommended
      IF SYNTH:COMMON-RENAL  "COMMON-RENAL - Chronic renal failure" = true
      DO Neutral
      MESSAGES  MSG66
    END RULE 91/15

    RULE 91/17 "If to do, People on dialysis: Information + double dose"
      WHEN Recommended
      IF COND:C17 "Chronic renal failure on dialysis" = true
      DO Neutral
      MESSAGES  MSG57 MSG48 MSG62 MSG61
    END RULE 91/17

    RULE 91/18 "If to do, People who have had a splenectomy or have asplenia: Information"
      WHEN Recommended
      IF COND:C36 "Spleen removal or non-functioning" = true
      DO Neutral
      MESSAGES  MSG48 MSG58
    END RULE 91/18

    RULE 91/20 "If to do, People in close proximity with hepatitis B patients: Information"
      WHEN Recommended
      IF COND:C122 "Person infected with the hepatitis B virus or chronic carrier of the HBs antigen in the entourage" = true
      DO Neutral
      MESSAGES  MSG67
    END RULE 91/20

    RULE 91/24 "If to do, Closed prisons: Information"
      WHEN Recommended
      IF COND:C124 "In detention in a penal institution" = true
      DO Neutral
      MESSAGES  MSG68
    END RULE 91/24

    RULE 91/25 "If to do, People at risk of infection through sexual contact : Information"
      WHEN Recommended
      IF COND:C123 "Sexual partner of a person infected with the hepatitis B virus" = true
      DO Neutral
      MESSAGES  MSG69
    END RULE 91/25

    RULE 91/26 "If to do, Students of medical schools and universities providing education in medical fields who have not been vaccinated against hepatitis B: Information"
      WHEN Recommended
      IF COND:C1113 "Students of medical schools and universities providing education in medical fields" = true
      DO Neutral
      MESSAGES  MSG48 MSG59
    END RULE 91/26

    RULE 91/28 "If to do, Persons who, due to their occupation, are at risk of infections associated with damage to tissue continuity : Information"
      WHEN Recommended
      IF COND:C1266 "Professionals exposed to the risk of contact with blood" = true
      DO Neutral
      MESSAGES  MSG48 MSG557
    END RULE 91/28
  END FOLDER 91
END FOLDER 9
END TARGET

MESSAGE MSG52 Justification ANY PRIO 0
  "Hepatitis B vaccination is recommended for people over the age of 60. In this age group, the risk of infection and complications is much higher. Therefore, it is worth considering vaccination as an effective method of health protection and prevention of serious liver disease."@en
 END MESSAGE MSG52

MESSAGE MSG62 Alert ANY PRIO 0
  "Reinforced vaccination protocol (2 doses of the standard adult dosage vaccine at each session)."@en
 END MESSAGE MSG62

MESSAGE MSG65 Justification ANY PRIO 0
  "Hepatitis B vaccination is recommended for people on immunosuppressive treatment. Such treatment weakens the immune system, which increases the risk of HBV infection. It is recommended to maintain antibody levels ≥100 IU/l. Antibody monitoring is done every 6 months. When the concentration falls below <100 IU/l, a double dose of the vaccine should be given."@en
 END MESSAGE MSG65

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

MESSAGE MSG64 Justification ANY PRIO 0
  "Diabetics have a 2-fold higher risk of developing acute hepatitis B compared to non-diabetics. When the anti-HBs antibody concentration is <10 IU/l after primary vaccination, another 1-3 doses of vaccine are recommended. When the antibody concentration is still <10 IU/l, no further vaccination is performed."@en
 END MESSAGE MSG64

MESSAGE MSG63 Justification ANY PRIO 0
  "Hepatitis B vaccination is recommended for people with cancer. Cancer patients are at higher risk of infection, especially during immunosuppressive treatment, which weakens their immune systems. It is recommended to maintain antibody levels ≥100 IU/l. Antibody monitoring is done every 6 months. When the concentration falls below <100 IU/l, a double dose of the vaccine should be given."@en
 END MESSAGE MSG63

MESSAGE MSG70 Summary ANY PRIO 0
  "Hepatitis B vaccination is especially recommended."@en
 END MESSAGE MSG70

MESSAGE MSG68 Justification ANY PRIO 0
  "Vaccination against hepatitis B is recommended for people in closed institutions. In such facilities, where there may be close contact with other people, the risk of HBV infection is increased.Vaccination protects not only vaccinated persons, but also other residents of the facility, minimizing the risk of spreading the virus. Vaccination is performed according to a 3-dose schedule : 0; 1; 6 months."@en
 END MESSAGE MSG68

MESSAGE MSG57 Justification ANY PRIO 0
  "Hepatitis B vaccination is especially recommended for people with kidney failure. Patients with kidney disease, especially those on dialysis, are at higher risk of HBV infection, which can lead to serious health complications. It is recommended to test antibody levels every 6-12 months. "@en
 END MESSAGE MSG57

MESSAGE MSG48 Other ANY PRIO 10
  "Refund: 100%."@en
 END MESSAGE MSG48

MESSAGE MSG61 Comments ANY PRIO 0
  "- From the age of 16, the vaccination schedule of a person with chronic renal failure on dialysis must be reinforced.<br>
- The reinforced vaccination schedule is carried out with the ENGERIX B 20 µg vaccine in double dose. Each injection is carried out with 40 μg of vaccine antigen (i.e. 2 doses of ENGERIX B 20 µg) according to a schedule of 4 injections (M0, M1, M2 and M6). <br>
- A check of the anti-HBs antibody level after vaccination and once a year is recommended: a booster vaccination will be carried out if the anti-HBs antibodies are less than 10 IU/L."@en
 END MESSAGE MSG61

MESSAGE MSG53 Justification ANY PRIO 0
  "Hepatitis B vaccination is especially recommended for women planning a pregnancy. Protection from infection is important for both the mother and the developing fetus."@en
 END MESSAGE MSG53

MESSAGE MSG184 Other PRO PRIO 0
  "To be administered with an adult vaccine (Engerix B 20, Euvax B 20, Hbvaxpro 10).
If hepatitis A vaccination is also recommended: Twinrix Adult."@en
 END MESSAGE MSG184

MESSAGE MSG56 Justification ANY PRIO 0
  "Hepatitis B vaccination is a key component of preventive health care, especially for people at risk, such as those infected with hepatitis C virus (HCV)."@en
 END MESSAGE MSG56

MESSAGE MSG73 Summary ANY PRIO 0
  "Vaccination against hepatitis B is recommended."@en
 END MESSAGE MSG73

MESSAGE MSG67 Justification ANY PRIO 0
  "Hepatitis B vaccination is recommended for people who are in close proximity with hepatitis B patients. These individuals are at a higher risk of infection, especially if they come into contact with bodily fluids or use shared objects.  Immunization is an effective method of protection against HBV and can help prevent serious health complications, so relatives of those with the disease should consider vaccination as a key component of prevention. Vaccination follows a 3-dose schedule : 0; 1; 6 months."@en
 END MESSAGE MSG67

MESSAGE MSG72 Summary ANY PRIO 0
  "Vaccination against hepatitis B is mandatory."@en
 END MESSAGE MSG72

MESSAGE MSG58 Justification ANY PRIO 0
  "Hepatitis B vaccination is especially recommended for people who have had a splenectomy or asplenia. These people are more vulnerable to infections, including hepatitis B, due to their weakened immunity. "@en
 END MESSAGE MSG58

MESSAGE MSG66 Justification ANY PRIO 0
  "Hepatitis B vaccination is recommended for people with kidney failure. Patients with kidney disease, especially those on dialysis, are at higher risk of HBV infection, which can lead to serious health complications. It is recommended to test antibody levels every 6-12 months. "@en
 END MESSAGE MSG66

MESSAGE MSG69 Justification ANY PRIO 0
  "People who engage in risky sexual behavior, such as not using condoms with unknown partners, are more susceptible to HBV infection. Vaccination is an effective method of protection that can help prevent serious health complications associated with hepatitis B. Anyone who is sexually active, especially in high-risk groups, should consider vaccination as an important part of preventive health care."@en
 END MESSAGE MSG69

MESSAGE MSG59 Justification ANY PRIO 0
  "Medical trainees are exposed to blood and other body fluids, which increases the risk of HBV infection. Vaccination is mandatory before the start of professional practice to ensure the safety of both students and the patients they will work with. "@en
 END MESSAGE MSG59

MESSAGE MSG54 Justification ANY PRIO 0
  "Hepatitis B vaccination is recommended for patients planning surgical procedures. Performing immunization before surgery increases safety by protecting against potential infection that may occur during medical procedures."@en
 END MESSAGE MSG54

MESSAGE MSG55 Justification ANY PRIO 0
  "Hepatitis B vaccination is especially recommended for organ and tissue transplant patients. These patients are at higher risk of infection due to a weakened immune system, making them more susceptible to HBV. It is recommended to maintain antibody levels ≥100 IU/l. Antibody monitoring is done every 6 months. When the concentration falls below <100 IU/l, a double dose of the vaccine should be given."@en
 END MESSAGE MSG55

MESSAGE MSG557 Justification ANY PRIO 0
  "Vaccination against hepatitis B is especially recommended for those exposed to infections associated with tissue damage, such as medical workers and those associated with cosmetic services. In these occupations, contact with blood and body fluids is unavoidable, increasing the risk of HBV infection. People in such occupations should consider vaccination as an important part of health care."@en
 END MESSAGE MSG557
