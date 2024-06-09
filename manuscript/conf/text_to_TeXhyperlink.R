# Pure BASE R code to change supp figure citation text to hyperlink
# This applies only for the templateThesis.tex file where both main text and supp are in the same pdf output
# Warning, this should be writen in Lua

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Steps:
# 1. Load main and supp TeX files
# 2. Get all `Figure S*` text from tex files. (There is the bug with \n newline that may not be identifiable, this will be trick to deal )
# 3. Get all TeX like figure IDs in their order of appearance
# 4. Replace Figure S text to LaTeX syntax hyperef:
  # `Figure S2` -> `Figure \ref{fig:crossComp}`

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



# Function to detect figure (`fig`) or table (`tbl`) `type` environements
# Returns detected line row indexes
detect_elem <- function(tex_file, type) {
  if(!type %in% c('fig', 'tbl')) stop('type must be either `fig` or `tbl`.')
  grep(paste0('hypertarget\\{', type, ':'), tex_file)
}


# Function to extract figure or table ID from selected row lines
# returns vector of figure ID
extract_id <- function(tex_file, type) {
  text_btw_brackets <- regmatches(tex_file, gregexpr("\\{([^}]*)\\}", tex_file))
  figs_only <- unlist(text_btw_brackets[grep(paste0(type, ':'), text_btw_brackets)])
  return(
    gsub('}', '', gsub(paste0('\\{', type, ':'), '', figs_only))
  )
}


# Function to add chapter specific ID (char) to fig ID
# return sentence text with modified figure ID
add_chapterID <- function(text, elem_id, chapter)
  gsub(paste0(elem_id, '\\}'), paste0(elem_id, chapter, '\\}'), text)



# Function to detect supp figure and table citations
# return detected line row indexes
detect_citation <- function(tex_file, type) {
  have_Snumber_pattern <- grep('S[0-9]', tex_file)
  # is the `Figure` keyword present in the same line or
  # in the line above (in case of new line)?
  have_type <- grep(
    ifelse(type == 'fig', 'Figure', 'Table'),
    tex_file[have_Snumber_pattern]
  )
  if(length(have_Snumber_pattern) != length(have_type)) {
    have_type_m1 <- grep(
      ifelse(type == 'fig', 'Figure', 'Table'),
      tex_file[have_Snumber_pattern[setdiff(seq_along(have_Snumber_pattern), have_type)] - 1]
    )
    if(length(have_type_m1) > 0)
      have_type <- order(append(
        have_type,
        setdiff(seq_along(have_Snumber_pattern), have_type)[have_type_m1]
      ))
  }
  return(have_Snumber_pattern[have_type])
}
# note this function will break if there is a table and figure with same Snumber
# Also, this code is very ugly


# Function to convert SX text to href tex using vectors of figure IDs
# return sentence text with converted text
text2tex <- function(text, elem_id, type, chapter) {
  # first find what is the figure or table numbe
  sel_char <- unlist(regmatches(text, gregexpr('S\\d+', text)))

  # convert each SX to specific figure ID
  new_name <- sapply(sel_char, \(x) elem_id[as.numeric(gsub('[A-Z]', '', x))])
  new_name <- paste0('\\ref{', type, ':', paste0(new_name, chapter), '}')
  
  for(i in seq_along(sel_char)) {
    text <- gsub(sel_char[i], new_name[i], text, fixed = TRUE)
  }

  return( text )
}


# meta function that takes a main and supp files to
# replace figure and table citations to latex hyper
# returns the main and supp TeX file with converted citation keys
change_citation <- function(main, supp, chapter) {
  # loop over figure and tables citation types
  for(typ in c('fig', 'tbl'))
  {
    elem_rows <- detect_elem(supp, type = typ)
    elem_id <- extract_id(supp[elem_rows], typ)
    citation_rows <- detect_citation(main, typ)

    # select element IDs to add chapter ID
    sel_char <- unlist(regmatches(main[citation_rows], gregexpr('S\\d+', main[citation_rows])))
    sel_index <- as.numeric(unlist(regmatches(sel_char, gregexpr('\\d+', sel_char))))
    elem_toChange <- unique(elem_id[sel_index])

    # edit main text
    for(i in seq_along(citation_rows))
      main[citation_rows[i]] <- text2tex(
        main[citation_rows[i]],
        elem_id,
        typ,
        chapter
      )

    # edit supp text
    for(i in seq_along(elem_toChange)) {
      rowIDs <- grep(elem_toChange[i], supp)
      for(r in seq_along(rowIDs))
        supp[rowIDs[r]] <- add_chapterID(
          supp[rowIDs[r]],
          elem_toChange[i],
          chapter
        )
    }
  }
  return( list( main, supp ) )
}


## Apply everything
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Load main and supp TeX files
main_t <- readLines(file.path('docs', 'manuscript_thesis.tex'))
supp_t <- readLines(file.path('docs', 'suppInfo_thesis.tex'))

# detect chapter number to add it to element ID
metadat <- readLines('metadata.yml')
metadat <- metadat[grep('chapter-number', metadat)]
chap <- unlist(regmatches(metadat, gregexpr("[[:digit:]]+", metadat)))

# convert main TeX
new_files <- change_citation(
  main_t,
  supp_t,
  chapter = paste0('_ch', chap)
)

# save converted files
writeLines(
  new_files[[1]],
  file.path('docs', 'manuscript_thesis.tex')
)

writeLines(
  new_files[[2]],
  file.path('docs', 'suppInfo_thesis.tex')
)
