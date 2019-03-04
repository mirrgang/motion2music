function [ pca_data ] = pca_data( data,PCs )
%Synopsis:
% pcaData = pca_data( data )
%
%Arguments:
% data -        data with observations in the rows and dimensions in the
%               or PCs in the columns
%Returns:
% pcaData     - data projected onto its PCs

    mcx =  data - mean(data); % mcx = mean centered data, think about whitening
    covariance = corr(mcx); % compute covariance
   %only first three PCs have eigenvalue > 1
   % [V, D] = eigs(covariance); % compute eigenvectors and corresponding eigenvalues
%     figure
%     plot(1:1:2,diag(D), '-ro');   
    pca_data = PCs'*mcx';%map data onto PCs
    pca_data = pca_data';
end

