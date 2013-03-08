

library(foreign)

data <- 
read.dta("C://My_Document//My Box Files//Masahiko Aida//Bootstrap//Boot-T.dta")

summary(data)

hist(data$BOOT2)

t <- rt(200, df)

postscript(file="C://My_Document//My Box Files//Analytics//TopicAnalysis//Bootstrap//Histgram.ps", onefile=FALSE, horizontal=FALSE)
hist(data$RESULTS7, breaks = 20, col = "green")

dev.off()
