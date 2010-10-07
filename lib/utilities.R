clean.variable.name <- function(variable.name)
{
  variable.name <- gsub('_', '.', variable.name, perl = TRUE)
  variable.name <- gsub('-', '.', variable.name, perl = TRUE)
  variable.name <- gsub('\\s+', '.', variable.name, perl = TRUE)
  return(variable.name)
}

parse.description <- function(entry)
{
  results <- as.character(as.data.frame(read.dcf('DESCRIPTION'))[1, entry])
  
  if (length(results) == 0)
  {
    return(NULL)
  }
  else
  {
    return(as.character(strsplit(results, '\\s*,\\s*')[[1]]))
  }
}
