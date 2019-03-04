function [ participant_id] = get_participant_ID( file_name )
%GET_PARTICIPANT_ID Summary of this function goes here
%   Detailed explanation goes here
%#### get participant id #################
participant_id='';
k = strfind(file_name,'#');
pointer=k+1;
l=file_name(pointer);
while ~strcmp(l,'_')
    participant_id = strcat(participant_id,l);
    pointer = pointer + 1;
    l = file_name(pointer);
end

end

