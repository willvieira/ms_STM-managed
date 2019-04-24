
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

deps:
	Rscript -e 'if (!require(rmarkdown)) install.packages("rmarkdown"); if (!require(knitr)) install.packages("knitr"); if (!require(bookdown)) install.packages("bookdown"); if (!require(rootSolve)) install.packages("rootSolve"); if (!require(devtools)) install.packages("devtools"); if (!require(STManaged)) devtools::install_github("willvieira/STManaged")'

clean:
	rm $(PDF) $(SIM_figs) $(NUM_figs)

.PHONY: deps clean
