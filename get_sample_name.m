function [ sample_name ] = get_sample_name( file_name)
%GET_SAMPLE_ID Summary of this function goes here
%   Detailed explanation goes here
%#### get sample id #####################
pointer = 1;
l = file_name(pointer);
sample_name = '';
while  ~strcmp(l,'_')
    sample_name = strcat(sample_name,l);
    pointer = pointer + 1;
    l = file_name(pointer);
end

end

