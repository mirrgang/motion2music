do_extract_features = 1;

if(do_extract_features)
    savePreProcessedMotionData('/home/melanie/WORKSPACE/motion2music2017/motion_phone','motion_data_pre_processed/');
    saveMotionDataProjected2Eigenspace('motion_data_pre_processed','motion_data_in_eigenspace/');
    saveFeatures('motion_data_in_eigenspace', 'features/');
end

nparticipants = 23;
nfeatures = 40;%29 motion features, sample_id, song_suitability, song_known, song_liking, participant_id, dancing_experience, dancing_training, is_amateur, music_bg, age, gender
nrandomeffects = 11;
nsamples = 15;
titles = get_song_titles('/home/melanie/WORKSPACE/motion2music2017/expert_ratings/subjective_music_qualities_SK.csv');
mapping = get_sample_name_id_mapping();
outtake_feature_data = getOuttakeFeatures();
sampleIDs_per_participant = getNSamplesPerParticipant(outtake_feature_data);
bg_data = getBackgroundSongData();

final_feature_space = zeros(nsamples*nparticipants-size(outtake_feature_data,1),nfeatures);
socio_data = get_socio_bio_features('random_effects/dancing_experience.csv', '%f%f%f', 1, [2 3], 1:23);
socio_data_music_bg = get_socio_bio_features('random_effects/music_bg.csv', '%f%f%f%f', 1, [2 3 4], 1:23);
is_amateur = socio_data(:,3)>=1;%participants trained in dancing for more or equal to one year

participant_selection = 1:23;
samples_count = 0;
for k=1:nparticipants
    participantID = participant_selection(k)        
    S = cell2mat(sampleIDs_per_participant{k});
    Nsamples_k = size(S,2);
    sample_feature_mapping = zeros(Nsamples_k,1);    
    motion_features_participant = zeros(Nsamples_k,nfeatures-nrandomeffects);
    bg_data_participant = [];
    for i=1:1:Nsamples_k
        j = S(i);
        sample_name = titles{j};  
        filename = strcat('features/features_',num2str(sample_name),'_',num2str(participantID),'_.mat');
        sample_feature_mapping(i) = mapping.(sample_name);
        load(filename);   
        motion_features_participant(i,:) = squeeze(features(1,:));
        bg_data_participant(i,:)=bg_data(k,sample_feature_mapping(i),:);
    end
    index = find(socio_data(:,1)==participantID);
    participant_socio_data = socio_data(index,[2 3]);
    participant_is_amateur = is_amateur(index);
    participant_socio_data_part2 = socio_data_music_bg(index,[2:4]);
    sample_ids = sample_feature_mapping;
    %TODO rework assignment
    start_idx = samples_count+1;
    final_feature_space(start_idx:start_idx+Nsamples_k-1,:) = [motion_features_participant sample_ids bg_data_participant ones(Nsamples_k,1)*[participantID participant_socio_data participant_is_amateur participant_socio_data_part2]];
    samples_count=samples_count+Nsamples_k;
end
%####################################################################

% save feature space
response_variables = get_response_variables(final_feature_space(:,30), get_expert_ratings_mean());
%########################################
fid = fopen('music_properties/factor_loads.csv');
A = textscan(fid, '%f %f %f', 8, 'Delimiter', ',');
fclose(fid);
pca_factor_loads = [A{1} A{2} A{3}];
mask = [1 2 5 6 7 11 12 14];
response_variables_PCs = pca_data(response_variables(:,mask),pca_factor_loads);
save('results/response_variables_PCs_2019.mat','response_variables_PCs'); 
csvwrite('results/response_variables_PCs_2019.csv', response_variables_PCs);
csvwrite('results/response_variables_2019.csv', response_variables);

final_feature_space(isnan(final_feature_space))=0;
csvwrite('results/feature_space_25_11_2018.csv', final_feature_space);
save('results/feature_space_25_11_2018.mat', 'final_feature_space');