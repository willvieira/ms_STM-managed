
PDF=manuscript.pdf
MANU=manuscript/manuscript.md
VIG=vignettes/*
SIM=sim-results/*
#SIM_figs=
NUM=num-results/*
NUM_figs=manuscript/img/num-result.pdf

$(PDF): $(MANU) $(VIG) $(SIM_figs) $(NUM_figs)
	Rscript -e "rmarkdown::render('$(MANU)', output_dir = '.')"

$(VIG): $(SIM) $(NUM)

$(SIM):

$(NUM_figs): $(NUM)
	Rscript -e "source('num-results/run_analysis.R')"
