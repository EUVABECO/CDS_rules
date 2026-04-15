CALC VZV_doses_received IS HIST(VZV-LA,0,count)
CALC VZV_last_dose_date IS HIST(VZV-LA,-1,date)
CALC VZV_first_vaccine IS HIST(VZV-LA,1,vaccine)
CALC VZV_d1d2 IS INTERVAL(HIST(VZV-LA,1,date),HIST(VZV-LA,2,date))


TARGET Chickenpox
FOLDER - "General rules"

  RULE 0 "Consistency check rule"
    IF ALL OF
      COND:C46 "Negative chickenpox serology" = true
      COND:C158 "Positive chickenpox serology" = true
    DO Exception
    MESSAGES  MSG239
  END RULE 0
END FOLDER -

FOLDER 1 "No contraindications, History chickenpox-"
  IF ALL OF
  SYNTH:COMMON-ID "COMMON-ID - Immunodépression sauf attente de transplantation (CI aux vaccins vivants)" = false
  SYNTH:COMMON-ID "COMMON-ID - Immunodépression sauf attente de transplantation (CI aux vaccins vivants)" = false

  FOLDER 10 "Zero dose"
    IF CALC:VZV_doses_received = 0

    RULE 11/01 "≥ 18y old, 0 dose: To do ASAP"
      IF CALC:Age>=18y
      DO Recommended
        Status DUE
        Age 18y
    END RULE 11/01
  END FOLDER 10

  FOLDER 11 "One dose"
    IF CALC:VZV_doses_received = 1

    RULE 11/01 "≥ 18y old, 1 dose Varilrix: To do 6w after LD"
      IF ALL OF
        CALC:Age>=18y
        CALC:VZV_first_vaccine = VAC0060 # VARILRIX
      DO Recommended
        Status DUE
        Age 18y
        Delay 6w from CALC:VZV_last_dose_date
    END RULE 11/01

    RULE 11/02 "≥ 18y old, 1 dose Varivax: To do [4-8w] after LD"
      IF ALL OF
        CALC:Age>=18y
        CALC:VZV_first_vaccine = VAC0061 #VARIVAX
      DO Recommended
        Status DUE
        Age 18y
        Delay 4w..8w from CALC:VZV_last_dose_date
    END RULE 11/02
  END FOLDER 11

  FOLDER 12 "Two doses or more"
    IF CALC:VZV_doses_received>=2

    RULE 12/1 "≥ 18y old, 2 doses: Up to date"
      IF CALC:Age>=18y
      DO Recommended
        Status COMPLETED
    END RULE 12/1
  END FOLDER 12
END FOLDER 1

FOLDER 2 "History chickenpox+"
  IF ANY OF
  COND:C158 "Positive chickenpox serology" = true
  COND:C145 "History of chickenpox" = true

  RULE 2/01 "≥ 18y old, History chickenpox+: Up to date"
    IF CALC:Age>=18y
    DO Recommended
      Status COMPLETED
  END RULE 2/01
END FOLDER 2

FOLDER 8 "Contraindication"
  IF SYNTH:COMMON-ID "COMMON-ID - Immunodépression sauf attente de transplantation (CI aux vaccins vivants)" = false

  RULE 8/01 "Current pregnancy: Temporary contraindicated (To do after pregnancy)"
    WHEN Recommended
    IF SYNTH:PREGNANCY_ONGOING "MATERNITY-PREGNANCY - Pregnancy in progress" = true
    DO Contraindicated
    MESSAGES  MSG142 MSG140 MSG143
  END RULE 8/01

  RULE 8/03 "Immunodepression: Contraindication with request for advice"
    IF SYNTH:COMMON-ID "COMMON-ID - Immunodépression sauf attente de transplantation (CI aux vaccins vivants)" = true
    DO Contraindicated
    MESSAGES  MSG144
  END RULE 8/03

  RULE 8/04 "Lymphoma: Contraindication"
    IF ANY OF
      COND:C1243 "Other cancer involving the bone marrow or lymphatic system" = true
      SYNTH:COMMON-LYM "COMMON-LYM - List of lymphoma" = true
    DO Contraindicated
    MESSAGES  MSG245
  END RULE 8/04

  RULE 8/05 "People after organ and tissue transplantation: Contraindication"
    IF SYNTH:COMMON-SOT-HSCT "COMMON - Solid organ or stem cell transplantation" = true
    DO Contraindicated
    MESSAGES  MSG254
  END RULE 8/05

  RULE 8/06 "HIV: Contraindication"
    IF COND:C24 "HIV infection" = true
    DO Contraindicated
    MESSAGES  MSG254
  END RULE 8/06

  RULE 8/07 "Congenital immunodeficiencies: Contraindication"
    IF SYNTH:COMMON-CID "COMMON-CID - Congenital immunodeficiencies" = true
    DO Contraindicated
    MESSAGES  MSG254
  END RULE 8/07

  RULE 8/08 "Immunodeficiency during anticancer treatment or receipt of steroid hormones: Contraindication"
    IF COND:C413 "Other immunosuppressive therapy" = true
    DO Contraindicated
    MESSAGES  MSG254
  END RULE 8/08
END FOLDER 8

FOLDER 9 "Further information"

  RULE 9/01 "If To do, 18y old: Message  (100%)"
    WHEN Recommended
    IF CALC:Age = 18y
    DO Neutral
    MESSAGES  MSG240
  END RULE 9/01

  RULE 9/02 "If To do, ≥ 19y old: Message"
    WHEN Recommended
    IF CALC:Age>=19y
    DO Neutral
    MESSAGES  MSG241
  END RULE 9/02

  RULE 9/03 "2 doses, d1d2 ≤ 3w: Too short"
    IF ALL OF
      CALC:VZV_d1d2<=3w
      CALC:VZV_doses_received = 2
    DO Exception
    MESSAGES  MSG250 MSG249
  END RULE 9/03

  RULE 9/04 "If to do, ≥ 18y old: Message = Vaccines that can be used (VARILRIX or VARIVAX)"
    WHEN Recommended
    IF CALC:Age>=18y
    DO Neutral
    MESSAGES  MSG337
  END RULE 9/04

  FOLDER 91 "Excel file"

    RULE 91/05 "Planned pregnancy: Especially recommended and temporary contraindicated the 3 months before the planned pregnancy"
      WHEN Recommended
      IF ALL OF
        SYNTH:PREGNANCY_ONGOING "MATERNITY-PREGNANCY - Pregnancy in progress" = false
        COND:C1122 "Woman considering pregnancy" = true
      DO Neutral
      MESSAGES  MSG243 MSG242 MSG244
    END RULE 91/05

    RULE 91/08 "If to do, Allergy to any component of vaccine: Message + alert"
      IF ALL OF
        COND:C1161 "Allergy from a previous vaccine administration" = true
        CALC:Age>=18y
      DO Neutral
      MESSAGES  MSG51 MSG165 MSG166 MSG104
    END RULE 91/08

    RULE 91/16 "If To do, 18y old, Congenital or acquired immunodeficiencies: Message  (Mandatory - 100%)"
      WHEN Recommended
      IF ALL OF
        CALC:Age = 18y
        SYNTH:COMMON-CID-AID "COMMON-CID-AID - Congenital or acquired immunodeficiencies" = true
      DO Neutral
      MESSAGES  MSG48 MSG256 MSG546
    END RULE 91/16

    RULE 91/17 "If To do, 18y old, Planned immunosuppressive treatment or chemotherapy: Message  (Mandatory - 100%)"
      WHEN Recommended
      IF ALL OF
        CALC:Age = 18y
        COND:C835 "Pending initiation of therapy that affects immunity" = true
      DO Neutral
      MESSAGES  MSG48 MSG256 MSG246
    END RULE 91/17

    RULE 91/18 "If To do, Contact with a person with chickenpox (up to 5th day after contact)"
      IF COND:C1242 "Contact with a person with chickenpox within the last 5 days" = true
      DO Neutral
      MESSAGES  MSG327
    END RULE 91/18

    RULE 91/19 "If To do, Close contact with a pregnant woman, ≥ 19y old: Message"
      WHEN Recommended
      IF ALL OF
        CALC:Age>=19y
        COND:C53 "Pregnant woman in the entourage" = true
      DO Neutral
      MESSAGES  MSG247
    END RULE 91/19

    RULE 91/20 "If To do, Close contact with immunocompromised, ≥ 19y old: Message"
      WHEN Recommended
      IF ALL OF
        CALC:Age>=19y
        COND:C47 "Immunocompromised person in the entourage" = true
      DO Neutral
      MESSAGES  MSG248
    END RULE 91/20

    RULE 91/21 "If To do, 18y old, Being around immunocompromised people or people before planned immunosuppressive treatment or chemotherapy: Message  (Mandatory - 100%)"
      WHEN Recommended
      IF ALL OF
        CALC:Age = 18y
        COND:C1244 "Person undergoing immunosuppressive treatment or chemotherapy in the entourage" = true
      DO Neutral
      MESSAGES  MSG48 MSG328 MSG256
    END RULE 91/21

    RULE 91/22 "If To do, 18y old, Nursing and care facility: Message (Mandatory - 100%)"
      WHEN Recommended
      IF ALL OF
        COND:C1245 "Stay in a nursing and care facility" = true
        CALC:Age = 18y
      DO Neutral
      MESSAGES  MSG48 MSG329 MSG256
    END RULE 91/22

    RULE 91/23 "If To do, 18y old, Residential medical care facility: Message (Mandatory - 100%)"
      WHEN Recommended
      IF ALL OF
        COND:C1246 "Stay in a residential medical care facility" = true
        CALC:Age = 18y
      DO Neutral
      MESSAGES  MSG48 MSG256 MSG330
    END RULE 91/23

    RULE 91/24 "If To do, 18y old, Family foster home: Message (Mandatory - 100%)"
      WHEN Recommended
      IF ALL OF
        CALC:Age = 18y
        COND:C1247 "Resides in a family foster home" = true
      DO Neutral
      MESSAGES  MSG331 MSG48 MSG256
    END RULE 91/24

    RULE 91/25 "If To do, 18y old, Home for mothers with small children and pregnant women: Message (Mandatory - 100%)"
      WHEN Recommended
      IF ALL OF
        CALC:Age = 18y
        COND:C1248 "Resides in a home for mothers with minor children and pregnant women" = true
      DO Neutral
      MESSAGES  MSG48 MSG256 MSG332
    END RULE 91/25

    RULE 91/26 "If To do, 18y old, Nursing care home: Message  (Mandatory - 100%)"
      IF ALL OF
        CALC:Age = 18y
        COND:C1237 "Resides in a medico-social care facility" = true
      DO Neutral
      MESSAGES  MSG255 MSG48 MSG256
    END RULE 91/26

    RULE 91/27 "If To do, 18y old, Childcare facility: Message  (Mandatory - 100%)"
      IF ALL OF
        CALC:Age = 18y
        COND:C1249 "Stay in a childcare and educational facility" = true
      DO Neutral
      MESSAGES  MSG48 MSG333 MSG256
    END RULE 91/27

    RULE 91/28 "If To do, 18y old, Regional therapeutic care center: Message  (Mandatory - 100%)"
      IF ALL OF
        CALC:Age = 18y
        COND:C1250 "Stay in a regional therapeutic care facility" = true
      DO Neutral
      MESSAGES  MSG48 MSG256 MSG334
    END RULE 91/28

    RULE 91/29 "If To do, 18y old, Pre-adoption intervention center: Message  (Mandatory - 100%)"
      IF ALL OF
        CALC:Age = 18y
        COND:C1251 "Stay in a pre-adoption intervention center" = true
      DO Neutral
      MESSAGES  MSG48 MSG256 MSG335
    END RULE 91/29

    RULE 91/30 "If To do, 18y old, Children's club: Message  (Mandatory - 100%)"
      IF ALL OF
        CALC:Age = 18y
        COND:C1252 "Stay in a children’s club" = true
      DO Neutral
      MESSAGES  MSG48 MSG336 MSG256
    END RULE 91/30

    RULE 91/31 "If To do, Students of medical schools and universities providing medical education: Message"
      WHEN Recommended
      IF COND:C1113 "Students of medical schools and universities providing education in medical fields" = true
      DO Neutral
      MESSAGES  MSG251 MSG252
    END RULE 91/31

    RULE 91/32 "If To do, Health professionals: Message"
      WHEN Recommended
      IF SYNTH:COMMON-MED-STAFF "COMMON-MED-STAFF - Medical staff" = true
      DO Neutral
      MESSAGES  MSG253 MSG252
    END RULE 91/32
  END FOLDER 91
END FOLDER 9
END TARGET

MESSAGE MSG48 Other ANY PRIO 10
  "Refund: 100%."@en
 END MESSAGE MSG48

MESSAGE MSG329 Justification ANY PRIO 0
  "Compulsory vaccination against chickenpox is mandatory for adolescents up to the age of 19 years, who have not had chickenpox, residing, or qualified to stay in nursing and care facilities."@en
 END MESSAGE MSG329

MESSAGE MSG256 Summary ANY PRIO 0
  "Vaccination against chickenpox is mandatory."@en
 END MESSAGE MSG256

MESSAGE MSG239 Alert ANY PRIO 0
  "There is an inconsistency in the “health profile”: the boxes Varicella serology positive and Varicella serology negative cannot be checked at the same time!"@en
 END MESSAGE MSG239

MESSAGE MSG330 Justification ANY PRIO 0
  "Compulsory vaccination against chickenpox is mandatory for adolescents up to the age of 19 years, who have not had chickenpox, residing, or qualified to reside, in residential madeical care facilities."@en
 END MESSAGE MSG330

MESSAGE MSG254 Justification ANY PRIO 0
  "Immunization is contraindicated in immunocompromised states."@en
 END MESSAGE MSG254

MESSAGE MSG241 Comments ANY PRIO 0
  "Vaccination recommended for people who have not had chickenpox and who have not been previously vaccinated with either mandatory or recommended vaccination. In adults, the course of chickenpox is more severe than in children.<br>
Chickenpox has a more severe course in adults over 20 years (the risk of complications and even death is 10-20 times higher than in children)."@en
 END MESSAGE MSG241

MESSAGE MSG243 Summary ANY PRIO 0
  "Vaccination is particularly recommended for women planning a pregnancy, at least three months before the start of the pregnancy."@en
 END MESSAGE MSG243

MESSAGE MSG242 Justification ANY PRIO 10
  "Vaccination recommended for people who have not had chickenpox and have not been previously vaccinated with either mandatory or recommended vaccination, especially women planning to become pregnant."@en
 END MESSAGE MSG242

MESSAGE MSG244 Justification ANY PRIO 0
  "Chickenpox vaccination is contraindicated during pregnancy and the three months preceding it."@en
 END MESSAGE MSG244

MESSAGE MSG142 Justification PATIENT PRIO 0
  "You are pregnant: wait until you give birth to get vaccinated."@en
 END MESSAGE MSG142

MESSAGE MSG140 Alert ANY PRIO 0
  "Vaccination contraindicated during pregnancy (live vaccine)."@en
 END MESSAGE MSG140

MESSAGE MSG143 Justification PRO PRIO 0
  "Your patient is pregnant: wait until after delivery to vaccinate her."@en
 END MESSAGE MSG143

MESSAGE MSG240 Comments ANY PRIO 0
  "Mandatory chickenpox vaccination is administered to:<br>
1. adolescents up to the age of 19 years who have not had chickenpox:<br>
a) with congenital or acquired immunodeficiency with a high risk of severe disease;<br>
b) prior to planned immunosuppressive treatment or chemotherapy;<br>
2. adolescents up to the age of 19 years who have not had chickenpox, from the community of persons defined in point 1;<br>
3. adolescents up to the age of 19, who have not contracted chickenpox, residing, or qualified to reside, in:<br>
a) nursing and care institutions;<br>
b) residential medical care facilities;<br>
c) family foster homes;<br>
d) homes for mothers with small children and pregnant women;<br>
e) nursing care homes;<br>
f) childcare facilities;<br>
g) regional therapeutic care centres;<br>
h) pre-adoption intervention centres;<br>
i) children's clubs.<br>"@en
 END MESSAGE MSG240

MESSAGE MSG245 Justification ANY PRIO 0
  "Immunocompromised conditions, lymphoma and other cancers involving the bone marrow or lymphatic system are contraindications to vaccination."@en
 END MESSAGE MSG245

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

MESSAGE MSG246 Justification ANY PRIO 0
  "Compulsory vaccination against chickenpox is mandatory for adolescents up to the age of 19 years who have not had chickenpox before planned immunosuppressive treatment or chemotherapy."@en
 END MESSAGE MSG246

MESSAGE MSG250 Summary ANY PRIO 0
  "The interval between the two doses is too short."@en
 END MESSAGE MSG250

MESSAGE MSG249 Justification ANY PRIO 0
  "The interval between successive doses of the same vaccine must be in accordance with the summary of product characteristics; it may be extended, but must not be shortened: the minimum interval between two doses must not be less than 4 weeks."@en
 END MESSAGE MSG249

MESSAGE MSG251 Justification ANY PRIO 0
  "Vaccination recommended for persons who have not had chickenpox and have not previously been vaccinated as part of either compulsory or recommended vaccination, in particular pupils and students of medical schools and colleges or other schools and colleges providing medical training."@en
 END MESSAGE MSG251

MESSAGE MSG252 Summary ANY PRIO 0
  "Vaccination against chickenpox is particularly recommended."@en
 END MESSAGE MSG252

MESSAGE MSG253 Justification ANY PRIO 0
  "Vaccination recommended for persons who have not had chickenpox and have not been previously vaccinated as part of compulsory or recommended vaccination, especially health care workers."@en
 END MESSAGE MSG253

MESSAGE MSG333 Justification ANY PRIO 0
  "Compulsory vaccination against chickenpox is mandatory for adolescents up to the age of 19 years who have not had chickenpox and who are residing, or are qualified to reside, in childcare facilities."@en
 END MESSAGE MSG333

MESSAGE MSG248 Justification ANY PRIO 0
  "Chickenpox is very dangerous for patients with impaired immunity (due to congenital immunodeficiencies, during cancer treatment or receiving steroid hormones).<br>
There is no danger of transmission of the vaccine virus to people with immunodeficiencies."@en
 END MESSAGE MSG248

MESSAGE MSG336 Justification ANY PRIO 0
  "Compulsory vaccination against chickenpox is mandatory for adolescents up to the age of 19 years, who have not had chickenpox, staying, or qualified to stay, in children's clubs."@en
 END MESSAGE MSG336

MESSAGE MSG337 Other PRO PRIO 0
  "Vaccine available: Varilrix ou Varivax."@en
 END MESSAGE MSG337

MESSAGE MSG327 Justification ANY PRIO 0
  "Chickenpox vaccine can be administered post-exposure. A dose of the vaccine should be given up to the 5th day after contact with an infectious person. Efficacy of 90% is highest when the vaccine is administered within 72 h of contact."@en
 END MESSAGE MSG327

MESSAGE MSG247 Justification ANY PRIO 0
  "Risk of congenital chickenpox when a pregnant woman is infected.<br>
Chickenpox is very dangerous for pregnant women, newborns of mothers who contracted chickenpox (the onset of the pox, or rash) within 5 days before or up to 48 h after birth."@en
 END MESSAGE MSG247

MESSAGE MSG334 Justification ANY PRIO 0
  "Compulsory vaccination against chickenpox is administered to adolescents up to the age of 19 years who have not had chickenpox, residing, or qualified for residence, in regional therapeutic care centers."@en
 END MESSAGE MSG334

MESSAGE MSG331 Justification ANY PRIO 0
  "Compulsory vaccination against chickenpox is mandatory for adolescents up to the age of 19 years, who have not had chickenpox, residing, or qualified to reside, in family foster homes."@en
 END MESSAGE MSG331

MESSAGE MSG335 Justification ANY PRIO 0
  "Compulsory vaccination against chickenpox is mandatory for adolescents up to the age of 19 years who have not had chickenpox, reside in, or are qualified to stay in, intervention pre-adoption centres."@en
 END MESSAGE MSG335

MESSAGE MSG328 Justification ANY PRIO 0
  "Compulsory vaccination against chickenpox shall be administered to adolescents up to the age of 19 years who have not had chickenpox, from persons:<br>
a) with congenital or acquired immunodeficiency with a high risk of severe disease;<br>
b) prior to planned immunosuppressive treatment or chemotherapy."@en
 END MESSAGE MSG328

MESSAGE MSG332 Justification ANY PRIO 0
  "Compulsory vaccination against chickenpox is administered to adolescents up to the age of 19 years who have not had chickenpox, residing, or qualified to reside, in homes for mothers with small children and pregnant women."@en
 END MESSAGE MSG332

MESSAGE MSG255 Justification ANY PRIO 0
  "Compulsory vaccination against chickenpox is mandatory for adolescents up to the age of 19 years who have not had chickenpox and who are residing, or are qualified to reside, in nursing care homes."@en
 END MESSAGE MSG255

MESSAGE MSG546 Justification ANY PRIO 0
  "Mandatory chickenpox vaccination is administered to adolescents under 19 years of age who have not had chickenpox, with congenital or acquired immunodeficiency with a high risk of severe disease."@en
 END MESSAGE MSG546

MESSAGE MSG144 Summary ANY PRIO 0
  "Specialist advice is recommended."@en
 END MESSAGE MSG144
