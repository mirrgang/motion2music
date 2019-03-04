function [ y_pca ] = get_PCA_response_variables( y , factor_loads)
%GET_PCA_RESPONSE_VARIABLES Summary of this function goes here
y_pca = y*factor_loads;
end

