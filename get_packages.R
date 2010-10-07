#!/usr/bin/Rscript

source('lib/load_libraries.R')
source('lib/utilities.R')

date <- '08282010'

setwd(paste('/Users/johnmyleswhite/Statistics/Datasets/CRAN_', date, sep = ''))
  
package.tarballs <- dir('.')
  
packages <- data.frame()

for (package.tarball in package.tarballs)
{
  package.name <- str_extract(package.tarball, '[^_]+')

  packages <- rbind(packages,
                     data.frame(Package = package.name))
}

write.csv(packages,
          file = file.path('/Users/johnmyleswhite/Statistics/cran_contest/data',
                           'packages.csv'),
          row.names = FALSE)
