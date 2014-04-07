function run_example_PPowerIIb
    % example specifying speaker locations inline
    % specifics are for Paul Power's octagon-cube configuration
    %
    % see also AMBI_MAT2SPKR_ARRAY, AMBI_RUN_ALLRAD
    
    %%
    decoder_type = 'pinv'; %'pinv'
    radius = 1; % meters
    
    %%
    for h_order = 1:3;
        for v_order = 1:min(h_order,2);
            mixed_order_scheme = 'HP';
            
            if false
                S = ambi_mat2spkr_array(...
                    [ 0:45:315, 0:60:300, 0:60:300;
                    zeros(size(0:45:315)), -45*ones(size(0:60:300)), 45*ones(size(0:60:300));
                    radius(1,ones(size(1:21))) ]',...
                    'AER', 'DDM', 'PPower-Oct-six+1');
                
            else
                S = ambi_mat2spkr_array(...
                    ... % adjust args according to data read from import file
                    ... %   see ambi_mat2spkr_array for coord and unit codes
                    ...
                    [
                    ... % horizontal Octagon
                    0           0     1
                    45          0     1
                    90          0     1
                    135         0     1
                    180         0     1
                    225         0     1
                    270         0     1
                    315         0     1
                    
                    ... % down Hexagon
                 
                    0         -45      1
                    60        -45      1
                    120       -45      1
                    180       -45      1
                    240       -45      1
                    300       -45      1
                     ... % up Hexagon
                   0          45    1
                   60        45     1
                   120       45     1
                   180       45     1
                   240       45     1
                   300       45     1
                    0        90     1
                   
                   
                 
                    ], ...
                    'AER',...            % locations are Cartesian X, Y, Z
                    'DDM', ...           % in meters
                    'PPower-Oct-six+1' ...        % name of array
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
    
