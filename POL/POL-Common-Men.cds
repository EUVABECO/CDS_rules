SYNTH MEN-RF "MEN-RF - All risk factors for meningococus" IS ANY OF
  SYNTH:COMMON-KIDNEY "COMMON-KIDNEY - Chronic kidney disease" = true
  SYNTH:COMMON-LIVER "COMMON-LIVER - Chronic liver diseases" = true
  COND:C404 "Cancer or hematological malignancy" = true
  COND:C36 "Spleen removal or non-functioning" = true
  COND:C24 "HIV infection" = true
  COND:C415 "Waiting for a hematopoietic stem cell transplant (marrow transplant)" = true
  SYNTH:COMMON-HSCT "COMMON - Stem cell transplantation" = true
  SYNTH:COMMON-TTT-ID "COMMON-TTT-ID - Treatment inducing immunosuppression" = true
  SYNTH:COMMON-RHU "COMMON-RHU - Rheumatic disease" = true
  COND:C541 "Anti-C5 treatment: Soliris® (Eculizumab) or Ultomiris® (ravulizumab)" = true
  COND:C1257 "Haemolytic uraemic syndrome (HUS)" = true
  COND:C1259 "Children in nursery school" = true
  COND:C1260 "Children in nursery" = true
  COND:C1170 "Dormitory accommodation" = true
  COND:C1262 "Accommodation in a university residence." = true
  COND:C1263 "Housed in barracks" = true
  COND:C1264 "Close contact with a case of invasive meningococcal infection" = true
  SYNTH:COMMON-MED-STAFF "COMMON-MED-STAFF - Medical staff" = true
  COND:C249 "Works in a medical biology laboratory" = true
#  SYST:patient_destinations = cf354ad7-86bf-423c-bd4c-0220f504457e
  CALC:Age>=65y
  