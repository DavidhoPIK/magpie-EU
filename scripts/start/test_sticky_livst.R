# |  (C) 2008-2018 Potsdam Institute for Climate Impact Research (PIK),
# |  authors, and contributors see AUTHORS file
# |  This file is part of MAgPIE and licensed under GNU AGPL Version 3
# |  or later. See LICENSE file or go to http://www.gnu.org/licenses/
# |  Contact: magpie@pik-potsdam.de


library(lucode2)
library(gms)
source("scripts/start_functions.R")
source("config/default.cfg")


# Calibrate yields
cfg$recalibrate <- FALSE
cfg$recalibrate_landconversion_cost <- FALSE

cfg$title <- "sticky_livestock_regional"
cfg$gms$c_timesteps <- "quicktest"

cfg$gms$livestock <- "fbask_jan16_sticky_regional"

start_run(cfg, codeCheck=TRUE)
