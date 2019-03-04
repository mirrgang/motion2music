function [ Q ] = readSubjectiveQualities( file_name )
%READSUBJECTIVEQUALITIES Summary of this function goes here
%   Detailed explanation goes here
fid = fopen(file_name);
A = textscan(fid, '%s %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 31, 'Delimiter', ',');
fclose(fid);
nRows = size(A{3});
qualities_description = {'rhythm presence','backbeat', 'downbeat', 'syncopation', 'tempo', 'accentuation', 'articulation', 'beat position', 'melodic direction', 'consonance', 'pitch level', 'pitch range', 'mode', 'complexity'};
sample_size = 31;
%sample titles
titles = A{1,1};
Q = [A{1,3} A{1,4} A{1,5} A{1,6} A{1,7} A{1,8} A{1,9} A{1,10} A{1,11} A{1,12} A{1,13} A{1,14} A{1,15} A{1,16}];

end

