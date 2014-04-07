function [ output_args ] = run_dec_idhoa1( path )
    %UNTITLED3 Summary of this function goes here
    %   Detailed explanation goes here
    
    if ~exist('path', 'var') || isempty(path)
        path = 'rescoeff.mat';
    end
    DD = load(path);
    
    S = ambi_mat2spkr_array(...
        [DD.THETA;DD.PHI;ones(size(DD.THETA))]',...
        'EAR','RRM', ...
        'IDHOA 1');
    
    ambi_run_allrad(S,3,[0,0,-1]);
    
    %ambi_run_pinv(S,3,[]);
end

