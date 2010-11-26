#!/usr/bin/Rscript

library('ProjectTemplate')
load.project()

library('tm')
library('topicmodels')

documents <- transform(documents, Text = as.character(Text))

documents <- subset(documents, nchar(Text) > 5000)

docs <- data.frame(docs = documents$Text,
                   row.names = documents$Package)

corpus <- Corpus(DataframeSource(docs))

corpus <- tm_map(corpus, tolower)

corpus <- tm_map(corpus, removeWords, stopwords('english'))

document.term.matrix <- DocumentTermMatrix(corpus)

#dtm <- removeSparseTerms(document.term.matrix, 0.4)

topic.model <- LDA(document.term.matrix, 25)

terms(topic.model, 50)

topic.assignments <- topics(topic.model)
write.csv(data.frame(Package = names(topic.assignments), Topic = as.numeric(topic.assignments)),
          'datatopics.csv',
          row.names = FALSE)

# In the future, it would be interesting to iterate over a small number
# of possible topics to find the number that maximizes predictive power.
