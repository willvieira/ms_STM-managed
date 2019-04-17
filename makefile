
PDF=manuscript.pdf
MANU=manuscript/manuscript.md
VIG=vignettes/*
SIM=sim-results/*
SIM_figs=manuscript/img/sim-result.pdf
NUM=num-results/*
NUM_figs=manuscript/img/num-result.pdf

$(PDF): $(MANU) $(VIG) $(SIM_figs) $(NUM_figs)
	@echo [1] Rendering pdf
	@Rscript -e "rmarkdown::render('$(MANU)', output_dir = '.', quiet = TRUE)"

$(VIG): $(SIM) $(NUM)

$(SIM_figs): $(SIM)
	@Rscript -e "source('sim-results/run_analysis.R')"

$(NUM_figs): $(NUM)
	@Rscript -e "source('num-results/run_analysis.R')"
