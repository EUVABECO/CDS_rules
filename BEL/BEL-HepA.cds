CALC HepA_doses_received IS HIST(HepA,0,count)
CALC HepA_last_dose_date IS HIST(HepA,-1,date)
CALC HepA_time_since_first_dose IS INTERVAL(HIST(HepA,1,date),BASE:eval)

SYNTH HVA-RF-ALL "HVA-RF-ALL - Medical and Pro risk factors" IS ANY OF
  SYNTH:HVA-RF-MED = true
  SYNTH:HVA-RF-PRO = true
	
SYNTH HVA-RF-MED "HVA-RF-MED - Medical risk factors for hepatitis" IS ANY OF
  COND:C1231 "Immunocompromised person" = true
  COND:C392 "Close contacts of a person with hepatitis A" = true
  COND:C956 "Cirrhosis" = true
  COND:C41 "Chronic liver disease" = true
  COND:C685 "Exposure to sexually transmitted infections (STIs)" = true
  COND:C118 "Child or adolescent in a service or institution for disabled children and youth" = true
  COND:C120 "Stay in a psychiatric institution" = true
  COND:C534 "Resides in a residential facility for disabled adults" = true
  COND:C124 "In detention in a penal institution" = true
  COND:C115 "Family member from a country with high endemicity for hepatitis A and possible stay in that country" = true

SYNTH HVA-RF-PRO "HVA-RF-PRO - Profesional risk factors for hepatitis A" IS ANY OF
  COND:C860 "Profession in the food industry" = true
  COND:C96 "Works in a laundry" = true
  COND:C88 "Works in a pre-school childcare facility (daycare, nursery school, etc.)" = true
  COND:C99 "Wastewater treatment staff (including wastewater treatment plants)" = true
  COND:C101 "Garbage collector" = true
  COND:C100 "Drainer" = true

TARGET HepA
FOLDER - "General rules"

  RULE 01 "rejouer"
    IF CALC:Age>=1d
    DO Neutral
    MESSAGES  MSG346
  END RULE 01
END FOLDER -

FOLDER 1 "Vaccination recommended"
  IF SYNTH:HVA-RF-ALL "HVA-RF-ALL - Medical and Pro risk factors" = true

  RULE 1/01 "0 dose : To do from 12m old"
    IF CALC:HepA_doses_received = 0
    DO Recommended
      Status DUE
      Age 12m
  END RULE 1/01

  RULE 1/02 "One dose: To do 6m after LD"
    IF CALC:HepA_doses_received = 1
    DO Recommended
      Status DUE
      Delay 6m..12m from CALC:HepA_last_dose_date
  END RULE 1/02
END FOLDER 1

FOLDER 2 "Required or Not required"

  RULE 2/01 "≥ 2 doses: Up to date"
    IF CALC:HepA_doses_received>=2
    DO Recommended
      Status COMPLETED
  END RULE 2/01
END FOLDER 2

FOLDER 9 "Further informations"

  RULE 9/01 "if to do, ≤ 15y: message = DUE with pediatric vaccine"
    WHEN Recommended
    IF CALC:Age<=15y
    DO Neutral
    MESSAGES  MSG164
  END RULE 9/01

  RULE 9/02 "if to do, ≥ 16y: message = DUE with adult vaccine "
    WHEN Recommended
    IF CALC:Age>=16y
    DO Neutral
    MESSAGES  MSG165
  END RULE 9/02

  RULE 9/03 "If to do: Message information"
    WHEN Recommended
    IF CALC:Age>=6m
    DO Neutral
    MESSAGES  MSG168
  END RULE 9/03

  RULE 9/04 "If to do, Pro: Message"
    WHEN Recommended
    IF SYNTH:HVA-RF-PRO "HVA-RF-PRO - Profesional risk factors for hepatitis A" = true
    DO Neutral
    MESSAGES  MSG166
  END RULE 9/04

  RULE 9/05 "If to do, Medical RF: Message"
    WHEN Recommended
    IF SYNTH:HVA-RF-MED "HVA-RF-MED - Medical risk factors for hepatitis" = true
    DO Neutral
    MESSAGES  MSG167
  END RULE 9/05

  RULE 9/06 "If to do, 1 dose, d1 ≥ 12m: Message"
    WHEN Recommended
    IF ALL OF
      CALC:HepA_time_since_first_dose>=12m
      CALC:HepA_doses_received = 1
    DO Neutral
    MESSAGES  MSG169
  END RULE 9/06
END FOLDER 9
END TARGET

MESSAGE MSG167 Justification ANY PRIO 0
  "Vaccination against hepatitis A is recommended for people with the following risk factors:<br>
- People with risky sexual practices including unprotected oral-anal or anal practices;<br>
- People with immunodeficiencies;<br>
- People with chronic liver diseases;<br>
- Residents of institutions;<br>
- People in direct contact with a patient with hepatitis A;<br>
- Children and adolescents of immigrants returning to their country of origin if it is located in an endemic area;<br>
- People in close contact with a recently adopted child who comes from a country where hepatitis A is widespread."@en
 END MESSAGE MSG167

MESSAGE MSG164 Other PRO PRIO 0
  "To be done with a pediatric vaccine (Havrix Junior, Vaqta 25)."@en
 END MESSAGE MSG164

MESSAGE MSG165 Other PRO PRIO 0
  "To be done with an adult vaccine (Avaxim 160, Havrix, Vaqta 50)."@en
 END MESSAGE MSG165

MESSAGE MSG168 Justification ANY PRIO 10
  "Vaccination against hepatitis A is recommended for travellers to regions where the disease is widespread, for certain population groups and for certain categories of professionals at risk."@en
 END MESSAGE MSG168

MESSAGE MSG166 Justification ANY PRIO 0
  "Vaccination against hepatitis A is recommended for the following professions:
- People working in the food chain;<br>
- Staff working in children's groups or with less independent people (nurseries, nursery schools, daycare centers, rest homes, institutions, etc.);<br>
- Clinical biology laboratory staff performing stool tests;<br>
- Workers in contact with wastewater (sewage networks, treatment plant staff, sewers and garbage collectors, septic tank emptiers, sanitation maintenance technicians, rodent exterminators, etc.);<br>
- Laundry staff."@en
 END MESSAGE MSG166

MESSAGE MSG169 Comments ANY PRIO 20
  "Even if the first dose was injected several years ago, the interrupted vaccination schedule can be resumed without having to start from scratch."@en
 END MESSAGE MSG169

MESSAGE MSG346 Details PATIENT PRIO 0
  "--"@en
 END MESSAGE MSG346
