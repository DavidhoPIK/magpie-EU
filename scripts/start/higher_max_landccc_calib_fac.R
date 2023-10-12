# |  (C) 2008-2023 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# ------------------------------------------------
# description: start run with default.cfg settings
# position: 1
# ------------------------------------------------

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

source("config/default.cfg")

cfg$recalibrate <- FALSE # no yield calibration
# make sure that the calibration file is not present
if (file.exists("modules/14_yields/input/f14_yld_calib.csv")) file.remove("modules/14_yields/input/f14_yld_calib.csv")
# also delete a dummy file; success of deletion can be checked in the end
if (file.exists("modules/14_yields/input/dummy.txt")) file.remove("modules/14_yields/input/dummy.txt")

cfg$recalibrate_landconversion_cost <- TRUE
cfg$cost_calib_max_landconversion_cost <- 4 # def = 3

#start MAgPIE run
start_run(cfg, codeCheck=FALSE)
