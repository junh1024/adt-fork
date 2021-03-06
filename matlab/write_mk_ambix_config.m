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
    
    % update per email from Matthias
    % On Feb 7, 2016, at 8:32 AM, Matthias Kronlachner <m.kronlachner@gmail.com> wrote:
    % I have binaries for download up to 5th order, and you can compile it for any order.
    if false %C.h_order >= 3 || C.v_order >= 3
        warning('The ambiX decoder plugin is limited to 3rd order');
    end
    
    fprintf('Writing Ambix config to: %s\n', filename);
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
    
    % On Apr 30, 2014, at 8:57 AM, Matthias Kronlachner <m.kronlachner@gmail.com> wrote:
    %
    % Concerning the /dec_mat_gain :
    % I see you add the fixed matrix gain of sqrt(1/4pi), are your decoder
    % matrices normalized to 1? Then this value should be set to 1. The matrix
    % gets rescaled by this factor.
    %
    % Other comments for your write_mk_ambix_config.m:
    %
    % #HRTF is not needed but i think it's good to leave it in there in case
    % somebody wants to add his binaural loudspeaker impulse responses.
    % Therefore the skeleton of the config file is complete.
    %
    % /flip 0 can be left in there as well in case you realize a mirrored y
    % axis and want to fix this in the config file
    
    
    %% header
    fprintf(fid, '// Ambix configuration\n// Written by %s\n', ...
        ambi_toolbox_version_string());
    [user, host, host_type] = getUserHost;
    fprintf(fid, '// run by %s on %s (%s) at %s\n', ...
        user, host, host_type, datestr(now));
    
    fprintf(fid, [ ...
        '\n', ...
        '// Note: The coefficient order, scale, etc. refer to the matrix below.\n', ...
        '//       The inputs to the Ambix plugin will always be ACN/SN3D.\n']);
    write_faust_decoder_info(fid,filename,S,C,D);
    
    %% GLOBAL
    fprintf(fid, [...
        '\n', ...
        '#GLOBAL\n', ...
        '/debug_msg %s\n', ...
        '/coeff_scale %s\n', ...
        '/coeff_seq  %s\n', ...
        '/flip %i\n', ...  % 1 negates y axis
        '/dec_mat_gain %f\n', ... % set to 1 per MK
        '#END\n'], ...
        D.description, lower(D.coeff_scale), lower(D.coeff_order), ...
        0, ...  % flip
        1  ...  % dec_mat_gain
        );
 

    %% SPEAKERS
    fprintf(fid, '\n#SPEAKERS spkrNr spkrLabel Radius Azimut Elevation x y z\n');
    for i = 1:length(S.id)
        % Note: format control '% f' produces a leading space when the
        % quantity is positive.
        fprintf(fid, '% i\t% s\t% f\t% f\t% f\t% f\t% f\t% f', ...
            i, S.id{i}, S.r(i), S.az(i)*180/pi, S.el(i)*180/pi, ...
            ... % multiply radius to get positions of speakers
            S.r(i).*S.x(i), S.r(i).*S.y(i), S.r(i).*S.z(i) );
        % is there a connection for this speaker?
        if false %isfield(S, 'conns') && length(S.conns) >= i
            fprintf(fid, '\t%s\n', S.conns{i});
        else
            fprintf(fid, '\n');
        end
    end
    fprintf(fid, '#END\n');
    
    %% HRTF
    % leave in as place holder, insert speaker HRTFs here
    fprintf(fid, [ ...
        '\n', ...
        '#HRTF\n', ...
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
            % M.hf does not have gamma applied at this point, so we must do
            % it here.  (FIXME: why is this?)
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

