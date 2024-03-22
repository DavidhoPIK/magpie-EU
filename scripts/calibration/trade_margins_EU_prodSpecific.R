library(mrvalidation)
library(magpie4)
library(mrcommons)

path_to_model_folder <- "/home/davidho/MAgPIEG/magpieEU/calibrate_EU_trademargins2"

calibrate_trade_margins_prod_specific <- function(path_to_out_dir, path_to_model_folder, path_to_initial_guess, target_EU_trade_vol, number_iterations)  {

  EUreg <- c("DEU", "EUC", "EUN", "EUS", "EUW")
  calib_magpie_name <- "trade_calib"
  filename_calib_gms <- paste0(calib_magpie_name, ".gms")
  fulldata_gdx <- "fulldata.gdx"
  filename_main_gms <- "main.gms"
  path_to_margins <- paste0(path_to_model_folder, "/modules/21_trade/selfsuff_reduced_bilateral22/input/f21_trade_margin_bilat.cs5")
  putfolder <- file.path(path_to_model_folder, "calib_magpie_name")
  setwd(path_to_model_folder)
  
  save_EU_TV_iterations <- list()
  save_multiplier_iterations <- list()
  for(i in 1:20) {

      unlink(filename_calib_gms)
      unlink(fulldata_gdx)
      unlink(putfolder, recursive = TRUE)
      dir.create(putfolder)

      if (!file.copy(filename_main_gms, filename_calib_gms)) {
        stop(paste("Unable to create", filename_calib_gms))
      }
      lucode2::manipulateConfig(filename_calib_gms, c_timesteps = 1)
      lucode2::manipulateConfig(filename_calib_gms, s_use_gdx = 2)
      
      file.copy(filename_calib_gms, putfolder)

      system(paste0("gams ", filename_calib_gms), wait = TRUE)

      trade <- gdx::readGDX(fulldata_gdx, "ov21_trade")
      total_interEU_region_flow <- collapseDim(dimSums(dimSums(trade[EUreg,,EUreg], dim=1), dim = 3.1)[,,"level"])

      kcr <- getItems(target_EU_trade_vol, split=T)[3][[1]][[1]]

      calib_factor <- total_interEU_region_flow[,,kcr]/target_EU_trade_vol
      current_margins <- read.magpie(path_to_margins)

      save_EU_TV_iterations[[i]] <- total_interEU_region_flow
      save_multiplier_iterations[[i]] <- calib_factor

      # dampen the change
      calib_factor <- (calib_factor - 1) * 0.13 + 1 # best 0.13

      new_margins <- current_margins

      new_margins[,,kcr] <- current_margins[,,kcr] * calib_factor

      write.magpie(new_margins, path_to_margins)


      print("i: ")
      print(i)
  }
  return(list(multiplier = save_multiplier_iterations, trade_vol = cur_EU_trade_vol))
}

path_to_out_dir <- "/home/davidho/MAgPIEG/magpieEU/calibrate_EU_trademargins_old2/output/testTradeMargCalib/toy_bilateral_EU_2024-01-31_16.28.27"
path_to_initial_guess <- file.path(path_to_out_dir, "magpie_y1995.gdx")
path_to_regmap <- file.path(path_to_out_dir, "regionmappingEU6.csv")

path_to_margins <- "/home/davidho/MAgPIEG/magpieEU/calibrate_EU_trademargins/modules/21_trade/input/f21_trade_margin.cs3"
EUreg <- c("DEU", "EUC", "EUN", "EUS", "EUW")

mapping <- madrat::toolGetMapping(path_to_regmap)

madrat::setConfig(regionmapping = path_to_regmap)


FAO_bil <- readRDS("/home/davidho/MAgPIEG/magpie-EU_model_external_things/validationdata/FAOBilUnAGG.rds")

# get reference for intra EU trade volume between EU regions
sum_intra_EU_export <- 0
for(EUexp_reg in EUreg ){
  for(EUexp_country in mapping$country[mapping$region == EUexp_reg]) {
    for(EUimp_reg in EUreg[EUreg != EUexp_reg]){
      for(EUimp_country in mapping$country[mapping$region == EUimp_reg]) {
        sum_intra_EU_export <- sum_intra_EU_export + collapseDim(FAO_bil[paste0(EUexp_country,".", EUimp_country), "y1995",])
      }
    }
  }
}

target_EU_trade_vol <- sum_intra_EU_export

list <- calibrate_trade_margins_prod_specific(path_to_full_gms, path_to_fulldata, target_EU_trade_vol, path_to_initial_guess, 10, path_to_out_dir, path_to_margins)

saveRDS(list,  "calibration_results.rds")

