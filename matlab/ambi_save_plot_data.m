function [ output_args ] = ambi_save_plot_data(S, V, M, C, ...
        fig_title, ele_min, ele_max )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    %% defaults
    if ~exist('ele_min', 'var') || isempty(ele_min)
        ele_min = -88;
    end
    
    if ~exist('ele_max', 'var') || isempty(ele_max)
        ele_max = +88;
    end
    
    fig_title_sanitized = strrep(fig_title, '_', ' ');
    
    %% girds
    n_phi = 45;     % number of vertical divisions
    n_theta = 90;   % number of horizontal divisions
    
    %d_phi = pi/n_phi;  % delta phi
    %d_theta = 2*pi/n_theta;  % delta theta
    
    geo = AzElGrid(-180:4:180-4, ele_min:4:ele_max);
    
    %%  compute rE and rV
    geo.a = ambi_sample_Y_sph(geo.az(:), geo.el(:), C)';
    
    [rV, rE, P, E] = ambi_rVrE_Y(M, [S.x, S.y, S.z]', geo.a);
    
    fprintf('Writing plot data to: %s\n', ...
        fullfile(ambi_decoders_dir(), 'test_data.mat'));
    save(fullfile(ambi_decoders_dir(), 'test_data.mat'),...
        'rV', 'rE', 'P', 'E', ...
        'S', 'V', 'M', 'C', ...
        'geo', 'fig_title', ...
        'fig_title_sanitized', ...
        'ele_min', 'ele_max', '-V6');
end

