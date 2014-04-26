function [] = write_faust_decoder_info(fid, filename, S, C, D)
    fprintf(fid, '\n//------- decoder information -------');
    fprintf(fid, '\n// decoder file = %s', filename);
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
