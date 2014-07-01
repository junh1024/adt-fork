function run_dec_CMAP8(r, az_offset)
    % example specifying speaker locations inline
    %
    % see also AMBI_SPKR_ARRAY, AMBI_MAT2SPKR_ARRAY, AMBI_RUN_ALLRAD
    
    %% decoder specs
    decoder_type = 'pinv'; % pinv | allrad
    
    h_order_range = 1:3; %1:2;
    v_order_range = 0; %1:min(h_order,2);
    
    mixed_order_scheme = 'HV';
    
    %% speaker array definition
    
    % radius
    if ~exist('r','var') || isempty(r), r = 2; end   % meters
    
    az_offset = 22.5;
    azis = (0:45:315)+az_offset;
    
    S8_all = ambi_spkr_array(...
        ... % array name
        'CMAP8_all', ...
        ... % coordindate codes, unit codes
        'AER', 'DDM', ...
        ... % speaker name, [azimuth, radius, elevation]
        'S1',  [azis(1), 0, r ], ...
        'S2',  [azis(2), 0, r ], ...
        'S3',  [azis(3), 0, r ], ...
        'S4',  [azis(4), 0, r ], ...
        ...
        'S5',  [azis(5), 0, r ], ...
        'S6',  [azis(6), 0, r ], ...
        'S7',  [azis(7), 0, r ], ...
        'S8',  [azis(8), 0, r ] ...
        );
    
    S8_odd = ambi_spkr_array(...
        ... % array name
        'CMAP8_odd', ...
        ... % coordindate codes, unit codes
        'AER', 'DDM', ...
        ... % speaker name, [azimuth, radius, elevation]
        'S1',  [azis(1), 0, r ], ...
        ... %'S2',  [azis(2), 0, r ], ...
        'S3',  [azis(3), 0, r ], ...
        ... %'S4',  [azis(4), 0, r ], ...
        ...
        'S5',  [azis(5), 0, r ], ...
        ... %'S6',  [azis(6), 0, r ], ...
        'S7',  [azis(7), 0, r ] ...
        ... %'S8',  [azis(8), 0, r ] ...
        );
    
    S8_even = ambi_spkr_array(...
        ... % array name
        'CMAP8_even', ...
        ... % coordindate codes, unit codes
        'AER', 'DDM', ...
        ... % speaker name, [azimuth, radius, elevation]
        ... %'S1',  [azis(1), 0, r ], ...
        'S2',  [azis(2), 0, r ], ...
        ... %'S3',  [azis(3), 0, r ], ...
        'S4',  [azis(4), 0, r ], ...
        ...
        ... %'S5',  [azis(5), 0, r ], ...
        'S6',  [azis(6), 0, r ], ...
        ... %'S7',  [azis(7), 0, r ], ...
        'S8',  [azis(8), 0, r ] ...
        );
    
    
    
    %% do it
    
    S = S8_odd;
    for h_order = h_order_range
        for v_order = v_order_range
            switch decoder_type
                case 'allrad'
                    ambi_run_allrad(...
                        S, ...    % speaker array struct
                        [h_order,v_order], ...  % ambisonic order [h, v]
                        [], ... % imaginary speakers
                        [], ...   % pathname for output, [] = default
                        true, ... % do plots, default is true for MATLAB, false for Octave
                        mixed_order_scheme ... % mixed order scheme HV or HP
                        );
                case 'pinv'
                    ambi_run_pinv(...
                        S, ...  % speaker array struct
                        [h_order,v_order], ...  % ambisonic order [h, v]
                        [], ... % imaginary speakers, none in this case
                        [], ... % pathname for output, [] = default
                        false, ... % do plots, default is true for MATLAB, false for Octave
                        mixed_order_scheme ... % mixed order scheme HV or HP
                        );
            end
        end
    end
end
