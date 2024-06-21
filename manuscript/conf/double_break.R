# Pure BASE R code to add double backslash "\\" at the end of paragraph
# This applies only main/supp_thesis.tex template
# Warning, this should be writen in Lua


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Steps:
# 1. read file
# 2. detect paragraphs
# 3. add double backslash
# 4. write file
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



# function to return last character of a string
# return length=1 character
# source: https://stackoverflow.com/a/7963963/6532002
substrRight <- function(x, n)
  substr(x, nchar(x)-n+1, nchar(x))


# function to detect last line of a paragraph writen in Latex
# return line index ID
detect_lastSentence <- function(tex_file)
{
  # detect empty lines
  empty_lines <- which(tex_file == "")

  # For the line before the empty line, detect if the last character is a dot
  before_empty <- empty_lines - 1

  # remove zero index
  if(0 %in% before_empty)
    before_empty <- before_empty[-which(before_empty == 0)]

  # which has dot or two dots as the last character
  out_dot <- before_empty[grep('\\.|\\:', substrRight(tex_file[before_empty], 1))]

  # which has `end{equation}` in the last sentence?
  out_eq <- before_empty[grep('end\\{equation\\}', tex_file[before_empty])]

  return( sort(unique(c(out_dot, out_eq))) )
}


# function to include double backslash at the end of the sentence
# Return the altered sentence
add_doubleBack <- function(text)
  return( paste0(text, '\\\\') )


# meta function that takes a main file to add double backslash
# at the end of the paragraph
# returns the altered main TeX file
change_file <- function(tex_file)
{
  # get sentence index to changes
  to_change <- detect_lastSentence(tex_file)

  # update sentences
  new_tex <- tex_file

  for(i in to_change)
    new_tex[i] <- add_doubleBack(tex_file[i])
  
  return( new_tex )
}



## Apply everything
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Load main TeX file
file.path('docs', 'manuscript_thesis.tex') |>
  sapply(
    \(x) readLines(x) |>
          change_file() |>
          writeLines(x)
  )
