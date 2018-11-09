
PDF=manuscript.pdf
MANU=manuscript/manuscript.md
VIG=vignettes/*
SIM=simulations/*
ANA=analytical-analysis/*

$(PDF): $(VIG) $(SIM) $(ANA)
	Rscript -e "rmarkdown::render('$(MANU)', output_dir = '.')"

$(VIG): $(SIM) $(ANA)

$(SIM):

$(ANA):
