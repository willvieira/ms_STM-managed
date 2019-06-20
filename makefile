# Manuscript
PDF=manuscript.pdf
MANU=manuscript/manuscript.md
CONF=manuscript/conf/*
# Numerical results
NUMFCT=num-results/model_STM_managed.R num-results/model_STM.R num-results/solve_Eq.R num-results/sysdata.rda
fig1R=num-results/run_analysis_fig1.R
fig2R=num-results/run_analysis_fig2.R
suppFigR=num-results/run_analysis_suppFig.R
NUM_fig1=manuscript/img/num-result.pdf
NUM_fig2=manuscript/img/num-result_2.pdf
SUPP_fig=manuscript/img/supp-num-result*
# simulation results
SIM_figR=sim-results/run_analysis.R
SIM_fig=manuscript/img/sim-result.pdf
SimOUTPUT=sim-results/output/*
RunSIM=sim-results/run_simulation.R
InitLand=sim-results/initLandscape/*
initLandR=sim-results/create_initLandscape.R

$(PDF): $(MANU) $(CONF) $(NUM_fig1) $(NUM_fig2) $(SUPP_fig) $(SIM_fig)
	@echo [1] Rendering pdf
	@Rscript -e "rmarkdown::render('$(MANU)', output_dir = '.', quiet = TRUE, output_format = 'bookdown::pdf_document2')"

$(NUM_fig1): $(fig1R) $(NUMFCT)
	@Rscript -e "source('num-results/run_analysis_fig1.R')"

$(NUM_fig2): $(fig2R) $(NUMFCT)
	@Rscript -e "source('num-results/run_analysis_fig2.R')"

$(SUPP_fig): $(suppFigR)
	@Rscript -e "source('num-results/run_analysis_suppFig.R')"

$(SIM_fig): $(SIM_figR) $(SimOUTPUT)
	@Rscript -e "source('sim-results/run_analysis.R')"

#$(SimOUTPUT): $(RunSIM) $(InitLand)
	#@Rscript -e "source('sim-results/run_simulation.R')"

$(InitLand): $(InitLandR)
	@Rscript -e "source('sim-results/create_initLandscape.R')"

md2word:
	@echo [1] Rendering word document
	@Rscript -e "rmarkdown::render('$(MANU)', output_dir = '.', quiet = TRUE, output_format = 'redoc::redoc')"

word2md:
	@echo [1] Rendering markdown
	@Rscript -e "redoc::dedoc('$(file)', track_changes = 'criticmarkup')"

deps:
	Rscript -e 'if (!require(rmarkdown)) install.packages("rmarkdown"); if (!require(knitr)) install.packages("knitr"); if (!require(bookdown)) install.packages("bookdown"); if (!require(rootSolve)) install.packages("rootSolve"); if (!require(githubinstall)) install.packages("githubinstall"); if (!require(STManaged)) devtools::install_github("willvieira/STManaged"); if (!require(redoc)) remotes::install_github("noamross/redoc")'

clean:
	rm $(PDF) $(SIM_fig) $(NUM_fig1) $(NUM_fig2) $(SUPP_fig)

.PHONY: deps clean
