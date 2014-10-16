function [ M, D ] = ambdec2mat( configpath )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    fid = fopen(configpath, 'r');
    if fid < 0
        error('%s not found.', configpath)
    end
    
    %% read the file
    matrix_count = 0;
    row_count = 0;
    
    while true
        tline = fgetl(fid);
        if ~ischar(tline), break; end
        
        if inOctave()
            % Octave is broken here , so we have to resort to sprintf
            C = strsplit(tline, sprintf(' \f\n\r\t\v'), true);
        else
            C = strsplit(tline);
        end
        %
        switch C{1}
            case '/version'
                D.version = str2double(C(2));
                
            case '/dec/chan_mask'
                D.chan_mask = hex2dec(C(2));
            case '/dec/speakers'
                D.speakers = str2double(C(2));
            case '/dec/freq_bands'
                D.freq_bands = str2double(C(2));
            case '/dec/coeff_scale' 
                D.coeff_scale = char(C(2));
                
            case '/opt/input_scale'
                D.input_scale = char(C(2));
            case '/opt/nfeff_comp'
                D.neff_comp = char(C(2));
            case '/opt/delay_comp'
                D.delay_comp = char(C(2));
            case '/opt/level_comp' 
                D.level_comp = char(C(2));
            
            case '/opt/xover_freq'
                D.xover_freq = str2double(C(2));
            case '/opt/xover_ratio'
                D.xover_ratio = str2double(C(2));
                
                
            case '/matrix/{'
                matrix_count = 1;
                row_count = 0;
            case '/lfmatrix/{'
                matrix_count = 2;
                row_count = 0;
            case '/hfmatrix/{'
                matrix_count = 3;
                row_count = 0;
                
            case 'order_gain'
                g{matrix_count} = str2double(C(2:end));
                
            case 'add_row'
                row_count = row_count + 1;
                c{matrix_count,row_count} = str2double(C(2:end));
        end
    end
    fclose(fid);
    
    %% create matrices
    switch D.freq_bands
        case 1
            M = cell2mat({c{1,:}}');
            D.gains = g{1};
            D.type = 1;
            D.decoder_type = D.type;
        case 2
            M.lf = cell2mat({c{2,:}}');
            M.hf = cell2mat({c{3,:}}');
            D.lf_gains = g{2};
            D.hf_gains = g{3};
            D.type = 3;
            D.decoder_type = D.type;
    end
    
    switch D.version
        case {1,2}
            error('untested');
        case 3
            D.coeff_order = 'ACN';
    end
    
    
end

