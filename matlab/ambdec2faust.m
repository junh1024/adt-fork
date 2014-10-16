function [] = ambdec2faust( ambdec_config, out_path, order, description )
    %UNTITLED2 Summary of this function goes here
    %   Detailed explanation goes here
    
    
    [M,D] = ambdec2mat(ambdec_config);
    
    if ~exist('description','var') || isempty(description)
        [path,name,ext] = fileparts(out_path);
        D.description = name;
    end
    
    C = ambi_channel_definitions(order(1),order(2),'HV', ...
        D.coeff_order, D.coeff_scale);
    
    S = ambdec2spkr_array(ambdec_config);
    
    write_faust_config( ...
        [out_path '.dsp'], ...
        D, S, M, C);
end

