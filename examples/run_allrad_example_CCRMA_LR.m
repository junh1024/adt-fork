
if false
    ambi_run_allrad(...
        SPKR_ARRAY_CCRMA_LISTENING_ROOM(), ...  % full sphere
        [3 3], ...         % ambisonic order
        false, ...  % imaginary speaker at bottom of dome
        '', ... % default outpath
        true ... % do plots in MATLAB and Octave
        );
else  
    ambi_run_pinv(...
        SPKR_ARRAY_CCRMA_LISTENING_ROOM(), ...  % full sphere
        [3 3], ...         % ambisonic order
        false, ...  % imaginary speaker at bottom of dome
        '', ... % default outpath
        true ...
        );
end
