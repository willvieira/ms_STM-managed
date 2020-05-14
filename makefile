# Manuscript
	PDF=manuscript.pdf
	MANU=manuscript/manuscript.md
	CONF=manuscript/conf/template.tex
	BIB=manuscript/conf/references.bib
	META=metadata.yml

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
	SUPP_fig1=manuscript/img/num-result_supp1.png
	# supplementary figure 4
	figSuppR4=num-results/plot_suppFig4.R
	SUPP_fig4=manuscript/img/num-result_supp2.png

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
	# figure 3 (two figures: RCP4.5 and RCP8.5)
	SIM_fig3R=sim-results/plot_fig3.R
	SIM_fig3=manuscript/img/sim-result_RCP4.5.png manuscript/img/sim-result_RCP8.5.png
	DATAfig3=sim-results/data/sim_summary_4.5.rda sim-results/data/sim_summary_8.5.rda
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
$(PDF): $(META) $(BIB) $(CONF) $(NUM_fig1) $(NUM_fig2) $(SUPP_fig1) $(SUPP_fig4) $(SIM_fig3) $(SIM_fig4) $(SIM_figSupp2) $(SIM_figSupp3)
	@echo [1] Rendering manuscript pdf
	@pandoc $(MANU) -o $(PDF) \
		--quiet \
		--metadata-file=metadata.yml \
		--template=manuscript/conf/template.tex \
		--filter pandoc-xnos \
		--number-sections \
		--bibliography=$(BIB)

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

# plot supplementary figure 4
$(SUPP_fig4): $(figSuppR4) $(fig2DATA)
	@Rscript -e "source('num-results/plot_suppFig4.R')"

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
# This md -> tex _. word is a quick and dirty until I create a lua filter to transform authors, afiil and keywords in full text for word docx
md2word:
	@echo [1] Rendering word document
	@pandoc $(MANU) -o manuscript.tex \
		--metadata-file=metadata.yml \
		--template=manuscript/conf/template.tex \
		--filter pandoc-xnos \
		--number-sections \
		--bibliography=$(BIB)
	@pandoc -s manuscript.tex -o manuscript.docx \
		--reference-doc=manuscript/conf/template.docx
	@rm manuscript.tex

# Convert markdown to html
md2html:
	@echo [1] Rendering html document
	@pandoc	-s --mathjax \
		-f markdown -t html \
		$(MANU) -o manuscript.html \
		--quiet \
		--metadata-file=metadata.yml \
		--template=manuscript/conf/template.html \
		--filter pandoc-xnos \
		--toc \
		--bibliography=$(BIB)

# install dependencies
install:
	Rscript -e 'if (!require(rootSolve)) install.packages("rootSolve"); if (!require(githubinstall)) install.packages("githubinstall"); if (!require(STManaged)) devtools::install_github("willvieira/STManaged@v2.0"); if (!require(stringr)) install.packages("stringr"); if (!require(RefManageR)) install.packages("RefManageR"); if (!require(RColorBrewer)) install.packages("RColorBrewer")'

testPandoc:
	echo "Lorem ipsum" > lorem_1.md
	pandoc lorem_1.md -o lorem_1.pdf --filter pandoc-xnos

clean: check_clean
	rm $(fig1DATA) $(NUM_fig1) $(fig2DATA) $(NUM_fig2) $(SUPP_fig1) $(DATAfig3) $(SIM_fig3) $(DATAfig4) $(SIM_fig4) $(DATAfigSupp2) $(SIM_figSupp2) $(DATAfigSupp3) $(SIM_figSupp3) $(PDF)

check_clean:
	@echo -n "Are you sure you want to delete all figures and the associated data? It takes about 40 minutes to run all analysis and plots. NOTE: the raw simulations will not be deleted as it needs access to the server to be ran again [y/N] " && read ans && [ $${ans:-N} == y ]

.PHONY: md2word word2md deps clean check_clean
