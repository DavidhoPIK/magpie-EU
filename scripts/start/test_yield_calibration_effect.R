# |  (C) 2008-2023 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# ------------------------------------------------
# description: test effect of yield calibration for different model settings
# position: 1
# ------------------------------------------------

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

##### helper functions 
makeSureThereIsNoLandccCalib <- function(cfg){
    cfg$recalibrate_landconversion_cost <- FALSE
    # make sure that the calibration file is not present
    if (file.exists("modules/39_landconversion/input/f39_calib.csv")) file.remove("modules/39_landconversion/input/f39_calib.csv")
    # also delete a dummy file; success of deletion can be checked in the end
    if (file.exists("modules/39_landconversion/input/dummy.txt")) file.remove("modules/39_landconversion/input/dummy.txt")
    return(cfg)
}

makeSureThereIsYieldCalibration <- function(cfg){
    cfg$recalibrate <- TRUE
    return(cfg)
}

resetConfigToDefault <- function(){
    source("config/default.cfg")
    return(cfg)
}

prepareRunWithYieldCalibration <- function(){
    cfg <- resetConfigToDefault()
    cfg <- makeSureThereIsNoLandccCalib(cfg)
    cfg <- makeSureThereIsYieldCalibration(cfg)
    return(cfg)
}

startRunAndSubmitCalibration <- function(cfg){
    if(cfg$recalibrate == TRUE){
      cfg$title <- paste0(cfg$title, "--with_yld_calib")
    } else if (cfg$recalibrate == TRUE) {
      cfg$title <- paste0(cfg$title, "--without_yld_calib")
    }
    start_run(cfg, codeCheck=FALSE)
    magpie4::submitCalibration(
        name = paste0("yield_calibtration_testing_DavidH_", cfg$title),
        file = c("modules/14_yields/input/f14_yld_calib.csv")
        )
}

##### runs with yield calibration 
# default settings
cfg <- prepareRunWithYieldCalibration()
cfg$title <- "default_settings"
#startRunAndSubmitCalibration(cfg)

# s14_calib_ir2rf off
cfg <- prepareRunWithYieldCalibration()
cfg$title <- "yields--s14_calib_ir2rf--off"
cfg$gms$s14_calib_ir2rf <- 0
#startRunAndSubmitCalibration(cfg)$title

# crop realizations
cfg <- prepareRunWithYieldCalibration()
cfg$title <- "crop--rotation_apr22"
cfg$gms$crop <- "rotation_apr22"
#startRunAndSubmitCalibration(cfg)

cfg <- prepareRunWithYieldCalibration()
cfg$title <- "crop--penalty_apr22"
cfg$gms$crop <- "penalty_apr22"
#startRunAndSubmitCalibration(cfg)

# pasture realizations
cfg <- prepareRunWithYieldCalibration()
cfg$title <- "pasture--grasslands_apr22"
cfg$gms$past <- "grasslands_apr22"
#startRunAndSubmitCalibration(cfg)

cfg <- prepareRunWithYieldCalibration()
cfg$title <- "pasture--static"
cfg$gms$past <- "static"
#startRunAndSubmitCalibration(cfg)   # Errors, see: test_yield_calibration_effect-28271299.out

# factor cost realizations
cfg <- prepareRunWithYieldCalibration()
cfg$title <- "factor_costs--sticky_feb18"
cfg$gms$factor_costs <- "sticky_feb18"
startRunAndSubmitCalibration(cfg)

cfg <- prepareRunWithYieldCalibration()
cfg$title <- "factor_cost--sticky_labor"
cfg$gms$factor_costs <- "sticky_labor"
startRunAndSubmitCalibration(cfg)

# c38_fac_req
cfg <- prepareRunWithYieldCalibration()
cfg$title <- "factor_cost--c38_fac_req--reg--per_ton_fao_may22"
cfg$gms$c38_fac_req <- "reg"
startRunAndSubmitCalibration(cfg)

cfg <- prepareRunWithYieldCalibration()
cfg$title <- "factor_cost--c38_fac_req--reg--sticky_labor"
cfg$gms$c38_fac_req <- "reg"
cfg$gms$factor_costs <- "sticky_labor"
startRunAndSubmitCalibration(cfg)

# h16 input
cfg <- prepareRunWithYieldCalibration()
cfg$title <- "input--h16"
cfg$input <- c(regional    = "rev4.89h16_David_EU_36f73207_magpie.tgz",
               cellular    = "rev4.89h16_David_EU_36f73207_bd86374e_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1_clusterweight-ba4466a8.tgz",
               validation  = "rev4.89h16_David_EU_36f73207_validation.tgz",
               additional  = "additional_data_rev4.45.tgz")
startRunAndSubmitCalibration(cfg)
