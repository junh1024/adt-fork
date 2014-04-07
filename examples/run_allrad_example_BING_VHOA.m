
for o = 3:6
    ambi_run_allrad(...
        SPKR_ARRAY_BING_2013FEB12(), ...
        o, ...          % ambisonic order
        [0 0 -1/2] ...  % imaginary speaker at bottom of dome
        );
    close all
end
