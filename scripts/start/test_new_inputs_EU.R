# |  (C) 2008-2018 Potsdam Institute for Climate Impact Research (PIK),
# |  authors, and contributors see AUTHORS file
# |  This file is part of MAgPIE and licensed under GNU AGPL Version 3
# |  or later. See LICENSE file or go to http://www.gnu.org/licenses/
# |  Contact: magpie@pik-potsdam.de


############################################################
#### Script for the generation of COACCH simulations ####
############################################################

library(lucode2)
library(gms)
source("scripts/start_functions.R")
source("scripts/performance_test.R")
source("config/default.cfg")


codeCheck <- FALSE          # avoid code check


cfg$force_download <- TRUE  # force redownload of input data
cfg$recalc_npi_ndc <- TRUE  # force recalculation of npi ncd policies

# Calibrate yields
cfg$recalibrate <- TRUE
cfg$calib_accuracy <- 0.05         # def = 0.05
cfg$calib_maxiter <- 10            # def = 20
cfg$damping_factor <- 0.98         # def= 0.96

# Calibrate land conversion costs
cfg$recalibrate_landconversion_cost <- TRUE
cfg$calib_accuracy_landconversion_cost <- 0.15 # 0.05 default
cfg$calib_maxiter_landconversion_cost <- 10    # def = 40
cfg$restart_landconversion_cost <- FALSE       # FALSE default
cfg$damping_factor_landconversion_cost <- 0.98 # 0.96 default   


cfg$gms$s80_maxiter <- 5            # def = 30; max number of iterations for optimisation
cfg$output <- c("rds_report")       # generate rds files for report
cfg$results_folder <- paste0("output/v4p81/:title::date:")
# title_flag <- "_marginEU"

cfg$gms$c_timesteps <- "coup2100"    # is default


# ---- H12
cfg$input <- c(regional    = "rev4.89h12_David_EU_h12_magpie.tgz",
               cellular    = "rev4.89h12_David_EU_h12_fd712c0b_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1.tgz",
               validation  = "rev4.89h12_400_David_EU_h12_validation.tgz",
               additional  = "additional_data_rev4.45.tgz")    # input data preprocessed for intended run

cfg$title  <- "h12"
cfg        <- setScenario(cfg,c("SSP2","NDC", "ForestryEndo")) # scenario defintion
cfg$gms$s13_ignore_tau_historical <- 1                         # def = 1
cfg$gms$factor_costs <- "sticky_feb18"                         # factor costs including investments in capital, def = per_ton_fao_may22
# start_run(cfg,codeCheck=FALSE)
# magpie4::submitCalibration(name = "h12")

# ---- H12_c400
cfg$input <- c(regional    = "rev4.89h12_400_David_EU_h12_magpie.tgz",
               cellular    = "rev4.89h12_400_David_EU_h12_a1382656_cellularmagpie_c400_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1_clusterweight-64eeb500.tgz",
               validation  = "rev4.89h12_400_David_EU_h12_validation.tgz",
               additional  = "additional_data_rev4.45.tgz")

cfg$title  <- "h12_c400"
cfg        <- setScenario(cfg,c("SSP2","NDC", "ForestryEndo"))
cfg$gms$s13_ignore_tau_historical <- 1
cfg$gms$factor_costs <- "sticky_feb18"  
#start_run(cfg,codeCheck=FALSE)
#magpie4::submitCalibration(name = "h12_c400")

# ---- H16
cfg$input <- c(regional    = "rev4.89h16_David_EU_36f73207_magpie.tgz",
               cellular    = "rev4.89h16_David_EU_36f73207_bd86374e_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1_clusterweight-ba4466a8.tgz",
               validation  = "rev4.89h16_David_EU_36f73207_validation.tgz",
               additional  = "additional_data_rev4.45.tgz")

cfg$title  <- "h16"
cfg        <- setScenario(cfg,c("SSP2","NDC", "ForestryEndo"))
cfg$gms$s13_ignore_tau_historical <- 1
cfg$gms$factor_costs <- "sticky_feb18"  
#start_run(cfg,codeCheck=FALSE)
#magpie4::submitCalibration(name = "h16")

# ---- H16S5
cfg$input <- c(regional    = "rev4.89h16s5_David_EU_1028489d_magpie.tgz",
               cellular    = "rev4.89h16s5_David_EU_1028489d_bd86374e_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1_clusterweight-ba4466a8.tgz",
               validation  = "rev4.89h16s5_David_EU_1028489d_validation.tgz",
               additional  = "additional_data_rev4.45.tgz")

cfg$title  <- "h16s5"
cfg        <- setScenario(cfg,c("SSP2","NDC", "ForestryEndo"))
cfg$gms$s13_ignore_tau_historical <- 1
cfg$gms$factor_costs <- "sticky_feb18"  
#start_run(cfg,codeCheck=FALSE)
#magpie4::submitCalibration(name = "h16s5")



cfg$title  <- "h16s5"
cfg        <- setScenario(cfg,c("SSP2","NDC", "ForestryEndo"))
cfg$gms$s13_ignore_tau_historical <- 1
cfg$gms$factor_costs <- "sticky_feb18"  
start_run(cfg,codeCheck=FALSE)
magpie4::submitCalibration(name = "h16s5")

# # Free trade runs
# cfg$title  <- "ssp2_h11e5_free_trade_uncalib"
# # cfg$title  <- "ssp2_h16_free_trade_uncalib"
# cfg        <- setScenario(cfg,c("SSP2","NDC", "ForestryEndo"))
# cfg$gms$s13_ignore_tau_historical <- 1
# cfg$gms$factor_costs <- "sticky_feb18"
# cfg$gms$trade <- "free_apr16"  
# start_run(cfg,codeCheck=FALSE)
# # magpie4::submitCalibration(name = "h11e5_1028489d")



# cfg$title  <- "ssp2_16eu_fallow_penal"
# cfg        <- setScenario(cfg,c("SSP2","NDC", "ForestryEndo"))
# cfg$gms$s13_ignore_tau_historical <- 1
# cfg$gms$factor_costs <- "sticky_feb18"  
# cfg$gms$crop <- "penalty_apr22"
# cfg$gms$c30_rotation_scenario <- "default"
# cfg$gms$c30_rotation_scenario_speed <- "by2050"
# cfg$gms$c30_marginal_land <- "q33_marginal"
# start_run(cfg,codeCheck=FALSE)
# magpie4::submitCalibration(name = "h16eu_penalty")


# cfg$title  <- "eat_deu"
# cfg        <- setScenario(cfg,c("SSP2","NDC", "ForestryEndo"))
# cfg$gms$s13_ignore_tau_historical <- 1
# cfg$gms$factor_costs <- "sticky_feb18"  
# # eat-lancet for germany
# cfg$gms$s15_exo_diet <- 1
# cfg$gms$scen_countries15  <- "DEU" 
# start_run(cfg,codeCheck=FALSE)
