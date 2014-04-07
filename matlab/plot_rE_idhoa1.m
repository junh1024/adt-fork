function [ output_args ] = plot_rE_idhoa1( path, S )
    %UNTITLED2 Summary of this function goes here
    %   Detailed explanation goes here
    
    if ~exist('path', 'var') || isempty(path)
        path = 'rescoeff_LR_Dome_noprune.mat';
        path = 'CCRMA_LR_DOME.mat';
    end
    idhoa = load(path);
    
    
    if ~exist('S', 'var') || isempty(S)
        S = ambi_mat2spkr_array(...
            [idhoa.THETA(:),idhoa.PHI(:),ones(size(idhoa.THETA(:)))],...
            'EAR','RRM', ...
            'CCRMA_LR_DOME');
    end
    
    ambi_plot_speakers(S,[],[]);
    
    
    order = double(idhoa.DEG);
    
    C = ambi_channel_definitions(order,order,'HV','ACN','N3D');
    
    M = idhoa.ResCoeff';
    
    size(M)
    
    ambi_plot_rE(S,[],M,C,[],[],-50,88);
end

% python to save
% import scipy.io as sio
% sio.savemat('/Users/heller/Documents/MATLAB/AmbiDecoderToolbox/rescoeff_LR_Dome.mat',{'ResCoeff':ResCoeff, 'PHI':PHI, 'THETA':THETA})
% sio.savemat('/Users/heller/Documents/MATLAB/AmbiDecoderToolbox/rescoeff_LR_Dome_noprune.mat',
%             {'ResCoeff':ResCoeff, 'PHI':PHI, 'THETA':THETA, 'DEC':DEC})
