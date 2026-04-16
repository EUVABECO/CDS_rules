# RULES GRAMMAR

# Principles

The recommendations provided by the CDS are based upon:

-   Basic demographic data on the patient.
-   Characteristics of the patient, entered through a personalized questionnaire.
-   The history of administered vaccines.

They are elaborated with a collection of set of rules, each set being associated to a given target disease.

The recommendations for each disease consist of:

-   a current status of immunization for the given disease,
-   a recommended action
-   the date for the next dose, if required,
-   a collection of justification messages.

Each rule is a logical proposition, giving an outcome (status, date, messages) from premises. Arbitration mechanisms determine, when several rules are triggered, which one should take the precedence. This is to enforce traceability and accountability, since:

-   any recommendation is associated with an identifiable rule
-   the history of modifications and verifications for any rule is fully traceable.

# Building blocks

## Rules

Rules are named with an identifier, possibly complemented with a description.

They express that if a logical condition is satisfied, a given action will be performed, and certain messages will be presented.

The simplest form of a rule could be:
```
RULE 10/01 "≤ 6m old, 0 dose: Todo from 2m old"
IF CALC:age <=6m
DO Recommended
Status TODO
Age 2m
END RULE 10/01
```
In this example, the vaccination for a child less than 6 months old is due at the age of 2 months. If this rule is executed for a child between 2 and 6 months, the recommendation will be for an immediate vaccination.

The most general form of a rule will be:
```
RULE <Id> <Description>
WHEN <Context>
IF <Premise>
DO <Action>
MESSAGES <list of messages>
END RULE <Id>
```
The first line gives the unique identifier of the rule, and its optional description.

### WHEN clause

The optional WHEN clause allows to create complementary rules that are triggered only when another rule has already decided upon an action, that is either to recommend the vaccination (WHEN RECOMMENDED) or to exclude it (WHEN CONTRAINDICATED). The purpose of this is to distinguish between basic rules, that determine the course of action, and complementary documentary rules, that will not alter the decision but add further person-dependent justification messages.

### IF clause

The IF clause determines if the action should be triggered. The \<Premise\> argument can be:

-   A test on a logical characteristic
-   A comparison between a numeric characteristic (for example a measured rate of antibodies) and a reference value
-   A comparison between the result of a function on characteristics (for example, the interval between two dates) and a reference value
-   A combination of the above, prefixed with the ANY OF or ALL OF operator.

For example, a valid premise could be:
```
IF ALL OF
CALC:d1d2>=3w
CALC:d2d3>=3w
CALC:d3d4>=3w
INTERVAL(HIST(Pneumo,-2,date),HIST(Pneumo,-1,date))>=3w
CALC:patient_age_at_the_last_act>=11m
SYNTH:PNEU-ONLY10/20-NOT23NC = true
```
### DO clause

The DO clause defines the action to be performed if the \<Premise\> is true. Four actions are possible:

-   DO RECOMMENDED if the vaccination is recommended for the given patient. In that case the DO clause is complemented with further elements to determine whether and when a next administration is due.
-   DO CONTRAINDICATED if the vaccination is contra-indicated
-   DO NEUTRAL does not require an action. This is typically the term that will be used for complementary rules, that are triggered only once an action has already been selected.
-   DO EXCEPTION is used in complex cases where the CDS cannot determine by itself any course of action. This will be complemented with some message proposing to refer to a human expert.

The DO RECOMMENDED clause must be complemented with the details needed to determine when the vaccination should be done. It consists in three terms:

-   Whether the vaccination is due or complete.
-   If the vaccination is not complete:
    -   The age or age range when the next administration should be done
    -   Possibly a delay from some other event (the last administration, a start of pregnancy, the start date of a vaccination campaign) that should be respected.
```
DO Recommended
Status DUE
Age 7y..9y
Delay 6w..8w from HIST(Per,-1,date)
```

Status allows for the mapping to the FHIR forecast status, according to the following table:

| Action          | Status   | Due date      | FHIR forecastStatus |
|-----------------|----------|---------------|---------------------|
| Recommended     | Complete |               | Complete            |
| Recommended     | Due      | In the future | Due                 |
| Recommended     | Due      | In the past   | Overdue             |
| Recommended     | Overdue  | Unspecified   | Overdue             |
| Contraindicated |          |               | Contraindicated     |
| Exception       |          |               | Unknown             |

When the target age is not expressed as a range, it means that the vaccination can be done at any time after the given age.

The Delay term imposes an uncompressible limit. Even if other rules assign an earlier age for vaccination and should have precedence, the computed due date will respect the imposed delay.

## Characteristics

The terms used in the premises are identified by a namespace, an identifier and optionally a description. Four namespaces are identified:

- **BASE** corresponds to two basic context information:
  + BASE:dob is the date of birth of the patient
  + BASE:eval is the date of evaluation (typically the day when it is run)
-   **COND** corresponds to characteristics that were entered into the questionnaire.
-   **SYNTH** are shorthand notations for logical characteristics elaborated from other characteristics
-   **CALC** are shorthand notations for numeric characteristics elaborated from other characteristics

### Characteristics from the questionnaire

The characteristics from the questionnaire are a constantly evolving set, according to the vaccination strategy expressed by the national experts. 

Normally they should be checked against a live online directory. In this simplified implementation every stated characteristic is supposed to be an existing one.

Each characteristic can be a Boolean, an integer, a float or a date.

### Synthetic characteristics

Synthetic characteristics are Boolean expressions formed with almost the same syntax as premises of rules.

```
SYNTH COMMON-RF-ID "Risk factors contraindicating vaccination with live vaccines" IS ANY OF
COND:C917 "Strong immunosuppressive treatment (covid)" = true
COND:C932 "Date of a solid organ transplant " >=1d
COND:C966 "Date of hematopoietic stem cell transplant (marrow transplant)" >=1d
COND:C578 "Ongoing chemotherapy for solid tumor" = true
COND:C594 "Ongoing chemotherapy for hematological malignancy" = true
COND:C996 "Congenital immune deficiency, without strong immunosuppression" = true
COND:C579 "Biotherapy leading to immunosuppression" = true
COND:C413 "Other immunosuppressive therapy" = true
COND:C1010 "Congenital immune deficiency, with strong immunosuppression" = true
```
The declaration starts with the identifier and label, and after the IS term one of the ANY OF or ALL OF operators.

## Operators and functions

### The HIST function
The HIST function is used to extract information from the history of administered vaccines. It takes three arguments:
  + A filter, that is the valence of vaccines to be considered
  + An index in the filtered list of vaccines
  + A selector, that describes the required characteristic of the vaccine event
  
The filtering of the list of vaccines takes into account the hierarchy of valences as defined by NUVA. In the example above, all administered vaccines with a valence that is a descendent of the Per valence will be included.

The index is:
- if positive, the rank in the filtered list
- if 0, the whole list (for the `count` selector)
- if negative, the backward rank from the end of the filtered list

The selector may be one of the following:

| Selector | Type   | Meaning                                              |
|----------|--------|--------------------------                            |
| date     | date   | date of administration                               |
| vaccine  | string | NUVA code of the vaccine                             |
| valences | set    | list of english shorthand notations of the valences  |
| booster  | boolean| if the administration was recorded as a booster dose |
| count    | Number | Number of doses                                      |

Typical use cases:
```
CALC Per_d1d2 IS INTERVAL(HIST(Per,1,date), HIST(Per,2,date))
CALC Per_doses_received IS HIST(Per,0,count)
CALC Per_last_dose_date IS HIST(Per,-1,date)
CALC Per_last_dose_is_booster IS HIST(Per,-1,booster)
CALC Per_last_dose_age is INTERVAL(CALC:Per_last_dose_date,BASE:eval)
CALC IntervalleDoseGrossesse IS INTERVAL(HIST(Per,-1,date),COND:C52 "Grossesse - Date des dernières règles")
```
### Operators

The evaluation operators are the following ones:

| Operator    | Applies to    | Description                |
|-------------|---------------|----------------------------|
| =           | Any value     | Equals                     |
| !=          | Any value     | Not equals                 |
| \>=         | Number/date   | Greater or equal           |
| \<=         | Number/date   | Lesser or equal            |
| \>          | Number/date   | Greater                    |
| \<          | Number/date   | Lesser                     |
| In          | Number/date   | Value in interval          |
| contains    | Set           | Set contains value         |
| contains no | Set           | Set does not contain value |

### Functions

The functions that may be used on numeric values (including dates) are:

| Function | Arguments       | Description                 |
|----------|-----------------|-----------------------------|
| INTERVAL | Date1, Date2    | Duration between two dates  |
| ADD      | Value1, Value2  | Add values                  |
| SUB      | Value1, Value2  | Subtract Value2 from Value1 |
| MUL      | Value1, Value2  | Multiply values             |
| DIV      | Value1, Value2  | Divide Value1 by Value2     |

They can be combined into composite expressions.

### Naming computed characteristics

Computed characteristics are elaborated from integer or float characteristics, using functions, possibly combined.
```
CALC BMI “Body/Mass Index” IS
DIV(COND:C-962 “Weight”, MUL(C-963 “Height”, C-963))
```

## Messages

The rules reference lists of message identifiers in their outcomes.

These messages are themselves described as:
```
MESSAGE <Id> <Type> <Audience> PRIO <prio>
  "<Text1>"@<lang1>  
  "<Text2>"@<lang2>  
 …
"<TextN>"@<langN>  
END MESSAGE <Id>
```
Where:

-   \<Id\> is the identifier of the message, as referenced in rules
-   \<Type\> is one of the supported message classes, that drive their representation by the client system: 
ALERT, SUMMARY, JUSTIFICATION, COMMENTS, DETAILS, OTHER
-   \<Audience\> is one of ANY, PRO or PATIENT
-   \<Text1\> is the text of the message in language \<lang1\>

## Target and Folders

Rules may be included into folders, that have a dual role of structuration and of factorization of terms in a set of rules.

Folders are wrapped into a target, that explicits to which disease the recommendations apply
```
TARGET <TargetId>
  FOLDER <Id> <Description>
  IF <Premise>
    <Rules or Folders>
  END FOLDER <Id>
END TARGET
```

The optional IF clause defines a premise that is inherited by all included rules or folders.

# Global structure

The overall structure of a ruleset for a disease is finally:

-   The declarations of all synthetic characteristics or computed characteristics used.
-   A target with one or several folders, containing further folders and rules.
-   The declaration of the messages with their attributes and translations.

[See grammar in PEG format](grammar.peg)
