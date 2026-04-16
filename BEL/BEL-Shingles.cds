CALC Shingles_doses_received IS HIST(Shingles,0,count)
CALC Shingles_last_dose_date IS HIST(Shingles,-1,date)	

TARGET Shingles

FOLDER 1 "immunocompromised - and ≥ 60y old"
  IF ALL OF
  CALC:Age>=60y
  SYNTH:COMMON-RF-ID "COMMON-RF-ID - ID risk factors contraindicating vaccination with live vaccines"  = false

  RULE 1 "≥ 60y od, IC-, 0 dose: To do from 60y old"
    IF CALC:Shingles_doses_received = 0
    DO Recommended
      Status DUE
      Age 60y
  END RULE 1

  RULE 2 "≥ 60y od, IC-, 1 dose: To do 2m after LD"
    IF CALC:Shingles_doses_received = 1
    DO Recommended
      Status DUE
      Age 60y
      Delay 2m from CALC:Shingles_last_dose_date
  END RULE 2

  RULE 3 "≥ 60y od, IC-, ≥ 2 doses: Up to date"
    IF CALC:Shingles_doses_received>=2
    DO Recommended
      Status COMPLETED
  END RULE 3
END FOLDER 1

FOLDER 2 "immunocompromised + and ≥ 16y old"
  IF ALL OF
  CALC:Age>=16y
  SYNTH:COMMON-RF-ID "COMMON-RF-ID - ID risk factors contraindicating vaccination with live vaccines" = true

  RULE 1 "≥ 16y od, IC+, 0 dose: To do from 16y old"
    IF CALC:Shingles_doses_received = 0
    DO Recommended
      Status DUE
      Age 16y
  END RULE 1

  RULE 2 "≥ 16y od, IC+, 1 dose: To do 2m after LD"
    IF CALC:Shingles_doses_received = 1
    DO Recommended
      Status DUE
      Age 16y
      Delay 2m from CALC:Shingles_last_dose_date
  END RULE 2

  RULE 3 "≥ 16y od, IC+, ≥ 2 doses: Up to date"
    IF CALC:Shingles_doses_received>=2
    DO Recommended
      Status COMPLETED
  END RULE 3
END FOLDER 2

FOLDER 9 "Further information"

  RULE 1 "If to do: message to do with Shingrix"
    WHEN Recommended
    IF CALC:Shingles_doses_received<=1
    DO Neutral
    MESSAGES  MSG77
  END RULE 1

  RULE 2 "if to do: Message"
    WHEN Recommended
    IF CALC:Shingles_doses_received<=1
    DO Neutral
    MESSAGES  MSG78
  END RULE 2
END FOLDER 9
END TARGET

MESSAGE MSG78 Justification ANY PRIO 0
  "The CSS recommends vaccination against zoster using a subunit, recombinant, non-live adjuvanted herpes zoster vaccine (2-dose regimen) for:<br>
- immunocompetent adults aged ≥ 60 years;<br>
- immunocompromised patients, including those on immunosuppressive therapy aged 16 years and older as well as patients on anti-JAK therapy."@en
 END MESSAGE MSG78

MESSAGE MSG77 Other ANY PRIO 0
  "Vaccines available: Shingrix"@en
 END MESSAGE MSG77

MESSAGE MSG346 Details PATIENT PRIO 0
  "--"@en
 END MESSAGE MSG346
