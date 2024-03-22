library(mrvalidation)
library(magpie4)
library(mrcommons)



calibrate_trade_margins <- function(path_to_full_gms, path_to_fulldata, target_EU_trade_vol, path_to_initial_guess, iterations, path_to_out_dir)  {
  save_EU_TV_iterations <- c()
  save_multiplier_iterations <- c()
  lucode2::manipulateConfig(path_to_full_gms, c80_path_to_initial_values = path_to_initial_guess, s80_load_initial_values =1)
  for(i in 1:iterations) {
      system(paste("gams", path_to_full_gms, "-putDir ", path_to_out_dir), wait = TRUE)

      trade <- gdx::readGDX(path_to_fulldata, "ov21_trade")[,,"level"]
      current_multiplier <- gdx::readGDX(path_to_fulldata, "s21_multiplier_trade_marg")


      cur_EU_trade_vol <- sum(trade[EUreg,,EUreg])
      save_EU_TV_iterations[i] <- cur_EU_trade_vol

      calib_factor <- cur_EU_trade_vol/target_EU_trade_vol

      # dampen the change
      calib_factor <- (calib_factor - 1) * 0.13 + 1 # best 0.13

      new_multiplier <- current_multiplier * calib_factor

      new_multiplier<- unlist(unname(new_multiplier[1]))
      save_multiplier_iterations[i] <- new_multiplier

      lucode2::manipulateConfig(path_to_full_gms, s21_multiplier_trade_marg = new_multiplier)
      print(i)
  }
  return(list(multiplier = save_multiplier_iterations, trade_vol = cur_EU_trade_vol))
}

path_to_out_dir <- "/home/davidho/MAgPIEG/magpieEU/calibrate_EU_trademargins/output/EU_sticky_livestock_trademargins/calib_trademargin_start_2024-02-01_16.40.40"
path_to_full_gms <- file.path(path_to_out_dir, "full.gms")
path_to_fulldata <- file.path(path_to_out_dir, "fulldata.gdx")
path_to_initial_guess <- file.path(path_to_out_dir, "magpie_y1995.gdx")
path_to_regmap <- file.path(path_to_out_dir, "regionmappingEU6.csv")

EUreg <- c("DEU", "EUC", "EUN", "EUS", "EUW")

setwd(path_to_out_dir)
mapping <- madrat::toolGetMapping(path_to_regmap)
FAO_bil <- readRDS("/home/davidho/MAgPIEG/magpie-EU_model_external_things/validationdata/FAOBilUnAGG.rds")

# get reference for intra EU trade volume between EU regions
sum_intra_EU_export <- 0
for(EUexp_reg in EUreg){
  for(EUexp_country in mapping$country[mapping$region == EUexp_reg]) {
    for(EUimp_reg in EUreg[EUreg != EUexp_reg]){
      for(EUimp_country in mapping$country[mapping$region == EUimp_reg]) {
        sum_intra_EU_export <- sum_intra_EU_export + sum(FAO_bil[paste0(EUexp_country,".", EUimp_country), "y1995",])
      }
    }
  }
}

target_EU_trade_vol <- sum_intra_EU_export





list <- calibrate_trade_margins(path_to_full_gms, path_to_fulldata, target_EU_trade_vol, path_to_initial_guess, 10, path_to_out_dir)

saveRDS(list,  "calibration_results.rds")
