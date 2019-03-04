function [] = saveMotionDataProjected2Eigenspace(fromFolder, toFolder)
    
for i=1:23
    %get all files belonging to participant i
    files_participant_i = dir(fullfile(fromFolder, strcat('*_#',num2str(i),'_.mat')));
    data_i = getParticipantData(fromFolder,i,'');    
    principle_components = getPCs(data_i);
    nfiles = length(files_participant_i);% number of musical excerpts belonging to this participant
    for f=1:nfiles
        file_name = files_participant_i(f).name;
        participant_id = get_participant_ID(file_name);
        sample_name = get_sample_name(file_name);
        data_f = getParticipantData(fromFolder,i,sample_name);
        data = pca_data(data_f,principle_components);
        save(strcat(toFolder,sample_name,'_#',participant_id, '_.mat'), 'data');
    end
end
end

