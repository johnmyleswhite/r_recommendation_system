# Add R and base to the packages data set.
packages <- rbind(packages, data.frame(Package = 'R'))
packages <- rbind(packages, data.frame(Package = 'base'))

# Drop version info from the depends, suggests and imports graphs.
depends$LinkedPackage <- sub('\\s*\\(.*', '', as.character(depends$LinkedPackage))
suggests$LinkedPackage <- sub('\\s*\\(.*', '', as.character(suggests$LinkedPackage))
imports$LinkedPackage <- sub('\\s*\\(.*', '', as.character(imports$LinkedPackage))

# Marginalize over the depends, suggests and imports graphs.
dependencies <- ddply(depends, 'LinkedPackage', nrow)
names(dependencies) <- c('Package', 'DependencyCount')

suggestions <- ddply(suggests, 'LinkedPackage', nrow)
names(suggestions) <- c('Package', 'SuggestionCount')

importings <- ddply(imports, 'LinkedPackage', nrow)
names(importings) <- c('Package', 'ImportCount')

# Marginalize over the task views and maintainer data sets.
inclusions <- ddply(views, 'LinkedPackage', nrow)
names(inclusions) <- c('Package', 'ViewsIncluding')

persons <- ddply(subset(maintainers, ! is.na(Maintainer)), 'Maintainer', nrow)
names(persons) <- c('Person', 'PackagesMaintaining')

# Get the maintainer information matched back into the maintainers data set.
maintainers <- merge(maintainers,
                     persons,
                     by.x = 'Maintainer',
                     by.y = 'Person',
                     all.x = TRUE)

# Recode the entries of the core, recommended and installations data frames.
core <- transform(core,
                  CorePackage = rep(1, nrow(core)))
recommended <- transform(recommended,
                         RecommendedPackage = rep(1, nrow(recommended)))

# Merge all of this information into the packages data frame.
packages <- merge(packages,
                  dependencies,
                  by = 'Package',
                  all.x = TRUE)
packages$DependencyCount <- ifelse(is.na(packages$DependencyCount),
                                   0,
                                   packages$DependencyCount)

packages <- merge(packages,
                  suggestions,
                  by = 'Package',
                  all.x = TRUE)
packages$SuggestionCount <- ifelse(is.na(packages$SuggestionCount),
                                   0,
                                   packages$SuggestionCount)

packages <- merge(packages,
                  importings,
                  by = 'Package',
                  all.x = TRUE)
packages$ImportCount <- ifelse(is.na(packages$ImportCount),
                               0,
                               packages$ImportCount)

packages <- merge(packages,
                  inclusions,
                  by = 'Package',
                  all.x = TRUE)
packages$ViewsIncluding <- ifelse(is.na(packages$ViewsIncluding),
                                  0,
                                  packages$ViewsIncluding)

packages <- merge(packages,
                  core,
                  by = 'Package',
                  all.x = TRUE)
packages$CorePackage <- ifelse(is.na(packages$CorePackage),
                               0,
                               1)

packages <- merge(packages,
                  recommended,
                  by = 'Package',
                  all.x = TRUE)
packages$RecommendedPackage <- ifelse(is.na(packages$RecommendedPackage),
                                      0,
                                      1)

packages <- merge(packages,
                  maintainers,
                  by = 'Package',
                  all.x = TRUE)

packages$PackagesMaintaining  <- ifelse(is.na(packages$PackagesMaintaining),
                                        0,
                                        packages$PackagesMaintaining)

packages <- merge(packages,
                       installations,
                       by = 'Package',
                       all = TRUE)

# Provide logarithmic versions of the continuous predictors.
packages <- transform(packages, LogDependencyCount = log(1 + DependencyCount))
packages <- transform(packages, LogSuggestionCount = log(1 + SuggestionCount))
packages <- transform(packages, LogImportCount = log(1 + ImportCount))
packages <- transform(packages, LogViewsIncluding = log(1 + ViewsIncluding))
packages <- transform(packages, LogPackagesMaintaining = log(1 + PackagesMaintaining))
