SYNTH MEN-A-RECEIVED "MEN-A- At least one dose of A vaccine" IS ANY OF
  CALC:MenA_received_valences contains MCV-A
  CALC:MenA_received_valences contains MPV-A

CALC MenA_doses_received IS HIST(MenA,0,count)
CALC MenA_received_valences IS HIST(MenA,0,valences)

TARGET MenA
FOLDER 1 "Common ACWY"

  FOLDER 11 "≤ 23m old"
    IF CALC:Age<=23m

    RULE 11/01 "≤ 23m old, 0 dose: To do ASAP"
      IF CALC:MenA_doses_received = 0
      DO Recommended
        Status DUE
        Age 15m
    END RULE 11/01
  END FOLDER 11

  FOLDER 12 "≥ 14y old"
    IF CALC:Age>=14y

    RULE 12/01 "≥ 14y old, 0 dose: To do ASAP 15-16y old"
      IF CALC:MenA_doses_received = 0
      DO Recommended
        Status DUE
        Age 15y..16y
    END RULE 12/01
  END FOLDER 12

  FOLDER 13 "Common"

    RULE 13/01 "≥ 1 dose ACWY: Up to date"
      IF ALL OF
        CALC:MenA_doses_received>=1
        SYNTH:MEN-ACWY-CONJ "MEN-ACWY- At least one dose of ACWY conjugate vaccine" = true
      DO Recommended
        Status COMPLETED
    END RULE 13/01

    RULE 13/02 "0 dose, Mecca: To do ASAP"
      IF ALL OF
        CALC:MenA_doses_received = 0
        COND:C1065 "Pilgrimage to Mecca (Hajj or Umrah)" = true
      DO Recommended
        Status DUE
        Age 2m
      MESSAGES  MSG175 MSG176
    END RULE 13/02
  END FOLDER 13

  FOLDER 9 "Further informations"

    RULE 9/01 "If to do: Information message"
      WHEN Recommended
      IF CALC:MenA_doses_received = 0
      DO Neutral
      MESSAGES  MSG170
    END RULE 9/01

    RULE 9/02 "If to do, ≤ 23m: Vaccines that can be used: Nimenri."
      WHEN Recommended
      IF CALC:Age<=23m
      DO Neutral
      MESSAGES  MSG173
    END RULE 9/02

    RULE 9/03 "If to do, ≥ 24m: Vaccines that can be used: Menveo, Nimenrix."
      WHEN Recommended
      IF CALC:Age>=24m
      DO Neutral
      MESSAGES  MSG174
    END RULE 9/03

    RULE 9/04 "If pregnant: Message alert"
      IF SYNTH:PREGNANCY_ONGOING "COMMON-PREGNANCY - Pregnancy in progress" = true
      DO Neutral
      MESSAGES  MSG188 MSG190
    END RULE 9/04
  END FOLDER 9
END FOLDER 1

FOLDER 2 "Specific rules"

  RULE 2/01 "≥ 1 dose A, not ACWY: To do 1 dose 1m after LD with ACWY"
    IF ALL OF
      SYNTH:MEN-ACWY-CONJ "MEN-ACWY- At least one dose of ACWY conjugate vaccine" = false
      SYNTH:MEN-A-RECEIVED "MEN-A- At least one dose of A vaccine" = true
    DO Suggested
    MESSAGES  MSG172 MSG171
  END RULE 2/01
END FOLDER 2

FOLDER 8 "Contraindications and special cases"

  RULE 8/01 "Case  « Refusal to vaccinate against this disease » checked: Special case + message"
    IF COND:C618 "Refusal of Meningococcal ACWY Vaccination" = true
    DO Exception
    MESSAGES  MSG6 MSG7
  END RULE 8/01
END FOLDER 8
END TARGET

MESSAGE MSG173 Other ANY PRIO 0
  "Vaccine that can be used: Nimenrix."@en
 END MESSAGE MSG173

MESSAGE MSG175 Justification ANY PRIO 0
  "In Saudi Arabia, outbreaks of meningococcus W135 have affected hundreds of pilgrims to Mecca in the past. A legal requirement for pilgrims to be vaccinated has been imposed. Vaccination must be done at least 10 days before arrival in the country."@en
 END MESSAGE MSG175

MESSAGE MSG176 Summary ANY PRIO 0
  "Vaccination must be completed at least 10 days before arrival in Saudi Arabia."@en
 END MESSAGE MSG176

MESSAGE MSG174 Other ANY PRIO 0
  "Vaccines that can be used: Menveo, Nimenrix."@en
 END MESSAGE MSG174

MESSAGE MSG172 Summary ANY PRIO 0
  "A vaccine against ACWY strains is indicated if travel to risk areas is planned."@en
 END MESSAGE MSG172

MESSAGE MSG171 Justification ANY PRIO 0
  "Just because a child has received the meningococcal C vaccine does not mean that the A, C, W135 and Y conjugate vaccine is not indicated if the child is traveling to risk areas. This second vaccine can be administered 1 month after the meningococcal C vaccine injection."@en
 END MESSAGE MSG171

MESSAGE MSG6 Alert ANY PRIO 0
  "Refusal of vaccination."@en
 END MESSAGE MSG6

MESSAGE MSG7 Justification ANY PRIO 0
  "The box indicating a refusal of vaccination against this disease has been checked in the health profile (section “Refusal of vaccination”)."@en
 END MESSAGE MSG7

MESSAGE MSG170 Comments ANY PRIO 10
  "Since September 2023, the Vaccination Program has offered vaccination against meningococcus A, C, W135 and Y."@en
 END MESSAGE MSG170

MESSAGE MSG188 Alert PATIENT PRIO 0
  "During pregnancy, vaccination only if the risk of exposure is clearly defined."@en
 END MESSAGE MSG188

MESSAGE MSG190 Justification ANY PRIO 0
  "There are no clinical data on the use of meningococcal vaccines in pregnant women. However, given the seriousness of meningococcal disease, pregnancy should not preclude vaccination when the risk of exposure is clearly defined."@en
 END MESSAGE MSG190

MESSAGE MSG346 Details PATIENT PRIO 0
  "--"@en
 END MESSAGE MSG346
