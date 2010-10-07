#!/usr/bin/Rscript

source('lib/load_libraries.R')
source('lib/utilities.R')

date <- '08282010'

setwd(paste('/Users/johnmyleswhite/Statistics/Datasets/CRAN_', date, sep = ''))

package.tarballs <- dir('.')

package.maintainers <- data.frame()

for (package.tarball in package.tarballs)
{
  package.name <- str_extract(package.tarball, '[^_]+')
  
  print(paste('Processing', package.name))
  
  system(paste('tar xfz', package.tarball))
  
  setwd(package.name)
  
  if (! file.exists('DESCRIPTION'))
  {
    print(paste(package.name, 'has no DESCRIPTION file.'))
    next()
  }
  
  maintainers <- parse.description('Maintainer')
  
  if (length(maintainers) > 0)
  {
    for (maintainer in maintainers)
    {
      package.maintainers <- rbind(package.maintainers,
                                   data.frame(Package = package.name,
                                              Maintainer = maintainer))
    }
  }
  
  setwd('..')
  
  system(paste('rm -rf', package.name))
}

write.csv(package.maintainers,
          file = file.path('/Users/johnmyleswhite/Statistics/cran_contest/data',
                           'maintainers.csv'),
          row.names = FALSE)

# The file that results from running this script unfortunately has several
# inappropriate newlines in it. In the data we've released, we've fixed
# these entries by hand.
