function run_dec_Shoebox
    
    %%
    mixed_order_scheme = 'HV';  % HV or HP
    
    S = SPKR_ARRAY_Shoebox;
    imaginary_speakers = [0,0,-1];  % one at bottom, used only for AllRAD
    
    do_plots = [];  % default is true for MATLAB, false for Octave
    output_path = [];  % pathname for output, [] = default
    
    decoder_type = 'ssf'; %'allrad'; %'pinv'
    
    for h_order = 4;
        for v_order = 4; %1:min(h_order,3);
            switch decoder_type
                case 'allrad'
                    ambi_run_allrad(...
                        S, ...  % speaker array struct
                        [h_order,v_order], ...  % ambisonic order [h, v]
                        imaginary_speakers, ... % imaginary speakers, one at bottom
                        output_path, ...
                        do_plots, ...
                        mixed_order_scheme ...
                        );
                case 'pinv'
                    ambi_run_pinv(...
                        S, ...  % speaker array struct
                        [h_order,v_order], ...  % ambisonic order [h, v]
                        [], ... % imaginary speakers, ignored for pinv
                        output_path, ...
                        do_plots, ...
                        mixed_order_scheme ...
                        );
                case 'ssf'
                    ambi_run_SSF(...
                        S,...
                        h_order,...
                        [], ... % imaginary speaker, ignored for SSF
                        [], ...
                        mixed_order_scheme...
                        );
            end
        end
    end
end
