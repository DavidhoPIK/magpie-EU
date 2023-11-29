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

# Do not calibrate yields
cfg$recalibrate <- FALSE

# Calibrate land conversion costs
cfg$calib_accuracy_landconversion_cost <- 0.15 # 0.05 default
cfg$calib_maxiter_landconversion_cost <- 10    # def = 40
cfg$restart_landconversion_cost <- FALSE       # FALSE default
cfg$damping_factor_landconversion_cost <- 0.98 # 0.96 default   


cfg$gms$s80_maxiter <- 5            # def = 30; max number of iterations for optimisation
cfg$output <- c("rds_report")       # generate rds files for report
cfg$results_folder <- paste0("output/v4p81/:title::date:")
# title_flag <- "_marginEU"

cfg$gms$c_timesteps <- "coup2100"    # is default

# ----------- With land use conversion costs calibration
cfg$recalibrate_landconversion_cost <- TRUE
# # ---- H12
# cfg$input <- c(regional    = "rev4.89h12_David_EU_h12_magpie.tgz",
#                cellular    = "rev4.89h12_David_EU_h12_fd712c0b_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1.tgz",
#                validation  = "rev4.89h12_400_David_EU_h12_validation.tgz",
#                additional  = "additional_data_rev4.45.tgz")    # input data preprocessed for intended run

# cfg$title  <- "h12_no_yield_calib"
# cfg        <- setScenario(cfg,c("SSP2", "NDC", "ForestryEndo")) # scenario defintion
# cfg$gms$s13_ignore_tau_historical <- 1                         # def = 1
# cfg$gms$factor_costs <- "sticky_feb18"                         # factor costs including investments in capital, def = per_ton_fao_may22
# #start_run(cfg,codeCheck=FALSE)

# # ---- H12_c400
# cfg$input <- c(regional    = "rev4.89h12_400_David_EU_h12_magpie.tgz",
#                cellular    = "rev4.89h12_400_David_EU_h12_a1382656_cellularmagpie_c400_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1_clusterweight-64eeb500.tgz",
#                validation  = "rev4.89h12_400_David_EU_h12_validation.tgz",
#                additional  = "additional_data_rev4.45.tgz")

# cfg$title  <- "h12_c400_no_yield_calib"
# cfg        <- setScenario(cfg,c("SSP2", "NDC", "ForestryEndo"))
# cfg$gms$s13_ignore_tau_historical <- 1
# cfg$gms$factor_costs <- "sticky_feb18"
# #start_run(cfg,codeCheck=FALSE)

# # ---- H16
# cfg$input <- c(regional    = "rev4.89h16_David_EU_36f73207_magpie.tgz",
#                cellular    = "rev4.89h16_David_EU_36f73207_bd86374e_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1_clusterweight-ba4466a8.tgz",
#                validation  = "rev4.89h16_David_EU_36f73207_validation.tgz",
#                additional  = "additional_data_rev4.45.tgz")

# cfg$title  <- "h16_no_yield_calib"
# cfg        <- setScenario(cfg,c("SSP2", "NDC", "ForestryEndo"))
# cfg$gms$s13_ignore_tau_historical <- 1
# cfg$gms$factor_costs <- "sticky_feb18"  
# #start_run(cfg,codeCheck=FALSE)

# # ---- H16S5
# cfg$input <- c(regional    = "rev4.89h16s5_David_EU_1028489d_magpie.tgz",
#                cellular    = "rev4.89h16s5_David_EU_1028489d_bd86374e_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1_clusterweight-ba4466a8.tgz",
#                validation  = "rev4.89h16s5_David_EU_1028489d_validation.tgz",
#                additional  = "additional_data_rev4.45.tgz")

# cfg$title  <- "h16s5_no_yield_calib"
# cfg        <- setScenario(cfg,c("SSP2", "NDC", "ForestryEndo"))
# cfg$gms$s13_ignore_tau_historical <- 1
# cfg$gms$factor_costs <- "sticky_feb18"  
# #start_run(cfg,codeCheck=FALSE)


# ----------- Without any calibration
cfg$recalibrate_landconversion_cost <- FALSE
# # ---- H12
# cfg$input <- c(regional    = "rev4.89h12_David_EU_h12_magpie.tgz",
#                cellular    = "rev4.89h12_David_EU_h12_fd712c0b_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1.tgz",
#                validation  = "rev4.89h12_400_David_EU_h12_validation.tgz",
#                additional  = "additional_data_rev4.45.tgz")    # input data preprocessed for intended run

# cfg$title  <- "h12_no_yield_and_landconversion_cost_calib"
# cfg        <- setScenario(cfg,c("SSP2", "NDC", "ForestryEndo")) # scenario defintion
# cfg$gms$s13_ignore_tau_historical <- 1                         # def = 1
# cfg$gms$factor_costs <- "sticky_feb18"                         # factor costs including investments in capital, def = per_ton_fao_may22
# #start_run(cfg,codeCheck=FALSE)

# # ---- H12 new cluster distribution
# cfg$input <- c(regional    = "rev4.89h12_David_EU_more_EU_weight_h12_magpie.tgz",
#                cellular    = "rev4.89h12_David_EU_more_EU_weight_h12_7a275ad3_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1_clusterweight-a277e803.tgz",
#                validation  = "rev4.89h12_David_EU_more_EU_weight_h12_validation.tgz",
#                additional  = "additional_data_rev4.45.tgz")    # input data preprocessed for intended run

# cfg$title  <- "h12_no_yield_and_landconversion_cost_calib_new_cluster"
# cfg        <- setScenario(cfg,c("SSP2", "NDC", "ForestryEndo")) # scenario defintion
# cfg$gms$s13_ignore_tau_historical <- 1                         # def = 1
# cfg$gms$factor_costs <- "sticky_feb18"                         # factor costs including investments in capital, def = per_ton_fao_may22
# #start_run(cfg,codeCheck=FALSE)

# # ---- H16S5
# cfg$input <- c(regional    = "rev4.89h16s5_David_EU_1028489d_magpie.tgz",
#                cellular    = "rev4.89h16s5_David_EU_1028489d_bd86374e_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1_clusterweight-ba4466a8.tgz",
#                validation  = "rev4.89h16s5_David_EU_1028489d_validation.tgz",
#                additional  = "additional_data_rev4.45.tgz")

# cfg$title  <- "h16s5_no_yield_and_landconversion_cost_calib"
# cfg        <- setScenario(cfg,c("SSP2", "NDC", "ForestryEndo"))
# cfg$gms$s13_ignore_tau_historical <- 1
# cfg$gms$factor_costs <- "sticky_feb18"
# #start_run(cfg,codeCheck=FALSE)

# # ---- H16
# cfg$input <- c(regional    = "rev4.89h16_David_EU_36f73207_magpie.tgz",
#                cellular    = "rev4.89h16_David_EU_36f73207_bd86374e_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1_clusterweight-ba4466a8.tgz",
#                validation  = "rev4.89h16_David_EU_36f73207_validation.tgz",
#                additional  = "additional_data_rev4.45.tgz")

# cfg$title  <- "h16_no_calib"
# cfg        <- setScenario(cfg,c("SSP2", "NDC", "ForestryEndo"))
# cfg$gms$s13_ignore_tau_historical <- 1
# cfg$gms$factor_costs <- "sticky_feb18"  
# #start_run(cfg,codeCheck=FALSE)

# ------------ bilateral trade realization

# # ---- H16
# cfg$input <- c(regional    = "rev4.89h16_David_EU_36f73207_magpie.tgz",
#                cellular    = "rev4.89h16_David_EU_36f73207_bd86374e_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1_clusterweight-ba4466a8.tgz",
#                validation  = "rev4.89h16_David_EU_36f73207_validation.tgz",
#                additional  = "additional_data_rev4.45.tgz")

# cfg$title  <- "h16_no_calib_bilateral_trade"
# cfg        <- setScenario(cfg,c("SSP2", "NDC", "ForestryEndo"))
# cfg$gms$s13_ignore_tau_historical <- 1
# cfg$gms$factor_costs <- "sticky_feb18"  
# #cfg$gms$trade <- "selfsuff_reduced_bilateral22"
# #start_run(cfg,codeCheck=FALSE)


# # # ---- H16S5
# cfg$input <- c(regional    = "rev4.89h16s5_David_EU_1028489d_magpie.tgz",
#                cellular    = "rev4.89h16s5_David_EU_1028489d_bd86374e_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1_clusterweight-ba4466a8.tgz",
#                validation  = "rev4.89h16s5_David_EU_1028489d_validation.tgz",
#                additional  = "additional_data_rev4.45.tgz")

# cfg$title  <- "h16s5_no_calib_bilateral_trade"
# cfg        <- setScenario(cfg,c("SSP2", "NDC", "ForestryEndo"))
# cfg$gms$s13_ignore_tau_historical <- 1
# cfg$gms$factor_costs <- "sticky_feb18"
# cfg$gms$trade <- "selfsuff_reduced_bilateral22"
# start_run(cfg,codeCheck=FALSE) # produces error

# # set back to default
# cfg$gms$trade <- "selfsuff_reduced"

# ------ uniform EU feedbaskets

 # ---- H16S5 
# cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL,
#                                 "./patched_input"=NULL),
#                            getOption("magpie_repos"))

# cfg$input <- c(regional    = "rev4.89h16s5_David_EU_1028489d_magpie.tgz",
#                cellular    = "rev4.89h16s5_David_EU_1028489d_bd86374e_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1_clusterweight-ba4466a8.tgz",
#                validation  = "rev4.89h16s5_David_EU_1028489d_validation.tgz",
#                additional  = "additional_data_rev4.45.tgz",
#                patch       = "patchFeedBaskets.tgz")

# cfg$title  <- "h16s5_no_calib_EU_uniform_feedbaskets"
# cfg        <- setScenario(cfg,c("SSP2","NDC", "ForestryEndo"))
# cfg$gms$s13_ignore_tau_historical <- 1
# cfg$gms$factor_costs <- "sticky_feb18"  
# start_run(cfg, codeCheck=FALSE)

# Sticky livestock 

# ---- H16S5
cfg$input <- c(regional    = "rev4.89h16s5_David_EU_1028489d_magpie.tgz",
               cellular    = "rev4.89h16s5_David_EU_1028489d_bd86374e_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1_clusterweight-ba4466a8.tgz",
               validation  = "rev4.89h16s5_David_EU_1028489d_validation.tgz",
               additional  = "additional_data_rev4.45.tgz")

cfg$title  <- "h16s5_no_calib_sticky_livestock"
cfg        <- setScenario(cfg,c("SSP2", "NDC", "ForestryEndo"))
cfg$gms$s13_ignore_tau_historical <- 1
cfg$gms$factor_costs <- "sticky_feb18"
cfg$gms$livestock <- "fbask_jan16_sticky"
# start_run(cfg,codeCheck=FALSE)

# ---- H16S5 regional sticky livestock
cfg$gms$livestock <- "fbask_jan16_sticky_regional"
cfg$title  <- "h16s5_no_calib_sticky_livestock_regional_ext_EUav_cap_need"
start_run(cfg,codeCheck=FALSE)


# ---- H16S5 regional sticky livestock no disagg no sticky normal
cfg$gms$livestock <- "fbask_jan16_sticky_regional"
cfg$title  <- "h16s5_noC_sticky_livst_reg_a_o_off_qT_high_cap_need"
cfg$gms$factor_costs <- "per_ton_fao_may22"
cfg$gms$disagg_lvst <- "off"
cfg$gms$c_timesteps <- "quicktest"
#start_run(cfg,codeCheck=FALSE)

# ---- H16S5 regional sticky livestock no disagg no sticky normal full run
cfg$gms$livestock <- "fbask_jan16_sticky_regional"
cfg$title  <- "h16s5_noC_sticky_livst_reg_a_o_off"
cfg$gms$factor_costs <- "per_ton_fao_may22"
cfg$gms$disagg_lvst <- "off"
cfg$gms$c_timesteps <- "coup2100"
#start_run(cfg,codeCheck=FALSE)