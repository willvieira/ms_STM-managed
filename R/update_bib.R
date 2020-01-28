################################################
#    ---- BibTeX Citation Organizer ----
# Will Vieira
# November 7, 2019
# Adapted from Garrick Aden-Buie: <http://garrickadenbuie.com>
################################################


library(stringr)
library(RefManageR)


#             ---- Set Up ----

  # Set Master BibTeX file location
  tmp <- tempfile()
  download.file(url = 'https://doc.ielab.usherbrooke.ca/index.php/s/Y8YhGJ8k2lyqgwh/download', destfile = tmp, quiet = TRUE)
  refs <- suppressWarnings(suppressMessages(RefManageR::ReadBib(file = tmp)))

  # Citation entries to keep, all others are skipped
  keep <- c('author', 'title', 'journal', 'year', 'volume', 'number',
            'pages', 'month', 'editor', 'publisher', 'doi', 'url')

  #args <- commandArgs(trailingOnly = TRUE)
  #infile <- args[1]
  infile <- 'manuscript/manuscript.md'

#



#    ---- Find citation keys in markdown ----

  stripCitekeys <- function(infile){
    indoc <- file(infile, open = 'r')
    cat(paste('Finding citations in:', infile, '\n'))
    citations <- c()
    count = 1
    for(line in readLines(indoc, warn = F)){
      count = count + 1
      if(str_detect(line, '@')) {
        candidate <- unlist(str_extract_all(line, "(?<=@)\\w+"))
        if(length(candidate) != 0){
            citations <- c(citations, candidate)
        }
      }
    }
    close(indoc)
    return(unique(citations))
  }

  citations <- stripCitekeys(infile)

#



#    ---- Compare document keys with those present in the bib file ----

  # get all bib keys
  refKeys <- unlist(lapply(refs, function(x) x[1]$key))

  # which key in the document is not the bib file?
  wrongKeys <- citations[!(citations %in% refKeys)]

  # remove wrong key
  citations <- citations[(citations %in% refKeys)]

#



#    ---- Add missing citations to the new bib file (specific to the document) ----

  newbibfile <- 'manuscript/conf/references.bib'

  # first check if a bib file already exists (to avoid over writting the whole file)
  bibAlready <- file.exists(newbibfile)

  # If true, load it and add the missing references
  if(bibAlready) {

    newBib <- ReadBib(file = newbibfile)
    newRefKeys <- unlist(lapply(newBib, function(x) x[1]$key))

    # test if it is necessary to update (remove a reference)
    if(all(citations %in% newRefKeys)) {

      # Remove useless keys
      toRemove <- newRefKeys[!(newRefKeys %in% citations)]
      if(length(toRemove) != 0) cat('Removing', length(toRemove), 'references from the', newbibfile, 'file:\n',
      paste(toRemove, collapse = '\n'), '\n')
      newBib <- newBib[which(!(unlist(newBib$key) %in% toRemove))]

      # test if it is necessary to update (add a reference)
    }else if(all(newRefKeys %in% citations)) {

      cat('Updating existing bib file:', newbibfile, '\n')

      # add missing keys
      refsToAdd <- citations[which(!(citations %in% newRefKeys))]
      newBib <- c(newBib, refs[which(refsToAdd == refKeys)])
      if(length(refsToAdd) != 0) {
        cat('Adding', length(refsToAdd), 'references to the', newbibfile, 'file:\n',
            paste(refsToAdd, collapse = '\n'), '\n')
      }

    }else {
      cat(newbibfile, 'is up to date\n')
    }

    # save file
    WriteBib(newBib, file = newbibfile)

  }else { # Othewise just write a bibfile with the references

    cat('Creating bib file:', newbibfile, '\n')

    # get all references
    refsToAdd <- refs[which(refKeys %in% citations)]
    if(length(refsToAdd) != 0) {
      cat('Adding', length(refsToAdd), 'references to the', newbibfile, 'file:\n',
          paste(refsToAdd, collapse = '\n'), '\n')
    }

    # save file
    WriteBib(refsToAdd, file = newbibfile)

  }

#



#    ---- Extra work ----

  # tell me if there's any wrong keyword (to  check)
  if(length(wrongKeys) != 0) {
    cat('These are the following keys I did not find on the main bibfile: \n',
        paste(wrongKeys, collapse = '\n'), '\n')
  }

#
