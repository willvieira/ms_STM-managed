# Manuscript
	PDF=manuscript.pdf
	MANU=manuscript/manuscript.md
	CONF=manuscript/conf/config_md.sty manuscript/conf/header.html manuscript/conf/style.css manuscript/conf/template.docx
	BIB=manuscript/conf/references.bib

# Numerical results
	# functions
	NUMFCT=num-results/model_STM_managed.R num-results/model_STM.R num-results/solve_Eq.R num-results/sysdata.rda
	# figure 1
	fig1R=num-results/plot_fig1.R
	fig1DATA=num-results/data/fig1/*
	DATAfig1R=num-results/run_analysis_fig1.R
	NUM_fig1=manuscript/img/num-result.png
	# figure 2
	fig2R=num-results/plot_fig2.R
	fig2DATA=num-results/data/fig2/*
	DATAfig2R=num-results/run_analysis_fig2.R
	NUM_fig2=manuscript/img/num-result_2.png
	# supplementary figure 1
	figSuppR=num-results/plot_suppFig.R
	SUPP_fig1=manuscript/img/supp-num-result.png

# simulation results
	# simulation
		# initland
		InitLand=sim-results/initLandscape/*
		initLandR=sim-results/create_initLandscape.R
		# Simulation 1 (figure 3 and supp 2)
		SimOUTPUT=sim-results/output/*
		RunSIM=sim-results/run_simulation.R
		# Simulation 2 (figure supp 3)
		SimOUTPUT_supp3=sim-results/outputSupp/*
		RunSIM2=sim-results/run_simulation_supp.R
	# figure 3
	SIM_fig3R=sim-results/plot_fig3.R
	SIM_fig3=manuscript/img/sim-result.png
	DATAfig3=sim-results/data/sim_summary.rda
	DATAfig3R=sim-results/run_analysis_fig3.R
	# figure 4
	SIM_fig4R=sim-results/plot_fig4.R
	SIM_fig4=manuscript/img/sim-result_2.png
	DATAfig4=sim-results/data/sim_summary_fig4.rda
	DATAfig4R=sim-results/run_analysis_fig4.R
	# supplementary figure 2
	SUPP_fig2R=sim-results/plot_figSupp2.R
	SIM_figSupp2=manuscript/img/sim-result_supp2.png
	DATAfigSupp2=sim-results/data/sim_summary_supp2.rda
	DATAfigSupp2R=sim-results/run_analysis_suppFig2.R
	# supplementary figure 3
	SUPP_fig3R=sim-results/plot_figSupp3.R
	SIM_figSupp3=manuscript/img/sim-result_supp3.png
	DATAfigSupp3=sim-results/data/sim_summary_supp3.rda
	DATAfigSupp3R=sim-results/run_analysis_suppFig3.R

# R
	bibR=R/update_bib.R

# render pdf
$(PDF): $(BIB) $(CONF) $(NUM_fig1) $(NUM_fig2) $(SUPP_fig1) $(SIM_fig3) $(SIM_fig4) $(SIM_figSupp2) $(SIM_figSupp3)
	@echo [1] Rendering manuscript pdf
	@Rscript -e "rmarkdown::render('$(MANU)', output_dir = '.', quiet = TRUE, output_format = 'bookdown::pdf_document2')"

$(BIB): $(MANU) $(bibR)
	@echo [1] check if references are up to date
	@Rscript -e "source('$(bibR)')"

# plot figure 1
$(NUM_fig1): $(fig1R) $(fig1DATA)
	@Rscript -e "source('num-results/plot_fig1.R')"

# run analysis figure 1
$(fig1DATA): $(DATAfig1R) $(NUMFCT)
	@Rscript -e "source('num-results/run_analysis_fig1.R')"

# plot figure 2
$(NUM_fig2): $(fig2R) $(fig2DATA)
	@Rscript -e "source('num-results/plot_fig2.R')"

# plot supplementary figure 1
$(SUPP_fig1): $(figSuppR) $(fig2DATA)
	@Rscript -e "source('num-results/plot_suppFig.R')"

# run analysis figure 2 and supplementary figure 1
$(fig2DATA): $(DATAfig2R) $(NUMFCT)
	@Rscript -e "source('num-results/run_analysis_fig2.R')"

# plot figure 3
$(SIM_fig3): $(SIM_fig3R) $(DATAfig3)
	@Rscript -e "source('sim-results/plot_fig3.R')"

# run analysis figure 3
#$(DATAfig3): $(DATAfig3R) # $(SimOUTPUT)
#	@Rscript -e "source('sim-results/run_analysis_fig3.R')"

# plot figure 4
$(SIM_fig4): $(SIM_fig4R) # $(DATAfig4)
	@Rscript -e "source('sim-results/plot_fig4.R')"

# run analysis figure 4
#$(DATAfig4): $(DATAfig4R) # $(SimOUTPUT)
#	@Rscript -e "source('sim-results/run_analysis_fig4.R')"

# plot supplementary figure 2
$(SIM_figSupp2): $(SUPP_fig2R) $(DATAfigSupp2)
	@Rscript -e "source('sim-results/plot_figSupp2.R')"

# run analysis supplementary figure 2
#$(DATAfigSupp2): $(DATAfigSupp2R) # $(SimOUTPUT)
#	@Rscript -e "source('sim-results/run_analysis_suppFig2.R')"

# plot supplementary figure 3
$(SIM_figSupp3): $(SUPP_fig3R) $(DATAfigSupp3)
	@Rscript -e "source('sim-results/plot_figSupp3.R')"

# run analysis supplementary figure 3
#$(DATAfigSupp3): $(DATAfigSupp3R) $(SimOUTPUT_supp3)
#	@Rscript -e "source('sim-results/run_analysis_suppFig3.R')"

# run simulation for figure 3 and supplementary figure 2 (access to the server needed)
#$(SimOUTPUT): $(RunSIM) $(InitLand)
	#@Rscript -e "source('sim-results/run_simulation.R')"

# run simulation for supplementary figure 3 (access to the server needed)
#$(SimOUTPUT_supp3): $(RunSIM2) $(InitLand)
	#@Rscript -e "source('sim-results/run_simulation_supp.R')"

# create initial landscapes for all simulations
$(InitLand): $(InitLandR)
	@Rscript -e "source('sim-results/create_initLandscape.R')"

# convert markdown to word
md2word:
	@echo [1] Rendering word document
	@Rscript -e "rmarkdown::render('$(MANU)', output_dir = '.', quiet = TRUE, output_format = 'redoc::redoc')"

# convert word to markdown (and keep track changes)
word2md:
	@if test -z "$(file)"; then echo "You must defined the document file such as 'make word2md file=doc.docx'"; exit 1; fi
	@echo [1] Rendering markdown
	@Rscript -e "redoc::dedoc('$(file)', track_changes = 'criticmarkup')"

# install dependencies
deps:
	Rscript -e 'if (!require(rmarkdown)) install.packages("rmarkdown"); if (!require(knitr)) install.packages("knitr"); if (!require(bookdown)) install.packages("bookdown"); if (!require(rootSolve)) install.packages("rootSolve"); if (!require(githubinstall)) install.packages("githubinstall"); if (!require(STManaged)) devtools::install_github("willvieira/STManaged"); if (!require(redoc)) remotes::install_github("noamross/redoc")'

clean: check_clean
	rm $(fig1DATA) $(NUM_fig1) $(fig2DATA) $(NUM_fig2) $(SUPP_fig1) $(DATAfig3) $(SIM_fig3) $(DATAfig4) $(SIM_fig4) $(DATAfigSupp2) $(SIM_figSupp2) $(DATAfigSupp3) $(SIM_figSupp3) $(PDF)

check_clean:
	@echo -n "Are you sure you want to delete all figures and the associated data? It takes about 40 minutes to run all analysis and plots. NOTE: the raw simulations will not be deleted as it needs access to the server to be ran again [y/N] " && read ans && [ $${ans:-N} == y ]

.PHONY: md2word word2md deps clean check_clean
