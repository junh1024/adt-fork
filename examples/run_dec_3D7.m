function run_dec_3D7(r, noCenter)
    % example specifying speaker locations inline
    %
    % see also AMBI_SPKR_ARRAY, AMBI_MAT2SPKR_ARRAY, AMBI_RUN_ALLRAD
    
    %% decoder specs
    decoder_type = 'allrad'; % pinv | allrad
    
    h_order_range = 2; %1:2;
    v_order_range = 1; %1:min(h_order,2);
    
    mixed_order_scheme = 'HV';
    
    %% speaker array definition
    
    % radius
    if ~exist('r','var') || isempty(r), r = 6; end   % feet
    if ~exist('noCenter','var'), noCenter = false; end
    
    % speaker FC is in plane of front speakers, so its 'r' is the same
    % as the x coordinate of FCL. Need to capture all three outputs because
    % octave's version of sph2cart makes a row vector when nargout = 1.
    % (and we can't use ~ because MATLAB 2007, doesn't recognize ~ for
    % ignored values)
    [fcl_x, fcl_y, fcl_z] = sph2cart(0, -55*pi/180, r);  %#ok<NASGU,ASGLU>
        
    switch noCenter
        case false
            S = ambi_spkr_array(...
                ... % array name
                '3D7', ...
                ... % coordindate codes, unit codes
                'ARE', 'DFD', ...
                ... % speaker name, [azimuth, radius, elevation]
                'FLH', [  51, r, +24 ], ...
                'FRH', [ 309, r, +24 ], ...
                'FC',  [   0, fcl_x,  0 ], ...
                'RCH', [ 180, r, +55 ], ...
                'FCL', [   0, r, -55 ], ...
                'RLL', [ 129, r, -24 ], ...
                'RRL', [ 231, r, -24 ] ...
                );
        case true
            S = ambi_spkr_array(...
                ... % array name
                '3D7-noCenter', ...
                ... % coordindate codes, unit codes
                'ARE', 'DFD', ...
                ... % speaker name, [azimuth, radius, elevation]
                'FLH', [  51, r, +24 ], ...
                'FRH', [ 309, r, +24 ], ...
                ... %'FC',  [   0, rc,  0 ], ...
                'RCH', [ 180, r, +55 ], ...
                'FCL', [   0, r, -55 ], ...
                'RLL', [ 129, r, -24 ], ...
                'RRL', [ 231, r, -24 ] ...
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

