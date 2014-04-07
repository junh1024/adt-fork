function run_example_AK
    % allrad example specifying speaker locations inline
    % specifics are for Divini Tree Yoga Studio, Santa Barbara
    %
    % see also AMBI_MAT2SPKR_ARRAY, AMBI_RUN_ALLRAD
    
    %%
    for h_order = 1:2;
        for v_order = 1:min(h_order,2);
            mixed_order_scheme = 'HP';

            S = ambi_mat2spkr_array(...
                ... % adjust args according to data read from import file
                ... %   see ambi_mat2spkr_array for coord and unit codes
                ... %ID	r (m)	a (deg) e (deg) // Speaker Name
                ... %-----------------------------------------------
                [ ...
                4.812	45  	3.66 ;... % // Left Front
                5.23   -45  	0.00 ;... % // Right Front
                5.23   -135     0.00 ;... % // Right Back
                5.23    135     0.00 ;... % // Left Back
                5.53    0       37.5 ;... % // Front Up
                5.53    180     37.5 ;... %	// Back Up
                5.53    90      37.5 ;... %	// Left Up
                5.53   -90      37.5 ;... %	// Right Up
                5.53    0      -37.5 ;... %	// Front Down
                5.53    180    -37.5 ;... %	// Back Down
                5.53    90     -37.5 ;... %	// Left Down
                5.53   -90     -37.5 ;... %	// Right Down
                ], ...
                'RAE',...            % locations 
                'MDD', ...           % in meters
                'AK1', ...            % name of array
                {'LF','RF','RB','LB',...
                 'FU','BU','LU','RU',...
                 'FD','BD','LD','RD'} ...
                );
            
            %decoder_type = 'allrad';
            decoder_type = 'pinv';
            switch decoder_type
                case 'allrad'
                    ambi_run_allrad(...
                        S, ...  % speaker array struct
                        [h_order,v_order], ...  % ambisonic order [h, v]
                        [], ... % imaginary speakers, none in this case
                        [], ... % pathname for output, [] = default
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
                        mixed_order_scheme, ... % mixed order scheme HV or HP
                        0.0...
                        );
            end
        end
    end
    
