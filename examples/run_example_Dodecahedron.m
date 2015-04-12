function run_example_Dodecahedron
    % allrad example specifying speaker locations inline
    % specifics are for regular dodecahedron as defined at
    %    http://en.wikipedia.org/wiki/Dodecahedron#Cartesian_coordinates
    %     the puts a pentagon at the top and bottom, which is not
    %     optimal for ambisonic use
    %
    % see also AMBI_MAT2SPKR_ARRAY, AMBI_RUN_ALLRAD
    
    %%
    phi = (1 + sqrt(5))/2;
    
    for h_order = 1:3
        for v_order = 1:min(h_order,3);
            mixed_order_scheme = 'HV';

            S = ambi_mat2spkr_array(...
                [ ...
                 1  1  1;
                 1 -1  1;
                -1 -1  1;
                -1  1  1;
                ... 
                 1  1 -1;
                 1 -1 -1;
                -1 -1 -1;
                -1  1 -1;
                ... % x-y plane
                 phi  1/phi 0;
                 phi -1/phi 0;
                -phi -1/phi 0;
                -phi  1/phi 0;
                ... % y-z plane
                 0  phi  1/phi;
                 0  phi -1/phi;
                 0 -phi -1/phi;
                 0 -phi  1/phi;
                ... % x-z plane
                 1/phi 0  phi;
                 1/phi 0 -phi;
                -1/phi 0 -phi;
                -1/phi 0  phi;
                ]/sqrt(3), ...
                'XYZ',...            % locations 
                'MMM', ...           % in meters
                'Dodecahedron' ...            % name of array
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
                        mixed_order_scheme ... % mixed order scheme HV or HP
                        );
            end
        end
    end
    
