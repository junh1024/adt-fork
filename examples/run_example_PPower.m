function run_example_PPower
    % example specifying speaker locations inline
    % specifics are for Paul Power's octagon-cube configuration
    %
    % see also AMBI_MAT2SPKR_ARRAY, AMBI_RUN_ALLRAD
    
    %%
    %decoder_type = 'allrad'; 
    decoder_type = 'pinv';

    radius = 1.35; % meters
    
    %%
    for h_order = 1:3;
        for v_order = 0:min(h_order,2);
            mixed_order_scheme = 'HP';
            
            if false
                S = ambi_mat2spkr_array(...
                    [ 0:45:315, 45:90:315, 45:90:315;
                    zeros(size(0:45:315)), -45*ones(size(45:90:315)), 45*ones(size(45:90:315));
                    radius(1,ones(size(1:16))) ]',...
                    'AER', 'DDM', 'PPower-Octagon-Cube');
                
            else
                S = ambi_mat2spkr_array(...
                    ... % adjust args according to data read from import file
                    ... %   see ambi_mat2spkr_array for coord and unit codes
                    radius * ...
                    [
                    ... % horizontal octagon
                     1.0000         0         0
                     0.7071    0.7071         0
                     0.0000    1.0000         0
                    -0.7071    0.7071         0
                    -1.0000    0.0000         0
                    -0.7071   -0.7071         0
                    -0.0000   -1.0000         0
                     0.7071   -0.7071         0
                     ... % down square
                     0.5000    0.5000   -0.7071
                    -0.5000    0.5000   -0.7071
                    -0.5000   -0.5000   -0.7071
                     0.5000   -0.5000   -0.7071
                     ... % up square
                     0.5000    0.5000    0.7071
                    -0.5000    0.5000    0.7071
                    -0.5000   -0.5000    0.7071
                     0.5000   -0.5000    0.7071
                    ], ...
                    'XYZ',...            % locations are Cartesian X, Y, Z
                    'MMM', ...           % in meters
                    'PPower-Octagon-Cube' ...        % name of array
                    );
            end
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
                        [], ... % do plots, default is true for MATLAB, false for Octave
                        mixed_order_scheme ... % mixed order scheme HV or HP
                        );
            end
        end
    end
    
