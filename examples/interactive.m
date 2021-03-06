function [ret] = interactive
    
    if ~exist('ambi_run_pinv','file')
        addpath(fullfile('..', 'matlab'));
        if ~exist('ambi_run_pinv','file')
            error('Cannot find ADT MATLAB scripts');
        end
    end
    
    defaults_file = 'adt_defaults.mat';
    
    fprintf('%s\n', ['ADT Interactive.  Default value shown in brackets []. ' ...
             '<cr> to accept defaults. ? for help.']);
    
    try
        load(defaults_file);
    catch e
        %display(e)
        defaults.csv_path = 'example.csv';
        defaults.speaker_array_name = 'example';
        defaults.coord_code = 'XYZ';
        defaults.units_code = 'MMM';
        defaults.order_h = 3;
        defaults.order_v = 3;
        defaults.convention = 1;  % fuma
        defaults.technique = 1; % allrad
        defaults.alpha = 0; % for pinv
        defaults.imag_spkrs_z = [-1, 1];
        defaults.version = 2;
    end
    
    try
        defaults.version;
    catch e
        fprintf('upgrading file to version 2\n');
        defaults.version = 2;
        defaults.alpha = 0;
        defaults.imag_spkrs_z = [-1,1];
    end
    
    ret = defaults;
    
    %ret.version = defaults.version;
    
    ret.csv_path = prompt_and_check(...
        '\nCSV file path [%s]: ', defaults.csv_path, ...
        'char', @(s)exist(s, 'file'), ...
        'Cannot open %s\n');
    
    [~, filename, ~] = fileparts(ret.csv_path);
    
    ret.spkr_array_name = prompt_and_check(...
        '\nSpeaker array name [%s]: ', filename, ...
        'char', @(s)length(s)>0, ...
        'Name must be one or more characters long\n');
    
    ret.coord_code = prompt_and_check(...
        ['\nCoordinate code for each column\n', ...
        '  X - front/back\n', ...
        '  Y - left/right\n', ...
        '  Z - up/down\n', ...
        '  A - azimuth (ccw from front)\n', ...
        '  E - elevation (from XY plane)\n', ...
        '  N - zenith angle (from +Z axis)\n', ...
        '  R - radius\n', ...
        'Choice [%s]: '], ...
        defaults.coord_code, ...
        'char', @(s)all(ismember(upper(s),'XYZAER')), ...
        'Each character should be one of X,Y,Z,A,E,R, not %s\n');
    
    ret.units_code = prompt_and_check(...
        ['\nUnit code for each column\n', ...
        '  M - meters\n', ...
        '  C - centimeters\n', ...
        '  F - feet\n', ...
        '  I - inches\n', ...
        '  R - radians\n', ...
        '  D - degrees\n', ...
        'Choice [%s]: '], ...
        defaults.units_code, ...
        'char', @(s)all(ismember(upper(s),'MCFIRDG')), ...
        'Each character should be one of M,C,F,I,R,D,G not %s\n');
    
    ret.convention = prompt_and_check(...
        ['\nInput convention\n', ...
        '  1. FuMa/AMB\n', ...
        '  2. AmbiX\n', ...
        '  3. N3D\n', ...
        '  4. SN2DXW/B2X\n', ...
        '  5. CICM\n', ...
        '  6, MPEG-H\n', ...
        'Choice [%d]: '],...
        defaults.convention, ...
        'str2double', @(i)ismember(i,1:6), ...
        'Should be one of [1,2,3,4,5,6], not %d\n');
    
    if ret.convention == 1
        max_order = 3;
    else
        max_order = 5;
    end
    
    ret.order_h = prompt_and_check(...
        '\nHorizontal order [%d]: ', defaults.order_h, ...
        'str2double', @(o)o>0&&o<=max_order,...
        ['H order should be between 1 and ', num2str(max_order), ', not %d\n']);
    
    ret.order_v = prompt_and_check(...
        '\nVertical order [%d]: ', defaults.order_h, ...
        'str2double', @(o)o<=ret.order_h&&o>=0, ...
        'V order should be between 0 and H order, not %d\n');
    
    ret.technique = prompt_and_check(...
        ['\nDesign technique,\n', ...
        '  1. AllRad\n', ...
        '  2. Pinv\n', ...
        '  3. Slepian\n', ...
        'Choice [%d]: '],...
        defaults.technique, ...
        'str2double', @(i)ismember(i,1:3), ...
        'Should be one of [1,2,3], not %d\n');
    
    switch ret.technique
        case 1         % prompt for imaginary speakers
            ret.imag_spkrs_z = prompt_and_check(...
                sprintf('\nEnter Z coord of imaginary speakers (+1 for apex, -1 for nadir) [%s]: ', ...
                num2str(defaults.imag_spkrs_z)),...
                defaults.imag_spkrs_z, ...
                'str2num', @(a)size(a,1)==1&&isnumeric(a),...
                'comma separated list of numbers, not %d\n');
            
        case 2
            ret.alpha = prompt_and_check(...
                '\nAlpha for Pinv (0=mode_matching, 1=even_energy) [%d]: ', ...
                defaults.alpha, ...
                'str2double', @(a)a>=0&&a<=1, ...
                'alphas should be between 0 and 1, not %d\n');
            
    end
    
    
    defaults = ret;
    
    % need -V6 so Octave will write in a format MATLAB can read, and vice versa.
    save(defaults_file, varname(defaults), '-V6');
    fprintf(['\nChoices written to %s.  Use run_dec_interactive to ' ...
             'create decoders.\n\n'], defaults_file);
end

function [ret] = prompt_and_check(prompt, def, ret_type, check, ...
                                  error_msg, help_msg)
    
    if ~exist('help_msg', 'var'), help_msg = 'No help yet.'; end
    
    while true
        ret_str = input(sprintf(prompt,def), 's');
        err_check = true;
        if isempty(ret_str)
            ret = def;
        elseif strcmpi(ret_str, '?')
            fprintf('%s\n', help_msg);
            err_check = false;
        else
            f = str2func(ret_type);
            ret = f(ret_str);
        end
        if err_check
            if check(ret)
                break
            else
                fprintf(error_msg, ret);
            end
        end
    end
end

function out = varname(var)
    out = inputname(1);
end
