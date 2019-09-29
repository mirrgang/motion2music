close all;
A = readSubjectiveQualities('expert_ratings/subjective_music_qualities_P2.csv');
B = readSubjectiveQualities('expert_ratings/subjective_music_qualities2_P3.csv');
C = readSubjectiveQualities('expert_ratings/subjective_music_qualities2_P1_prepared.csv');
mask_selected_songs = [1 4:7 9 13 15:20 25 28]; %selected songs

ratings_A = A(mask_selected_songs,:);
ratings_B = B(mask_selected_songs,:);
ratings_C = C(mask_selected_songs,:);

%load PCs of music properties
fid = fopen('music_properties/factor_loads.csv');
F = textscan(fid, '%f %f %f', 8, 'Delimiter', ',');
fclose(fid);
pca_factor_loads = [F{1} F{2} F{3}];
mask = [1 2 5 6 7 11 12 14];%selected music properties with sufficient inter-rater reliability

%plot correlation between music properties
all_ratings = [ratings_A(:, mask);ratings_B(:, mask); ratings_C(:, mask)];
csvwrite('music_ratings_all.csv', all_ratings);

%transform expert ratings to feature space, reduce ratings from 15x8 to
%15x3
ratings_A_transformed = pca_data(ratings_A(:,mask),pca_factor_loads);
ratings_B_transformed = pca_data(ratings_B(:,mask),pca_factor_loads);
ratings_C_transformed = pca_data(ratings_C(:,mask),pca_factor_loads);

%for each music property, create 15x3 matrix with rows=songs, and
%columns=experts
rhythmicity = [ratings_A_transformed(:,1) ratings_B_transformed(:,1) ratings_C_transformed(:,1)];
pitch = [ratings_A_transformed(:,2) ratings_B_transformed(:,2) ratings_C_transformed(:,2)];
complexity = [ratings_A_transformed(:,3) ratings_B_transformed(:,3) ratings_C_transformed(:,3)];

x_rhythmicity = (1:size(rhythmicity,1))';
y_rhythmicity = mean(rhythmicity,2);
e_rhythmicity = std(rhythmicity,1,2);

x_pitch = (1:size(pitch,1))';
y_pitch = mean(pitch,2);
e_pitch = std(pitch,1,2);

x_complexity = (1:size(complexity,1))';
y_complexity = mean(complexity,2);
e_complexity = std(complexity,1,2);


delta_offset = .09;%offset for confidence intervals not to be obscured

subplot(1,2,1)
hold on
eb_1 = errorbar(x_rhythmicity-delta_offset,y_rhythmicity,e_rhythmicity,'-+');
eb_2 = errorbar(x_pitch,y_pitch,e_pitch, '--o');
eb_3 = errorbar(x_complexity+delta_offset,y_complexity,e_complexity,':d');
%lower ending of confidence interval
lo_rhythmicity = y_rhythmicity - e_rhythmicity;
lo_pitch = y_pitch - e_pitch;
lo_complexity = y_complexity - e_complexity;
%upper ending of confidence interval
hi_rhythmicity = y_rhythmicity + e_rhythmicity;
hi_pitch = y_pitch + e_pitch;
hi_complexity = y_complexity + e_complexity;

%line through means
hl_rhythmicity = line(x_rhythmicity-delta_offset,y_rhythmicity);
hl_pitch = line(x_pitch,y_pitch);
hl_complexity = line(x_complexity+delta_offset,y_complexity);

%grid on
xlim([0.8 15]);
set(hl_rhythmicity, 'color', 'k', 'marker', 'x', 'linestyle', '-');
set(eb_1, 'color', 'k', 'marker', 'x', 'linestyle', '-');
set(hl_pitch, 'color', [0.4 0.4 0.4], 'marker', '+', 'linestyle', '--');
set(eb_2, 'color', [0.4 0.4 0.4], 'marker', '+', 'linestyle', '--');
set(hl_complexity, 'color', [0.1 0.1 0.1], 'marker', 'd', 'linestyle', ':');
set(eb_3, 'color', [0.1 0.1 0.1], 'marker', 'd', 'linestyle', ':');

songs = {'GirlOnFire', 'Detroit', 'Chandelier', 'YouDontKnowMyName', 'DryAndDusty', 'AladdinSane', 'AnotherStar', 'PeoplePleaser', 'Bad', 'Monument', 'SacreDuPrintemps', 'LeavingSong', 'SpaceOddity', 'Tonight', 'CosmicLove'};
set(gca,'xtick', 1:15, 'xticklabel',songs) 
xtickangle(45)
legend([hl_rhythmicity, hl_pitch, hl_complexity], 'rhythmicity', 'pitch', 'complexity');

%########## subjective ratings of movement suitability ############
BG_song = getBackgroundSongData();
suitability2move = squeeze(BG_song(:,:,1));
like = squeeze(BG_song(:,:,2));

predictors_all = csvread('response_variables_PCs_2019.csv')
all = csvread('feature_space_25_11_2018_PC_on_participant_level.csv')
suitability_all = all(:, 31);
[corr_suitability2move_music, p] = corr([suitability_all predictors_all])


subplot(1,2,2)
x_suitability = (1:size(suitability2move,2));
x_like = (1:size(like,2));
y_suitability = mean(suitability2move,1);
y_like = mean(like,1);
e_suitability = std(suitability2move,1);
e_like = std(like,1);
hold on
e_suit_plot = errorbar(x_suitability-delta_offset,y_suitability,e_suitability,'x');
e_like_plot = errorbar(x_like,y_like,e_like,'x');
lo_suitability = y_suitability - e_suitability;
lo_like = y_like - e_like;
hi_like = y_like + e_like;
hi_suitability = y_suitability + e_suitability;
hl_like = line(x_like-delta_offset,y_like);
hl_suitability = line(x_suitability-delta_offset,y_suitability);

%grid on
xlim([0.8 15]);
set(hl_suitability, 'color', 'k', 'marker', 'x', 'linestyle', '-');
set(e_suit_plot, 'color', 'k', 'marker', 'x');
set(hl_like, 'color', [0.1 0.1 0.1], 'marker', '+', 'linestyle', '--');
set(e_like_plot, 'color', [0.1 0.1 0.1], 'marker', '+');
set(gca,'xtick', 1:15, 'xticklabel',songs) 
xtickangle(45)
legend([hl_suitability, hl_like], 'suitability to move', 'liking');
