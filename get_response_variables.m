function [response_variables ] = get_response_variables( music_ids, expert_ratings_mean )
%APPEND_SAMPLE_RATINGS_TO_MOTION_FEATURES creates response variables 
%for each predictor variable from expert ratings mean mean to
%
%Synopsis:
%[RESPONSE_VARS] = get_sample_ratings_for_motion_features(sample_ids, expert_ratings )
%
%Arguments:
% music_ids           - ids of music for each motion sample
% expert_ratings_mean - mean of expert ratings for each quality and musical sample (songs in the rows, ratings in the columns) 
%
%Returns:
% PRESPONSE_VARIABLES - corresponding ratings for motion features 
response_variables = zeros(size(music_ids,1),size(expert_ratings_mean,2));
for i=1:length(music_ids)
    response_variables(i,:) = expert_ratings_mean(music_ids(i),:);
end

end

