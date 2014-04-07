function run_dec_t48
    % allrad example specifying speaker locations inline
    % specifics are for Paul Powers' octagon-cube configuration
    %
    % see also AMBI_MAT2SPKR_ARRAY, AMBI_RUN_ALLRAD_AMBDEC
    
    %%
    decoder_type = 'pinv'; % pinv | allrad
    h_order = 6;
    v_order = 6;
    
    mixed_order_scheme = 'HP';
    
    sd = spherical_t_design(3,48,9);
    
    S = ambi_mat2spkr_array(...
        ... % adjust args according to data read from import file
        ... %   see ambi_mat2spkr_array for coord and unit codes
        ... %ID	r (m)	a (deg) e (deg) // Speaker Name
        ... %-----------------------------------------------
        [ sd.x, sd.y, sd.z ], ...
        'XYZ',...            % locations
        'MMM', ...           % in meters
        't49' ...          % name of array
        );
    
    switch decoder_type
        case 'allrad'
            ambi_run_allrad(...
                S, ...  % speaker array struct
                [h_order,v_order], ...  % ambisonic order [h, v]
                [], ... % imaginary speakers, none in this case
                [], ... % pathname for output, [] = default
                [], ... % do plots, default is true for MATLAB, false for Octave
                mixed_order_scheme ... % mixed order scheme HV or HP
                );
        case 'pinv'
            ambi_run_pinv(...
                S, ...  % speaker array struct
                [h_order,v_order], ...  % ambisonic order [h, v]
                [], ... % imaginary speakers, none in this case
                [], ... % pathname for output, [] = default
                true, ... % do plots, default is true for MATLAB, false for Octave
                mixed_order_scheme ... % mixed order scheme HV or HP
                );
    end
end
    
