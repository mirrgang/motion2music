source("./IO.R")
data <- get_median_fixed_effects();

####### CORRELATION MOTION FEATURE SPACE A ############################
library("PerformanceAnalytics")
pdf('corrMotionFeatures.pdf')
chart.Correlation(data, histogram=TRUE, pch=19)
dev.off()

library(corrplot)
M <- cor(data)
res1 <- cor.mtest(data, conf.level = .95)
pdf('correlationMotionFeatures.pdf')
corrplot(M, insig = "label_sig",p.mat = res1$p,order="hclust",
         sig.level = c(.001, .01, .05), pch.cex = .7,type = "upper")
dev.off()
