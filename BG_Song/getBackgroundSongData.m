function[BG] = getBackgroundSongData()
    filedir = '../BG_Song/';
    files = dir(fullfile(filedir, '*.csv'));
    nSamples = length(files);
    nParticipants = 23;
    mapping = get_sample_name_id_mapping();
    BG = zeros(nParticipants,nSamples,3);
    for i=1:1:nSamples
        file_name = files(i).name    
        A = csvread(strcat(filedir,file_name));
        songTitle = get_sample_name_from_end(file_name);
        songTitle = songTitle(1:length(songTitle)-4)%get rid of csv suffix
        sample_id = mapping.(songTitle);
        BG(:,sample_id,:) = A;
    end
end