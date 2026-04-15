CALC Per_doses_received IS HIST(Per,0,count)
CALC Per_last_dose_is_booster IS HIST(Per,-1,booster)
CALC Per_last_dose_date IS HIST(Per,-1,date)	
CALC Per_age_at_last_dose IS INTERVAL(BASE:dob,CALC:Per_last_dose_date)

SYNTH PERT-MANDATORY "PERT-MANDATORY - Mandatory vaccination for of pertusis" IS ANY OF
  COND:C36 "Spleen removal or non-functioning" = true
  SYNTH:COMMON-SOT-HSCT "COMMON - Solid organ or stem cell transplantation" = true
  COND:C19 "Waiting for an organ transplant (kidney, heart, liver or lung)" = true
  COND:C415 "Waiting for a hematopoietic stem cell transplant (marrow transplant)" = true

SYNTH PERT-RF "PERT-RF - Risk factor for pertusis" IS ANY OF
  COND:C36 "Spleen removal or non-functioning" = true
  SYNTH:COMMON-SOT-HSCT "COMMON - Solid organ or stem cell transplantation" = true
  COND:C415 "Waiting for a hematopoietic stem cell transplant (marrow transplant)" = true
  COND:C19 "Waiting for an organ transplant (kidney, heart, liver or lung)" = true
  COND:C378 "Active health professional" = true
  COND:C1121 "Close professional contact with an infant under 6 months of age" = true
  COND:C1180 "Close and prolonged contact with an infant under 12 months of age" = true

SYNTH PERT-REFUND "PERT-REFUND - Refund: 100%" IS ANY OF
  SYNTH:PREGNANCY_ONGOING "MATERNITY-PREGNANCY - Pregnancy in progress" = true
  SYNTH:PERT-MANDATORY "PERT-MANDATORY - Mandatory vaccination for of pertusis" = true

TARGET Pertussis

FOLDER 1 "18y old or more - Pregnancy -"
  IF ALL OF
  CALC:Age>=18y
  SYNTH:PREGNANCY_ONGOING "MATERNITY-PREGNANCY - Pregnancy in progress" = false

  FOLDER 10 "Zero dose"
    IF CALC:Per_doses_received = 0

    RULE 10/1 "0 dose, 18y old: To do ASAP"
      IF CALC:Age<=18y
      DO Recommended
        Status DUE
        Age 18y
    END RULE 10/1

    RULE 10/2 "0 dose, ≥19y old, RF-: recommended"
      IF ALL OF
        CALC:Age>=19y
        SYNTH:PERT-RF "PERT-RF - Risk factor for pertusis" = false
      DO Recommended
        Status DUE
        Age 18y
      MESSAGES  MSG164
    END RULE 10/2

    RULE 10/3 "0 dose, ≥19y old, RF+: To do ASAP"
      IF ALL OF
        CALC:Age>=19y
        SYNTH:PERT-RF "PERT-RF - Risk factor for pertusis" = true
      DO Recommended
        Status DUE
        Age 19y
    END RULE 10/3
  END FOLDER 10

  FOLDER 11 "≤ 2 doses and LD is not a booster"
    IF ALL OF
    CALC:Per_doses_received<=2
    CALC:Per_last_dose_is_booster = false

    RULE 11/01 "One dose: to do 2m after LD"
      IF CALC:Per_doses_received = 1
      DO Recommended
        Status DUE
    END RULE 11/01

    RULE 11/02 "Two doses: to do 6m after LD"
      IF CALC:Per_doses_received = 2
      DO Recommended
        Status DUE
        Delay 6m from CALC:Per_last_dose_date
    END RULE 11/02
  END FOLDER 11

  FOLDER 12 "Three doses or more or LD is a booster (Copie)"
    IF ANY OF
    CALC:Per_doses_received>=3
    CALC:Per_last_dose_is_booster = true

    RULE 12/01 "≥ 3 doses or LD is booster, LD ≤ 17y old: to do from 18y, 4y after LD"
      IF ALL OF
        CALC:Age>=18y
        CALC:Per_age_at_last_dose<=17y
      DO Recommended
        Status DUE
        Age 18y
        Delay 4y from CALC:Per_last_dose_date
      MESSAGES  MSG299
    END RULE 12/01

    RULE 12/02 "≥ 3 doses or LD is booster, LD ≥ 18y old: to do in 10 years"
      IF ALL OF
        CALC:Age>=18y
        CALC:Per_age_at_last_dose>=18y
      DO Recommended
        Status DUE
        Delay 10y from CALC:Per_last_dose_date
      MESSAGES  MSG156
    END RULE 12/02
  END FOLDER 12
END FOLDER 1

FOLDER 2 "Pregnancy +"
  IF SYNTH:PREGNANCY_ONGOING "MATERNITY-PREGNANCY - Pregnancy in progress" = true

  RULE 2/01 "0 dose, Pregnancy in progress: To do between 27 and 36w"
    IF CALC:Age>=18y
    DO Recommended
      Status DUE
      Age 18y
      Delay 27w..36w from COND:C1081 "Pregnancy start date"
  END RULE 2/01
END FOLDER 2

FOLDER 9 "Further information (Copie)"

  RULE 9/01 "If to do, Mandatory vaccination: Information"
    WHEN Recommended
    IF SYNTH:PERT-MANDATORY "PERT-MANDATORY - Mandatory vaccination for of pertusis" = true
    DO Neutral
    MESSAGES  MSG296 MSG295
  END RULE 9/01

  RULE 9/02 "If to do, Refund 100%: Information"
    WHEN Recommended
    IF SYNTH:PERT-REFUND "PERT-REFUND - Refund: 100%" = true
    DO Neutral
    MESSAGES  MSG48
  END RULE 9/02

  RULE 9/03 "If to do: Document"
    WHEN Recommended
    IF CALC:Age>=18y
    DO Neutral
  END RULE 9/03

  RULE 9/04 "If to do, Pregnancy: Information"
    WHEN Recommended
    IF SYNTH:PREGNANCY_ONGOING "MATERNITY-PREGNANCY - Pregnancy in progress" = true
    DO Neutral
    MESSAGES  MSG154
  END RULE 9/04

  RULE 9/05 "If to do, Allergy from a previous vaccination: Information"
    WHEN Recommended
    IF COND:C1161 "Allergy from a previous vaccine administration" = true
    DO Neutral
    MESSAGES  MSG51 MSG165 MSG166 MSG122
  END RULE 9/05

  RULE 9/06 "If to do, Before transplantation of internal organs, haematopoietic cells: Information"
    WHEN Recommended
    IF SYNTH:COMMON-WAIT-TRANSPLANT "COMMON - Waiting for a transplant" = true
    DO Neutral
    MESSAGES  MSG152
  END RULE 9/06

  RULE 9/07 "If to do, After transplantation of internal organs, haematopoietic cells: Information"
    WHEN Recommended
    IF SYNTH:COMMON-SOT-HSCT "COMMON - Solid organ or stem cell transplantation" = true
    DO Neutral
    MESSAGES  MSG153
  END RULE 9/07

  RULE 9/08 "If to do, Spleen removal or non-functioning : Information"
    WHEN Recommended
    IF COND:C36 "Spleen removal or non-functioning" = true
    DO Neutral
    MESSAGES  MSG167
  END RULE 9/08

  RULE 9/09 "If to do, Medical staff: Information"
    WHEN Recommended
    IF SYNTH:COMMON-MED-STAFF "COMMON-MED-STAFF - Medical staff" = true
    DO Neutral
    MESSAGES  MSG157
  END RULE 9/09

  RULE 9/10 "If to do, Medical personnel in contact with newborns and infants: Information"
    WHEN Recommended
    IF COND:C1121 "Close professional contact with an infant under 6 months of age" = true
    DO Neutral
    MESSAGES  MSG159
  END RULE 9/10

  RULE 9/12 "If to do, Close and prolonged contact with an infant under 12 months of age: Information"
    WHEN Recommended
    IF COND:C1180 "Close and prolonged contact with an infant under 12 months of age" = true
    DO Neutral
    MESSAGES  MSG158
  END RULE 9/12
END FOLDER 9
END TARGET

MESSAGE MSG152 Justification ANY PRIO 0
  "Les personnes devant bénéficier une transplantation d'organes internes ou de cellules souches hématopoïétiques sont soumises à la vaccination obligatoire contre la diphtérie, le tétanos et la coqueluche."@en
 END MESSAGE MSG152

MESSAGE MSG153 Justification ANY PRIO 0
  "Les personnes ayant subi une transplantation de cellules souches hématopoïétiques ou d'organes internes sont soumises à la vaccination obligatoire contre la diphtérie, le tétanos et la polio. Les patients post-transplantés doivent consulter leur médecin pour déterminer un calendrier de vaccination approprié, en tenant compte de leur état de santé et de leur traitement immunosuppresseur."@en
 END MESSAGE MSG153

MESSAGE MSG296 Details ANY PRIO 0
  "La vaccination contre la coqueluche est obligatoire pour : <br>- les personnes aspléniques ou ayant un dysfonctionnement ou une ablation de la rate ; <br> - les personnes avant ou après une transplantation d'organe solide ou de cellules souches hématopoïétiques."@en
 END MESSAGE MSG296

MESSAGE MSG295 Alert ANY PRIO 0
  "Vaccination obligatoire contre la coqueluche en présence de certains facteurs de risque."@en
 END MESSAGE MSG295

MESSAGE MSG51 Alert ANY PRIO 0
  "Attention : allergie - voir commentaires avant toute administration de vaccin."@en
 END MESSAGE MSG51

MESSAGE MSG165 Comments PATIENT PRIO 0
  "Une allergie à une précédente administration de vaccin a été signalée. Vous devez informer clairement le professionnel de santé avant toute nouvelle vaccination, quelle que soit le vaccin administré."@en
 END MESSAGE MSG165

MESSAGE MSG166 Comments PRO PRIO 0
  "Une allergie lors d’une précédente administration de vaccin a été signalée. Avant tout nouvel acte vaccinal, bien vérifier l’origine de la précédente allergie et adapter la conduite à tenir. Demandez un avis spécialisé en cas de doute."@en
 END MESSAGE MSG166

MESSAGE MSG122 Comments ANY PRIO 10
  "REMARQUE ! Hypersensibilité aux substances actives ou à l’un des excipients mentionnés et à tout ingrédient pouvant être présent à l’état de traces."@en
 END MESSAGE MSG122

MESSAGE MSG167 Justification ANY PRIO 0
  "Les personnes atteintes d’une asplénie, d'un dysfonctionnement ou d'une ablation de la rate sont soumises à la vaccination obligatoire contre la diphtérie, le tétanos, la coqueluche et la polio."@en
 END MESSAGE MSG167

MESSAGE MSG164 Justification ANY PRIO 0
  "La vaccination est recommandée pour tous les adultes."@en
 END MESSAGE MSG164

MESSAGE MSG156 Justification ANY PRIO 0
  "Il est recommandé aux adultes primo-vaccinés de se faire vacciner avec une dose de rappel unique tous les 10 ans.
Vaccination contre la diphtérie, le tétanos, la polio et la coqueluche avec le vaccin diphtérie-tétanos-coqueluche à composante coqueluche réduite (Tdap ou Tdap-IPV)."@en
 END MESSAGE MSG156

MESSAGE MSG159 Justification ANY PRIO 0
  "Compte tenu du rationnel épidémiologique, la vaccination contre la diphtérie et le tétanos est recommandée pour le personnel de santé, notamment celui en contact avec les nouveau-nés et les nourrissons. Vaccination contre la diphtérie, le tétanos, la coqueluche avec un vaccin diphtérie-tétanos-coqueluche à composante coqueluche réduite (Tdap ou Tdap-IPV)."@en
 END MESSAGE MSG159

MESSAGE MSG158 Justification ANY PRIO 0
  "Compte tenu de la justification épidémiologique, la vaccination contre la diphtérie, le tétanos et la coqueluche est recommandée pour l'entourage des nouveau-nés et des nourrissons jusqu'à 12 mois. Vaccination contre la diphtérie, le tétanos et la coqueluche avec le vaccin diphtérie-tétanos-coqueluche à composante coqueluche réduite (Tdap ou Tdap-VPI)."@en
 END MESSAGE MSG158

MESSAGE MSG154 Justification ANY PRIO 0
  "Pour des raisons épidémiologiques, la vaccination contre cette maladie est recommandée aux femmes enceintes entre la 27e et la 36e semaine de grossesse et, dans les cas justifiés de risque d'accouchement prématuré, après la 20e semaine de grossesse, selon un schéma à une dose, en tant que vaccination recommandée pour laquelle l'achat de vaccins a été couvert par un financement du ministère de la santé.<br>
Vaccination contre la diphtérie, le tétanos et la coqueluche avec le vaccin diphtérie-tétanos-coqueluche à composant coquelucheux réduit (Tdap ou Tdap-VPI)."@en
 END MESSAGE MSG154

MESSAGE MSG157 Justification ANY PRIO 0
  "Compte tenu de la justification épidémiologique, la vaccination contre la diphtérie et le tétanos est recommandée pour le personnel médical. Vaccination contre la diphtérie, le tétanos et la coqueluche avec le vaccin diphtérie-tétanos-coqueluche à composante coqueluche réduite (Tdap ou Tdap-IPV)."@en
 END MESSAGE MSG157

MESSAGE MSG299 Justification ANY PRIO 0
  "Un rappel vaccinal contre la diphtérie et le tétanos (Td) est obligatoire à l'âge de 18 ans. Ce vaccin est entièrement remboursé. Il est recommandé d’associer la vaccination contre la coqueluche (Tdap), mais cette association n'est pas remboursée."@en
 END MESSAGE MSG299

MESSAGE MSG48 Other ANY PRIO 10
  "Remboursement : 100%."@en
 END MESSAGE MSG48
