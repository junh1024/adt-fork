function [ D ] = write_ambdec_config(filename, D, S, M, C)
    %write_ambdec_config(fname, D, S, M) write Ambdec configuration file
    %   D = write_ambdec_config(filename, D, S, M, C) writes a ver. 3 Ambdec config file.
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
    %  Note: the file format was reversed engineered from the AmbDec 0.51
    %  source code and preset files and may change with subsequent releases
    %  of AmbDec.
    
    %
    % FIXME FIXME needs a clean up.  Several defaults are filled in here,
    % so it must be called even if we don't want and ambdec config file.
    % Should factor out the defaulting mechanism.
    
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
    % $Id$
    
    %%
    [fid, msg] = fopen(filename,'w');
    if msg
        error([msg ': ' filename]);
    end
    
    %% header
    fprintf(fid, '# AmbDec configuration\n# Written by %s\n', ...
        ambi_toolbox_version_string());
    [user, host, host_type] = getUserHost;
    fprintf(fid, '# run by %s on %s (%s) at %s\n\n', ...
            user, host, host_type, datestr(now));
    
    ambdec_file_version = 3;
    
    %% decoder defaults
    if false
    Din = D;
    D.description = S.name;
    D.freq_bands  = 1;           % 2
    
    D.coeff_order = 'fuma';      % acn
    D.coeff_scale = 'fuma';      % n3d sn3d
    D.input_scale = 'fuma';      % n3d sn3d
    
    % if all the speaker radii are within 10% of each other, default 
    % is to put nfc on input. 
    if max(S.r(:))/min(S.r(:)) < 1.1
        D.neff_comp = 'input';    % none, input, output
    else
        D.neff_comp = 'output';
    end
    
    D.delay_comp  = 'on';        % on off
    D.level_comp  = 'on';        % on off
    D.xover_freq  = 400;         % in Hz
    D.xover_ratio = 0.0;         % in dB (!)
    
    % fill fields from Din
    fields = fieldnames(Din);
    for i = 1:length(fields)
        D.(fields{i}) = Din.(fields{i});
    end
    end
    
    
    % compute channel mask from channel definitions
    %  note: AmbDec uses ACN order
    % fixme fixme: is there ever a valid case where the caller supplies the
    % channel mask?
    if ~isfield(D,'chan_mask')
        acn1 = ambi_ACN(C.sh_l,C.sh_m)+1; %acn is zero based
        acn_mask = false(1,max(acn1));
        acn_mask(acn1) = true;
        D.chan_mask   = dec2hex(digits2num(acn_mask,2));
    end
    
    switch D.freq_bands
        case 1
            if ~isfield(D,'gains'),       D.gains       = [1 1 1 1]; end
        case 2
            if ~isfield(D,'lf_gains'),    D.lf_gains    = [1 1 1 1]; end
            if ~isfield(D,'hf_gains'),    D.hf_gains    = [1 1 1 1]; end
        otherwise
            error('freq_bands must be 1 or 2, not %i', D.freq_bands);
    end
    
    %% if no speaker IDs, gensym some 'cause Ambdec needs 'em
    if ~isfield(S, 'id')
        S.id = arrayfun(@(i)sprintf('S%02i', i), 1:length(S.x),...
            'UniformOutput', false);
    end
    
    %% if no speaker conns (jack auto connect), make null ones.
    if ~isfield(S, 'conn')
        S.conn = arrayfun(@(i)sprintf(''), 1:length(S.x),...
            'UniformOutput', false);
    end
    
    %% put coefficients into ACN order
    
    if 0
        % we use FUMA order
        fuma = 'WXYZRSTUVKLMNOPQ';
        % Fons uses ACN order in Ambdec 0.5s
        acn  = 'WYZXVTRSUQOMKLNP';
        
        map = 1:length(acn);
        switch lower(D.coeff_order)
            case 'fuma'
                for i = 1:length(acn)
                    map(i) = find(acn(i)==fuma);
                end
            case 'acn'
                % nada
            otherwise
                error('unknown coefficient order: %s', D.coeff_order);
        end
    end
    
    % need to use 'dummy' here instead of ~, to support Octave 3.2 and
    % earlier 
    [dummy,perm] = sort(acn1);
    map = perm;
    
    if iscell(C.names)
        fprintf(fid, '# input channel order: ');
        for i = 1:length(C.names(map))
            fprintf(fid, '%s ', C.names{map(i)});
        end
        fprintf(fid, '\n\n');
    else
        fprintf(fid, '# input channel order: %s\n\n', C.names(map));
    end
    
    
    %% write it out
    fprintf(fid, ...
        ['/description     %s\n\n',...
        '/version         \t%i\n\n',...
        ...
        '/dec/chan_mask   \t%s\n',...
        '/dec/freq_bands  \t%i\n',...
        '/dec/speakers    \t%i\n',...
        '/dec/coeff_scale \t%s\n\n'], ...
        D.description, ...
        ambdec_file_version,...
        lower(D.chan_mask), ...
        D.freq_bands, ...
        numel(S.id), ...
        lower(D.coeff_scale));
    
    fprintf(fid, ...
        ['/opt/input_scale  \t%s\n',...
        '/opt/nfeff_comp   \t%s\n',...
        '/opt/delay_comp   \t%s\n',...
        '/opt/level_comp   \t%s\n',...
        '/opt/xover_freq   \t%f\n',...
        '/opt/xover_ratio  \t%f\n\n'], ...
        lower(D.input_scale),...
        lower(D.neff_comp),...
        lower(D.delay_comp),...
        lower(D.level_comp),...
        D.xover_freq,...
        D.xover_ratio);
    
    %% speakers
    fprintf(fid, ...
        ['/speakers/{\n',...
        '#            id      dist     azim     elev     conn\n',...
        '#-----------------------------------------------------------------------\n',...
        ]);
    % check number of speakers, Ambdec requires at least four
    if length(S.id) < 4
        warning('Ambdec requires at least four speakers, nsprk=%i',length(S.id));
    end
    %
    for i = 1:length(S.id)
        % Note: format control '% f' produces a leading space when the
        % quantity is positive.
        fprintf(fid, 'add_spkr \t%s\t% f\t% f\t% f', ...
            S.id{i}, S.r(i), S.az(i)*180/pi, S.el(i)*180/pi );
        % is there a connection for this speaker?
        if isfield(S, 'conns') && length(S.conns) >= i 
            fprintf(fid, '\t%s\n', S.conns{i});
        else
            fprintf(fid, '\n');
        end
    end
    fprintf(fid, '/}\n\n');
    
    %% matrix
    switch D.freq_bands
        case 1
            write_matrix(fid, 'matrix', D.gains, M, map);
            
        case 2
            write_matrix(fid, 'lfmatrix',  D.lf_gains, M.lf, map);
            write_matrix(fid, 'hfmatrix',  D.hf_gains, M.hf, map);
    end
    
    fprintf(fid, '/end\n');
    fclose(fid);
    
    fprintf('----\n');
    fprintf('AmbDec preset file = %s\n', filename);
    %fprintf('required inputs = %s\n', C.names(map));  FIXME FIXME!!!
    fprintf('speaker outputs = ');
    for i = 1:length(S.id)
        fprintf('%s ', S.id{i});
    end
    fprintf('\n----\n');
end

function write_matrix(fid, mat_name, gains, M, map)
    fprintf(fid, '/%s/{\norder_gain', mat_name);
    fprintf(fid, '\t%f', gains);
    % ambdec expects four gains regardless of decoder order (!?!)
    fprintf(fid, '\t%f', zeros(1,4-length(gains))); 
    fprintf(fid, '\n');
    write_rows(fid, M, map);
    fprintf(fid, '/}\n\n');
end

function write_rows(fid, M, map)
    for i = 1:size(M,1)
        fprintf(fid, 'add_row ');
        fprintf(fid, '\t% f', M(i,map));
        fprintf(fid, '\n');
    end
end
