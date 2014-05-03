function run_allrad_example_IEM_CUBE
    % example reading speaker config from a CSV file
    %
    % see also AMBI_MAT2SPKR_ARRAY, AMBI_RUN_ALLRAD
    
    %%
    % LScoordinate.csv downloaded from
    %   http://ambisonics-symposium.org/symposium2009/audio-infrastructure/loudspeaker-coordinates-csv
    
    % speaker location data starts on row 3, column 2 of file
    %  (note DLMREAD is zero based)
    % Matthias Kronlachner says +Y points to the right, so fix here
    S_coords = dlmread('LScoordinates.csv', ',', 2, 1) * diag([1,-1,1]);
    
    % The origin of these measurements is on the floor; move it to the
    % height of lowest speaker, approx ear height for seated listeners
    S_coords(:,3) = S_coords(:,3) - min(S_coords(:,3));
    
    for order = 1:3
        ambi_run_allrad(...
            ambi_mat2spkr_array(...
            S_coords, ...
            'XYZ',...            % locations are Cartesian X, Y, Z
            'MMM', ...           % in meters
            'IEM_CUBE' ...       % name of array
            ), ...
            [order,order], ...    % ambisonic order [h, v]
            [0,0,-1] ... % imaginary speakers at the bottom
            );
    end
    
