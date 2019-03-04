function [data_all] = getParticipantData( fromFolder, participant_id, sample_name )
%GETPARTICIPANTDATA Summary of this function goes here
%   Detailed explanation goes here
if strcmp(sample_name,'') %get all files of participant
    matfiles = dir(fullfile(fromFolder, strcat('*#', num2str(participant_id) ,'_.mat')));
else%get specific file of participant    
    matfiles = dir(fullfile(fromFolder, strcat(sample_name,'_#', num2str(participant_id),'_.mat')));
end
nfiles = length(matfiles);
data_all = []
for i = 1 : nfiles
    file_name = matfiles(i).name
    load(file_name,'data');
    data_all = [data_all;data];
end
end

