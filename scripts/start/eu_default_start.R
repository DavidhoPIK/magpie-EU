
library(lucode2)
library(gms)
source("scripts/start_functions.R")
source("scripts/performance_test.R")
source("config/default.cfg")


cfg$force_download <- TRUE  # force redownload of input data
cfg$recalc_npi_ndc <- FALSE  # force recalculation of npi ncd policies

cfg$output <- c("rds_report")       # generate rds files for report
cfg$results_folder <- paste0("output/EU_default_run/:title::date:")

# use no calibration
cfg$recalibrate <- FALSE
cfg$recalibrate_landconversion_cost <- FALSE

# default scenario 
cfg        <- setScenario(cfg,c("SSP2", "NDC", "ForestryEndo"))

cfg$gms$s13_ignore_tau_historical <- 1 # is default

# sticky crop factor cost and sticky livstock costs
cfg$gms$factor_costs <- "sticky_feb18"
cfg$gms$livestock <- "fbask_jan16_sticky_regional"
cfg$gms$s70_multiplicator_capital_need <- 2

# use no intra EU trade tarrifs but margings
cfg$gms$trade <- "selfsuff_reduced_bilateral22"
cfg$gms$s21_intra_supreg_tariff <- 0
cfg$gms$s21_multiplier_trade_marg <- 2 


 # add patched input data folder
 cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL,
                                 "./patched_input"=NULL),
                            getOption("magpie_repos"))

 # input data to be used
 cfg$input <- c(regional    = "rev4.101h16s5_David_EU3_1028489d_magpie.tgz",
                cellular    = "rev4.101h16s5_David_EU3_1028489d_84b4b948_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1_clusterweight-4deb493c.tgz",
                validation  = "rev4.101h16s5_David_EU3_1028489d_validation.tgz",
                additional  = "additional_data_rev4.48.tgz",
                patch       = c("patchFeedBaskets.tgz", "patchPastrTauHist.tgz")  ) # patch with uninform feed baskets in the EU



cfg$title  <- "default_eu_run"
start_run(cfg,codeCheck=FALSE)