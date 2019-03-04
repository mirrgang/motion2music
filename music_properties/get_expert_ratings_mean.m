function [Q_mean] = get_expert_ratings_mean()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
label = {'rhythm (vague = 1, outstanding = 10)','backbeat (vague = 1, outstanding = 10)','downbeat (vague = 1, outstanding = 10)','syncopation (accent on beat = 1, syncopic = 10)',    'tempo (slow=1, fast=10)','accentuation (light = 1, marcato = 10)',    'rhythmic articulation (staccato = 1, legato = 10)',    'beat position of bass/snare (1 = laid back, 10 =up front)',    'melodic direction (descending =1, ascending = 10)',    'consonance (dissonant = 1, consonant = 10)','pitch level (low=1, high = 10)','pitch range (narrow=1, wide=10)','mode (minor = 1, major = 10)','complexity (simple = 1, complex = 10)'};
A = readSubjectiveQualities('expert_ratings/subjective_music_qualities_SK.csv');
B = readSubjectiveQualities('expert_ratings/subjective_music_qualities2_Kiki.csv');
C = readSubjectiveQualities('expert_ratings/subjective_music_qualities2_JS_prepared.csv');
mask_selected_songs = [1 4:7 9 13 15:20 25 28]; %selected songs
Q_mean = (A(mask_selected_songs,:)+B(mask_selected_songs,:)+C(mask_selected_songs,:))/3.0;
end

