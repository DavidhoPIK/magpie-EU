readArgs("outputdir")
print(outputdir)

rmarkdown::render("./scripts/output/projects/evaluate_calibration_factors.Rmd",
                  output_dir = paste0(outputdir, "/validation"))
