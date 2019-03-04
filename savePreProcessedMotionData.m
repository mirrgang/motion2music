function [] = savePreProcessedMotionData(fromFolder, toFolder)
%##### LOAD CSV RAW DATA ###########################################
matfiles = dir(fullfile(fromFolder, '*acc.csv'));
nfiles = length(matfiles);% number of musical excerpts
%##### PARAMETERS FOR PRE-Processing ###############################
desired_N = 100;
requested_duration=15;% standard duration to keep in seconds
duration = 20; % current duration, same this time
offset = 5; %seconds to be cut off in the beginning
for i = 1 : nfiles
        file_name = matfiles(i).name
        M = csvread(fullfile(fromFolder, file_name) );
        participant_id = get_participant_ID(file_name);
        sample_name = get_sample_name(file_name);
        %####### PRE-PROCESSING ###############################
        %adapt sample rate    
        %pre-process data: cut beginning and end, resample
        data = pre_process(M, duration, requested_duration,offset, desired_N);
        save(strcat(toFolder,sample_name,'_#', participant_id, '_.mat'), 'data');
end
end

