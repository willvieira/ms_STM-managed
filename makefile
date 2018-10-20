FIG=img/*
CONF=conf/*
PDF=firstDraft.pdf
MD=firstDraft.md

$(PDF): $(MD) $(CONF) $(FIG)
	Rscript -e "rmarkdown::render('$(MD)')"
