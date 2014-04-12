install.packages("Rfacebook")
require(Rfacebook)
#sign up for facebook developer code on facebook 
fb_oauth <- fbOAuth(app_id="INSERT YOUR OWN", app_secret="INSERT YOUR OWN")
my_friends <- getFriends(token=fb_oauth, simplify=FALSE)
my_friends_info <- getUsers(my_friends$id, token=fb_oauth, private_info=TRUE)
write.csv(my_friends_info, "myfbfriends.csv")
my_network <- getNetwork(fb_oauth, format="adj.matrix")
singletons <- rowSums(my_network)==0 #remove people who are only connected to me 
install.packages("igraph")
require(igraph)
my_graph <- graph.adjacency(my_network[!singletons,!singletons])
layout <- layout.drl(my_graph,options=list(simmer.attraction=0))
plot(my_graph, vertex.size=2, 
     #vertex.label=NA, 
     vertex.label.cex=0.5,
     edge.arrow.size=0, edge.curved=TRUE,layout=layout)

#calculate network density 
density <- graph.density(my_graph, loops=TRUE)
density2 <- graph.density(simplify(my_graph), loops=FALSE)

#calculate indegree
d.in <- degree(my_graph, mode = c("in"), loops = TRUE, normalized = FALSE)
#out degree
d.out <- degree(my_graph, mode = c("out"), loops = TRUE, normalized = FALSE)
#degree centrality 
degree <- degree(my_graph, loops=T, normalized=F)
#betweenness centrality 
btwn <- betweenness(my_graph, directed = F)
#closeness centrality 
close <- closeness(my_graph, mode = c("all"))
#eigenvector centrality 
eigen <- evcent(my_graph)
#bonchich power centrality 
bon <- bonpow(my_graph)

eigen1 <- eigen[[1]]

#make a data frame of centrality measures 
centrals <- data.frame(d.in, d.out, degree, btwn, close, eigen1)


install.packages("rgexf")
require(rgexf)
nodes <- data.frame(cbind(V(my_graph), as.character(V(my_graph))))
edges <- t(Vectorize(get.edge, vectorize.args='id')(my_graph, 1:ecount(my_graph)))
write.gexf(nodes=nodes,edges=edges, output="gephifb.gexf")
