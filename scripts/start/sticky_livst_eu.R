
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
cfg$results_folder <- paste0("output/EU_sticky_livst_comp/:title::date:")


# develop standard
cfg$input <- c(regional    = "rev4.89h16s5_David_EU_1028489d_magpie.tgz",
               cellular    = "rev4.89h16s5_David_EU_1028489d_bd86374e_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1_clusterweight-ba4466a8.tgz",
               validation  = "rev4.89h16s5_David_EU_1028489d_validation.tgz",
               additional  = "additional_data_rev4.45.tgz")
cfg$title  <- "h16s5DnC"
cfg        <- setScenario(cfg,c("SSP2", "NDC", "ForestryEndo"))
cfg$gms$s13_ignore_tau_historical <- 1
cfg$gms$factor_costs <- "sticky_feb18"
cfg$gms$livestock <- "fbask_jan16"
start_run(cfg,codeCheck=FALSE)

# develop sticky livst m2
cfg$gms$livestock <- "fbask_jan16_sticky_regional"
cfg$title  <- "h16s5DnC_stLS_m2"
cfg$gms$s70_multiplicator_capital_need <- 2
#start_run(cfg,codeCheck=FALSE)

# develop sticky livst m4
cfg$gms$livestock <- "fbask_jan16_sticky_regional"
cfg$title  <- "h16s5DnC_stLS_m4"
cfg$gms$s70_multiplicator_capital_need <- 4
#start_run(cfg,codeCheck=FALSE)

# develop sticky livst m10
cfg$gms$livestock <- "fbask_jan16_sticky_regional"
cfg$title  <- "h16s5DnC_stLS_m10"
cfg$gms$s70_multiplicator_capital_need <- 10
#start_run(cfg,codeCheck=FALSE)

# develop sticky livst m10 disagg lvst off
cfg$gms$livestock <- "fbask_jan16_sticky_regional"
cfg$title  <- "h16s5DnC_stLS_m10_dis_livst_off"
cfg$gms$s70_multiplicator_capital_need <- 10
cfg$gms$s70_disaggregate_livestock <- FALSE
#start_run(cfg,codeCheck=FALSE)

