

library(foreign)

data <- 
read.dta("C://My_Document//My Box Files//Masahiko Aida//Bootstrap//Boot-T.dta")

summary(data)




t <- rt(2000, 2970)


postscript(file="C://My_Document//My Box Files//Masahiko Aida//Bootstrap//Histgram.ps", onefile=FALSE, horizontal=FALSE)
par(mfrow=c(2,1))
hist(data$BOOT2, breaks = 40, main ='bootstrap-t')
hist(t, breaks = 40)

dev.off()
