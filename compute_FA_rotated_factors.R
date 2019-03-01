library(psych)
source("IO.R")
motion_features <- get_median_fixed_effects()
psych::scree(motion_features,factors=TRUE,pc=TRUE,main="Scree plot",hline=NULL,add=FALSE)
pdf('screePlot.pdf')
VSS.scree(motion_features, main = "scree plot")
dev.off()
factors<-fa(motion_features,3)
factors # print results
library(GPArotation)
kaiser_factors <- kaiser(factors, rotate = "oblimin")
kaiser_factors
write.csv(kaiser_factors$loadings, "kaiserNormalizedFactors3.csv", row.names=TRUE)

pcs_rotated <- psych::principal(motion_features, rotate="oblimin", nfactors=3, scores=TRUE)
print(pcs_rotated$loadings[,])  # Scores returned by principal()
pcs_unrotated <- psych::principal(motion_features, nfactors=3, scores=TRUE)
print(pcs_unrotated$loadings[,])
write.csv(pcs_rotated$loadings, "PCs3_oblimin.csv", row.names=TRUE)
kaiser_PCs <- kaiser(pcs_unrotated, rotate = "oblimin")
kaiser_PCs
write.csv(kaiser_PCs$loadings, "kaiserNormalizedPCs3.csv", row.names=TRUE)

#means_rating <- read.csv("/home/melanie/WORKSPACE/R/mean_ratings_headful.csv")
#selection <- means_rating[,c(1,2,5,6,7,11,12,14)]

#psych::scree(selection,factors=TRUE,pc=TRUE,main="Scree plot",hline=NULL,add=FALSE) 
#VSS.scree(selection, main = "scree plot")

#a<-factanal(selection,3,rotation="varimax")
#a # print results
#b <- psych::principal(selection, rotate="varimax", nfactors=3, scores=TRUE)
#print(b$loadings[,])  # Scores returned by principal()

