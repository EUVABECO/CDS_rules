SYNTH MEN_RF_1 "MEN-RF-1 : Medical Risk factors for invasive meningococcal infections" IS ANY OF
  COND:C21 "Complement deficit" = true
  COND:C541 "Anti-C5 treatment: Soliris® (Eculizumab) or Ultomiris® (ravulizumab)" = true
  COND:C36 "Spleen removal or non-functioning" = true
  COND:C23 "Homozygous sickle cell disease" = true
  COND:C7 "Double heterozygous sickle cell disease" = true
  COND:C635 "Patient with a complement deficiency or treated with Soliris® (eculizumab) or Ultomiris® (ravulizumab) in the family" = true
  COND:C24 "HIV infection" = true

SYNTH MEN_RF_2 "MEN-RF-2 : Occupational risks for meningitis" IS ANY OF
  COND:C1118 "Military" = true
  COND:C542 "Works in a meningococcal research laboratory" = true

SYNTH MEN_RF_3 "MEN-RF-3 : Haematopoietic stem cell transplants" IS ALL OF COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)">=1d

SYNTH MEN_RF_41 "MEN-RF-41 : Tabac and [15-24y] old" IS ALL OF
  COND:C1156 "Smoking" = true
  CALC:Age in 15y..24y

SYNTH MEN_RF_42 "MEN-RF-42 : Dormitory accommodation and [15-24y] old" IS ALL OF
  COND:C1170 "Dormitory accommodation" = true
  CALC:Age in 15y..24y
  
SYNTH MEN_RF_4 "MEN-RF-4 : Others RF (Tabac and dormitory accommodation)" IS ANY OF
  SYNTH:MEN_RF_41 "MEN-RF-41 : Tabac and [15-24y] old" = true
  SYNTH:MEN_RF_42 "MEN-RF-42 : Dormitory accommodation and [15-24y] old" = true
  
SYNTH MEN_RF_WO_HSCT "MEN-RF : All Risk factors for invasive meningococcal infections (Med / Pro / Other - without HSCT)" IS ANY OF
  SYNTH:MEN_RF_1 "MEN-RF-1 : Medical Risk factors for invasive meningococcal infections" = true
  SYNTH:MEN_RF_2 "MEN-RF-2 : Occupational risks for meningitis" = true
  SYNTH:MEN_RF_4 "MEN-RF-4 : Others RF (Tabac and dormitory accommodation)" = true

SYNTH MEN_RF_W_HSCT "MEN-RF : All Risk factors for invasive meningococcal infections (med / Pro / Others / HSCT)" IS ANY OF
  SYNTH:MEN_RF_1 "MEN-RF-1 : Medical Risk factors for invasive meningococcal infections" = true
  SYNTH:MEN_RF_2 "MEN-RF-2 : Occupational risks for meningitis" = true
  SYNTH:MEN_RF_3 "MEN-RF-3 : Haematopoietic stem cell transplants" = true
  SYNTH:MEN_RF_4 "MEN-RF-4 : Others RF (Tabac and dormitory accommodation)" = true

SYNTH MEN-AC-NC "MEN-AC-NC : Dernière valence reçue est un vaccin AC non conjugué" IS ALL OF
  CALC:MenA_last_valence_ids  contains MPV-A
  CALC:MenA_last_valence_ids  contains MPV-C

SYNTH MEN-ACWY-NC "MEN-ACWY-NC : Dernière valence reçue est un vaccin ACWY non conjugué" IS ALL OF
  CALC:MenA_last_valence_ids  contains MPV-A
  CALC:MenA_last_valence_ids  contains MPV-C
  CALC:MenA_last_valence_ids  contains MPV-Y
  CALC:MenA_last_valence_ids  contains MPV-W
  
SYNTH MEN-ACWY-Conj "MEN-ACWY-Conj : Dernière valence reçue est un vaccin ACWY conjugué" IS ALL OF
  CALC:MenA_last_valence_ids  contains MCV-A
  CALC:MenA_last_valence_ids  contains MCV-C
  CALC:MenA_last_valence_ids  contains MCV-Y
  CALC:MenA_last_valence_ids  contains MCV-W

SYNTH MEN-NC "MEN-NC Dernière valence reçu est un vaccin non conjugué ACWY ou AC" IS ANY OF
  SYNTH:MEN-AC-NC "MEN-AC-NC : Dernière valence reçue est un vaccin AC non conjugué" = true
  SYNTH:MEN-ACWY-NC "MEN-ACWY-NC : Dernière valence reçue est un vaccin ACWY non conjugué" = true  