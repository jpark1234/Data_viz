install.packages("tm")
require(tm)
#topic modeling is based on probability modeling. its like dimension reduction process. 
#this is like unsupervised learning. depending on the size of k, you will get different clusters.
#tuning the k is not hte purpose of this course. 
#there is an optimal k in real life tho. 
data(acq)
reuters <-Corpus(VectorSource(as.vector(acq)))
#if you have any different type of file, you need to use a different function than VectorSource. 
#docSource, etc etc depending on the formate of the data 
reuters <- tm_map(reuters, tolower)
reuters <- tm_map(reuters, removeWords, stopwords("english"))
tdm <- TermDocumentMatrix(reuters, control=list(removePunctuation=TRUE,removeNumbers=TRUE))

#inspect(tdm[1:10, 1:10]) <- this is just for the first ten rows and columns of the term document matrix 

install.packages("topicmodels")
require(topicmodels)

#choose number of topics and type of method (VEM or Gibbs)
#we are arbitrarily going with five topics. 
#VEM: variational algorithim
#Gibbs: Gibbs sampling 
#the results are pretty much similar the only difference is the converngence speed, VEM is apparently faster becauaes its newer
lda_model <- LDA(tdm, method="VEM", control=list(alpha=0.1), k=5)
#k is the number of topics we want to cluster by
#alpha is so-called the prior (yeah, remember that from machine learning? )
#in most results alpha is pretty small - how do determine alpha?
#alpha = 0.1 is pretty popular, alpha is usually very low so can go even lower 
lda_inf <- posterior(lda_model, tdm)
#posterior is the prediction 
#lda_inf contains two matricies: topics and terms
#choose top five words to reprsent each topic
#use top.topic.words() function from lda package
install.packages("lda")
require(lda)
top.words <- top.topic.words(t(lda_inf$topics),5, by.score=TRUE)
#we transpose the matrix because its v by k matrix originally 
#by.score = FALSE is default. by.score is false, it only sorts based on probability we have. 
#if it is true, it means that we consider both the probability in the row and the probablity in the column.
#we not only look at the distributuion wihtin the topic but in other topics as well. this is more comprehensive
top.words

#get the topic proportion in each document
topic.proportions <-t(lda_inf$terms)/ colSums(lda_inf$terms)
topic.proportions

colnames(topic.proportions) <- apply(top.words, 2, paste, collapse=" ")
#2 means columm 1 means row

#use melt() function from reshape2 to transform data for the plot
install.packages("reshape2")
require(reshape2)
topic.proportions.df <- melt(cbind(data.frame(topic.proportions), document=factor(1:50)), 
                                   variable.name="topic" , id.vars="document")
#use melt function to take a d by k matrix to a d*k by 3 
require(ggplot2)
qplot(topic, value, fill=document, ylab="proportion", data=topic.proportions.df, geom="bar") 
+opts(axis.text.x=theme_text(angle=90, hjust=1)) + coord_flip() + facet_wrap(~document, ncol=5)
###i get an error message 

#visualize top 15 words 
top.words <- top.topic.words(t(lda_inf$topics), 15, by.score=TRUE)

#search for the top 15 words 
index <-c()
for(element in top.words) index <-c(index, which(rownames(lda_inf$topics) == element))
hm <- heatmap(lda_inf$topics[index,], Rowv=NA, Colv=NA, col=cm.colors(256), scale="column", margins=c(5,10))

#create another heat map sorted by alphabetic order
sub_matrix <- lda_inf$topics[index,]
sorted_matrix <- sub_matrix[order(rownames(sub_matrix)),]
colnames(sorted_matrix) <- c("Topic1", "Topic2", "Topic3", "Topic4", "Topic5")
hm2 <- heatmap(sorted_matrix, Rowv=NA, Colv=NA, col = cm.colors(256), scale="column", margins=c(5,10))
#if you dont set RowV ColV to NA you get a dendogram 
#scale = "column" 
#sclae = "row" is default 

#vizualize word network
correlation <- cor(t(lda_inf$topics))

#chose top 15 words of each topic to get a subset of correlation matrix
index <- c()
for(element in top.words) index <-c(index, which(rownames(correlation)==element))

adjacency <- correlation[index,index]

#use igraph to construct a network
install.packages("igraph")
require(igraph)

g <- graph.adjacency(adjacency, mode="undirected")
g
plot(g, layout=layout.kamada.kawai, vertex.color="pink")
