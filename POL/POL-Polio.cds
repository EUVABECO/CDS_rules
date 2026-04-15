CALC Polio_doses_received IS HIST(POLIO,0,count)
CALC Polio_last_dose_date IS HIST(POLIO,-1,date)
CALC Polio_last_dose_booster IS HIST(POLIO,-1,booster)

TARGET Polio
FOLDER 1 "18y old or more"
  IF CALC:Age>=18y

  FOLDER 10 "Zero dose"
    IF CALC:Polio_doses_received = 0

    RULE 10/1 "0 dose, 18y old: To do ASAP"
      IF CALC:Age<=18y
      DO Recommended
        Status DUE
        Age 18y
    END RULE 10/1

    RULE 10/2 "0 dose, ≥19y old, RF-: recommended"
      IF ALL OF
        CALC:Age>=19y
        SYNTH:74298da0-be79-4046-8e0b-b05b86c312da "POLIO-RF - Risk factor for polio" = false
      DO Recommended
        Status DUE
        Age 18y
      MESSAGES  MSG164
    END RULE 10/2

    RULE 10/3 "0 dose, ≥19y old, RF+: To do ASAP"
      IF ALL OF
        CALC:Age>=19y
        SYNTH:74298da0-be79-4046-8e0b-b05b86c312da "POLIO-RF - Risk factor for polio" = true
      DO Recommended
        Status DUE
        Age 19y
    END RULE 10/3
  END FOLDER 10

  FOLDER 11 "≤ 2 doses and LD is not a booster"
    IF ALL OF
    CALC:Polio_doses_received<=2
    CALC:Polio_last_dose_booster = false

    RULE 11/01 "One dose: to do 1-2m after LD"
      IF CALC:Polio_doses_received = 1
      DO Recommended
        Status DUE
        Delay 1m..2m from CALC:Polio_last_dose_date
    END RULE 11/01

    RULE 11/02 "Two doses: to do 6-12m after LD"
      IF CALC:Polio_doses_received = 2
      DO Recommended
        Status DUE
        Delay 6m..12m from CALC:Polio_last_dose_date
    END RULE 11/02
  END FOLDER 11

  FOLDER 12 "Three doses or more or LD is a booster"
    IF ANY OF
    CALC:Polio_doses_received>=3
    CALC:Polio_last_dose_booster = true

    RULE 12/01 "≥ 3 doses or LD is booster: Up to date"
      IF CALC:Age>=18y
      DO Recommended
        Status COMPLETED
      MESSAGES  MSG297 MSG298
    END RULE 12/01
  END FOLDER 12
END FOLDER 1

FOLDER 9 "Further information"

  RULE 9/01 "If to do, Mandatory vaccination: Information"
    WHEN Recommended
    IF SYNTH:DIPH-MANDATORY "DIPH-MANDATORY - Mandatory vaccination for of diphteria" = true
    DO Neutral
    MESSAGES  MSG48 MSG168 MSG139
  END RULE 9/01

  RULE 9/05 "If to do, Allergy from a previous vaccination: Information"
    WHEN Recommended
    IF COND:C1161 "Allergy from a previous vaccine administration" = true
    DO Neutral
    MESSAGES  MSG51 MSG165 MSG166 MSG122
  END RULE 9/05

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

#  RULE 91/10 "Persons planning to stay in a region of risk of Poliomyelitis infection: Information"
#    IF SYST:patient_destinations = 59788a87-c48b-4a98-99ea-5dda3b8b2231
#    DO Neutral
#    MESSAGES  MSG533
#  END RULE 91/10

END FOLDER 9
END TARGET

MESSAGE MSG167 Justification ANY PRIO 0
  "People with asplenia, splenic dysfunction or splenic removal are subject to mandatory vaccination against diphtheria, tetanus, pertusis and polio."@en
 END MESSAGE MSG167

MESSAGE MSG153 Justification ANY PRIO 0
  "Individuals who have undergone hematopoietic stem cell or internal organ transplantation are required to be vaccinated against diphtheria, tetanus, pertussis, and polio. Post-transplant patients should consult their physician to determine an appropriate vaccination schedule, taking into account their medical condition and immunosuppressive therapy."@en
 END MESSAGE MSG153

MESSAGE MSG51 Alert ANY PRIO 0
  "Warning: allergy - see comments before any vaccine administration."@en
 END MESSAGE MSG51

MESSAGE MSG165 Comments PATIENT PRIO 0
  "An allergy to a previous vaccine administration has been reported. You must clearly inform the healthcare professional before any new vaccination, regardless of the vaccine administered."@en
 END MESSAGE MSG165

MESSAGE MSG166 Comments PRO PRIO 0
  "An allergy to a previous vaccine administration has been reported. Before any new vaccination, carefully check the origin of the previous allergy and adapt the course of action. Seek specialist advice if in doubt."@en
 END MESSAGE MSG166

MESSAGE MSG122 Comments ANY PRIO 10
  "NOTE! Hypersensitivity to the active substances or to any of the excipients listed and to any ingredient that may be present in trace amounts."@en
 END MESSAGE MSG122

MESSAGE MSG297 Summary ANY PRIO 0
  "There is no mandatory booster vaccination strictly for polio.  "@en
 END MESSAGE MSG297

MESSAGE MSG298 Comments ANY PRIO 0
  "Adults can receive the polio vaccine as part of the diphtheria and tetanus booster, along with a combination vaccine."@en
 END MESSAGE MSG298

MESSAGE MSG48 Other ANY PRIO 10
  "Refund: 100%."@en
 END MESSAGE MSG48

MESSAGE MSG168 Details ANY PRIO 0
  "Vaccination is mandatory for: <br> - children and adolescents up to and including the age of 18; <br> - people with asplenia or with a dysfunction or removal of the spleen; <br> - people before or after a solid organ or hematopoietic stem cell transplant; <br>Persons planning to stay in a region of risk of Poliomyelitis infection."@en
 END MESSAGE MSG168

MESSAGE MSG139 Alert ANY PRIO 10
  "Vaccination required up to and including the age of 18 or in the presence of certain risk factors."@en
 END MESSAGE MSG139

MESSAGE MSG533 Justification ANY PRIO 0
  "Poliomyelitis vaccination is recommended for people planning to stay in regions where there is a risk of infection with this virus. Poliomyelitis is a serious viral disease that can lead to permanent damage to the nervous system."@en
 END MESSAGE MSG533

MESSAGE MSG164 Justification ANY PRIO 0
  "Vaccination is recommended for all adults."@en
 END MESSAGE MSG164
