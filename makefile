# Manuscript
	PDF=manuscript.pdf
	MANU=manuscript/manuscript.md
	CONF=manuscript/conf/*

# Numerical results
	# functions
	NUMFCT=num-results/model_STM_managed.R num-results/model_STM.R num-results/solve_Eq.R num-results/sysdata.rda
	# figure 1
	fig1R=num-results/plot_fig1.R
	fig1DATA=num-results/data/fig1/*
	DATAfig1R=num-results/run_analysis_fig1.R
	NUM_fig1=manuscript/img/num-result.pdf
	# figure 2
	fig2R=num-results/plot_fig2.R
	fig2DATA=num-results/data/fig2/*
	DATAfig2R=num-results/run_analysis_fig2.R
	NUM_fig2=manuscript/img/num-result_2.pdf
	# supplementary figure 1
	figSuppR=num-results/plot_suppFig.R
	SUPP_fig=manuscript/img/supp-num-result.pdf

# simulation results
	# simulation
	InitLand=sim-results/initLandscape/*
	initLandR=sim-results/create_initLandscape.R
	SimOUTPUT=sim-results/output/*
	RunSIM=sim-results/run_simulation.R
	# figure 3
	SIM_fig3R=sim-results/plot_fig3.R
	SIM_fig3=manuscript/img/sim-result.pdf
	DATAfig3=sim-results/data/sim_summary.rda
	DATAfig3R=sim-results/run_analysis_fig3.R


$(PDF): $(MANU) $(CONF) $(NUM_fig1) $(NUM_fig2) $(SUPP_fig) $(SIM_fig3)
	@echo [1] Rendering manuscript pdf
	@Rscript -e "rmarkdown::render('$(MANU)', output_dir = '.', quiet = TRUE, output_format = 'bookdown::pdf_document2')"

$(NUM_fig1): $(fig1R) $(fig1DATA)
	@Rscript -e "source('num-results/plot_fig1.R')"

$(fig1DATA): $(DATAfig1R) $(NUMFCT)
	@Rscript -e "source('num-results/run_analysis_fig1.R')"

$(NUM_fig2): $(fig2R) $(fig2DATA)
	@Rscript -e "source('num-results/plot_fig2.R')"

$(SUPP_fig): $(figSuppR) $(fig2DATA)
	@Rscript -e "source('num-results/plot_suppFig.R')"

$(fig2DATA): $(DATAfig2R) $(NUMFCT)
	@Rscript -e "source('num-results/run_analysis_fig2.R')"

$(SIM_fig3): $(SIM_fig3R) $(DATAfig3)
	@Rscript -e "source('sim-results/plot_fig3.R')"

$(DATAfig3): $(DATAfig3R) $(SimOUTPUT)
	@Rscript -e "source('sim-results/run_analysis_fig3.R')"

#$(SimOUTPUT): $(RunSIM) $(InitLand)
	#@Rscript -e "source('sim-results/run_simulation.R')"

$(InitLand): $(InitLandR)
	@Rscript -e "source('sim-results/create_initLandscape.R')"

md2word:
	@echo [1] Rendering word document
	@Rscript -e "rmarkdown::render('$(MANU)', output_dir = '.', quiet = TRUE, output_format = 'redoc::redoc')"

word2md:
	@if test -z "$(file)"; then echo "You must defined the document file such as make 'word2md file=doc.docx'"; exit 1; fi
	@echo [1] Rendering markdown
	@Rscript -e "redoc::dedoc('$(file)', track_changes = 'criticmarkup')"

deps:
	Rscript -e 'if (!require(rmarkdown)) install.packages("rmarkdown"); if (!require(knitr)) install.packages("knitr"); if (!require(bookdown)) install.packages("bookdown"); if (!require(rootSolve)) install.packages("rootSolve"); if (!require(githubinstall)) install.packages("githubinstall"); if (!require(STManaged)) devtools::install_github("willvieira/STManaged"); if (!require(redoc)) remotes::install_github("noamross/redoc")'

clean:
	rm $(PDF) $(SIM_fig) $(NUM_fig1) $(NUM_fig2) $(SUPP_fig) $(fig1DATA) $(fig2DATA)

.PHONY: deps clean
