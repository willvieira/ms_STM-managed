
PDF=manuscript.pdf
MANU=manuscript/manuscript.md
VIG=vignettes/*
SIM=sim-results/*
NUM=num-results/*

$(PDF): $(VIG) $(SIM) $(NUM)
	Rscript -e "rmarkdown::render('$(MANU)', output_dir = '.')"

$(VIG): $(SIM) $(NUM)

$(SIM):

$(NUM):
