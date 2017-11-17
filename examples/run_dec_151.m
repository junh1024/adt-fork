function run_dec_151(r, variant)
    % example specifying speaker locations inline
    % see also AMBI_SPKR_ARRAY, AMBI_MAT2SPKR_ARRAY, AMBI_RUN_ALLRAD
    
    % Originally, this was for an Auro 10.1 (TC) layout, but that's not really a popular Auro layout
    % so I changed it to a base 9.0 layout, which is also compatible with Sennheiser's Ambeo 9.0 layout - junh1024
    
    %% decoder specs
    decoder_type = 'pinv'; %'allrad'; % pinv | allrad
    
    h_order_range = 3; %1:2;
    v_order_range = 3; %1:min(h_order,2);
    
    mixed_order_scheme = 'HV';
    
    %% speaker array definition
    
    % radius
    if ~exist('r','var') || isempty(r), r = 6; end   % feet
    if ~exist('variant','var'), variant = '9.1'; end
    
    h_ele = 45; % deg
    hz = r * tan( h_ele * pi/180 );
    
    if true
        z = 0;
    else
        z = -hz/2;
        hz = hz/2;
    end
    
    switch variant
        case '9.1'
            S = ambi_spkr_array(...
                ... % array name
                '151ENC', ...
                ... % coordindate codes, unit codes
                'ARZ', 'DMM', ...
                ... % speaker name, [azimuth, radius, elevation]
                ... % 'Ear Level'  ITU 5.0
                'L',  [  30, r, z ], ...
                'R',  [ -30, r, z ], ...
                'BL', [ 150, r, z ], ...				
				'BR', [-150, r, z ], ...
                'SL', [ 90, r, z ], ...
                'SR', [-90, r, z ], ...
				...
                'HL',  [  30, r, hz ], ...
                'HR',  [ -30, r, hz ], ...
                'HBL', [ 150, r, hz ], ...				
				'HBR', [-150, r, hz ], ...
                'HSL', [ 90, r,  hz ], ...
                'HSR', [-90, r,  hz ], ...
				...
				'BTL',  [  30, r, -hz ], ...
                'BTR',  [ -30, r, -hz ], ...
                'BTBL', [ 150, r, -hz ], ...				
				'BTBR', [-150, r, -hz ], ...
                'BTSL', [ 90, r,  -hz ], ...
                'BTSR', [-90, r,  -hz ]...
...
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
                        false, ... % do plots, default is true for MATLAB, false for Octave
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

