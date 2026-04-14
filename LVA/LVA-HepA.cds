CALC HepA_doses_received IS HIST(HepA,0,count)
CALC HepA_last_dose_date IS HIST(HepA,-1,date)
CALC HepA_time_since_first_dose IS INTERVAL(HIST(HepA,1,date),BASE:eval)


SYNTH HVA-RF-ALL "HVA-RF-ALL - Medical and Pro risk factors" IS ANY OF
  SYNTH:HVA-RF-MED "HVA-RF-MED - Medical risk factors for hepatitis" = true
  SYNTH:HVA-RF-PRO "HVA-RF-PRO - Profesional risk factors for hepatitis A" = true

SYNTH HVA-RF-PRO "HVA-RF-PRO - Profesional risk factors for hepatitis A" IS ANY OF
  COND:C860 "Profession in the food industry" = true
  COND:C96 "Works in a laundry" = true
  COND:C88 "Works in a pre-school childcare facility (daycare, nursery school, etc.)" = true
  COND:C99 "Wastewater treatment staff (including wastewater treatment plants)" = true
  COND:C101 "Garbage collector" = true
  COND:C100 "Drainer" = true

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

TARGET HepA

FOLDER 1 "Vaccination recommended"
  IF SYNTH:HVA-RF-ALL "HVA-RF-ALL - Medical and Pro risk factors" = true

  RULE 1/01 "0 dose : To do from 12m old"
    IF ALL OF
      CALC:HepA_doses_received= 0
      SYNTH:HVA-RF-ALL "HVA-RF-ALL - Medical and Pro risk factors" = true
    DO Recommended
      Status DUE
      Age 12m
  END RULE 1/01

  RULE 1/02 "One dose: To do 6m after LD"
    IF CALC:HepA_doses_received= 1
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
    MESSAGES  MSG343
  END RULE 9/01

  RULE 9/02 "if to do, ≥ 16y: message = DUE with adult vaccine "
    WHEN Recommended
    IF CALC:Age>=16y
    DO Neutral
    MESSAGES  MSG344
  END RULE 9/02

  RULE 9/03 "If to do: Message information"
    WHEN Recommended
    IF CALC:Age>=6m
    DO Neutral
    MESSAGES  MSG345
  END RULE 9/03

  RULE 9/04 "If to do, Pro: Message"
    WHEN Recommended
    IF SYNTH:HVA-RF-PRO "HVA-RF-PRO - Profesional risk factors for hepatitis A" = true
    DO Neutral
    MESSAGES  MSG346
  END RULE 9/04

  RULE 9/05 "If to do, Medical RF: Message"
    WHEN Recommended
    IF SYNTH:HVA-RF-MED "HVA-RF-MED - Medical risk factors for hepatitis" = true
    DO Neutral
    MESSAGES  MSG342
  END RULE 9/05

  RULE 9/06 "If to do, 1 dose, d1 ≥ 12m: Message"
    WHEN Recommended
    IF ALL OF
      CALC:HepA_time_since_first_dose>=12m
      CALC:HepA_doses_received= 1
    DO Neutral
    MESSAGES  MSG347
  END RULE 9/06
END FOLDER 9
END TARGET

MESSAGE MSG347 Comments ANY PRIO 20
  "Even if the first dose was given several years ago, the interrupted vaccination schedule can be resumed without having to start all over again."@en
 END MESSAGE MSG347

MESSAGE MSG345 Justification ANY PRIO 10
  "Vaccination against hepatitis A is recommended for travellers to regions where the disease is widespread, for certain population groups and for certain categories of professionals at risk."@en
 END MESSAGE MSG345

MESSAGE MSG342 Justification ANY PRIO 0
  "La vaccination contre l’hépatite A est recommandée pour les personnes présentant les facteurs de risque suivants :<br>
- Les personnes ayant des pratiques sexuelles à risque incluant des pratiques oro-anales ou anales non protégées ;<br>
- Les personnes immunodéprimées ;<br>
- Les personnes atteintes de pathologies chroniques du foie ;<br>
- Les résidents d’institutions ;<br>
- Les personnes en contact direct avec un malade atteint d’hépatite A ;<br>
- Les enfants et adolescents d’immigrants qui retournent dans leur pays d’origine si celui-ci est situé dans une zone endémique ;<br>
- Les personnes en contact étroit avec un enfant récemment adopté qui provient d’un pays où l’hépatite A est très répandue."@en
 END MESSAGE MSG342

MESSAGE MSG346 Justification ANY PRIO 0
  "Vaccination against hepatitis A is recommended for the following professions:
- People working in the food chain;<br>
- Staff working in children's groups or with less independent people (nurseries, nursery schools, daycare centers, rest homes, institutions, etc.);<br>
- Clinical biology laboratory staff performing stool tests;<br>
- Workers in contact with wastewater (sewage networks, treatment plant staff, sewers and garbage collectors, septic tank emptiers, sanitation maintenance technicians, rodent exterminators, etc.);<br>
- Laundry staff."@en
 END MESSAGE MSG346

MESSAGE MSG344 Other PRO PRIO 0
  "To be administered with an adult vaccine (Avaxim 160, Havrix, Vaqta 50)."@en
 END MESSAGE MSG344

MESSAGE MSG343 Other PRO PRIO 0
  "To be administered with a paediatric vaccine (Havrix Junior, Vaqta 25)."@en
 END MESSAGE MSG343
