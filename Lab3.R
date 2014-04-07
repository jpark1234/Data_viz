#lets try some plotting fun! :D 
require(ggplot2)
#reshape2 has more advanced functions that ggplot2
#GGobi has some network features 
setwd("C:/Users/Jeeyoon/Documents/Columbia University/FALL SEMESTER CLASSES/SPRING SEMESTER CLASSES/QMSS G4063/Lab/Lab3")
tennis <- read.csv("10yearsUSOpen.csv")
t <- subset(tennis, country1=="USA"|country1=="ITA"|country1=="RUS"|country1=="GER"|country1=="BEL")

#1. Bar plots 
qplot(year, data=t, fill=country1, geom="bar")
ggplot(t, aes(year,flil=country1)) + geom_bar()
qplot(year, data=t, fill=country1, geom="bar") + coord_flip() 
#coor_flip : flip the coordinates, turn it to a sideway bar graph
f1 <- qplot(year, data=t, fill=country1, geom="bar", poistion="dodge", binwidth=0.5)
f1 #binwidth=1 is no gap, and the smaller the number, larger the gap, thinner the bars
 
#adjust the scale - so here you say 2003 to 2012 for every year 
f2 <- f1 + scale_x_continuous(breaks=seq(2003,2012,1))
f2
#ggplot2 is more modern, you add objects. its object based - you keep adding layers of objets onto the same plot.
#lots of styling flexibility

#change color with scale_fill_manual
#more color options: computerhope.com/htmcolor.htm
f3 <- f2 + scale_fill_manual(values=c("#7fc6bc","#083642","#b1df01","#cdef9c","#466b5d"))
f3

#brewer pallet, scale_fill_brewer whu whuuuut
qplot(year, data=t, fill=country1, geom="bar", position="dodge", binwidth=0.5) + scale_fill_brewer(palette = "Paired")

#the rest of ther brewer palettes are available when you do
RColorBrewer::display.brewer.all()


#2. Scatter plots 
#size is basically cex. sets the size of the plotting dots
#here, i am basically adding two charts togeter - error for winner 1, error for winner 2. boom
#first c is x axis, second c is y axis 
qplot(c(winner1, winner2), c(error1, error2), data=tennis, size=c(winner1, winner2)/c(error1,error2))
#add some colorz B-)
#the 1, 0 is basically a label here so you can do whatever to distinguish it 
qplot(c(winner1, winner2), c(error1, error2), data=tennis, size=c(winner1, winner2)/c(error1,error2), color=factor(rep(1:0, each=nrow(tennis))))
#you can do continuos gradient colors with scale_color_gradient
qplot(c(winner1, winner2), c(error1, error2), data=tennis, size=c(winner1, winner2)/c(error1,error2), 
      color=c(ace1,ace2))+scale_color_gradient(low="black", high="red")
#lets try some shapes!
qplot(c(winner1, winner2), c(error1, error2), data=tennis, size=c(winner1, winner2)/c(error1,error2), 
      color=c(ace1, ace2), shape=factor(rep(1:0, each=nrow(tennis)))) + scale_colour_gradient(low="blue", high="red")
#add some axis labels and legends
# we are adding legend labels, hang tight donkeyz
plot1 <- qplot(c(winner1, winner2), c(error1,error2), data=tennis, size=c(winner1,winner2)/c(error1,error2), color=c(ace1, ace2),
               shape=factor(rep(0:1, each=nrow(tennis)))) + scale_colour_gradient(low="blue", high="red", name="Number of Aces")
plot1
plot2 <- plot1 + xlab("Number of Winners") + ylab("Number of Errors")
plot2

plot3 <- plot2 + scale_colour_gradient(low="blue", high="red", name="Number of Aces") + scale_shape_discrete(name="Result", labels=c("Winner","Loser")) + scale_size_continuous(name="Ratio of Winners to Errors")
plot3

#wanna see some trend lines, you say?
plot4 <- qplot(c(winner1, winner2), c(error1, error2), data=tennis, color=factor(rep(0:1, each=nrow(tennis))))
plot4

plot4 + geom_smooth() #the default method here is method="gam" when n>1000, otherwise use method="loess"
plot4 + geom_smooth(method="loess",level=0.95) # you dont like grey?
#level is confidence interval, okie?
plot4 + geom_smooth(method="loess",level=0.95, se=F)
#what now, you want labels on the lines? fine
# aes(40,60) is the coordinates where you want your label to appear 
plot4 + geom_smooth(method="lm", level=0.99) + geom_text(aes(40,60, label="Trend Line for Losers, haha", color="1")) + geom_text(aes(50,30, label="Trend Line for Winners, yay", color="0"))

#3. Density Maps
qplot(c(firstPointWon1, firstPointWon2, secPointWon1,secPointWon2), geom="density", data=tennis,
      fill=factor(rep(1:4, each=nrow(tennis))), alpha=0.2)
#alpha is transparency do +facet_grid(year~.) for multiple layers 
qplot(c(firstPointWon1, firstPointWon2, secPointWon1,secPointWon2), geom="density", data=tennis,
      fill=factor(rep(1:4, each=nrow(tennis))), alpha=0.2) + facet_grid(year~.)
#screw these colors, i want new ones and make it smoother
#adjust makes the plots flatter, higher the number the smoother it is 
qplot(c(firstPointWon1,firstPointWon2,secPointWon1,secPointWon2),geom="density",adjust=3, data=tennis, 
      fill=factor(rep(1:4,each=nrow(tennis))), alpha=0.2)+scale_fill_manual(values=c("red","pink","blue","lightblue")) 
#wanna see a stacked histogram? yes always.
qplot(c(ace1, ace2), geom="density", adjust=3, data=tennis, fill=factor(rep(year,2)), alpha=0.5, position="stack")
#wow, so pretty!
#just density lines?
qplot(c(ace1,ace2), geom="density", adjust=3, data=tennis, color=factor(rep(year,2)), alpha=0.5, position="stack")

#pie charts and box plots
#generate nationality pie charts by rotating bar chars
qplot(country1, data=tennis, geom="bar", fill=country1, width=1)+ coord_polar() #x as direction
qplot(country1, data=tennis, geom="bar", fill=country1, width=1)+ coord_polar(theta="y") #default setting is x
#but i just want a pie :(
qplot(factor(1), data=tennis, geom="bar", fill=country1)+coord_polar(theta="y")

#use box plot to compare distributuions
w1 <- qplot(factor(rep(1:4, each=nrow(tennis))), c(firstPointWon1, firstPointWon2, secPointWon1, secPointWon2), 
            data=tennis, geom="boxplot", fill=factor(rep(1:4, each=nrow(tennis))))
w1
#how about we try marking outliers with red dots (this is good for small datasets)
w1 + geom_boxplot(outlier.colour="red", outlier.size=2) #do note the BRITISH WAY OF SPELLING. its COLOUR!

w2 <- qplot(factor(rep(1:4, each=nrow(tennis))), c(firstPointWon1, firstPointWon2, secPointWon1, secPointWon2), 
            data=tennis, geom=c("jitter", "boxplot"), fill=factor(rep(1:4, each=nrow(tennis))))
w2 # here we jittered the data to make it look like someone spilled black sesame seeds everywhere. yumm

#violin plot 
w3 <- qplot(factor(rep(1:4, each=nrow(tennis))), c(firstPointWon1, firstPointWon2, secPointWon1, secPointWon2),
            data=tennis, geom=c("jitter", "violin"), fill=factor(rep(1:4, each = nrow(tennis))))
w3
# well...i like box plots. not violin. 

lab3prac <- ggplot(tennis, aes(x=avgFirstServe1, y=return2)) + geom_point(aes(color=gender, size=return2, shape=gender))
lab3prac
