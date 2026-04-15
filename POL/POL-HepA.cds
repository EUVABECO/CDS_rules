CALC HepA_doses_received IS HIST(HepA,0,count)
CALC HepA_last_dose_date IS HIST(HepA,-1,date)
CALC HepA_time_since_first_dose IS INTERVAL(HIST(HepA,1,date),BASE:eval)


SYNTH HVA-RF-ALL "HVA-RF-ALL - Medical and Pro risk factors" IS ANY OF
  SYNTH:HVA-RF-MED "HVA-RF-MED - Medical risk factors for hepatitis" = true
  SYNTH:HVA-RF-PRO "HVA-RF-PRO - Profesional risk factors for hepatitis A" = true

SYNTH HVA-RF-PRO "HVA-RF-PRO - Profesional risk factors for hepatitis A" IS ANY OF
  COND:C860 "Profession in the food industry" = true
  COND:C99 "Wastewater treatment staff (including wastewater treatment plants)" = true
  COND:C101 "Garbage collector" = true
  COND:C100 "Drainer" = true
  COND:C201 "Works in a neonatal unit" = true
  COND:C1235 "Work in an infectious diseases, gastroenterology or pediatrics department" = true
  COND:C274 "Works in an infectious disease department" = true

SYNTH HVA-RF-MED "HVA-RF-MED - Medical risk factors for hepatitis" IS ANY OF
  COND:C24 "HIV infection" = true
  COND:C14 "Chronic hepatitis B virus infection" = true
  COND:C125 "Chronic hepatitis C virus infection" = true
  SYNTH:HVA-MSM "HVA-MSM - Men having sex with men" = true
  COND:C114 "Parenteral drug abuse" = true
#   SYST:patient_destinations = a71387a7-98e0-4ea9-abff-6dc185467942  # Travel - commented out for the moment

SYNTH HVA-MSM "HVA-MSM - Men having sex with men" IS ALL OF
  COND:C129 "Sexual relations with men" = true
  BASE:sex = m

TARGET HepA
FOLDER 1 "Vaccination recommended"
  IF SYNTH:HVA-RF-ALL "HVA-RF-ALL - Medical and Pro risk factors" = true

  RULE 1/01 "0 dose : To do from 18y old"
    IF ALL OF
      CALC:HepA_doses_received  = 0
      SYNTH:HVA-RF-ALL "HVA-RF-ALL - Medical and Pro risk factors" = true
    DO Recommended
      Status DUE
      Age 18y
  END RULE 1/01

  RULE 1/02 "One dose: To do 6m after LD"
    IF CALC:HepA_doses_received  = 1
    DO Recommended
      Status DUE
      Delay 6m..12m from CALC:HepA_last_dose_date
  END RULE 1/02
END FOLDER 1

FOLDER 2 "Required or Not required"

  RULE 2/01 "≥ 2 doses: Up to date"
    IF CALC:HepA_doses_received >=2
    DO Recommended
      Status COMPLETED
  END RULE 2/01
END FOLDER 2

FOLDER 9 "Further informations"

  RULE 9/01 "If to do: Message = Vaccines that can be used"
    WHEN Recommended
    IF CALC:Age>=18y
    DO Neutral
    MESSAGES  MSG173
  END RULE 9/01

  RULE 9/02 "If to do: Source for medical RF"
    WHEN Recommended
    IF ALL OF
      CALC:Age>=18y
      SYNTH:HVA-RF-MED "HVA-RF-MED - Medical risk factors for hepatitis" = true
    DO Neutral
  END RULE 9/02

  RULE 9/03 "If to do: Source for pro RF"
    WHEN Recommended
    IF ALL OF
      CALC:Age>=18y
      SYNTH:HVA-RF-PRO "HVA-RF-PRO - Profesional risk factors for hepatitis A" = true
    DO Neutral
  END RULE 9/03

  RULE 9/04 "if to do, RF+: Information"
    WHEN Recommended
    IF SYNTH:HVA-RF-ALL "HVA-RF-ALL - Medical and Pro risk factors" = true
    DO Neutral
    MESSAGES  MSG185
  END RULE 9/04

  RULE 9/05 "If to do, 1 dose, d1 ≥ 12m: Message"
    WHEN Recommended
    IF ALL OF
      CALC:HepA_time_since_first_dose>=12m
      CALC:HepA_doses_received  = 1
    DO Neutral
    MESSAGES  MSG169
  END RULE 9/05

  FOLDER 91 "Excel files"

    RULE 91/04 "If to do, Allergy to any component of vaccine: Message"
      IF ALL OF
        COND:C1161 "Allergy from a previous vaccine administration" = true
        CALC:Age>=18y
      DO Neutral
      MESSAGES  MSG51 MSG165 MSG166 MSG104
    END RULE 91/04

    RULE 91/06 "If to do, HIV"
      WHEN Recommended
      IF COND:C24 "HIV infection" = true
      DO Neutral
      MESSAGES  MSG177
    END RULE 91/06

    RULE 91/07 "If to do, People infected with hepatitis B virus: Information"
      WHEN Recommended
      IF COND:C14 "Chronic hepatitis B virus infection" = true
      DO Neutral
      MESSAGES  MSG176
    END RULE 91/07

    RULE 91/08 "If to do, People infected with hepatitis C virus: Information"
      WHEN Recommended
      IF COND:C125 "Chronic hepatitis C virus infection" = true
      DO Neutral
      MESSAGES  MSG175
    END RULE 91/08

    RULE 91/09 "If to do, Men having sex with men: Information"
      WHEN Recommended
      IF SYNTH:HVA-MSM "HVA-MSM - Men having sex with men" = true
      DO Neutral
      MESSAGES  MSG178
    END RULE 91/09

#    RULE 91/10 "If to do, People travelling to countries with high and intermediate endemicity of hepatitis A: Information"
#      WHEN Recommended
#      IF SYST:patient_destinations = a71387a7-98e0-4ea9-abff-6dc185467942   Travel, commented out for the moment
#      DO Neutral
#      MESSAGES  MSG183
#    END RULE 91/10

    RULE 91/11 "If to do, Drug addicts: Information"
      WHEN Recommended
      IF COND:C114 "Parenteral drug abuse" = true
      DO Neutral
      MESSAGES  MSG179
    END RULE 91/11

    RULE 91/12 "If to do, Medical workers, especially in infectious diseases, gastroenterology and pediatric departments: Information"
      WHEN Recommended
      IF ANY OF
        COND:C201 "Works in a neonatal unit" = true
        COND:C1235 "Work in an infectious diseases, gastroenterology or pediatrics department" = true
        COND:C274 "Works in an infectious disease department" = true
        COND:C367 "Works in a pediatric ward" = true
      DO Neutral
      MESSAGES  MSG180
    END RULE 91/12

    RULE 91/13 "If to do, People employed in food production and distribution: Information"
      WHEN Recommended
      IF COND:C860 "Profession in the food industry" = true
      DO Neutral
      MESSAGES  MSG181
    END RULE 91/13

    RULE 91/14 "If to do, Persons employed in the removal of municipal waste and liquid waste: Information"
      WHEN Recommended
      IF ANY OF
        COND:C99 "Wastewater treatment staff (including wastewater treatment plants)" = true
        COND:C100 "Drainer" = true
        COND:C101 "Garbage collector" = true
      DO Neutral
      MESSAGES  MSG182
    END RULE 91/14
  END FOLDER 91
END FOLDER 9
END TARGET

MESSAGE MSG177 Justification ANY PRIO 0
  "Vaccination against hepatitis A is especially recommended for people infected with HIV. These people are at risk because their immune systems may be weakened, which increases the likelihood of complications related to hepatitis A infection."@en
 END MESSAGE MSG177

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

MESSAGE MSG183 Justification ANY PRIO 0
  "Vaccination against hepatitis A is especially recommended for people traveling to countries with high and intermediate endemicity of hepatitis A infections. In such regions, the risk of infection is much higher, mainly due to inadequate sanitary conditions and the widespread occurrence of the virus. People planning to travel should get vaccinated at least 14 days before traveling so that the body has time to produce appropriate antibodies."@en
 END MESSAGE MSG183

MESSAGE MSG175 Justification ANY PRIO 0
  "Vaccination against hepatitis A is especially recommended for people infected with the hepatitis C virus (HCV). These people are at greater risk of complications from other viral infections, so protection against hepatitis A is especially important."@en
 END MESSAGE MSG175

MESSAGE MSG185 Summary ANY PRIO 0
  "Vaccination against hepatitis A is particularly recommended."@en
 END MESSAGE MSG185

MESSAGE MSG169 Comments ANY PRIO 20
  "Even if the first dose was given several years ago, the interrupted vaccination schedule can be resumed without having to start from scratch."@en
 END MESSAGE MSG169

MESSAGE MSG176 Justification ANY PRIO 0
  "Vaccination against hepatitis A is especially recommended for people infected with hepatitis B because they may have a weakened immune system, which increases their susceptibility to complications associated with other viral infections."@en
 END MESSAGE MSG176

MESSAGE MSG181 Justification ANY PRIO 0
  "Vaccination against hepatitis A is especially recommended for people employed in food production and distribution. Workers in this industry may be exposed to the virus, which increases the risk of infection for both them and consumers. Therefore, vaccination is a key element in protecting public health and ensuring food safety."@en
 END MESSAGE MSG181

MESSAGE MSG178 Justification ANY PRIO 0
  "Vaccination against hepatitis A is especially recommended for men who have sex with men. This group is particularly at risk of infection because hepatitis A can be transmitted not only through food but also through sexual contact."@en
 END MESSAGE MSG178

MESSAGE MSG179 Justification ANY PRIO 0
  "Vaccination against hepatitis A is especially recommended for drug users. People in this group are particularly vulnerable to infection because risky practices, such as sharing needles, can increase the likelihood of contact with the virus."@en
 END MESSAGE MSG179

MESSAGE MSG180 Justification ANY PRIO 0
  "Vaccination against hepatitis A is especially recommended for medical workers, especially those working in infectious diseases, gastroenterology and pediatric departments. These people are exposed to contact with patients who may be carriers of the virus, which increases the risk of infection."@en
 END MESSAGE MSG180

MESSAGE MSG182 Justification ANY PRIO 0
  "Vaccination against hepatitis A is especially recommended for those employed in the removal of municipal waste and liquid sewage. These workers may come into contact with materials that may be contaminated with the virus."@en
 END MESSAGE MSG182

MESSAGE MSG173 Other PRO PRIO 0
  "To be done with an adult vaccine (Avaxim 160, Havrix Adult).<br>
If hepatitis B vaccination is also recommended: Twinrix Adult."@en
 END MESSAGE MSG173
