function [] = write_mk_ambix_config( filename, D, S, M, C )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    
    %% argument defaults
    if isempty(filename)
        fid = 1; % write to console
    else
        [fid,msg] = fopen(filename,'w');
        if msg
            error([msg ': ' filename]);
        end
    end
    
    %%
    % On Apr 10, 2014, at 9:01 PM, Matthias Kronlachner <m.kronlachner@gmail.com> wrote:
    %
    % All my plug-ins work with ACN/SN3D. The matrix is being scaled and
    % rearranged to fit ACN/SN3D input signals.  They are normalized to 1. This
    % is where I neglected the ambix proposal.
    %
    % I added /dec_mat_gain just recently for manual adjustments of the
    % loudness as I had decoders from different sources and with very different
    % loudness levels. (eg. Zotter is using the sqrt(1/4pi) norm.)
    
    %% header
    fprintf(fid, '// Ambix configuration\n// Written by %s\n', ...
        ambi_toolbox_version_string());
    [user, host, host_type] = getUserHost;
    fprintf(fid, '// run by %s on %s (%s) at %s\n', ...
            user, host, host_type, datestr(now));
    
    fprintf(fid, [...
        '\n'...
        '// Note: The coefficient order, scale, etc. refer to the matrix below.\n', ...
        '//       The inputs to the Ambix plugin will always be ACN/SN3D.\n']);
    write_faust_decoder_info(fid,filename,S,C,D);
    
    %% GLOBAL
    fprintf(fid, [...
        '\n'...
        '#GLOBAL\n' ...
        '/debug_msg %s\n' ...,
        '/coeff_scale %s\n' ...
        '/coeff_seq  %s\n'...
        '/flip %i\n'... );  % FIXME FIXME  ???
        '/dec_mat_gain %f\n' ... % FIXME FIXME
        '#END\n'], ...
        D.description, lower(D.coeff_scale), lower(D.coeff_order), ...
        0, sqrt(1/(4*pi)));
    
    %% HRTF
    % FIXME FIXME is this needed?
    fprintf(fid, [...
        '\n'...
        '#HRTF\n'...
        '#END\n']);
    
    %% DECODER MATRIX
    map = C.channels > -1; %hack to build true vector with correct length
    
    switch D.freq_bands
        case 1
            fprintf(fid, '\n#DECODERMATRIX\n');
            write_rows(fid, ambi_apply_gamma(M,D.gains,C), map);
            fprintf(fid, '#END\n');
        case 2
            fprintf(fid, '\n#DECODERMATRIX\n');
            write_rows(fid, ambi_apply_gamma(M.hf,D.hf_gains, C), map);
            fprintf(fid, '#END\n');
        otherwise
            error('freq_bands must be 1 or 2, not %i', D.freq_bands);
    end
    
    %% clean up
    if fid ~=1
        fclose(fid);
    end
    
end

function write_rows(fid, M, map)
    for i = 1:size(M,1)
        %fprintf(fid, 'add_row ');
        if ~exist('map','var') || isempty(map)
            fprintf(fid, '\t% f', M(i,:));
        else
            fprintf(fid, '\t% f', M(i,map));
        end
        fprintf(fid, '\n');
    end
end

