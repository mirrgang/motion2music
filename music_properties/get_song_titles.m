function [ titles ] = get_song_titles( file_name )
%GETSONGTITLES Summary of this function goes here
%   Detailed explanation goes here
% fid = fopen(file_name);
% A = textscan(fid, '%s %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 31, 'Delimiter', ',');
% fclose(fid);
% %sample titles
% mask_selected_songs = [1 4:7 9 13 15:20 25 28];
% titles = A{1,1};
% titles = titles(mask_selected_songs);
titles = {'AladdinSane', 'AnotherStar', 'Bad', 'Chandelier', 'CosmicLove' , 'Detroit',  'DryAndDusty','GirlOnFire', 'LeavingSong', 'Monument', 'PeoplePleaser', 'SacreDuPrintemps', 'SpaceOddity', 'Tonight', 'YouDontKnowMyName'};
end

