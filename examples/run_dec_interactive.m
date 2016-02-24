function [ D ] = run_dec_interactive( name )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    load('defaults.mat')
    
    if ~exist('name', 'var'), name = []; end;
    
    S = ambi_mat2spkr_array(...
        defaults.csv_path, ...
        defaults.coord_code, ...
        defaults.units_code, ...
        name);
    
    %convention_codes = {'fuma', 'ambix', 'ambix2009'};
    
    C = ambi_channel_definitions_convention(...
        [defaults.order_h, defaults.order_v], ...
        defaults.convention);
    
    
    switch defaults.technique
        case {1, 'allrad'}
            imag_spkrs = [...
                zeros(size(defaults.imag_spkrs_z',1),2),...
                defaults.imag_spkrs_z'];
                
            
            D = ambi_run_allrad(...
                S, ...  % speaker array struct
                C, ...  % ambisonic order [h, v]
                imag_spkrs ... % imaginary speakers, one at bottom
                );

        case {2, 'pinv'}
            D = ambi_run_pinv(...
                S, ...  % speaker array struct
                C, ...  % ambisonic order [h, v]
                [], ... % imaginary speakers, ignored for pinv
                [], ... % output path
                [], ... %do_plots, ...
                [], ... %mixed_order_scheme, ...
                defaults.alpha ...
                );
        case {3, 'ssf'}
            D = ambi_run_SSF(...
                S,...
                C ...
                );

        otherwise
            error('unknown technique code (%d)', defaults.technique);
            
    end
    
    
end

