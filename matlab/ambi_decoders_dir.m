function [ outdir ] = ambi_decoders_dir( create )
    %AMBI_DECODERS_DIR(create) returns directory to which decoders are written
    %   create if true create the directory, else warn
    %   Edit this file to change where decoders are written
    
    outdir = fullfile('..','decoders');
    
    if ~exist(outdir,'dir')
        if create
            mkdir(outdir);
        else
            warning('Decoder outdir does not exist: %s', outdir);
        end
    end
    
end

