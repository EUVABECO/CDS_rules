CALC Shingles_doses_received IS HIST(Shingles,0,count)
CALC Shingles_last_dose_date IS HIST(Shingles,-1,date)


TARGET Shingles

FOLDER 1 "immunocompromised - and ≥ 60y old"
  IF ALL OF
  CALC:Age>=60y
  SYNTH:COMMON-RF-ID  = false

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
  SYNTH:COMMON-RF-ID = true

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
    MESSAGES  MSG349
  END RULE 1

  RULE 2 "if to do: Message"
    WHEN Recommended
    IF CALC:Shingles_doses_received<=1
    DO Neutral
    MESSAGES  MSG348
  END RULE 2
END FOLDER 9
END TARGET

MESSAGE MSG349 Other ANY PRIO 0
  "Vaccines that can be used: Shingrix"@en
 END MESSAGE MSG349

MESSAGE MSG348 Justification ANY PRIO 0
  "Vaccination against zoster with a recombinant, non-live, adjuvanted, subunit herpes zoster vaccine (2-dose regimen) is recommended for:<br>
- immunocompetent adults aged ≥ 60 years;<br>
- immunocompromised patients, including those on immunosuppressive therapy aged ≥ 16 years."@en
 END MESSAGE MSG348
