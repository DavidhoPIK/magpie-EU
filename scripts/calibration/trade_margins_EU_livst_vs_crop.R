# calibrate trademargins, single factor for crop and for livestock
# is converging


library(mrvalidation)
library(magpie4)
library(mrcommons)


calibrate_trade_margins_prod_specific <- function(path_to_model_folder, target_EU_trade_vol, number_iterations, dampening = 0.09, prod_specific = 2)  {

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
  for(i in 1:number_iterations) {

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

      trade <- gdx::readGDX(fulldata_gdx, "ov21_trade", temporal = 2, spatial = 2)
      total_interEU_region_flow <- collapseDim(dimSums(dimSums(trade[EUreg,,EUreg], dim=1), dim = 3.1)[,,"level"])

      items <- getItems(target_EU_trade_vol, split=T)[3][[1]][[1]]

      if(prod_specific == 2) {
        calib_factor <- total_interEU_region_flow[,,items]/target_EU_trade_vol
      }
      else if(prod_specific == 0) {
         calib_factor <- sum(total_interEU_region_flow[,,items]) / sum(target_EU_trade_vol)
      } else if(prod_specific == 1) {
        kcr <- intersect(magpiesets::findset("kcr"), items)
        kli <- magpiesets::findset("kli")
        calib_factor_livs <-  sum(total_interEU_region_flow[,,kli]) / sum(target_EU_trade_vol[,,kli])
        calib_factor_crop <-  sum(total_interEU_region_flow[,,kcr]) / sum(target_EU_trade_vol[,,kcr])

      }

      current_margins <- read.magpie(path_to_margins)
      save_EU_TV_iterations[[i]] <- total_interEU_region_flow[,,items]


      if(prod_specific != 1) {
        save_multiplier_iterations[[i]] <- calib_factor

        # dampen the change
        calib_factor <- (calib_factor - 1) * dampening + 1 # suitable dampening:  0.1

        new_margins <- current_margins

        new_margins[,,items] <- current_margins[,,items] * calib_factor
      }
      else {
        save_multiplier_iterations[[i]] <- list(kcr = calib_factor_crop, kli = calib_factor_livs)
        calib_factor_livs <- (calib_factor_livs - 1) * dampening + 1 # suitable dampening:  0.1
        calib_factor_crop <- (calib_factor_crop - 1) * dampening + 1 # suitable dampening:  0.1
        new_margins <- current_margins
        new_margins[,,kli] = current_margins[,,kli] * calib_factor_livs
        new_margins[,,kcr] = current_margins[,,kcr] * calib_factor_crop
      }

      write.magpie(new_margins, path_to_margins)

      print("   ")
      print("i: ")
      print(i)
      print("   ")
      print("Multiplier ")
      print(list(kcr = calib_factor_crop, kli = calib_factor_livs))
      print("Tradeflows ")
      print(total_interEU_region_flow[,,items])
      Sys.sleep(0.5)
  }
  return(list(multiplier = save_multiplier_iterations, trade_vol = save_EU_TV_iterations))
}

sum_inter_EUregion_trade <- function(EUreg, FAO_bil, mapping, year = "y1995") {
  sum_intra_EU_export <- 0
   # iterate thrpugh exporting regions 
  for(EUexp_reg in EUreg ){
    # iterate through all countries of that exp region
    for(EUexp_country in mapping$country[mapping$region == EUexp_reg]) { 
      # iterate through all region the exp region can possibly export too
      for(EUimp_reg in EUreg[EUreg != EUexp_reg]){
        # iterate through all countries of that importing region
        for(EUimp_country in mapping$country[mapping$region == EUimp_reg]) {
          # sum the bilateral trade flow to the overall flow we are interested in
          sum_intra_EU_export <- sum_intra_EU_export + collapseDim(FAO_bil[paste0(EUexp_country,".", EUimp_country), year,])
        }
      }
    }
  }
  return(sum_intra_EU_export)
}



path_to_model_folder <- "/home/davidho/MAgPIEG/magpieEU/calibrate_EU_trademargins2"



path_to_out_dir <- "/home/davidho/MAgPIEG/magpieEU/calibrate_EU_trademargins_old2/output/testTradeMargCalib/toy_bilateral_EU_2024-01-31_16.28.27"
path_to_regmap <- file.path(path_to_out_dir, "regionmappingEU6.csv")

EUreg <- c("DEU", "EUC", "EUN", "EUS", "EUW")


madrat::setConfig(regionmapping = path_to_regmap)

mapping <- toolGetMapping(path_to_regmap) 

FAO_bil_lvst <- calcOutput("FAOBilateralTrade", output = "qty", products = "kli", aggregate = FALSE)
FAO_bil_kcr <- calcOutput("FAOBilateralTrade", output = "qty", products = "kcr", aggregate = FALSE)

FAO_bil <- mbind(FAO_bil_lvst,FAO_bil_kcr)

# function to sum up traded volume inter our EU regions EUW, EUN, ...



target_EU_trade_vol <- sum_inter_EUregion_trade(EUreg, FAO_bil, mapping)

result <- calibrate_trade_margins_prod_specific(path_to_model_folder, target_EU_trade_vol, 50, 0.13, prod_specific = 1)



# ------  plottting and saving
saveRDS(result,  "calibration_truemodel_results.rds")

# plot_prod_mult <- function(mult, prod, n) {
#   values <- 0
#   for(i in 1:n) {
#     values[i] <- mult[[i]] [,,prod]
#   }
#   return(values)
# }
# plot(plot_prod_mult(result$multiplier, "livst_milk", 20), type = "l")

# title(main="milk ratio iterations", 
#   xlab="iterations", ylab="ratio")
