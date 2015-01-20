function [ret] = interactive
    
    if ~exist('ambi_run_pinv','file')
        addpath(fullfile('..', 'matlab'));
        if ~exist('ambi_run_pinv','file')
            error('Cannot find ADT MATLAB scripts');
        end
    end
        
    try
        load('defaults.mat');
    catch e
        %display(e)
        defaults.csv_path = 'speakers.csv';
        defaults.coord_code = 'XYZ';
        defaults.units_code = 'MMM';
        defaults.order_h = 3;
        defaults.order_v = 3;
        defaults.convention = 1;  % fuma
        defaults.technique = 1; % allrad
    end
    
    ret.csv_path = prompt_and_check(...
        'CSV file path [%s]: ', defaults.csv_path, ...
        'char', @(s)exist(s, 'file'), ...
        'Cannot open %s\n');
    
    ret.coord_code = prompt_and_check(...
        'Coordinate code [%s]: ', defaults.coord_code, ...
        'char', @(s)all(ismember(upper(s),'XYZAER')), ...
        'Each character should be one of X,Y,Z,A,E,R, not %s\n');
    
    ret.units_code = prompt_and_check(...
        'Units code [%s]: ', defaults.units_code, ...
        'char', @(s)all(ismember(upper(s),'MCFIRDG')), ...
        'Each character should be one of M,C,F,I,R,D,G not %s\n');
    
    ret.convention = prompt_and_check(...
        'Encoding convention,\n  1. FuMa/AMB\n  2. AmbiX\n  3. N3D\nChoice [%d]: ',...
        defaults.convention, ...
        'str2double', @(i)ismember(i,1:3), ...
        'Should be one of [1,2,3], not %d\n');
    
    if ret.convention == 1
        max_order = 3;
    else
        max_order = 5;
    end
    
    ret.order_h = prompt_and_check(...
        'Horizontal order [%d]:', defaults.order_h, ...
        'str2double', @(o)o>0&&o<=max_order,...
        ['H order should be between 1 and ', num2str(max_order), ', not %d\n']);
    
    ret.order_v = prompt_and_check(...
        'Vertical order [%d]:', defaults.order_h, ...
        'str2double', @(o)o<=ret.order_h&&o>0, ...
        'V order should be between 1 and H order, not %d\n');
    
    ret.technique = prompt_and_check(...
        'Design technique,\n  1. AllRad\n  2. Pinv\n  3. Slepian\nChoice [%d]: ',...
        defaults.technique, ...
        'str2double', @(i)ismember(i,1:3), ...
        'Should be one of [1,2,3], not %d\n');
    
    defaults = ret;
    
    % need -V6 so Octave will write in a format MATLAB, and vice versa.
    save('defaults.mat', varname(defaults), '-V6');
end

function [ret] = prompt_and_check(prompt, def, ret_type, check, error_msg)
    while true
        ret_str = input(sprintf(prompt,def), 's');
        if isempty(ret_str)
            ret = def;
        else
            f = str2func(ret_type);
            ret = f(ret_str);
        end
        if check(ret)
            break
        else
            fprintf(error_msg, ret);
        end
    end
end

function out = varname(var)
  out = inputname(1);
end
