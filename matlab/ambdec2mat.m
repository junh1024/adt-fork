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
        if ~ischar(tline), break; end  % end-of-file
        
        tline = strtrim(tline);
        
        if isempty(tline), continue; end  % empty line
        if strcmpi(tline(1), '#'), continue; end % comment
        
        if false %inOctave()
            % Octave is broken here , so we have to resort to sprintf
            C = strsplit(tline, sprintf(' \f\n\r\t\v'), true);
            % Octave developers have broken this, see
            %  http://octave.1599824.n4.nabble.com/Re-new-strsplit-function-td4651374.html
        else
            C = strsplit(tline);
        end
        %
        %fprintf('...%s...\n', C{1});
        switch C{1}
            case '/description'
                D.ambdec_description = strtrim(tline(13:end));
            case '/version'
                D.version = str2double(C(2));
                
                % version 1 and 2 files have these
            case '/dec/hor_order'
                D.hor_order = str2double(C(2));
            case '/dec/ver_order'
                D.ver_order = str2double(C(2));
                
                % version 3 files have this
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
                
                % version 3 files have this
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
                g{matrix_count} = str2double(C(2:end)); %#ok<AGROW>
                
            case 'add_row'
                row_count = row_count + 1;
                c{matrix_count,row_count} = str2double(C(2:end)); %#ok<AGROW>
            
            case 'add_spkr'
                % this is handled by ambdec2spkr_array
                
            case '\end'
                break;
                
            otherwise
                warning('unparsed line: %s', tline);
        end
    end
    fclose(fid);
    
    %% create matrices
    switch D.freq_bands
        case 1
            M = vertcat(c{1,:});
            D.gains = g{1};
            D.type = 1;
            D.decoder_type = D.type;
        case 2
            M.lf = vertcat(c{2,:});
            M.hf = vertcat(c{3,:});
            D.lf_gains = g{2};
            D.hf_gains = g{3};
            D.type = 3;
            D.decoder_type = D.type;
    end
    
    switch D.version
        case {1,2}
            warning('untested ambdec file version: %d', D.version);
            % version 1 and 2 use FuMA order
            D.coeff_order = 'FuMa';
            D.xover_ratio = 0;
        case 3
            % version 3 uses ACN order
            D.coeff_order = 'ACN';
            % todo fill in H and V orders from channel mask
    end
    
    
end

