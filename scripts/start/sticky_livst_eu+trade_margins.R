
library(lucode2)
library(gms)
source("scripts/start_functions.R")
source("scripts/performance_test.R")
source("config/default.cfg")


cfg$force_download <- TRUE  # force redownload of input data
cfg$recalc_npi_ndc <- TRUE  # force recalculation of npi ncd policies

# No calibration
cfg$recalibrate <- FALSE
cfg$recalibrate_landconversion_cost <- FALSE


cfg$output <- c("rds_report")       # generate rds files for report
cfg$results_folder <- paste0("output/EU_sticky_livsestock_trademargins/:title::date:")


# EU standard with sticky livst
cfg$input <- c(regional    = "rev4.89h16s5_David_EU_1028489d_magpie.tgz",
               cellular    = "rev4.89h16s5_David_EU_1028489d_bd86374e_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1_clusterweight-ba4466a8.tgz",
               validation  = "rev4.89h16s5_David_EU_1028489d_validation.tgz",
               additional  = "additional_data_rev4.45.tgz")
cfg$title  <- "h16s5DnC"
cfg        <- setScenario(cfg,c("SSP2", "NDC", "ForestryEndo"))
cfg$gms$s13_ignore_tau_historical <- 1
cfg$gms$factor_costs <- "sticky_feb18"
cfg$gms$livestock <- "fbask_jan16_sticky_regional"
cfg$title  <- "sticky_LS_m2"
cfg$gms$s70_multiplicator_capital_need <- 2
#start_run(cfg,codeCheck=FALSE)

# ---- EU standard with sticky livst and bilateral trade (only margins)
# patch trade tariffs such that inter EU trade has not tariffs
cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL,
                                "./patch_inputdata"=NULL),
                           getOption("magpie_repos"))

cfg$input <- c(regional    = "rev4.89h16s5_David_EU_1028489d_magpie.tgz",
               cellular    = "rev4.89h16s5_David_EU_1028489d_bd86374e_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1_clusterweight-ba4466a8.tgz",
               validation  = "rev4.89h16s5_David_EU_1028489d_validation.tgz",
               additional  = "additional_data_rev4.45.tgz",
               patch       = "patchTradeTarriffs.tgz")
cfg$title  <- "sticky_LS_m2_trademargins"
cfg$gms$trade <- "selfsuff_reduced_bilateral22"
#start_run(cfg,codeCheck=FALSE)

# fix q21_trade_bilateral equation 
cfg$title  <- "sticky_LS_m2_trademargins_fix_q21_trade_b"
#start_run(cfg,codeCheck=FALSE)


# ---- EU standard with sticky livst and bilateral trade (including tariffs)

cfg$input <- c(regional    = "rev4.89h16s5_David_EU_1028489d_magpie.tgz",
               cellular    = "rev4.89h16s5_David_EU_1028489d_bd86374e_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1_clusterweight-ba4466a8.tgz",
               validation  = "rev4.89h16s5_David_EU_1028489d_validation.tgz",
               additional  = "additional_data_rev4.45.tgz") # no patched input
cfg$title  <- "sticky_LS_m2_trademarginsAndTariffsfix"
cfg$gms$trade <- "selfsuff_reduced_bilateral22"
#start_run(cfg,codeCheck=FALSE)

# ---- MCP JAMS reformualtion
cfg$title  <- "sticky_LS_m2_trademarginsAndTariffsfix_MCP_JAMS_reformualtion"
#start_run(cfg,codeCheck=FALSE)

# ---- MCP JAMS reformualtion few timestep
cfg$title  <- "sticky_MCP_test"
cfg$gms$c_timesteps <- 2
start_run(cfg,codeCheck=FALSE)
