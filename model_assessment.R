#!/usr/bin/Rscript

source('example_model.R')

training.data$LogitProbabilities <- 1 / (1 + exp(-predict(logit.fit)))

predicted.probabilities <- ddply(training.data,
                                 'Package',
                                 function (d) {with(d, LogitProbabilities[1])})
names(predicted.probabilities) <- c('Package', 'PredictedProbability')

empirical.probabilities <- ddply(training.data,
                                 'Package',
                                 function (d) {nrow(subset(d, Installed == 1)) / nrow(d)})
names(empirical.probabilities) <- c('Package', 'EmpiricalProbability')

probabilities <- merge(predicted.probabilities,
                       empirical.probabilities,
                       by = 'Package')

mean.absolute.error <- with(probabilities,
                            mean(abs(PredictedProbability - EmpiricalProbability)))
worst.case.absolute.error <- with(probabilities,
                                  max(abs(PredictedProbability - EmpiricalProbability)))

library('SortableHTMLTables')

sortable.html.table(probabilities,
                    'probabilities.html',
                    'reports')
