function [ D ] = write_faust_config(filename, D, S, M, C )
    %write_faust_config(fname, D, S, M) write Faust configuration file
    %   D = write_faust_config(filename, D, S, M, C) writes configuration
    %   info for Faust decoder implementation
    %
    %  filename is the file name to write
    %  D is the decoder struct, empty fields are filled in from defaults
    %  S is the speaker array struct
    %  M is the decoder matrix.  For dual-band decoders M.lf is the low
    %    frequency matrix, M.hf is the high frequency matrix.  There should be
    %    one row for each speaker, one column for each ambisonic component.  It
    %    will recorder the columns to be in ACN order.
    %  D is returned with defaults filled in.
    %
    
    
    %{
This file is part of the Ambisonic Decoder Toolbox (ADT).
Copyright (C) 2013  Aaron J. Heller

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.
    
You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
    %}
    
    % Author: Aaron J. Heller <heller@ai.sri.com>
    % $Id: write_faust_config.m 26470 2014-03-20 07:40:47Z heller $
    
    %%
    [fid, msg] = fopen(filename,'w');
    if msg
        error([msg ': ' filename]);
    end
    
    %%
    [f.dir,f.name,f.type] = fileparts(filename);
    
    fprintf(fid, '// Faust Decoder Configuration File');
    fprintf(fid, '\n// Written by %s %s', ...
        'AmbiToolbox V3.1', datestr(now));
    [user, host, host_type] = getUserHost;
    fprintf(fid, '\n// run by %s on %s (%s)\n', user, host, host_type);
    
    write_faust_decoder_info(fid, filename, S, C, D);
    
    fprintf(fid, ...
        ['\n// start decoder configuration\n'...
        'declare name\t\"%s\";\n'],...
        f.name);
    
    fprintf(fid, ...
        ['\n// bands\n'...
        'nbands = %d;\n'],...
        D.decoder_type);
    
    fprintf(fid, ...
        ['\n// decoder type\n'...
        'decoder_type = %d;\n'],...
        D.freq_bands);
    
    fprintf(fid, ...
        ['\n// crossover frequency in Hz\n'...
        'xover_freq = hslider(\"xover [unit:Hz]\",400,200,800,20)'...
        ': dezipper;\n'] ...
        );
    
    fprintf(fid, ...
        ['\n// lfhf_balance\n'...
        'lfhf_ratio = hslider(\"lf/hf [unit:dB]\", 0, -3, +3, 0.1)'...
        ': mu.db2linear : dezipper;\n\n'] ...
        );
    
    fprintf(fid, ...
        ['\n// decoder order\n'...
        'decoder_order = %d;\n'], ...
        max(C.h_order,C.v_order));
    
    co = C.sh_l;
    fprintf(fid, '\n// ambisonic order of each input component\n');
    fprintf(fid, 'co = (');
    fprintf(fid, '% d,', co(1:end-1));
    fprintf(fid, '% d);\n', co(end));
    
    fprintf(fid, ...
        ['\n// use full or reduced input set\n'...
        'input_full_set = %d;\n'], ...
        1); % FIXME hardwired FIXME
    
    fprintf(fid, ...
        ['\n// delay compensation\n'...
        'delay_comp = %d;\n'], ...
        strcmpi(D.delay_comp, 'on'));
    
    fprintf(fid, ...
        ['\n// level compensation\n'...
        'level_comp = %d;\n'], ...
        strcmpi(D.level_comp, 'on'));
    
    switch D.neff_comp
        case 'input'
            fprintf(fid, ...
                ['\n// nfc on input or output\n'...
                'nfc_output = %d;\nnfc_input = %d;\n'], ...
                0,1);
            
        case 'output'
            fprintf(fid, ...
                ['\n// nfc on input or output\n'...
                'nfc_output = %d;\nnfc_input = %d;\n'], ...
                1,0);
    end
    
    fprintf(fid, ...
        ['\n// enable output gain and muting controls\n'...
        'output_gain_muting = %d;\n'], ...
        1); % FIXME hardwired for now  FIXME
    
    
    fprintf(fid, ...
        ['\n// number of speakers\n'...
        'ns = %d;\n'], ...
        length(S.x));
    
    % round speaker radii to nearest 0.1mm
    rs = round(S.r * 1.0e3)/1.0e3;
    
    fprintf(fid, '\n// radius for each speaker in meters\n');
    write_faust_vector( rs, 'rs', fid);
    %fprintf(fid, 'rs = (');
    %fprintf(fid, '% d,', rs(1:end-1));
    %fprintf(fid, '% d);\n', rs(end));
    
    fprintf(fid, '\n// per order gains, 0 for LF, 1 for HF.  Used to implement shelf filters, or to modify velocity matrix for max_rE decoding, and so forth.  See Appendix A of BLaH6 for values.\n');
    switch D.decoder_type
        case 1    % one-band rE_max
            write_faust_vector( D.gains, 'gamma(0)', fid);
            
        case {2,3} % two-band shelf and vienna
            write_faust_vector( D.lf_gains, 'gamma(0)', fid);
            write_faust_vector( D.hf_gains, 'gamma(1)', fid);
    end
    
    switch D.decoder_type
        case 1 % one-band rE_max
            fprintf(fid, '\n// gain matrix\n');
            write_faust_speaker_matrix(M,0,'s',fid);
            
        case 2 % two-band shelf
            fprintf(fid, '\n// gain matrix\n');
            write_faust_speaker_matrix(M.lf,0,'s',fid);
            
        case 3 % two-band vienna
            fprintf(fid, '\n// LF gain matrix\n');
            write_faust_speaker_matrix(M.lf,0,'s',fid);
            fprintf(fid, '\n// HF gain matrix\n');
            write_faust_speaker_matrix(M.hf,1,'s',fid);
    end
    
    % input mask
    input_mask = char(zeros(1,(max(C.h_order,C.v_order)+1)^2) + '!');
    %input_mask = char(zeros(1,max(C.channels(:))) + '!');
    input_mask(C.channels) = '_';
    fprintf(fid, '\n\n// ----- do not change anything below here ----\n');
    fprintf(fid, '\n// mask for full ambisonic set to channels in use\n');
    fprintf(fid, 'input_mask(0) = bus(nc);\n');
    fprintf(fid, 'input_mask(1) = (');
    fprintf(fid, '%c,', input_mask(1:end-1));
    fprintf(fid, '%c);\n', input_mask(end));
    
    [pathstr, name, ext] = fileparts(mfilename('fullpath'));
    if true
        fprintf(fid, '\n\n%s\n//EOF!\n', ...
            fileread(fullfile(pathstr, 'faust', 'ambi-decoder_preamble2.dsp')));
    else
        fprintf(fid, '\n\n\ninclude(%s);\n',...
            fullfile(pathstr, 'faust', 'ambi-decoder_preamble2.dsp'));
    end
    
    
    fclose(fid);
    
    % write decoder info to stdout
    if true
        write_faust_decoder_info(1, filename, S, C, D)
    end
end

function [] = write_faust_vector( v, var_name, fid )
    v = v(:);
    fprintf(fid, '%s = (', var_name);
    fprintf(fid, '% 14.10g,', v(1:end-1));
    fprintf(fid, '% 14.10g);\n', v(end));
end

function [] = write_faust_speaker_matrix( M, band, Msym, fid)
    %UNTITLED2 Summary of this function goes here
    %   Detailed explanation goes here
    
    if ~exist('Msym', 'var'), Msym = 's'; end;
    if ~exist('fid', 'var'),  fid = 1; end;
    
    % round to 10 significant digits (= -200dB)
    M = round(M*1.0e10)/1.0e10;
    for i = 1:size(M,1);
        fprintf(fid, '%s(%02d,%1d) = (', Msym, i-1, band);
        fprintf(fid, '% 14.10g,', M(i,1:end-1));
        fprintf(fid, '% 14.10g);\n', M(i,end));
    end
    
end

function [] = write_faust_decoder_info(fid, filename, S, C, D)
    fprintf(fid, '\n//------- faust decoder information -------');
    fprintf(fid, '\n// dsp file = %s', filename);
    fprintf(fid, '\n// speaker array name = %s', S.name);
    fprintf(fid, '\n// horizontal order   = %d', C.h_order);
    fprintf(fid, '\n// vertical order     = %d', C.v_order);
    fprintf(fid, '\n// coefficient order  = %s', D.coeff_order);
    fprintf(fid, '\n// coefficient scale  = %s', D.coeff_scale);
    fprintf(fid, '\n// input scale        = %s', D.input_scale);
    fprintf(fid, '\n// mixed-order scheme = %s', C.scheme);
    if iscell(C.names)
        fprintf(fid, '\n// input channel order: ');
        for i = 1:length(C.names)
            fprintf(fid, '%s ', C.names{i});
        end
    else
        fprintf(fid, '\n// input channel order: %s', C.names);
    end
    fprintf(fid, '\n// output speaker order: ');
    for i = 1:length(S.id)
        fprintf(fid, '%s ', S.id{i});
    end
    fprintf(fid, '\n//-------\n\n');
end



