setwd("~/Project/Output/PEL_Chr11/")

CEU.CHB.Fst <- read.table("CEU.CHB.fst.slidwind.txt", fill=TRUE)
CEU.PERU.Fst <- read.table("CEU.PEL.fst.slidwind.txt", fill=TRUE)
CHB.PERU.Fst <- read.table("CHB.PEL.fst.slidwind.txt", fill=TRUE)

Position <- CEU.CHB.Fst$V2

CEU.CHB.Fst <- CEU.CHB.Fst$V4
CEU.PERU.Fst <- CEU.PERU.Fst$V4
CHB.PERU.Fst <- CHB.PERU.Fst$V4

T.Pop1.Pop2 <- -log(1 - CEU.CHB.Fst)
T.Pop1.Pop3 <- -log(1 - CEU.PERU.Fst)
T.Pop2.Pop3 <- -log(1 - CHB.PERU.Fst)  

PBS.Pop3 <- (T.Pop1.Pop3 + T.Pop2.Pop3 - T.Pop1.Pop2)/2
PBS.Pop3[PBS.Pop3<0] <- 0
PBS.Pos <- cbind(Position,PBS.Pop3)

pdf("~/Chromosome11.pdf", width=10, height = 7)
plot(PBS.Pos, ylab="PBS", xlab="Position (Mb)",main="Chromosome 11", pch=20, col="blue4")
dev.off()
abline(v=61600000)
abline(v=39307000)
abline(h=0.85)


Chr11 <- PBS.Pos
Chr11 <- cbind(as.integer(11), Chr11[,1], Chr11[,2], seq(1,13482))
colnames(Chr11) <- c("CHR", "BP", "P","SNP")
Chr15 <- PBS.Pos
Chr15 <- cbind(as.integer(15), Chr15[,1], Chr15[,2])
colnames(Chr15) <- c("CHR", "BP", "P")
Chr22 <- PBS.Pos
Chr22 <- cbind(as.integer(22), Chr22[,1], Chr22[,2])
colnames(Chr22) <- c("CHR", "BP", "P")

library(qqman)
vignette("qqman")
mplot <- rbind(Chr11,Chr15,Chr22)
manplot <- data.frame(Chr11)
manplot$CHR[manplot$CHR==11] <- 1
manplot$CHR[manplot$CHR==15] <- 2
manplot$CHR[manplot$CHR==22] <- 3

abline(h=quantile(manplot$P,.999,na.rm=TRUE))
hello <- subset(manplot,manplot$P > 0.5467227)
hello

snpsofinterest<- seq(6120,6174,1)
resfactor=3
pdf("~/Manhattan.pdf", height=7, width=10)
manhattan(manplot, ylim=c(0,0.8), logp=FALSE, chrlabs=c("11"), 
          ylab="PBS", main="Chromosome 11 50Kb Window PBS",cex = 0.6, 
          cex.axis = 0.9, col = c("blue4", "orange3"), suggestiveline = F,
          genomewideline = F,highlight=snpsofinterest, xlab = "Position (Mb)")

dev.off()



abline(h=Threshold)
manhattan(subset(manplot, CHR == 3), logp=FALSE,chrlabs=c("11"),ylim=c(0,1),          ylab="PBS", main="Manhattan plot of PBS values",cex = 0.6, 
          cex.axis = 0.9, suggestiveline = F,xlab="Chromosome 22 Position (Mb)",
          genomewideline = F)
abline(h=0.55, col="red")

PBS.High <-subset(manplot, manplot$P>0.8)
PBS.High[order(PBS.High[,3]),]

###################################################################################

setwd("~/Project/Output/PEL_Chr11/")

CEU.CHB.Fst <- read.table("CEU.CHB.fst.slidwind.txt", fill=TRUE)
CEU.PERU.Fst <- read.table("CEU.PEL.fst.slidwind.txt", fill=TRUE)
CHB.PERU.Fst <- read.table("CHB.PEL.fst.slidwind.txt", fill=TRUE)

CEU.CHB.Fst.61 <- subset(CEU.CHB.Fst, CEU.CHB.Fst[,2]>61000000)
CEU.CHB.Fst.61 <- subset(CEU.CHB.Fst.61, CEU.CHB.Fst.61[,2]<62000000)
CEU.PERU.Fst.61 <- subset(CEU.PERU.Fst, CEU.PERU.Fst[,2]>61000000)
CEU.PERU.Fst.61 <- subset(CEU.PERU.Fst.61, CEU.PERU.Fst.61[,2]<62000000)
CHB.PERU.Fst.61 <- subset(CHB.PERU.Fst, CHB.PERU.Fst[,2]>61000000)
CHB.PERU.Fst.61 <- subset(CHB.PERU.Fst.61, CHB.PERU.Fst.61[,2]<62000000)

dim(CEU.CHB.Fst.61)
dim(CEU.PERU.Fst.61)
dim(CHB.PERU.Fst.61)
Position <- CEU.CHB.Fst.61$V2

CEU.CHB.Fst.61 <- CEU.CHB.Fst.61$V4
CEU.PERU.Fst.61 <- CEU.PERU.Fst.61$V4
CHB.PERU.Fst.61 <- CHB.PERU.Fst.61$V4

T.Pop1.Pop2 <- -log(1 - CEU.CHB.Fst.61)
T.Pop1.Pop3 <- -log(1 - CEU.PERU.Fst.61)
T.Pop2.Pop3 <- -log(1 - CHB.PERU.Fst.61)  
Position <- Position/1000000
PBS.Pop3 <- (T.Pop1.Pop3 + T.Pop2.Pop3 - T.Pop1.Pop2)/2
PBS.Pop3[PBS.Pop3<0] <- 0
PBS.Pos <- cbind(Position,PBS.Pop3)

pdf("~/FADS_50kb_window.pdf",height=7, width=10)
plot(PBS.Pos, ylab="PBS", xlab="Position (Mb)",main="Chromosome 11: FADS Cluster", frame.plot=FALSE, cex=1, type="l",lty=1, ylim=c(0,0.6))
dev.off()
write(t(PBS.Pos),"~/FADS_50kb.txt",ncol=2)
abline(v=61600000)
abline(v=39307000)
abline(h=0.85)

PBS.High <-subset(PBS.Pos, PBS.Pos[,2]>0.8)
PBS.High[order(PBS.High[,2]),]

###################################################################################

CEU.CHB.Fst.67 <- subset(CEU.CHB.Fst, CEU.CHB.Fst[,2]>66555000)
CEU.CHB.Fst.67 <- subset(CEU.CHB.Fst.67, CEU.CHB.Fst.67[,2]<67555000)
CEU.PERU.Fst.67 <- subset(CEU.PERU.Fst, CEU.PERU.Fst[,2]>66555000)
CEU.PERU.Fst.67 <- subset(CEU.PERU.Fst.67, CEU.PERU.Fst.67[,2]<67555000)
CHB.PERU.Fst.67 <- subset(CHB.PERU.Fst, CHB.PERU.Fst[,2]>66555000)
CHB.PERU.Fst.67 <- subset(CHB.PERU.Fst.67, CHB.PERU.Fst.67[,2]<67555000)

dim(CEU.CHB.Fst.67)
dim(CEU.PERU.Fst.67)
dim(CHB.PERU.Fst.67)
Position <- CEU.CHB.Fst.67$V2

CEU.CHB.Fst.67 <- CEU.CHB.Fst.67$V4
CEU.PERU.Fst.67 <- CEU.PERU.Fst.67$V4
CHB.PERU.Fst.67 <- CHB.PERU.Fst.67$V4

T.Pop1.Pop2 <- -log(1 - CEU.CHB.Fst.67)
T.Pop1.Pop3 <- -log(1 - CEU.PERU.Fst.67)
T.Pop2.Pop3 <- -log(1 - CHB.PERU.Fst.67)  

PBS.Pop3 <- (T.Pop1.Pop3 + T.Pop2.Pop3 - T.Pop1.Pop2)/2
PBS.Pop3[PBS.Pop3<0] <- 0
PBS.Pos <- cbind(Position,PBS.Pop3)


plot(PBS.Pos, ylab="PBS", xlab="Position",main="Chromosome 11:66555000-67555000")
abline(v=61600000)
abline(v=39307000)
abline(h=0.85)

PBS.High <-subset(PBS.Pos, PBS.Pos[,2]>0.5)
PBS.High[order(PBS.High[,2]),]

###################################################################################


CEU.CHB.Fst.94 <- subset(CEU.CHB.Fst, CEU.CHB.Fst[,2]>94055000)
CEU.CHB.Fst.94 <- subset(CEU.CHB.Fst.94, CEU.CHB.Fst.94[,2]<95055000)
CEU.PERU.Fst.94 <- subset(CEU.PERU.Fst, CEU.PERU.Fst[,2]>94055000)
CEU.PERU.Fst.94 <- subset(CEU.PERU.Fst.94, CEU.PERU.Fst.94[,2]<95055000)
CHB.PERU.Fst.94 <- subset(CHB.PERU.Fst, CHB.PERU.Fst[,2]>94055000)
CHB.PERU.Fst.94 <- subset(CHB.PERU.Fst.94, CHB.PERU.Fst.94[,2]<95055000)

dim(CEU.CHB.Fst.94)
dim(CEU.PERU.Fst.94)
dim(CHB.PERU.Fst.94)
Position <- CEU.CHB.Fst.94$V2

CEU.CHB.Fst.94 <- CEU.CHB.Fst.94$V4
CEU.PERU.Fst.94 <- CEU.PERU.Fst.94$V4
CHB.PERU.Fst.94 <- CHB.PERU.Fst.94$V4

T.Pop1.Pop2 <- -log(1 - CEU.CHB.Fst.94)
T.Pop1.Pop3 <- -log(1 - CEU.PERU.Fst.94)
T.Pop2.Pop3 <- -log(1 - CHB.PERU.Fst.94)  

PBS.Pop3 <- (T.Pop1.Pop3 + T.Pop2.Pop3 - T.Pop1.Pop2)/2
PBS.Pop3[PBS.Pop3<0] <- 0
PBS.Pos <- cbind(Position,PBS.Pop3)


plot(PBS.Pos, ylab="PBS", xlab="Position",main="Chromosome 11:94055000-95055000")
abline(v=61600000)
abline(v=39307000)
abline(h=0.85)

PBS.High <-subset(PBS.Pos, PBS.Pos[,2]>0.5)
PBS.High[order(PBS.High[,2]),]

###################################################################################

setwd("~/Project/Output/PEL_Chr22/Per_Site")

CEU.CHB.Fst <- read.table("CEU.CHB.fst.slidwind.txt", fill=TRUE)
CEU.PERU.Fst <- read.table("CEU.PEL.fst.slidwind.txt", fill=TRUE)
CHB.PERU.Fst <- read.table("CHB.PEL.fst.slidwind.txt", fill=TRUE)

CEU.CHB.Fst.42 <- subset(CEU.CHB.Fst, CEU.CHB.Fst[,2]>41635000)
CEU.CHB.Fst.42 <- subset(CEU.CHB.Fst.42, CEU.CHB.Fst.42[,2]<42635000)
CEU.PERU.Fst.42 <- subset(CEU.PERU.Fst, CEU.PERU.Fst[,2]>41635000)
CEU.PERU.Fst.42 <- subset(CEU.PERU.Fst.42, CEU.PERU.Fst.42[,2]<42635000)
CHB.PERU.Fst.42 <- subset(CHB.PERU.Fst, CHB.PERU.Fst[,2]>41635000)
CHB.PERU.Fst.42 <- subset(CHB.PERU.Fst.42, CHB.PERU.Fst.42[,2]<42635000)

dim(CEU.CHB.Fst.42)
dim(CEU.PERU.Fst.42)
dim(CHB.PERU.Fst.42)
Position <- CEU.CHB.Fst.42$V2

CEU.CHB.Fst.42 <- CEU.CHB.Fst.42$V4
CEU.PERU.Fst.42 <- CEU.PERU.Fst.42$V4
CHB.PERU.Fst.42 <- CHB.PERU.Fst.42$V4

T.Pop1.Pop2 <- -log(1 - CEU.CHB.Fst.42)
T.Pop1.Pop3 <- -log(1 - CEU.PERU.Fst.42)
T.Pop2.Pop3 <- -log(1 - CHB.PERU.Fst.42)  

PBS.Pop3 <- (T.Pop1.Pop3 + T.Pop2.Pop3 - T.Pop1.Pop2)/2
PBS.Pop3[PBS.Pop3<0] <- 0
PBS.Pos <- cbind(Position,PBS.Pop3)


plot(PBS.Pos, ylab="PBS", xlab="Position",main="Chromosome 22:41635000-42635000")
abline(v=39280000)
abline(v=39307000)
abline(h=0.85)

PBS.High <-subset(PBS.Pos, PBS.Pos[,2]>1)
PBS.High[order(PBS.High[,2]),]


###################################################################################


CEU.CHB.Fst.40 <- subset(CEU.CHB.Fst, CEU.CHB.Fst[,2]>40275000)
CEU.CHB.Fst.40 <- subset(CEU.CHB.Fst.40, CEU.CHB.Fst.40[,2]<41225000)
CEU.PERU.Fst.40 <- subset(CEU.PERU.Fst, CEU.PERU.Fst[,2]>40275000)
CEU.PERU.Fst.40 <- subset(CEU.PERU.Fst.40, CEU.PERU.Fst.40[,2]<41225000)
CHB.PERU.Fst.40 <- subset(CHB.PERU.Fst, CHB.PERU.Fst[,2]>40275000)
CHB.PERU.Fst.40<- subset(CHB.PERU.Fst.40, CHB.PERU.Fst.40[,2]<41225000)

dim(CEU.CHB.Fst.40)
dim(CEU.PERU.Fst.40)
dim(CHB.PERU.Fst.40)
Position <- CEU.CHB.Fst.40$V2

CEU.CHB.Fst.40 <- CEU.CHB.Fst.40$V4
CEU.PERU.Fst.40 <- CEU.PERU.Fst.40$V4
CHB.PERU.Fst.40 <- CHB.PERU.Fst.40$V4

T.Pop1.Pop2 <- -log(1 - CEU.CHB.Fst.40)
T.Pop1.Pop3 <- -log(1 - CEU.PERU.Fst.40)
T.Pop2.Pop3 <- -log(1 - CHB.PERU.Fst.40)  

PBS.Pop3 <- (T.Pop1.Pop3 + T.Pop2.Pop3 - T.Pop1.Pop2)/2
PBS.Pop3[PBS.Pop3<0] <- 0
PBS.Pos <- cbind(Position,PBS.Pop3)

plot(PBS.Pos, ylab="PBS", xlab="Position",main="Chromosome 22:40275000-41225000")

###################################################################################

setwd("~/Project/Output/PEL_Chr22/Per_Site")

CEU.CHB.Fst.39 <- subset(CEU.CHB.Fst, CEU.CHB.Fst[,2]>38800000)
CEU.CHB.Fst.39 <- subset(CEU.CHB.Fst.39, CEU.CHB.Fst.39[,2]<39800000)
CEU.PERU.Fst.39 <- subset(CEU.PERU.Fst, CEU.PERU.Fst[,2]>38800000)
CEU.PERU.Fst.39 <- subset(CEU.PERU.Fst.39, CEU.PERU.Fst.39[,2]<39800000)
CHB.PERU.Fst.39 <- subset(CHB.PERU.Fst, CHB.PERU.Fst[,2]>38800000)
CHB.PERU.Fst.39 <- subset(CHB.PERU.Fst.39, CHB.PERU.Fst.39[,2]<39800000)

dim(CEU.CHB.Fst.39)
dim(CEU.PERU.Fst.39)
dim(CHB.PERU.Fst.39)
Position <- CEU.CHB.Fst.39$V2

CEU.CHB.Fst.39 <- CEU.CHB.Fst.39$V4
CEU.PERU.Fst.39 <- CEU.PERU.Fst.39$V4
CHB.PERU.Fst.39 <- CHB.PERU.Fst.39$V4

T.Pop1.Pop2 <- -log(1 - CEU.CHB.Fst.39)
T.Pop1.Pop3 <- -log(1 - CEU.PERU.Fst.39)
T.Pop2.Pop3 <- -log(1 - CHB.PERU.Fst.39)  

PBS.Pop3 <- (T.Pop1.Pop3 + T.Pop2.Pop3 - T.Pop1.Pop2)/2
PBS.Pop3[PBS.Pop3<0] <- 0
PBS.Pos <- cbind(Position,PBS.Pop3)

plot(PBS.Pos, ylab="PBS", xlab="Position",main="Chromosome 22:38800000-39800000")
