function run_example_octagon
    % example specifying speaker locations inline
    % specifics are for Paul Power's octagon-cube configuration
    %
    % see also AMBI_MAT2SPKR_ARRAY, AMBI_RUN_ALLRAD
    
    %%
    decoder_type = 'allrad';
    %decoder_type = 'pinv';
    
    radius = 2; % meters
    
    mixed_order_scheme = 'HP';
    
    %%
    for h_order = 1:3;
        for v_order = 0;
            
            S = ambi_mat2spkr_array(...
                [ 0:45:315;
                zeros(size(0:45:315));
                radius*ones(size(0:45:315)) ]',...
                'AER', 'DDM', 'Octagon');
            
            
            switch decoder_type
                case 'allrad'
                    ambi_run_allrad(...
                        S, ...  % speaker array struct
                        [h_order,v_order], ...  % ambisonic order [h, v]
                        [0 0 1; 0 0 -1], ... % imaginary speakers
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
                        [], ... % do plots, default is true for MATLAB, false for Octave
                        mixed_order_scheme ... % mixed order scheme HV or HP
                        );
            end
        end
    end
    
end

