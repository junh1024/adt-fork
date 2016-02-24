function run_dec_Boardroom
    
    %% how to find the ADT's matlab files
    %   update for your installation
    addpath('/Users/heller/Documents/adt/matlab');
    %%
    mixed_order_scheme = 'HV';  % HV or HP
    
    S = SPKR_ARRAY_Boardroom(31);
    
    imaginary_speakers = [0,0,-1];  % one at bottom, used for AllRAD only
    
    do_plots = [];  % default is true for MATLAB, false for Octave
    %do_plots = true;  % default is true for MATLAB, false for Octave
    output_path = [];  % pathname for output, [] = default
    
    decoder_type = 'ssf';
    %decoder_type = 'allrad';
    %decoder_type = 'pinv';
    
    % alpha can range from 0 to 1, used for PINV only
    %alpha = 0;  % mode matching
    alpha = 1;  % even energy
    
    for order = 3  % ambisonic order
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
                    mixed_order_scheme, ...
                    alpha ...
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
