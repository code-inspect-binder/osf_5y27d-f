# -- Version for submission 
# -- dwj : 10th October 2018

# -- This script loads a subset of tables from the NIMH CATIE source

# -- Paths : assumes execution from working directory ./Code
source.data.path <- "../SourceData/"

## 1 -- demographics tables
  all_content = readLines(paste( source.data.path, "demo01.txt", sep = ""))
  skip_second = all_content[-2]
  demog.tab = read.csv(textConnection(skip_second), header = TRUE, stringsAsFactors = TRUE, sep = "\t")
  # convert age from months to years
  demog.tab$interview_age <- demog.tab$interview_age / 12


## 2 -- drug doses
  all_content <- readLines(paste( source.data.path, "dosecomp01.txt", sep = ""))
  skip_second <- all_content[-2]
  drug.doses  <- read.csv(textConnection(skip_second), header = TRUE, stringsAsFactors = TRUE, sep = "\t")
  drug.doses$ID <- as.numeric( as.character( drug.doses$src_subject_id ) )
  
  ## -- apply corrections (tranposition errors noted)
        ## participant ID = 1931
        ## -- these values for medad10 are 800 (of quietiapine), but should be 5 (of fluphenazine)
        drug.doses$medad10[ ( which( drug.doses$ID == 1931 & drug.doses$phase_ct == "Phase 3" ) ) ] <- c(5,5)
        drug.doses$medad13[ ( which( drug.doses$ID == 1931 & drug.doses$phase_ct == "Phase 3" ) ) ] <- c(800,800)
  
        ## participant ID 2897
        ## -- these values for medad10 are 600 and 400 (of clozapine), but should be 10 (of fluphenazine)
        drug.doses$medad10[ ( which( drug.doses$ID == 2897 & drug.doses$phase_ct == "Phase 3" ) ) ] <- c(10,NA)
        drug.doses$medad13[ ( which( drug.doses$ID == 2897 & drug.doses$phase_ct == "Phase 3" ) ) ] <- c(600,400)
        
        ## participant ID 1729
        # drug.doses[ ( which( drug.doses$ID == 1729 & drug.doses$phase_ct == "Phase 3" ) ), ]
        drug.doses$medad10[ ( which( drug.doses$ID == 1729 & drug.doses$phase_ct == "Phase 3" ) ) ] <- 15
        drug.doses$medad13[ ( which( drug.doses$ID == 1729 & drug.doses$phase_ct == "Phase 3" ) ) ] <- 300
        
    
# 3 -- PANSS data 
  all_content <- readLines(paste( source.data.path, "panss01.txt", sep = ""))
  skip_second <- all_content[-2]
  temp.PANSS.tab  <- read.csv(textConnection(skip_second), header = TRUE, stringsAsFactors = TRUE, sep = "\t")
  
  PANSS.tab <- with( temp.PANSS.tab, temp.PANSS.tab[ , c("src_subject_id", "phase_ct", "visday", "truncvis",
                                               "pos_p1","pos_p2","pos_p3","pos_p4","pos_p5","pos_p6","pos_p7",
                                               "neg_n1","neg_n2","neg_n3","neg_n4","neg_n5","neg_n6","neg_n7",
                                               "gps_g1","gps_g2","gps_g3","gps_g4","gps_g5","gps_g6","gps_g7",
                                               "gps_g8","gps_g9","gps_g10","gps_g11","gps_g12","gps_g13",
                                               "gps_g14","gps_g15","gps_g16")
                                          ]
                     )
  
# 4 --  Quality of Life data 
  all_content <- readLines(paste( source.data.path, "qol01.txt", sep = ""))
  skip_second <- all_content[-2]
  QoL.temp    <- read.csv(textConnection(skip_second), header = TRUE, stringsAsFactors = TRUE, sep = "\t")
  
    
  QoL.tab <- with( QoL.temp, QoL.temp[ , c("src_subject_id", "phase_ct", "visday", "truncvis",
                                 "qol01a", "qol01b", "qol01c",         
                                 "qol01d", "qol01e", "qol01f", "qol01g", "qol02",
                                 "qol03", "qol04", "qol05", "qol06", "qol07",         
                                 "qol08", "qol09", "qol10", "qol11", "qol12",             
                                 "qol13", "qol14", "qol15", "qol16", "qol17",             
                                 "qol18", "qol19", "qol20", "qol21", "qol22",             
                                 "qol23a", "qol23b", "qol23c", "qol23d", "qol24a",
                                 "qol24b", "qol24c", "qol24d", "qol25a", "qol25b",            
                                 "qol25c", "qol25d", "qol25e", "qol25f", "qol25g",            
                                 "qol25h", "qol25ia", "qol25ib", "qol25ic", "qol25id",
                                 "qol25ie", "qol25if", "qol25ig", "qol25j1", "qol25j2",            
                                 "qol25j3", "qol25j4", "qol26a", "qol26aa", "qol26b",             
                                 "qol26ba", "qol26c", "qol26ca", "qol26d", "qol26da",            
                                 "qol26e", "qol26ea", "qol27a", "qol27b", "qol27c",             
                                 "qol28a", "qol28b", "qol28c", "qol28d", "qol28e",             
                                 "qol29a", "qol29b", "qol29c", "qol29d", "qol30a",             
                                 "qol30b", "qol30c", "qol30d", "qol31",
                                 "intr_rel", "inst_rol", "intr_fou", "com_obj") ]
  )

# 5 -- MacArthur Violence data
  all_content <- readLines(paste( source.data.path, "macvlnce01.txt", sep = ""))
  skip_second <- all_content[-2]
  all_content    <- read.csv(textConnection(skip_second), header = TRUE, stringsAsFactors = TRUE, sep = "\t")  
  viol.tab <- with( all_content, all_content[ , c("src_subject_id", "phase_ct", "visday", "truncvis",
                                                  "mac1a", "mac2a", "mac3a", "mac4a", "mac5a", "mac6a",
                                                  "mac7a", "mac8a", "mac9a", "mac10a", "mac11a",
                                                  "mac12a", "mac13a", "mac14a", "mac15a", "mac16a", "mac17a",
                                                  "mac18a","mac19a","mac19b","mac19c","mac19d") ]
  )
  
# 6 -- SCID data at baseline
  all_content <- readLines(paste( source.data.path, "scid_ph01.txt", sep = ""))
  skip_second <- all_content[-2]
  all_content    <- read.csv(textConnection(skip_second), header = TRUE, stringsAsFactors = TRUE, sep = "\t")
  SCID.tab <- with( all_content, all_content[ c("src_subject_id",
                                  "scid03",  ## depression in past 5 years
                                  "scid05",  ## alcohol dependence in past 5 years
                                  "scid07",  ## alcohol abuse in past 5 years
                                  "scid09",  ## drug dependence in past 5 years
                                  "scid11",  ## drug abuse in past 5 years
                                  "scid13",  ## OCD in past 5 years
                                  "scid15"  ## other anxiety disorder past 5 years
                                  ) ] )
  
# 7 -- Baseline PMHx data
  all_content <- readLines(paste( source.data.path, "dgsposys01.txt", sep = ""))
  skip_second <- all_content[-2]
  pmhx    <- read.csv(textConnection(skip_second), header = TRUE, sep = "\t")
  pmhx    <- pmhx[ which( pmhx$truncvis == 0 ), ]
  pmhx <- with( pmhx, pmhx[ c("src_subject_id", "current_diagnosis", "status") ])
  
  # -- create a codified table of PMHx / current dx for each participant to use in analysis
  all.ids <- unique( pmhx$src_subject_id )
  
  pmhx.tab <- data.frame( ID = all.ids, 
                          COPD     = rep(NA, length( all.ids)),
                          DM       = rep(NA, length( all.ids)),
                          HepABC   = rep(NA, length( all.ids)),
                          Lipid    = rep(NA, length( all.ids)),
                          HTN      = rep(NA, length( all.ids)),
                          IHD      = rep(NA, length( all.ids)),
                          OsteoArth= rep(NA, length( all.ids)),
                          Osteopor = rep(NA, length( all.ids)),
                          STI      = rep(NA, length( all.ids))
                        )
  
  for( i in 1:length( pmhx.tab$ID ) ) {
    thisID <- pmhx.tab$ID[i]
    dxs        <- pmhx$current_diagnosis[ which( pmhx$src_subject_id == thisID) ]
    dxs.status <- pmhx$status[ which( pmhx$src_subject_id == thisID) ]
    
    dxs.tab <-  setNames(as.list(dxs.status), dxs)
    
    # because the data is not organised in a consistent fashion, we have to inspect each Dx individually
    pmhx.tab$COPD[i]       <- as.numeric( dxs.tab["Chronic Obstructive Pulmonary Disease"] )
    pmhx.tab$DM[i]         <- as.numeric( dxs.tab["Diabetes (Type I or II)"] )
    pmhx.tab$HepABC[i]     <- as.numeric( dxs.tab["Hepatitis A,B,C"] )
    pmhx.tab$Lipid[i]      <- as.numeric( dxs.tab["Hyperlipidemia"] )
    pmhx.tab$HTN[i]        <- as.numeric( dxs.tab["Hypertension"] )
    pmhx.tab$IHD[i]        <- as.numeric( dxs.tab["Ischemic Heart Disease"] )
    pmhx.tab$OsteoArth[i]  <- as.numeric( dxs.tab["Osteoarthritis"] )
    pmhx.tab$Osteopor[i]   <- as.numeric( dxs.tab["Osteoporosis"] )
    pmhx.tab$STI[i]        <- as.numeric( dxs.tab["Sexually Transmitted Infectious Disease"] )
  }

# 8 -- Keyvars table 
  all_content <- readLines(paste( source.data.path, "keyvars01.txt", sep = ""))
  skip_second <- all_content[-2]
  keyvars    <- read.csv(textConnection(skip_second), header = TRUE, stringsAsFactors = FALSE, sep = "\t")
  
  # -- treatment columns to extract from keyvar
    rx.cols <- c("src_subject_id", "treat_1",  "treat_1a", "treat11a",
                 "dose_1",   "dose_1a",  "treat_1b", "dose_1b", 
                 "treat_2e", "treat_2t", "treat2",
                 "dose_2e", "dose_2t",
                 "treat_31", "treat_32", "treat_3", "lastphas")
  
    subRx <- data.frame( keyvars[ , rx.cols] )
    subRx$ID <- as.numeric( as.character( subRx$src_subject_id ) )
    subRx$LastPhase <- factor( subRx$lastphas )
    # -- nb : we leave keyvars native table in the environment for later use.
  
# -- Tidy up environment
  rm( temp.PANSS.tab )
  rm( skip_second )
  rm( all_content )
  rm( pmhx )

