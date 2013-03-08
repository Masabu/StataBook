

library(foreign)

data <- 
read.dta("C://My_Document//My Box Files//Analytics//TopicAnalysis//Bootstrap//ForGraph.dta")

summary(data)

hist(data$RESULTS7)

postscript(file="C://My_Document//My Box Files//Analytics//TopicAnalysis//Bootstrap//Histgram.ps", onefile=FALSE, horizontal=FALSE)
hist(data$RESULTS7, breaks = 20, col = "green")
dev.off()
