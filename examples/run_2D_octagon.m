function run_2D_octagon
    % example for 2D polygons
    
    num_speakers = 8;
    radius = 2; % meters
    start_angle = 0;  % put 'auto' for half the separation angle
    array_name = 'Octagon0';
    speaker_ids = [];  % gensym speaker names
    
    decoder_type = 'pinv'; % 'allrad'
    mixed_order_scheme = 'HP';
    channel_order = 'fuma';
    channel_normalization = 'fuma';
    do_plots = [];  % take default
    out_path = [];  % take default
    
    % used by AllRAD only
    imaginary_speakers = [ ...
        0, 0,  1; % one at the top
        0, 0, -1  % one at the bottom
        ];
    
    S = SPKR_ARRAY_2D_POLYGON(num_speakers, radius, start_angle, ...
        array_name, speaker_ids);
    
    %%
    for h_order = 1:3
        for v_order = 0
            
            C = ambi_channel_definitions(h_order,v_order,...
                mixed_order_scheme, ...
                channel_order, channel_normalization);
            
            fprintf('h_order = %d, v_order = %d\n', h_order, v_order);
            switch decoder_type
                case 'allrad'
                    [D, S, M, C] = ambi_run_allrad(...
                        S, ...  % speaker array struct
                        C, ...  % channel defs
                        imaginary_speakers, ... % imaginary speakers
                        out_path, ... % pathname for output, [] = default
                        do_plots, ... % do plots, default is true for MATLAB, false for Octave
                        mixed_order_scheme ... % mixed order scheme HV or HP
                        );
                case 'pinv'
                    [D, S, M, C] = ambi_run_pinv(...
                        S, ...  % speaker array struct
                        C, ...  % channel defs
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


