# Manuscript
	msOutput=docs/manuscript.pdf docs/manuscript.html docs/manuscript.docx
	msInput=manuscript/manuscript.md
	CONF=manuscript/conf/*
	BIB=manuscript/references.bib
	META=metadata.yml
	SUPPINFO=manuscript/suppInfo.md

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
	# Supplementary figure 5
	SUPP_figR5=num-results/plot_suppFig5.R
	SUPP_fig5=manuscript/img/num-result_supp5.png

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
	# figure 5
	SIM_fig5R=sim-results/plot_fig5.R
	SIM_fig5=manuscript/img/sim-result_3.png
	DATAfig5_6=sim-results/data/shift_dt.RDS
	DATAfig5_6R=sim-results/run_calculateShift.R
	# figure 6
	SIM_fig6R=sim-results/plot_fig6.R
	SIM_fig6=manuscript/img/sim-result_4.png
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
	# supplementary figure 4
	SUPP_fig4R=sim-results/plot_figSupp4.R
	SIM_figSupp4=manuscript/img/sim-result_supp4.png
	# supplementary figure 5
	SIM_SUPP_fig5R=sim-results/plot_figSupp5.R
	SIM_figSupp5=manuscript/img/sim-result_supp5.png

# R
	bibR=R/update_bib.R

# render manuscript pdf
$(msOutput): $(META) $(BIB) $(CONF) $(NUM_fig1) $(NUM_fig2) $(SUPP_fig1) $(SUPP_fig4) $(SUPP_fig5) $(SIM_fig3) $(SIM_fig4) $(SIM_fig5) $(SIM_fig6) $(SIM_figSupp2) $(SIM_figSupp3) $(SIM_figSupp4) $(SIM_figSupp5) $(SUPPINFO)
	@bash manuscript/conf/build.sh $(msInput) $(BIB) $(META) $(SUPPINFO)

# generate bib file
$(BIB): $(msInput) $(bibR)
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

# plot supplementary figure 5
$(SUPP_fig5): $(SUPP_figR5) $(fig2DATA)
	@Rscript -e "source('num-results/plot_suppFig5.R')"

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

# plot figure 5
$(SIM_fig5): $(SIM_fig5R) $(DATAfig5_6)
	@Rscript -e "source('sim-results/plot_fig5.R')"

# run analysis figure 5
$(DATAfig5_6): $(DATAfig5_6R) $(DATAfig3) $(DATAfigSupp2) $(DATAfigSupp3)
	@Rscript -e "source('sim-results/run_calculateShift.R')"

# plot supplementary figure 4
$(SIM_figSupp4): $(SUPP_fig4R) $(DATAfig5_6)
	@Rscript -e "source('sim-results/plot_figSupp4.R')"

# plot figure 6
$(SIM_fig6): $(SIM_fig6R) $(DATAfig5_6)
	@Rscript -e "source('sim-results/plot_fig6.R')"

# plot supplementary figure 2
$(SIM_figSupp2): $(SUPP_fig2R) $(DATAfigSupp2)
	@Rscript -e "source('sim-results/plot_figSupp2.R')"

# plot supplementary figure 5
$(SIM_figSupp5): $(SIM_SUPP_fig5R) $(DATAfig5_6)
	@Rscript -e "source('sim-results/plot_figSupp5.R')"

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

# install dependencies
install:
	Rscript -e 'if (!require(renv)) install.packages("renv", dependencies = TRUE); renv::restore()'

clean: check_clean
	rm $(PDF) $(SUPPPDF) $(NUM_fig1) $(fig1DATA) $(NUM_fig2) $(fig2DATA) $(SIM_fig3) $(SIM_fig4) $(SUPP_fig1) $(SUPP_fig4) $(SIM_figSupp2) $(SIM_figSupp3)

check_clean:
	@echo -n "Are you sure you want to delete all figures and the associated data? It takes about 40 minutes to run all analysis and plots. NOTE: the raw simulations will not be deleted as it needs access to the server to be ran again [y/N] " && read ans && [ $${ans:-N} == y ]

.PHONY: install clean check_clean
