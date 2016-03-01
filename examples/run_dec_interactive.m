function [ D, S, C ] = run_dec_interactive( name )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    load('adt_defaults.mat')
    
    if ~exist('name', 'var')
        if isfield(defaults, 'spkr_array_name')
            name = defaults.spkr_array_name
        else
            [~, name, ~] = fileparts(defaults.csv_path); 
        end
    end;
    
    try
        A = txt2mat(defaults.csv_path);
        Smat = A(:,end-2:end);
    catch err1
        fprintf('%s\n', 'falling back to importdata()');
        
        try
            A = importdata(defaults.csv_path);
            if isstruct(A)
                Smat = A.data(:,end-2:end);
            elseif isnumeric(A)
                Smat = A(:,end-2:end);
            else
                error('importdata returned unknown data type %s', class(A))
            end
        catch err2
            fprintf('%s\n', 'WARNING: falling back to csvread()\ncheck that data is read correctly.');
            A = csvread(defaults.csv_path);
            Smat = A(:,end-2,end);
        end
    end
    
    % assume the coordinate are last three columns
    
    
    S = ambi_mat2spkr_array(...
        Smat, ...
        defaults.coord_code, ...
        defaults.units_code, ...
        name);
    
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

