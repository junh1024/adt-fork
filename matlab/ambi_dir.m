function [ outdir ] = ambi_dir( dir_name, create )
    
    switch dir_name
        case 'decoders'
            outdir = fullfile('..','decoders');
        case 'data'
            outdir = fullfile('..','data');
        case 'examples'
            outdir = fullfile('..','examples');
        case 'python'
            outdir = fullfile('..','python');
    end
    
    if ~exist(outdir,'dir')
        if create
            mkdir(outdir);
        else
            warning('%s directory does not exist: %s', dir_name, outdir);
        end
    end
end
