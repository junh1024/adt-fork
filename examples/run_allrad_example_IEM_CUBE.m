function run_allrad_example_IEM_CUBE
    % example reading speaker config from a CSV file
    %
    % see also AMBI_MAT2SPKR_ARRAY, AMBI_RUN_ALLRAD
    
    %%
    % LScoordinate.csv downloaded from
    %   http://ambisonics-symposium.org/symposium2009/audio-infrastructure/loudspeaker-coordinates-csv
    
    for order = 1:3
        ambi_run_allrad(...
            ... % adjust args according to data read from import file
            ... %   see ambi_mat2spkr_array for coord and unit codes
            ambi_mat2spkr_array(...
            ... % speaker location data starts on row 3, column 2 of file
            ... %  (note DLMREAD is zero based)
            ... % per Matthias Kronlachner +Y points to the right, so fix here
            dlmread('LScoordinates.csv', ',', 2, 1) * diag([1,-1,1]), ...
            'XYZ',...            % locations are Cartesian X, Y, Z
            'MMM', ...           % in meters
            'IEM_CUBE' ...       % name of array
            ), ...
            [order,order], ...    % ambisonic order [h, v]
            [0,0,-1] ... % imaginary speakers at the bottom
            );
    end
    
