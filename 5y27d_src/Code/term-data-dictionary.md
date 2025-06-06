# CATIE TRS - Terminology and Data Dictionary


## Abbreviations Used
Throughout, we refer to the following :

  * SOF - social and occupational functioning data
  * Sx  - symptom data (PANSS)
  * Rx  - treatments

We often refer to the **absolute** criteria for Sx (and SOF) -- this means that the threshold specified in TRRIP has been met for Sx or SOF at some time point.  Note, that this is *different* to the change / persistence criteria for Sx (i.e. the <20% reduction).  If a participant meets the absolute criteria, and then meets the persistence of symptoms / SOF criteria, they are designated TRS.

## Assumptions
The way the data are collected in CATIE means that while Sx and Rx data are recorded frequently, the SOF data was recorded only on less-frequent designated intervals throughout the study.  For this reason, we used last observation carried forward (LOCF) when the SOF data was not aligned with the time point at which TRS status was assessed.  

## Sub-Samples / Groups
Recall that the TRRIP criteria specifies an **absolute** and **change** criteria for symptoms - most importantly, the absolute criteria for symptoms specifies a threshold for positive and negative symptom domains.  Then, TRRIP specifies that after **two adequate trials** a participant is treatment resistant if and only if:

  1. The absolute criteria must still be met for positive, negative or both domains
  2. And the change / response to treatments must be <20% in the overall PANSS score, as well as either the positive, negative (or both) domains.

So, if a participant enters the CATIE trial and progresses through and then exits the trial and:

  1.  **never** meets the **absolute threshold** criteria, then we designate them **"Never Above Threshold"** (NAT) because by definition, the participant's change in symptoms / response to treatment is not relevant (i.e. a participant can never be treatment resistant because they must meet the absolute *and* change criteria together)
  2.  **at some time point** meets the **absolute threshold** criteria, then we designate them **"Above Threshold"** (AT), because now, we want to follow this participant and establish how their symptoms respond to two (or more) adequate treatments.

A participant in the "Above Threshold" (AT) group can then exit the trial having had:

  1. two or more adequate treatments but **not displaying response** by the TRRIP criteria, and are designated **TRS**
  2. two or more adequate treatments but **respond** according to the the TRRIP criteria, and are designated **Responders**
  3. **only one** adequate treatments, but **not displaying** response by the TRRIP criteria, and are **right censored**, remaining above threshold, and continuing at risk of TRS (e.g. had they been followed up for a further adequate trial)
  4. **zero** adequate treatments, but **not displaying** response by the TRRIP criteria, and are **right censored**, remaining above threshold, and at continuing risk of TRS (e.g. had they been followed up for a further two adequate trials)

# Data Dictionary
The data relevant to analyses are contained in `./DerivedData/survivalData_tabulated.csv`.   The `data.frame` `tabSurv` data dictionary is a little complex, so the details are:

**Identifiers**:

  * `ID` - Participant ID number

**Timing**:

  * `time.inTrial` - Total time in the trial -- this will be the contributed person years for this participant (whether they develop TRS or not)
  * `time.inTrialYrs` = time.inTrial / 365 (in years)

  * Time of "onset" of **individual criteria** including if a participant *ever* meets individual criteria
  
    * If `NA` the participant *never* met Sx, SOF or Rx criteria (where Sx = symptoms on PANSS, SOF = social occupational function and Rx = treatments)
    * Otherwise, time they met criteria at the time specified in days

	  * `onset.Sx` : the day absolute symptoms triggered above threshold (this does **not** mean the **change** in symptoms meets TRS criteria < 20%)
	  * `onset.SOF` : the day SOF triggered above threshold
	  * `onset.Rx` : the day adequate trials triggered threshold of $\geq 2$

  * Timing of "onsets" for **all three TRS criteria**
    * If `NA` the participant *never* met the criteria, otherwise, times are in days
	  * `time.onset.TRS` : the time at which Sx **and** SOF triggered above threshold, denoting the baseline for which PANSS is assessed
	  * `time.onset.TRSYrs` is `time.onset.TRS` in years
    * `time.TRS` : the time **confirmed** TRS (if at all) = some day after `time.onset.TRS` and adequate treatment condition met.  For a TRS participant, this is the person contributed 'disease free' time for incidence rate analyses.
    * Note, at the time `onset.Rx` (i.e. when adequate treatments $\geq 2$), we then check the corresponding Sx and SOF for response, and if not responding (by the criteria in TRRIP) we label this as the time TRS event happens
	  * `time.TRSYrs` = `time.TRS` in years
                        
**Summary of treatments**:

  * `numAdeq` : the number of adequate trials (by TRRIP criteria on dose, duration, concordance)
  * `durAdeq` : the total duration of adequate trials
  * `totalRx` : total number of drug treatments, whether meeting 'adequate' criteria or not
  * Note, if any are `NA` then this data is missing / could not be established from public CATIE datasets
	

**Summary of "Caseness"**: (independent of time)

  * `status.rx` : the participant did at some point meet TRS criteria for adequate treatments
  * `status.sx` : the participant did meet TRS criteria for symptoms **not changing** in response to adequate treatment
  * `status.sof` : the participant did at some point meet TRS criteria for SOF
  * All above are `0/1`, with `1` meaning positive, `0` negative 
  * `status.TRS` : overall, flag for TRS caseness where `1` = censored (did not convert) `2` = converted to TRS 
  
**TRS domains**: (Only for those participants reaching full TRS criteria with `status.TRS = 2`)

  * `TRS.pos` : treatment resistance in the positive domain (0/1; 1 = TRUE, 0 = FALSE)
  * `TRS.neg` : treatment resistance in the negative domain (0/1; 1 = TRUE, 0 = FALSE)
                        
**Missing Data Flags**: (missing enough data that follow-up / TRS assessment cannot be performed)

  * `missing.Sx` : not enough records for symptom trajectory
  * `missing.Rx` : not enough records for treatments trajectory
  * `missing.SOF` : not enough records for SOF trajectory
  * Coded as 1 (missing) or 0 otherwise. 