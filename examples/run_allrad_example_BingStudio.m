function [D,S,M,C] = run_allrad_example_BingStudio()
    % example reading speaker config from AmbDec config file
    
    [D,S,M,C] = ambi_run_allrad(...
        ambdec2spkr_array('BingStudio-spkrs.ambdec','BingStudio-Apr2013'), ...
        3, ...       % ambisonic order
        [ 0 0 -1] ...  % imaginary speaker at bottom
        );
    
