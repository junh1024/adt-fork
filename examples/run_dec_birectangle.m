function run_dec_birectangle(r, lateral)
    % example specifying speaker locations inline
    %
    % see also AMBI_SPKR_ARRAY, AMBI_MAT2SPKR_ARRAY, AMBI_RUN_ALLRAD
    
    %% decoder specs
    decoder_type = 'pinv'; % pinv | allrad
    
    h_order_range = 1; %1:2;
    v_order_range = 1; %1:min(h_order,2);
    
    mixed_order_scheme = 'HV';
    
    %% speaker array definition
    
    % radius
    if ~exist('r','var') || isempty(r), r = 2; end   % meters
    
    phi = 60;
    
    S = ambi_spkr_array(...
        ... % array name
        'Birectangle', ...
        ... % coordindate codes, unit codes
        'AER', 'DDM', ...
        ... % speaker name, [azimuth, radius, elevation]
        'LF',  [    phi, 0, r ], ...
        'RF',  [   -phi, 0, r ], ...
        'RB',  [180+phi, 0, r ], ...
        'LB',  [180-phi, 0, r ], ...
        ...
        'FU',  [   0,  30, r ], ...
        'FD',  [   0, -30, r ], ...
        'BU',  [ 180,  30, r ], ...
        'BD',  [ 180, -30, r ] ...
        );
    
    %% do it
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
                        true, ... % do plots, default is true for MATLAB, false for Octave
                        mixed_order_scheme ... % mixed order scheme HV or HP
                        );
            end
        end
    end
end
