source("./IO.R")

music_data <- get_music_variables_as_data_frame();
names <- get_motion_feature_names_median();
motion_data <- get_median_fixed_effects();

PCs_motion_data_table <- read.csv('kaiserNormalizedPCs3.csv', header=TRUE)
PCs_motion_data <- data.frame(PCs_motion_data_table$RC1, PCs_motion_data_table$RC2, PCs_motion_data_table$RC3)
# transpose eigenvectors
PCs_motion_data.t <- t(PCs_motion_data)
# transpose data
motion_data.t <- t(scale(motion_data, center = TRUE, scale = TRUE))
motion_data_in_eigenspace <- t(PCs_motion_data.t %*% motion_data.t)
colnames(motion_data_in_eigenspace) <- c("irregular_slowness", "irregular_size", "irregular_smoothness")

all_data_FEATURE_SPACE_A <-cbind(scale(motion_data, center = TRUE, scale = TRUE), music_data)
all_data_FEATURE_SPACE_B <- cbind(motion_data_in_eigenspace, music_data)
require(MASS)
library(lme4)

rhythmicity.A.full  <- lm(rhythmicity ~ max_freq_hz + max_freq_mag + max_freq_rel + volume 
                                       + median_dist_midcrosses + median_std_dist_midcrosses + median_rise_median 
                                       + median_rise_std + median_fall_median + median_fall_std + median_peak_median 
                                       + median_peak_std, data=all_data_FEATURE_SPACE_A)
summary(rhythmicity.A.full)
threshold = qchisq(0.05, 1, lower.tail = F)#threshold for p-value
step.model.rhythmicity.A <- stepAIC(rhythmicity.A.full, k = threshold, direction = "both", 
                                  trace = FALSE)
sink("rhythmicity_A_final.txt")
print(summary(step.model.rhythmicity.A))
sink()

rhythmicity.B.full <- lm(rhythmicity ~ irregular_slowness + irregular_size + irregular_smoothness, data=all_data_FEATURE_SPACE_B)

summary(rhythmicity.B.full)
threshold = qchisq(0.05, 1, lower.tail = F)#threshold for p-value
step.model.rhythmicity.B <- stepAIC(rhythmicity.B.full, k = threshold, direction = "both", 
                                    trace = FALSE)
sink("rhythmicity_B_final.txt")
print(summary(step.model.rhythmicity.B))
sink()


#shapiro.test(step.model$residuals)
#ks.test(step.model$residuals, "pnorm")
pitch.full.model.A <- lm(pitch ~ max_freq_hz + max_freq_mag + max_freq_rel + volume 
                         + median_dist_midcrosses + median_std_dist_midcrosses + median_rise_median 
                         + median_rise_std + median_fall_median + median_fall_std + median_peak_median 
                         + median_peak_std, data=all_data_FEATURE_SPACE_A)
step.model.pitch.A <- stepAIC(pitch.full.model.A, k = threshold, direction = "both", 
                                    trace = FALSE)
sink("pitch_A_final.txt")
print(summary(step.model.pitch.A))
sink()

pitch.B.full <- lm(pitch ~ irregular_slowness + irregular_size + irregular_smoothness, data=all_data_FEATURE_SPACE_B)

summary(pitch.B.full)
threshold = qchisq(0.05, 1, lower.tail = F)#threshold for p-value
step.model.pitch.B <- stepAIC(pitch.B.full, k = threshold, direction = "both", 
                                    trace = FALSE)
sink("pitch_B_final.txt")
print(summary(step.model.pitch.B))
sink()


complexity.full.model.A <- lm(complexity ~ max_freq_hz + max_freq_mag + max_freq_rel + volume 
                         + median_dist_midcrosses + median_std_dist_midcrosses + median_rise_median 
                         + median_rise_std + median_fall_median + median_fall_std + median_peak_median 
                         + median_peak_std, data=all_data_FEATURE_SPACE_A)
step.model.complexity.A <- stepAIC(complexity.full.model.A, k = threshold, direction = "both", 
                              trace = FALSE)
sink("complexity_A_final.txt")
print(summary(step.model.complexity.A))
sink()

complexity.B.full <- lm(complexity ~ irregular_slowness + irregular_size + irregular_smoothness, data=all_data_FEATURE_SPACE_B)

summary(complexity.B.full)
threshold = qchisq(0.05, 1, lower.tail = F)#threshold for p-value
step.model.complexity.B <- stepAIC(complexity.B.full, k = threshold, direction = "both", 
                              trace = FALSE)
sink("complexity_B_final.txt")
print(summary(step.model.complexity.B))
sink()