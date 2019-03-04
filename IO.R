get_music_variables_as_data_frame <- function()
{
  music_properties <- read.csv("./data/response_variables_PCs_2019.csv",header = FALSE);
  rhythmicity <- as.numeric(music_properties[,1]);
  pitch <- as.numeric(music_properties[,2]);
  complexity <- as.numeric(music_properties[,3]);
  music_data <- data.frame(rhythmicity, pitch, complexity);
  return(music_data)
}

get_motion_feature_names <- function()
{
  names <- c("max_freq_hz","max_freq_mag", "max_freq_rel", "volume", 
             "median_dist_midcrosses_PC1","std_dist_midcrosses_PC1", "rise_median_x", "rise_std_x",
             "fall_median_x", "fall_std_x","peak_median_x","peak_std_x",
           "median_dist_midcrosses_PC2","std_dist_midcrosses_PC2",
           "rise_median_y", "rise_std_y","fall_median_y", "fall_std_y",
           "peak_median_y", "peak_std_y","median_dist_midcrosses_PC3", "std_dist_midcrosses_PC3",
           "rise_median_z","rise_std_z","fall_median_z","fall_std_z",
           "peak_median_z","peak_std_z");
  return(names)
}



get_motion_feature_names_median <- function()
{
  names <- c("max_freq_hz","max_freq_mag", "max_freq_rel", "volume", 
             "median_dist_midcrosses","median_std_dist_midcrosses", "median_rise_median", "median_rise_std",
             "median_fall_median", "median_fall_std","median_peak_median","median_peak_std");
  return(names)
}

get_sample_names <- function()
{
  song_names <- list('GirlOnFire', 'Detroit', 'Chandelier', 'YouDontKnowMyName','DryAndDusty','AladdinSane',
               'AnotherStar','PeoplePleaser','Bad','Monument','SacreDuPrintemps','LeavingSong',
               'SpaceOddity','Tonight','CosmicLove');
  return(song_names);
}

get_participant_ID <- function()
{
  feature_space <- read.csv("./data/feature_space_25_11_2018_PC_on_participant_level.csv", header = FALSE);
  participant_id <- as.factor(feature_space[,34]);
  return(participant_id);
}

get_median_fixed_effects_and_random_effects <- function(scaleData=TRUE)
{
  feature_space <- read.csv("./data/feature_space_25_11_2018_PC_on_participant_level.csv", header = FALSE);
  #feature_space <- scale(feature_space, center=FALSE, scale=TRUE);
  max_freq_hz<- as.numeric(feature_space[,1]);
  max_freq_mag<-as.numeric(feature_space[,2]);
  max_freq_rel <- as.numeric(feature_space[,3]);
  volume<- as.numeric(feature_space[,4]);
  median_dist_midcrosses_PC1 <- as.numeric(feature_space[,5]); 
  median_dist_midcrosses_PC2 <- as.numeric(feature_space[,13]);
  median_dist_midcrosses_PC3 <- as.numeric(feature_space[,21]);
  median_dist_midcrosses <- apply(cbind(median_dist_midcrosses_PC1,median_dist_midcrosses_PC2,median_dist_midcrosses_PC3), 1, median)
  std_dist_midcrosses_PC1 <- as.numeric(feature_space[,6]);
  std_dist_midcrosses_PC2<- as.numeric(feature_space[,14]);
  std_dist_midcrosses_PC3 <- as.numeric(feature_space[,22]);
  median_std_dist_midcrosses <- apply(cbind(std_dist_midcrosses_PC1,std_dist_midcrosses_PC2,std_dist_midcrosses_PC3), 1, median)
  rise_median_x<- as.numeric(feature_space[,7]);
  rise_median_y<- as.numeric(feature_space[,15]);
  rise_median_z<- as.numeric(feature_space[,23]);
  median_rise_median <- apply(cbind(rise_median_x,rise_median_y,rise_median_z), 1, median)
  rise_std_x <- as.numeric(feature_space[,8]);
  rise_std_y<- as.numeric(feature_space[,16]);
  rise_std_z<- as.numeric(feature_space[,24]);
  median_rise_std <- apply(cbind(rise_std_x,rise_std_y,rise_std_z), 1, median)
  fall_median_x<- as.numeric(feature_space[,9]);
  fall_median_y<- as.numeric(feature_space[,17]);
  fall_median_z<- as.numeric(feature_space[,25]);
  median_fall_median <- apply(cbind(fall_median_x,fall_median_y,fall_median_z), 1, median)
  fall_std_x<- as.numeric(feature_space[,10]);
  fall_std_y<- as.numeric(feature_space[,18]);
  fall_std_z<- as.numeric(feature_space[,26]);
  median_fall_std <- apply(cbind(fall_std_x,fall_std_y,fall_std_z), 1, median)
  peak_median_x <- as.numeric(feature_space[,11]);
  peak_median_y <- as.numeric(feature_space[,19]);
  peak_median_z <- as.numeric(feature_space[,27]);
  median_peak_median <- apply(cbind(peak_median_x,peak_median_y,peak_median_z), 1, median);
  peak_std_x<- as.numeric(feature_space[,12]);
  peak_std_y <- as.numeric(feature_space[,20]);
  peak_std_z<- as.numeric(feature_space[,28]);
  median_peak_std <- apply(cbind(peak_std_x,peak_std_y,peak_std_z), 1, median);
  sample_id <- as.factor(feature_space[,30]);
  bg_song_suitability_to_move <- as.numeric(feature_space[,31]);
  bg_song_known <- as.numeric(feature_space[,32]);
  bg_song_like <- as.numeric(feature_space[,33]);
  participant_id <- as.factor(feature_space[,34]);
  dancing_experience <- as.numeric(feature_space[,35]);
  dancing_training <- as.numeric(feature_space[,36]);
  is_amateur <- as.numeric(feature_space[,37]);
  music_bg <- as.numeric(feature_space[,38]);
  age <- as.numeric(feature_space[,39]);
  gender <- as.factor(feature_space[,40]);
  
  data_compilation <- data.frame(max_freq_hz, max_freq_mag, max_freq_rel, volume, 
                                 median_dist_midcrosses, median_std_dist_midcrosses, median_rise_median, median_rise_std, 
                                 median_fall_median, median_fall_std, median_peak_median, median_peak_std, 
                                 sample_id, bg_song_suitability_to_move, bg_song_known, bg_song_like, participant_id, 
                                 dancing_experience, dancing_training, is_amateur, music_bg, age, gender);
  return(data_compilation);
}

get_median_fixed_effects <- function()
{
  feature_space <- read.csv("./data/feature_space_25_11_2018_PC_on_participant_level.csv", header = FALSE);
  max_freq_hz<- as.numeric(feature_space[,1]);
  max_freq_mag<-as.numeric(feature_space[,2]);
  max_freq_rel <- as.numeric(feature_space[,3]);
  volume<- as.numeric(feature_space[,4]);
  median_dist_midcrosses_PC1 <- as.numeric(feature_space[,5]); 
  median_dist_midcrosses_PC2 <- as.numeric(feature_space[,13]);
  median_dist_midcrosses_PC3 <- as.numeric(feature_space[,21]);
  median_dist_midcrosses <- apply(cbind(median_dist_midcrosses_PC1,median_dist_midcrosses_PC2,median_dist_midcrosses_PC3), 1, median)
  std_dist_midcrosses_PC1 <- as.numeric(feature_space[,6]);
  std_dist_midcrosses_PC2<- as.numeric(feature_space[,14]);
  std_dist_midcrosses_PC3 <- as.numeric(feature_space[,22]);
  median_std_dist_midcrosses <- apply(cbind(std_dist_midcrosses_PC1,std_dist_midcrosses_PC2,std_dist_midcrosses_PC3), 1, median)
  rise_median_PC1<- as.numeric(feature_space[,7]);
  rise_median_PC2<- as.numeric(feature_space[,15]);
  rise_median_PC3<- as.numeric(feature_space[,23]);
  median_rise_median <- apply(cbind(rise_median_PC1,rise_median_PC2,rise_median_PC3), 1, median)
  rise_std_PC1 <- as.numeric(feature_space[,8]);
  rise_std_PC2<- as.numeric(feature_space[,16]);
  rise_std_PC3<- as.numeric(feature_space[,24]);
  median_rise_std <- apply(cbind(rise_std_PC1,rise_std_PC2,rise_std_PC3), 1, median)
  fall_median_PC1<- as.numeric(feature_space[,9]);
  fall_median_PC2<- as.numeric(feature_space[,17]);
  fall_median_PC3<- as.numeric(feature_space[,25]);
  median_fall_median <- apply(cbind(fall_median_PC1,fall_median_PC2,fall_median_PC3), 1, median)
  fall_std_PC1<- as.numeric(feature_space[,10]);
  fall_std_PC2<- as.numeric(feature_space[,18]);
  fall_std_PC3<- as.numeric(feature_space[,26]);
  median_fall_std <- apply(cbind(fall_std_PC1,fall_std_PC2,fall_std_PC3), 1, median)
  peak_median_PC1 <- as.numeric(feature_space[,11]);
  peak_median_PC2 <- as.numeric(feature_space[,19]);
  peak_median_PC3 <- as.numeric(feature_space[,27]);
  median_peak_median <- apply(cbind(peak_median_PC1,peak_median_PC2,peak_median_PC3), 1, median)
  peak_std_PC1<- as.numeric(feature_space[,12]);
  peak_std_PC2 <- as.numeric(feature_space[,20]);
  peak_std_PC3<- as.numeric(feature_space[,28]);
  median_peak_std <- apply(cbind(peak_std_PC1,peak_std_PC2,peak_std_PC3), 1, median)
  data_compilation <- data.frame(max_freq_hz, max_freq_mag, max_freq_rel, volume, 
                                 median_dist_midcrosses, median_std_dist_midcrosses, median_rise_median, median_rise_std, 
                                 median_fall_median, median_fall_std, median_peak_median, median_peak_std);
  write.csv(data_compilation, "motion_features_medians.csv", row.names=TRUE)
  return(data_compilation);
}