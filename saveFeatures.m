function [ ] = saveFeatures( fromFolder, toFolder)
%SAVEFEATURES Summary of this function goes here
%   Detailed explanation goes here
requested_duration=15;
n_segments = 15;

files = dir(fullfile(fromFolder, '*.mat'));
nfiles = length(files);% number of musical excerpts belonging to this participant
for f=1:nfiles
    file_name = files(f).name;
    participant_id = get_participant_ID(file_name);
    sample_name = get_sample_name(file_name);
    data_pre_pca = getParticipantData(fromFolder,participant_id,sample_name);    
    current_FS = size(data_pre_pca,1)/requested_duration;
    features = extract_motion_features(data_pre_pca, current_FS, requested_duration, n_segments);
    save(strcat(toFolder, 'features_',sample_name,'_',participant_id, '_.mat'), 'features');
end
end

