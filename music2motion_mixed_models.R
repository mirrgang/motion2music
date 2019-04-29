#Mixed Models: Sample => Movement

source("IO.R")
fixed_and_random_effects <- get_median_fixed_effects_and_random_effects()
sample_id <- fixed_and_random_effects$sample_id
participant_id <- fixed_and_random_effects$participant_id
dependent_variables <- data.frame(get_motion_features_PCs())
all_data <- cbind(sample_id, participant_id, dependent_variables);

# Mixed Models for irregular slowness, size, and smoothness
library(nlme)
library(lme4)
mm_irregular_slowness = lme(irregular_slowness ~ sample_id,
              random = ~ 1|participant_id,
              data = all_data)
mm_irregular_size = lme(irregular_size ~ sample_id,
                        random = ~ 1|participant_id,
                        data = all_data)
mm_irregular_smoothness = lme(irregular_smoothness ~ sample_id,
                        random = ~ 1|participant_id,
                        data = all_data)

# Estimated Marginal Means for Mixed Models
library(emmeans)
emm_slowness <- emmeans(mm_irregular_slowness, "sample_id")
emm_size <- emmeans(mm_irregular_size, "sample_id")
emm_smoothness <- emmeans(mm_irregular_smoothness, "sample_id")
emms <- c(emm_slowness, emm_size, emm_smoothness)
for(emm in emms)
{
 # type III test for pairwise and joint significance of fixed effects
  pairs(emm, simple = "sample_id")
  c<-contrast(emm)
  print(test(c, joint = TRUE))
}

library(ggplot2)
library(ggpubr)
# Prepare and Plot data
labels_sample_id <- get_sample_names();

emm_slowness_df <- as.data.frame(emm_slowness)
emm_slowness_df$model <- 'irregular_slowness'
emm_slowness_df$sample_name <- labels_sample_id
emm_size_df <- as.data.frame(emm_size)
emm_size_df$model <- 'irregular_size'
emm_size_df$sample_name <- labels_sample_id
emm_smoothness_df <- as.data.frame(emm_smoothness)
emm_smoothness_df$model <- 'irregular_smoothness'
emm_smoothness_df$sample_name <- labels_sample_id
 
all_df <- rbind(emm_slowness_df, emm_size_df, emm_smoothness_df)
sample<-as.numeric(all_df$sample_id)
flevels <- levels(all_df$sample_id)

pdf("estimatedMarginalMeans.pdf")
pd <- position_dodge(-0.2)
ggplot(all_df, aes(x=sample, y=emmean, colour=model)) + 
  geom_errorbar(aes(ymin=lower.CL, ymax=upper.CL), width=.1, position=pd) +
  geom_line(aes(linetype = model)) +
  geom_point() +
  scale_color_brewer(palette="Paired")+
  theme_minimal() +
  scale_y_continuous(name="estimated marginal means")+
  scale_x_discrete(name="sample", labels=all_df$sample_name, limits=flevels) +
  rotate_x_text(angle = 45) 
dev.off()