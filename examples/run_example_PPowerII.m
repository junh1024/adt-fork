function run_example_PPowerII
    % example specifying speaker locations inline
    % specifics are for Paul Power's octagon-cube configuration
    %
    % see also AMBI_MAT2SPKR_ARRAY, AMBI_RUN_ALLRAD
    
    %%
    decoder_type = 'pinv'; %'pinv'
    radius = 1.35; % meters
    
    %%
    for h_order = 1:3;
        for v_order = 1:min(h_order,3);
            mixed_order_scheme = 'HP';
            
            if false
                S = ambi_mat2spkr_array(...
                    [ 0:45:315, 0:60:360, 0:60:360;
                    zeros(size(0:45:360)), -45*ones(size(0:60:360)), 45*ones(size(0:60:360));
                    radius(1,ones(size(1:18))) ]',...
                    'AER', 'DDM', 'PPower-Octagon-Hexagon');
                
            else
                S = ambi_mat2spkr_array(...
                    ... % adjust args according to data read from import file
                    ... %   see ambi_mat2spkr_array for coord and unit codes
                    ...
                    [
                    ... % horizontal Octagon
                    0           0     1.35
                    45          0     1.35
                    90          0     1.35
                    135         0     1.35
                    180         0     1.35
                    225         0     1.35
                    270         0     1.35
                    315         0     1.35
                    
                    ... % down Hexagon
                    0          -45      1.35
                    60         -45      1.35
                    120        -45      1.35
                    180        -45      1.35
                    240        -45      1.35
                    300        -45      1.35
                     ... % up Hexagon
                    0           45      1.35
                    60          45      1.35
                    120         45      1.35
                    180         45      1.35
                    240         45      1.35
                    300         45      1.35
                 
                    ], ...
                    'AER',...            % locations are Spherical Az, El, Rad
                    'DDM', ...           % in degrees and meters
                    'PPower-Octagon-Hexagon' ...        % name of array
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
    
