print(commandArgs())
arg <- commandArgs()

Pop1.Pop2.Fst <- arg[6]
Pop1.Pop3.Fst <- arg[7]
Pop2.Pop3.Fst <- arg[8]
output <- arg[9]

setwd(output)

Pop1.Pop2.Fst <- read.table(Pop1.Pop2.Fst, fill=TRUE)
Pop1.Pop3.Fst <- read.table(Pop1.Pop3.Fst, fill=TRUE)
Pop2.Pop3.Fst <- read.table(Pop2.Pop3.Fst, fill=TRUE)

Position <- Pop1.Pop2.Fst$V2

Pop1.Pop2.Fst <- Pop1.Pop2.Fst$V4
Pop1.Pop3.Fst <- Pop1.Pop3.Fst$V4
Pop2.Pop3.Fst <- Pop2.Pop3.Fst$V4

T.Pop1.Pop2 <- -log(1 - Pop1.Pop2.Fst)
T.Pop1.Pop3 <- -log(1 - Pop1.Pop3.Fst)
T.Pop2.Pop3 <- -log(1 - Pop2.Pop3.Fst)  

PBS.Pop3 <- (T.Pop1.Pop3 + T.Pop2.Pop3 - T.Pop1.Pop2)/2
PBS.Pop3[PBS.Pop3<0] <- 0
PBS.Pos <- cbind(Position,PBS.Pop3)

PBS.Plot <- cbind(as.integer(11), PBS.Pos[,1], PBS.Pos[,2])
colnames(PBS.Plot) <- c("CHR", "BP", "P")

install.packages("qqman")
library(qqman)

manplot <- data.frame(PBS.Plot)
max<-ceiling(max(manplot$P))

png("~/PBS.Plot.png", units="in", height=8, width=12, res=500)
manhattan(manplot, ylim=c(0,max), logp=FALSE, chrlabs=c(""), 
          ylab="PBS", main="",cex = 0.7,cex.lab=1.4, cex.main=1.8, 
          cex.axis = 1.4, col = c("blue4", "orange3"), suggestiveline = F,
          genomewideline = F,highlight=snpsofinterest,lwd=1.7,xlab = "Position (Mb)")

dev.off()
