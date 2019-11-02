
# Load packages

library(readr)
library(RCurl)
library(downloader)
library(knitr)
library(tinytex) #replace rmarkdown with tinytex
library(sp)
library(raster)
library(rasterVis)
library(dplyr)
library(tidyr)
library(rstan)
library(ggplot2)
library(cowplot)
library(pbmcapply)
library(Hmisc)
library(png)
library(grid)
library(gridBase)
library(gridExtra)
library(pROC)
library(GGally)

R.utils::sourceDirectory('R/')

#------------- Download data ---------------------------

BCI_download_species_table('downloads/bci.spptable.rdata')

BCI_download_50ha_plot_full('downloads/bci.full.Rdata31Aug2012.zip') 

BCI_download_canopy_data_full('downloads/bci.full_canopy_Aug2012.zip')

#------------- Load data  -------------------------------

BCI_50haplot <- BCI_load_50ha_plot("downloads/bci.full.Rdata31Aug2012.zip")

BCI_wood_density <- BCI_load_wood_density("data/BCI_traits_20101220.csv")

BCI_nomenclature <- BCI_load_nomenclature("downloads/bci.spptable.rdata")

BCI_dbh_error_data <- BCI_load_dbh_error_data("data/dbh_error_data.rdata")

BCI_canopy <- BCI_load_canopy("downloads/bci.full_canopy_Aug2012.zip")

#------------- Process data  ----------------------------

BCI_demography_cleaned <- BCI_clean(BCI_50haplot, BCI_nomenclature)

BCI_dbh_95 <- get_spp_dbh_95(BCI_50haplot)

recruits <- recruits_8595(BCI_50haplot)

gap_index_raster <- get_gap_index_raster(BCI_canopy)

recruit_gap_conditions <- get_recruit_gap_conditions(recruits, gap_index_raster)

BCI_gap_index <- get_mean_spp_gap_index(recruit_gap_conditions)   

BCI_demography_traits <- merge_BCI_data(BCI_demography_cleaned, BCI_wood_density, BCI_dbh_95, BCI_gap_index)

BCI_true_dbh_model <- run_true_dbh_model(BCI_demography_traits)

BCI_model_data <- add_true_growth(BCI_demography_traits, BCI_true_dbh_model)

BCI_model_dataset_folds <- split_into_kfolds(BCI_model_data)

BCI_training_full <- extract_trainheldout_set(BCI_model_dataset_folds, NA)

BCI_training_sets <- make_trainheldout(BCI_model_dataset_folds)

#-------------Export data ---------------------------

export_data(BCI_training_sets, 'data/kfold_data/bci_data.rds')

saveRDS(BCI_training_full, 'data/bci_data_full.rds')

#------------- Model diagnostics ------------------------
all_model_diagnostics <- model_diagnostics("null_model", 
                                           "function_growth_comparison",
                                           "rho_combinations", 
                                           "gap_combinations", 
                                           "size_combinations",
                                           "species_random_effects",
                                           "rho_gap_all",
                                           "rho_size_all",
                                           "gap_size_all",
                                           "multi_trait_all",
                                           "final_model",
                                           "final_base_growth_hazard_re")

#------------- Model outputs -------------------

# Cross validation statistics
logloss_summaries <- collate_logloss_summaries()

# Final model
final_model <- compile_models('final_model')

# Final model with only species random effects only
final_spp_re_model <- compile_models('final_base_growth_hazard_re')

# Final model parameter estimates
spp_params <- summarise_spp_params(final_model, BCI_training_full)

mu_param_trends_by_trait <- param_by_trait_mu_trends(final_model, 
                                                     BCI_training_full, 
                                                     c("wood_density","gap_index","dbh_95"))

#------------- Tables ---------------------------
table_1(final_model, BCI_training_full)

#------------- Figures ---------------------------
png('ms/figures/fig1_tree.png')
download('http://ian.umces.edu/imagelibrary/albums/userpics/10002/normal_ian-symbol-generic-tree-rainforest-3.png')
dev.off()

pdf("ms/figures/fig1.pdf", width = 3.46, height = 4)
plot_fig1("ms/figures/fig1_tree.png", "ms/figures/dead_tree.png", "ms/figures/Fig1c.png")
dev.off()

pdf("ms/figures/fig2.pdf", width = 6.5, height = 2)
plot_fig2(logloss_summaries)
dev.off()

pdf("ms/figures/fig3.pdf", width = 6.5, height = 3.5, onefile = FALSE)
plot_fig3(spp_params, mu_param_trends_by_trait)
dev.off()

pdf("ms/figures/fig4.pdf", width = 3.46, height = 4, onefile = FALSE)
plot_fig4(final_model, BCI_training_full)
dev.off()

pdf("ms/figures/supp_fig1.pdf", width = 5, height = 6, onefile = FALSE)
plot_fig4(final_model, BCI_training_full, hazard_curve =TRUE)
dev.off()

pdf("ms/figures/supp_fig2.png", width = 3.46, height = 3.46, 
    units = 'in', res = 300)
plot_figS1(BCI_model_data)
dev.off()

pdf("ms/figures/supp_fig3.pdf", width = 6, height = 6, onefile = FALSE)
plot_figS2(gap_index_raster, recruit_gap_conditions)
dev.off()

pdf("ms/figures/supp_fig4.pdf", width = 3.46, height = 8)
plot_spp_params(final_model, BCI_training_full, "alpha", expression(log(alpha)))
dev.off()

pdf("ms/figures/supp_fig5.pdf", width = 3.46, height = 8)
plot_spp_params(final_model, BCI_training_full, "beta", expression(log(beta)))
dev.off()

pdf("ms/figures/supp_fig6.pdf", width = 3.46, height = 8)
plot_spp_params(final_model, BCI_training_full, "gamma", expression(log(gamma)))
dev.off()

pdf("ms/figures/supp_fig7.pdf", width = 6, height = 6, onefile = FALSE)
plot_trait_cors(BCI_training_full)
dev.off()

pdf("ms/figures/supp_fig8.png", width = 3.46, height = 3.46, 
    units = 'in', res = 300)
plot_figS8(BCI_training_full)
dev.off()

#------------- Manuscript ---------------------------
knitr::knit("ms/manuscript.Rnw", output = "ms/manuscript.tex")
pdflatex("ms/manuscript.tex")

knitr::knit("ms/supplementary.Rnw", output = "ms/supplementary.tex")
pdflatex("ms/supplementary.tex")
