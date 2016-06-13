function run_thrive_1
    % example specifying speaker locations inline
    %  specifics are for the Thrive 1.0 16-speaker sphere
    % see also AMBI_MAT2SPKR_ARRAY, AMBI_RUN_ALLRAD
    
    %%
    % This is for the Google/Jump Inspector Thrive v1.0 binaural
    % decoder presets downloaded from:
    %   https://storage.googleapis.com/jump-inspector/workflow/thrive.zip
    % see also:
    %   https://support.google.com/jump/answer/6399746?hl=en
    %   https://support.google.com/jump/answer/6400185
    %
    % I am assuming that the HRIR names are:
    %    E<elevation (deg)>_A<azimuth (deg)>_D<radius (meters)>.wav
    % these can be decoded with 'E%f_A%f_D%f.wav'
    %
    % According to my analysis this configuration can support 2nd-order
    % decoding, but not 3rd.  Contrast this with the 16-node Fliege sphere
    % in run_dec_Fliege16, which will support 3rd-order.
    
    decoder_type = 'pinv';
    mixed_order_scheme = 'HP';
    channel_order = 'acn';
    channel_normalization = 'sn3d';
    do_plots = [];
    out_path = [];
    
    if false
        % read from listing of HRIR files
        fid= fopen('thrive_v1.0/thrive-sphere-hrirs.txt');
        spkr_dirs = textscan(fid, 'E%f_A%f_D%f.wav', 'CollectOutput', true);
        fclose(fid);
        S = ambi_mat2spkr_array(spkr_dirs{1}, 'EAR', 'DDM', 'Thrive_16');
    else
        S = ambi_mat2spkr_array(...
            ... % adjust args according to data read from array
            ... %   see ambi_mat2spkr_array for coord and unit codes
            ... %	ele (deg), azi (deg) rad (m) % hrir file gain delay-ms
            ... %-----------------------------------------------
            [ ...
            -13.6,  -90, 1.42;  ... %  E-13.6_A-90_D1.42.wav 1 0
            -13.6,    0, 1.42;  ... %  E-13.6_A0_D1.42.wav 1 0
            -13.6,  180, 1.42;  ... %  E-13.6_A180_D1.42.wav 1 0
            -13.6,   90, 1.42;  ... %  E-13.6_A90_D1.42.wav 1 0
            -51.5, -135, 1.42;  ... %  E-51.5_A-135_D1.42.wav 1 0
            -51.5,  -45, 1.42;  ... %  E-51.5_A-45_D1.42.wav 1 0
            -51.5,  135, 1.42;  ... %  E-51.5_A135_D1.42.wav 1 0
            -51.5,   45, 1.42;  ... %  E-51.5_A45_D1.42.wav 1 0
             13.6, -135, 1.42;  ... %  E13.6_A-135_D1.42.wav 1 0
             13.6,  -45, 1.42;  ... %  E13.6_A-45_D1.42.wav 1 0
             13.6,  135, 1.42;  ... %  E13.6_A135_D1.42.wav 1 0
             13.6,   45, 1.42;  ... %  E13.6_A45_D1.42.wav 1 0
             51.5,  -90, 1.42;  ... %  E51.5_A-90_D1.42.wav 1 0
             51.5,    0, 1.42;  ... %  E51.5_A0_D1.42.wav 1 0
             51.5,  180, 1.42;  ... %  E51.5_A180_D1.42.wav 1 0
             51.5,   90, 1.42;  ... %  E51.5_A90_D1.42.wav 1 0
            ], ...
            'EAR',...            % locations
            'DDM', ...           % in meters
            'Thrive_Sphere16' ...            % name of array
            );
    end
    %%
    for h_order = 1:3
        for v_order = h_order
            
            C = ambi_channel_definitions(h_order,v_order,...
                mixed_order_scheme, ...
                channel_order, channel_normalization);
            
            fprintf('h_order = %d, v_order = %d\n', h_order, v_order);
            switch decoder_type
                case 'allrad'
                    [D, S, M, C] = ...
                        ambi_run_allrad(...
                        S, ...  % speaker array struct
                        C, ...  % ambisonic order [h, v]
                        [], ... % imaginary speakers, none in this case
                        out_path, ... % pathname for output, [] = default
                        do_plots, ... % do plots, default is true for MATLAB, false for Octave
                        mixed_order_scheme ... % mixed order scheme HV or HP
                        );
                case 'pinv'
                    [D, S, M, C] = ...
                        ambi_run_pinv(...
                        S, ...  % speaker array struct
                        C, ...  % ambisonic order [h, v]
                        [], ... % imaginary speakers, none in this case
                        out_path, ... % pathname for output, [] = default
                        do_plots, ... % do plots, default is true for MATLAB, false for Octave
                        mixed_order_scheme, ... % mixed order scheme HV or HP
                        0.0...
                        );
            end
        end
    end
end

