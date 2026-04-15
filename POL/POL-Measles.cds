CALC Meas_doses_received IS HIST(MEAS,0,count)
CALC Meas_last_dose_date IS HIST(MEAS,-1,date)

SYNTH MMR-MANDATORY "MMR-MANDATORY - Mandatory vaccination for of measles, rubella and mumps" IS ANY OF
  COND:C36 "Spleen removal or non-functioning" = true
  SYNTH:COMMON-SOT-HSCT "COMMON - Solid organ or stem cell transplantation" = true
  CALC:Age<=18y

TARGET Measles

FOLDER 0 "MMR"

  FOLDER 0 "History Measles +"
    IF COND:C146 "History of measles" = true

    RULE 0/01 "≥18y old, History Measles+: Up to date"
      IF CALC:Age>=18y
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG131 MSG132 MSG130
    END RULE 0/01
  END FOLDER 0

  FOLDER 1 "History Measles -"
    IF COND:C146 "History of measles" = false

    RULE 1/01 "≥18y old, 0 dose: To do ASAP"
      IF ALL OF
        CALC:Meas_doses_received = 0
        CALC:Age>=18y
      DO Recommended
        Status DUE
        Age 18y
    END RULE 1/01

    RULE 1/02 "≥18y old, 1 dose: To do 12m after LD"
      IF ALL OF
        CALC:Meas_doses_received = 1
        CALC:Age>=18y
      DO Recommended
        Status DUE
        Age 18y
        Delay 28d from CALC:Meas_last_dose_date
    END RULE 1/02

    RULE 1/03 "≥18y old, ≥2 doses, RECO-: Up to date"
      IF ALL OF
        CALC:Meas_doses_received>=2
        CALC:Age>=18y
      DO Recommended
        Status COMPLETED
    END RULE 1/03
  END FOLDER 1

  FOLDER 8 "Contraindication"
    IF COND:C146 "History of measles" = false

    RULE 01 "Current pregnancy: Temporary contraindicated (To do after pregnancy)"
      WHEN Recommended
      IF SYNTH:PREGNANCY_ONGOING "MATERNITY-PREGNANCY - Pregnancy in progress" = true
      DO Contraindicated
      MESSAGES  MSG142 MSG140 MSG141 MSG143
    END RULE 01

    RULE 02 "Immunodepression: Contraindication with request for advice"
      WHEN Recommended
      IF SYNTH:COMMON-ID-MMR "COMMON-ID - Immunosuppression (Special CI MMR)" = true
      DO Contraindicated
      MESSAGES  MSG144
    END RULE 02
  END FOLDER 8

  FOLDER 9 "Further information"

    RULE 9/01 "If to do, Mandatory vaccination: message information"
      WHEN Recommended
      IF SYNTH:MMR-MANDATORY "MMR-MANDATORY - Mandatory vaccination for of measles, rubella and mumps" = true
      DO Neutral
      MESSAGES  MSG139
    END RULE 9/01

    FOLDER 91 "Excel files"

      RULE 91/01 "If to do, 18y old: Message mandatory until 19y old AND reimbursement 100%"
        WHEN Recommended
        IF CALC:Age = 18y
        DO Neutral
        MESSAGES  MSG48 MSG127
      END RULE 91/01

      RULE 91/05 "If to do, Female: Message"
        WHEN Recommended
        IF BASE:sex = f
        DO Neutral
        MESSAGES  MSG128
      END RULE 91/05

      RULE 91/07 "If to do, Planned pregnancy: Contraindicated + Message"
        WHEN Recommended
        IF COND:C1122 "Woman considering pregnancy" = true
        DO Contraindicated
        MESSAGES  MSG133
      END RULE 91/07

      RULE 91/08 "If to do, Allergy to any component of vaccine: Message"
        WHEN Recommended
        IF COND:C1161 "Allergy from a previous vaccine administration" = true
        DO Neutral
        MESSAGES  MSG51 MSG165 MSG145 MSG166
      END RULE 91/08

      RULE 91/10 "If to do, People after organ and tissue transplantation: message information + 100% Refund"
        WHEN Recommended
        IF SYNTH:COMMON-SOT-HSCT "COMMON - Solid organ or stem cell transplantation" = true
        DO Neutral
        MESSAGES  MSG48 MSG134 MSG144
      END RULE 91/10

      RULE 91/11 "If to do, People who have had a splenectomy or have asplenia: message information + 100% Refund"
        WHEN Recommended
        IF COND:C36 "Spleen removal or non-functioning" = true
        DO Neutral
        MESSAGES  MSG135 MSG48
      END RULE 91/11

      RULE 91/14 "If to do, Students of medical schools and universities providing medical education: message information"
        WHEN Recommended
        IF COND:C1113 "Students of medical schools and universities providing education in medical fields" = true
        DO Neutral
        MESSAGES  MSG136
      END RULE 91/14

      RULE 91/15 "If to do, Health care workers : message information"
        WHEN Recommended
        IF SYNTH:COMMON-MED-STAFF "COMMON-MED-STAFF - Medical staff" = true
        DO Neutral
        MESSAGES  MSG137
      END RULE 91/15

      RULE 91/16 "If to do, Kindergarten employees: message information"
        WHEN Recommended
        IF COND:C88 "Works in a pre-school childcare facility (daycare, nursery school, etc.)" = true
        DO Neutral
        MESSAGES  MSG138
      END RULE 91/16

      RULE 91/17 "If to do, School employees : message information"
        WHEN Recommended
        IF COND:C95 "National education professional in contact with children" = true
        DO Neutral
        MESSAGES  MSG532
      END RULE 91/17

      RULE 91/18 "If to do, Hospital workers / clinic workers : message information"
        WHEN Recommended
        IF ANY OF
          COND:C1265 "Working in a care establishment" = true
          COND:C88 "Works in a pre-school childcare facility (daycare, nursery school, etc.)" = true
        DO Neutral
        MESSAGES  MSG556
      END RULE 91/18
    END FOLDER 91

    FOLDER 92 "Rubella specific"

      RULE 92/06 "If to do, Male: Message"
        WHEN Recommended
        IF ALL OF
          BASE:sex = m
          BASE:eval<=2020-01-01
        DO Neutral
        MESSAGES  MSG129
      END RULE 92/06
    END FOLDER 92
  END FOLDER 9
END FOLDER 0
END TARGET

MESSAGE MSG133 Comments ANY PRIO 10
  "NOTE! Vaccination with the combined vaccine against MEASLES, MUMPS and RUBELLA should not be performed 4 weeks before a planned pregnancy, due to the theoretical possibility of a set of congenital defects of the fetus caused by the vaccine attenuated live strain of rubella virus."@en
 END MESSAGE MSG133

MESSAGE MSG142 Justification PATIENT PRIO 0
  "You are pregnant: wait until you give birth to get vaccinated."@en
 END MESSAGE MSG142

MESSAGE MSG140 Alert ANY PRIO 0
  "Vaccination contraindicated during pregnancy (live vaccine)."@en
 END MESSAGE MSG140

MESSAGE MSG141 Comments PRO PRIO 0
  "Given the contraindication of live attenuated vaccines (especially rubella, measles, varicella) in pregnant women, efforts should be made to immunize non-immune women against these diseases before pregnancy or just after childbirth."@en
 END MESSAGE MSG141

MESSAGE MSG143 Justification PRO PRIO 0
  "Your patient is pregnant: wait until after delivery to vaccinate her."@en
 END MESSAGE MSG143

MESSAGE MSG51 Alert ANY PRIO 0
  "Warning: allergy - see comments before any vaccine administration."@en
 END MESSAGE MSG51

MESSAGE MSG165 Comments PATIENT PRIO 0
  "An allergy to a previous vaccine administration has been reported. You must clearly inform the healthcare professional before any new vaccination, regardless of the vaccine administered."@en
 END MESSAGE MSG165

MESSAGE MSG145 Comments ANY PRIO 0
  "NOTE! It is important to consult a medical doctor before the next vaccination in case of any allergic reaction."@en
 END MESSAGE MSG145

MESSAGE MSG166 Comments PRO PRIO 0
  "An allergy to a previous vaccine administration has been reported. Before any new vaccination, carefully check the origin of the previous allergy and adapt the course of action. Seek specialist advice if in doubt."@en
 END MESSAGE MSG166

MESSAGE MSG137 Justification ANY PRIO 10
  "Vaccination against measles, rubella and mumps is especially recommended for health care workers who have not previously been vaccinated or undergone these diseases. Protection against these dangerous infections is crucial because these individuals have direct contact with patients, which increases the risk of infection."@en
 END MESSAGE MSG137

MESSAGE MSG48 Other ANY PRIO 10
  "Refund: 100%."@en
 END MESSAGE MSG48

MESSAGE MSG134 Justification ANY PRIO 10
  "Vaccination against measles, mumps and rubella is mandatory for organ and tissue transplant recipients. These people are particularly vulnerable to the serious consequences of infectious diseases due to a weakened immune system resulting from immunosuppressive treatment. Post-transplant patients should consult their physician to determine an appropriate vaccination schedule, taking into account their medical condition and immunosuppressive therapy."@en
 END MESSAGE MSG134

MESSAGE MSG144 Summary ANY PRIO 0
  "Specialist advice is recommended."@en
 END MESSAGE MSG144

MESSAGE MSG136 Justification ANY PRIO 10
  "Vaccination against measles, rubella and mumps is crucial for medical students and trainees who have not previously been vaccinated or undergone these diseases. Protection against these serious infections is not only important for their health, but also for the safety of the patients they will be working with."@en
 END MESSAGE MSG136

MESSAGE MSG135 Justification ANY PRIO 10
  "Vaccination against measles, mumps and rubella is mandatory for people who have had a splenectomy or asplenia. These people have an increased risk of serious infections because the lack of a spleen leads to a weakened immune system, making them more susceptible to viral and bacterial infections."@en
 END MESSAGE MSG135

MESSAGE MSG138 Justification ANY PRIO 10
  "MMR vaccination against measles, rubella and mumps is especially recommended for young women working in children's environments who have not previously been vaccinated or contracted these diseases. Protection against these infectious diseases is crucial, as these individuals have regular contact with children who may carry the viruses."@en
 END MESSAGE MSG138

MESSAGE MSG131 Justification PRO PRIO 0
  "When a person is infected with <strong>measles</strong>, they develop protective antibodies against the disease. A positive measles serology alone does not constitute proof of protection against this disease if it is carried out at a distance from the clinical signs.<br> The certainty of the diagnosis of measles is based on direct detection of the virus (in particular by PCR) or on positive IgM serology at the time of the rash. The condition ‘History of measles’ in the health profile should only be ticked if the diagnosis is certain.<br> Furthermore, having had measles does not contraindicate trivalent measles-mumps-rubella (MMR) vaccination if this is also recommended."@en
 END MESSAGE MSG131

MESSAGE MSG132 Justification PATIENT PRIO 0
  "When a person is infected with <strong>measles</strong>, they develop protective antibodies against the disease. To ensure that a history of measles is certain, it is essential to seek your doctor's advice. In fact, a positive measles serology test carried out at a distance from the illness is not in itself proof of protection against the disease. <br> What's more, having had measles does not contraindicate vaccination with a trivalent measles-mumps-rubella (MMR) vaccine if this is recommended."@en
 END MESSAGE MSG132

MESSAGE MSG130 Summary ANY PRIO 0
  "Measles: guaranteed protection against this disease if a history of measles is confirmed."@en
 END MESSAGE MSG130

MESSAGE MSG129 Details ANY PRIO 0
  "Vaccination is especially recommended for young men for the prevention of congenital rubella, especially those not vaccinated by mandatory vaccination."@en
 END MESSAGE MSG129

MESSAGE MSG128 Details ANY PRIO 0
  "Vaccination is especially recommended for young women, especially those working in children's environments who are not immunized, not previously vaccinated, and who have not been ill."@en
 END MESSAGE MSG128

MESSAGE MSG127 Comments ANY PRIO 0
  "Vaccination is mandatory up to and including the age of 18."@en
 END MESSAGE MSG127

MESSAGE MSG532 Justification ANY PRIO 0
  "MMR vaccination against measles, rubella and mumps is especially recommended for young women working in children's environments who have not previously been vaccinated or contracted these diseases. Protection against these infectious diseases is crucial, as these individuals have regular contact with children who may carry the viruses."@en
 END MESSAGE MSG532

MESSAGE MSG139 Alert ANY PRIO 10
  "Vaccination required up to and including the age of 18 or in the presence of certain risk factors."@en
 END MESSAGE MSG139

MESSAGE MSG556 Justification ANY PRIO 0
  "MMR vaccination against measles, rubella and mumps is especially recommended for young women working in pediatric environments, such as kindergartens or hospitals. These individuals are exposed to children who may be carriers of these diseases, increasing the risk of infection."@en
 END MESSAGE MSG556
