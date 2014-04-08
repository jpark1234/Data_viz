install.packages("tm")
require(tm)
install.packages("wordcloud")
require(wordcloud)

text <- scan("today_news.txt", what="character")
corpus <- Corpus(DataFrameSource(data.frame(text)))
corpus <- tm_map(corpus, function(x)removeWords(tolower(x),stopwords()))
wordcloud(corpus,colors=brew.pal(5,"set1"), random.order=FALSE, max.words=50)

#customize stop words
myStopwords <- c("can")
myCorpus <- tm_map(corpus, removeWords, myStopwords)
wordcloud(myCorpus, colors=brewer.pal(5,"Set1"), random.order=FALSE, max.words=50)

#topic modeling 
install.packages("lda")
require(lda)
doclines <- lexicalize(corpus)
result <- lda.collapsed.gibbs.sampler(doclines$documents, 10, doclines$vocab,
                                      250, 0.1, 0.1, compute.log.likelihood=TRUE)
cloud.data <- sort(result$topics[1,], decreasing=TRUE)[1,50]
wordcloud(names(cloud.data), freq=cloud.data, scale=c(4,0.1), min.freq=1,
          rot.per=0, random.order=FALSE, colors=brewer.pal(5, "Set1"))

#lexicon-based sentiment analysis
pos <- scan('opinion-lexicon-English/positive-words.txt', what="character", comment.char=",")
neg <- scan('opinion-lexicon-English/negative-words.txt', what="character", comment.char=",")

#customize the dictionary
pos.wrods <- c(pos, "upgrade", 'lol')
neg.words <- c(neg, "wtf", "wait", "waiting", "epicfail", "mechanical")

#sample data
sample.text <- c("Oh, I absolutely love cupcakes, even if its not as good as brownies.", 
                 "Cheese! It must be love", "Restaurant Fair tickets are now on sale.",
                 "I love cheese I cannot lie!")
text.sentiment <- score.sentiment(sample.tennis, pos.words, neg.words)