function run_dec_auro3d(r, variant)
    % example specifying speaker locations inline
    %
    % see also AMBI_SPKR_ARRAY, AMBI_MAT2SPKR_ARRAY, AMBI_RUN_ALLRAD
    
    %% decoder specs
    decoder_type = 'pinv'; %'allrad'; % pinv | allrad
    
    h_order_range = 1; %1:2;
    v_order_range = 1; %1:min(h_order,2);
    
    mixed_order_scheme = 'HV';
    
    %% speaker array definition
    
    % radius
    if ~exist('r','var') || isempty(r), r = 6; end   % feet
    if ~exist('variant','var'), variant = '10.1'; end
    
    h_ele = 40; % one source say 40deg others say 30deg
    hz = r * tan( h_ele * pi/180 );
    
    if true
        z = 0;
    else
        z = -hz/2;
        hz = hz/2;
    end
    
    switch variant
        case '10.1'
            S = ambi_spkr_array(...
                ... % array name
                'Aura3D_10_1', ...
                ... % coordindate codes, unit codes
                'ARZ', 'DMM', ...
                ... % speaker name, [azimuth, radius, elevation]
                ... % 'Ear Level'  ITU 5.1
                'L',  [  30, r, z ], ...
                'C',  [   0, r, z ], ...
                'R',  [ -30, r, z ], ...
                'RS', [-120, r, z ], ...
                'LS', [ 120, r, z ], ...
                ... % 'Height'  Aura 3D 9.1
                'HL',  [  30, r, hz], ...
                'HR',  [ -30, r, hz], ...
                'HRS', [-120, r, hz], ...
                'HLS', [ 120, r, hz], ...
                ... % 'VOG'     Aura 3D 10.1
                'VOG', [   0, 0, hz]...
                );
        
    end
    
    
    %% do it
    for h_order = h_order_range
        for v_order = v_order_range
            switch decoder_type
                case 'allrad'
                    ambi_run_allrad(...
                        S, ...    % speaker array struct
                        [h_order,v_order], ...  % ambisonic order [h, v]
                        [0,0,-1], ... % imaginary speakers
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

