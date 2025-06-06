---
title: "CATIE-TRS Readme"
author: "Dan W Joyce"
date: 15th October 2018
---

R code for analysing CATIE trial data for treatment resistance

# 1. Installation / Directory Structure

The 'package' includes (under the parent directory):

  * Code         -- Contains the scripts to analyse the data from first principles, and all analyses
  * SourceData   -- Place the downloaded CATIE source data here (i.e. unzip the NIMH repository for CATIE; see below for required files)
  * DerivedData  -- Data produced by scripts is stored here.

## 1.1 - Data Sources / Supplied Data
Importantly, because we do not have rights to distribute the CATIE source data, the `DerivedData` directory contains the relevant preprocessed data that can then be used to reproduce the analyses in the paper **without** having access to the CATIE source repository.  The original CATIE tables cannot be reverse engineered from the derived data contained in `DerivedData`.  

We do not have permission to distribute the CATIE data and the source `.txt` files must be applied for and obtained via `https://data-archive.nimh.nih.gov/`

The relevant derived data supplied is:
 
  * `raw_trajectories.RData` -- binary image of the results of `preprocess_trajectories.R` for attaching (or loading).
  * `survivalData_tabulated.csv` -- this CSV contains all data, preprocessed, for the descriptive and inferential analyses.

If the user has access to the source CATIE data, the following `.txt` files must be placed in `./SourceData`

  * `demo01.txt`
  * `dosecomp01.txt`
  * `panss01.txt`
  * `qol01.txt`
  * `macvlnce01.txt`
  * `scid_ph01.txt`
  * `dgsposys01.txt`
  * `keyvars01.txt`

## 1.2 Dependencies / Packages
The analyses scripts make use of the following `R` packages.  For example, at the `R` command line paste this to install all packages:
```
  install.packages(
    c("dplyr",
      "reshape2",
      "ggplot2",
      "knitr",
      "kableExtra",
      "reshape2",
      "survival",
      "survminer",
      "gridExtra",
      "DiagrammeR",
      "venneuler",
      "VIM",
      "mice",
      "stringr",
      "boot",
      "parallel",
      "tibble",
      "rms"
      )
  )
```

## 1.3 Test Environment
Final testing for these scripts:

  * Linux 16.04 LTS (64-bit), with 16Gb RAM, 1TB HDD and Core i7-4770 @ 3.4 GHz CPU
  * R Core version 3.4.4 ("Someone to Lean on")

## 1.3 Other Information
In `./Code` there are some extra documents to help:

  * `term-data-dictionary.html` describes the data table used for all analyses (i.e. the data in `survivalData_tabulated.csv`)

  * `demo_determining_TRS.Rmd` (and the corresponding `.html` file) is an R Markdown document showing a walkthrough the `tabulate_cases.R` script which produces `survivalData_tabulated.csv`

# 2 - Executing the Scripts

## 2.1 From CATIE Source Data

If the user has access to the CATIE source data, and the files have been placed in `./SourceData` then the following can be executed:

  1. `preprocess_trajectories.R` -- calls `load_all_tables.R` and then does a majority of the data-mining to establish 'trajectories' of symptoms, treatments and social/occupational functioning (idiosyncratic code that heavily relies on the CATIE data dictionary; contains code that produces the SOFAS / PSP proxy measure from CATIE's scales).  See Supplementary Information for details of the algorithms for each component of TRRIP. Unless the user has a copy of the CATIE data placed in ./SourceData, this script **will not** work.

Note that `load_all_tables.R` reads the subset of CATIE "raw" data files in, preparing them as data.frames for the main processing scripts.  Again, this script **only** works if the user has downloaded a copy of the `.txt` files for the NIMH CATIE data repository. 

The execution of these `preprocess_trajectories.R` takes about one minute on an i7 Linux machine with 16 Gb RAM and is fairly silent in terms of output.

The remainded of the analyses are then conducted as explained below.

## 2.2 - Reproducing Analyses without CATIE Source Data
To extract TRS cases from the whole sample (i.e. implementing the algorithms described in Supplementary Information):

  1. Run the script `tabulate_cases.R` -- uses the output of `preprocess_trajectories.R` (e.g. the binary image `./DerivedData/raw_trajectories.RData`), builds a large table containing the data required to estimate incidence rates and inferential analyses.  This script writes `./DerivedData/survivalData_tabulated.csv`.  For transparency, an annotated walk-through is provided in `demo_determining_TRS.html` or the executable markdown script `demo_determining_TRS.Rmd`

The script `tabulate_cases.R` takes under 10 seconds to run on an i7 Linux box.

Alternatively, if the user wants to skip the data preprocessing and directly interrogate the analyses for the paper:

  2. `participant_flow_missing_data.Rmd` -- For Figures 1, 2, Supplementary Figure S2, and Table 2 in the paper.  Depends only on `./DerivedData/survivalData_tabulated.csv`.  Also stores the result of imputations : `./DerivedData/imputed_tabSurv.RData`. Without executing, the analyses can be followed in `participant_flow_missing_data.html`.  To execute and compile the script from `Rmd` to `html` takes just under 1 minute. 

  3. `inferential_analyses.Rmd` -- For incidence rates, Table 3 and Supplementary Figure S3.  Depends only on `./DerivedData/survivalData_tabulated.csv` and `./DerivedData/imputed_tabSurv.RData`. Without executing, the analyses can be followed in `inferential_analyses.html`. To execute and compile the script from `Rmd` to `html` takes just under 1 minute.


# 3. Data Errors / Integrity Issues

During analyses, we found transposition errors yielding incongurent medication doses for a few participants.
On investigating, in the CATIE source file `dosecomp01.txt`, for the following participants:

  * src_subject_id = 1931 :
    * For columns `phase_ct` = `Phase 3`, `Visit` = `Visit17`
    * Columns/variables : `medad10` = 800 and `medad13` = 5
    * Which implies Fluphenazine = 800mg and Quetiapine = 5mg
    * Correct values are: `medad10` = 5 and `medad13` = 800.


  * src_subject_id = 2897 :
    * For columns `phase_ct` = `Phase 3`, `Visit` = `Visit17` 	
    * Columns/variables : `medad10` = 600 and `medad13` = 10
    * Which implies Fluphenazine = 600 and Clozapine = 10mg
    * Correct values are: `medad10` = 10 and `medad13` = 600

  * src_subject_id = 1729 :
    * For columns `phase_ct` = `Phase 3`, `Visit` = `EndofPhase3`
    * Columns/variables : `medad10` = 300 and `medad13` = 15
    * Which implies Fluphenazine = 300mg, Clozapine = 15mg
    * Correct values are: `medad10` = 15 and `medad13` = 300mg

The code in `load_all_tables.R` makes these corrections. 
