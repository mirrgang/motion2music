function [ NSamplesPerParticipant ] = getNSamplesPerParticipant(outtake_data)
    NSamples_default = 1:1:15;
    nParticipants = 23;
    NSamplesPerParticipants = [];
    for i=1:1:nParticipants
        indices = find(outtake_data(:,2)==i);
        if isempty(indices)
            NSamplesPerParticipant{i} = {NSamples_default};
        else
            sample_ids_to_be_removed = outtake_data(indices,1);
            NSamplesPerParticipant{i} = {remove(sample_ids_to_be_removed,NSamples_default)};
        end
    end
end

