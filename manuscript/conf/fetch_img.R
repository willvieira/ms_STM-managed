# Pure BASE R code to fetch all URL based images from markdownd documents
# Save it locally before LaTeX build
# Change markdown link reference

# where downloaded figures should be saved?
to_path = 'docs/manuscript/figs/'

# which files to verify?
tex_files = dir('docs', pattern = '_thesis.tex', full.names = TRUE)



# Function to detect figure environement with https
# Returns index which is TRUE
detect_figURL <- function(tex_file)
  grep("(?=.*includegraphics)(?=.*https)", tex_file, perl = TRUE)


# Function to extract https adress
get_figURL <- function(txt)
  gsub('.*\\{|\\}', '', txt)


# Function to change URL https address to a local file name
change_URL <- function(URL, to = to_path) {
  # remove https address
  fig_name <- gsub('.*\\/|\\{|\\}', '', URL)
  # add relative path
  paste0(to, fig_name)
}


# Function to download PNG file from URL address
download_URL <- function(URL, to = to_path)
  download.file(URL, destfile = change_URL(URL), mode = 'wb')


# meta function to read tex file, save image, and change URL
update_tex <- function(tex_file, to = to_path) {

  # read tex file
  tex <- readLines(tex_file)
  
  # get lines with URL adress
  lines_to_change <- detect_figURL(tex)
  
  # extract URL
  fig_urls <- unname(sapply(tex[lines_to_change], get_figURL))

  # download PNG files
  sapply(fig_urls, download_URL)

  # change figure adress from URL to local path
  for(Line in seq_along(lines_to_change)) {

    tex[lines_to_change[Line]] <- gsub(
      fig_urls[Line],
      change_URL(fig_urls[Line], to = gsub('docs/', '', to_path)),
      tex[lines_to_change[Line]]
    )
  }
     
  # save tex file
  writeLines(tex, tex_file)
}


# Before running, make sure `to_path` is available
dir.create(to_path, recursive = TRUE)

# where magic happens
invisible(
  sapply(
    tex_files,
    update_tex
  )
)
