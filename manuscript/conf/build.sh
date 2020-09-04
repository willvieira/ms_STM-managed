#!/bin/sh
###################################################################
# Bash file to build the manuscript outputs (html, pdf, and docx)
# Will Vieira
# Sept 3, 2020
###################################################################

# Arguments to pass to this script:
# - $1 manuscript.md
# - $2 references.bib
# - $3 metadata.yml
# - $4 suppInfo.md
# - $5 ...

# Build pdf
echo [1] Rendering manuscript pdf
pandoc $1 -o docs/manuscript.pdf \
    --quiet \
    --metadata-file=$3 \
    --template=manuscript/conf/template.tex \
    --filter pandoc-xnos \
    --number-sections \
    --bibliography=$2

# Build tex
echo [1] Rendering manuscript tex
pandoc $1 -o docs/manuscript.tex \
    --quiet \
    --metadata-file=$3 \
    --template=manuscript/conf/template.tex \
    --filter pandoc-xnos \
    --number-sections \
    --bibliography=$2

# Build suppInfo
echo [1] Rendering supporting information pdf
pandoc $4 -o docs/suppInfo.pdf \
    --quiet \
    --toc \
    --metadata-file=$3 \
    --template=manuscript/conf/templateSupp.tex \
    --filter pandoc-xnos \
    --number-sections \
    --bibliography=$2

# Build html
echo [1] Rendering html document
pandoc -s --mathjax \
    -f markdown -t html \
    $1 -o docs/manuscript.html \
    --quiet \
    --metadata-file=$3 \
    --template=manuscript/conf/template.html \
    --filter pandoc-xnos \
    --toc \
    --bibliography=$2
echo [1] Rendering html supporting information
pandoc -s --mathjax \
    -f markdown -t html \
    $4 -o docs/suppInfo.html \
    --quiet \
    --metadata-file=$3 \
    --template=manuscript/conf/templateSupp.html \
    --filter pandoc-xnos \
    --toc \
    --bibliography=$2

# Build docx
## This md -> tex _. word is a q&d until I create a lua filter to transform authors, afill and keywords in full text for word docx
echo [1] Rendering word document
pandoc $1 -o manuscript.tex \
    --metadata-file=$3 \
    --template=manuscript/conf/templateWord.tex \
    --filter pandoc-xnos \
    --number-sections \
    --bibliography=$2
pandoc -s manuscript.tex -o docs/manuscript.docx \
    --reference-doc=manuscript/conf/template.docx
	rm manuscript.tex