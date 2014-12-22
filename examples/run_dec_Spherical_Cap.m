function run_dec_Spherical_Cap
    
    %addpath('/home/andersvi/site/ADT/adt/matlab');
    %%
    mixed_order_scheme = 'HV';  % HV or HP
    
    S = spkrs_LG_SPHERICAL_CAP;
    imaginary_speakers = [0,0,-1];  % one at bottom, used only for AllRAD
    
    % do_plots = [];  % default is true for MATLAB, false for Octave
    do_plots = true;  % default is true for MATLAB, false for Octave
    output_path = [];  % pathname for output, [] = default
    
    decoder_type = 'ssf';
    %decoder_type = 'allrad';
    %decoder_type = 'pinv';
    
    for order = 4
        switch decoder_type
            case 'allrad'
                ambi_run_allrad(...
                    S, ...  % speaker array struct
                    [order,order], ...  % ambisonic order [h, v]
                    imaginary_speakers, ... % imaginary speakers, one at bottom
                    output_path, ...
                    do_plots, ...
                    mixed_order_scheme ...
                    );
            case 'pinv'
                ambi_run_pinv(...
                    S, ...  % speaker array struct
                    [order,order], ...  % ambisonic order [h, v]
                    [], ... % imaginary speakers, ignored for pinv
                    output_path, ...
                    do_plots, ...
                    mixed_order_scheme ...
                    );
            case 'ssf'
                ambi_run_SSF(...
                    S,...
                    order,...
                    [], ... % imaginary speaker, ignored for SSF
                    [], ...
                    mixed_order_scheme...
                    );
        end
    end
end
