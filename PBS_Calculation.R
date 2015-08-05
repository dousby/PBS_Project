arg <- commandArgs()

filepath <- arg[6]
output <- arg[7]
PBScalc <- function(filepath, output){

  Fsttab <- read.table(filepath)
  
  ## Calc T for each group:
  
  T.Pop1.Pop2 <- -log(1 - Fsttab[1,])
  T.Pop1.Pop3 <- -log(1 - Fsttab[2,])
  T.Pop2.Pop3 <- -log(1- Fsttab[3,])  

  PBS.Pop1 <- (T.Pop1.Pop2 + T.Pop1.Pop3 - T.Pop2.Pop3)/2
  PBS.Pop2 <- (T.Pop1.Pop2 + T.Pop2.Pop3 - T.Pop1.Pop3)/2
  PBS.Pop3 <- (T.Pop1.Pop3 + T.Pop2.Pop3 - T.Pop1.Pop2)/2
  
  PBS <- matrix(0, nrow=3, ncol=1)
  PBS[1,1] <- PBS.Pop1
  PBS[2,1] <- PBS.Pop2
  PBS[3,1] <- PBS.Pop3

  write(PBS, output, ncolumns=1)
}

PBScalc(filepath, output)