function [] = write_faust_adapter( C_in, C_out, ...
        out_path, plugin_name )
    %UNTITLED2 Summary of this function goes here
    %   Detailed explanation goes here
    
    %% defaults
    if ~exist('plugin_name', 'var')
        [~,plugin_name,~] = fileparts(out_path);
    end
    
    [fid, msg] = fopen(out_path,'w');
    if msg
        error([msg ': ' out_path]);
    end
    
    %%
    M = ambi_make_adapter_matrix(C_in, C_out);
    
    % faust template is up and over from this file
    dirstr = fileparts(mfilename('fullpath'));
    template_file = ...
        fullfile(dirstr, '..', 'faust', 'adapter-template.dsp');
    template = fileread(template_file);
    
    fprintf(fid, template, plugin_name, size(M,2), size(M,1));
    write_faust_adapter_matrix(M, fid);
    
    fclose(fid);
end

