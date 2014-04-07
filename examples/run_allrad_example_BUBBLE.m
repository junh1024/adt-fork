function run_allrad_example_BUBBLE
% example reading speaker config from AmbDec config file
    
ambi_run_allrad(...
    ambdec2spkr_array('bubble-h1v1-3A.ambdec','Bubble24_3A'), ...
    2, ...       % ambisonic order
    [0 0 1; 0 0 -1] ...  % imaginary speaker at top and bottom
    );
