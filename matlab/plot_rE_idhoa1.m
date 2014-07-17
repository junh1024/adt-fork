function [ output_args ] = plot_rE_idhoa1( path, S )
    %UNTITLED2 Summary of this function goes here
    %   Detailed explanation goes here
    
    % invoke with:
    % plot_rE_idhoa1([],SPKR_ARRAY_CCRMA_LISTENING_ROOM('dome'));
    
    if ~exist('path', 'var') || isempty(path)
        %path = 'rescoeff_LR_Dome_noprune.mat';
        %path = 'CCRMA_LR_DOME.mat';
        dec_type = 'wbin_-10deg_nomute_3rd';
        %dec_type = 'wbin_-10deg_yesmute_3rd';
        path = fullfile('..', 'decoders', 'CCRMA', ...
            dec_type, ...
            'CCRMA_LR_DOME.mat');
        S = SPKR_ARRAY_CCRMA_LISTENING_ROOM('dome');
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
    
    % IDHOA always uses N3D.
    C = ambi_channel_definitions(order,order,'HV','ACN','N3D');
    
    M = idhoa.ResCoeff';
    
    size(M)
    
    %ambi_plot_rE(S,[],M,C,[],[],-50,88);
    
    D.decoder_type = 1;
    D.input_scale = 'fuma';
    D.description = [S.name, '-', dec_type];
    
    ambi_write_decoder_engine_configuration(S,C,M,D);
end

% python to save
% import scipy.io as sio
% sio.savemat('/Users/heller/Documents/MATLAB/AmbiDecoderToolbox/rescoeff_LR_Dome.mat',{'ResCoeff':ResCoeff, 'PHI':PHI, 'THETA':THETA})
% sio.savemat('/Users/heller/Documents/MATLAB/AmbiDecoderToolbox/rescoeff_LR_Dome_noprune.mat',
%             {'ResCoeff':ResCoeff, 'PHI':PHI, 'THETA':THETA, 'DEC':DEC})
