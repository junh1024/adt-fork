function [M,D,name,out_path] = ambi_write_decoder_engine_configuration(S,C,M_mm,D,Gamma,name,out_path)
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    %% setup decoder config
    
    if ~exist('name','var') || isempty(name) 
        name = D.description;
    end
    
    if ~exist('Gamma', 'var') || isempty(Gamma)
        Gamma = ones(size(0:max(C.v_order,C.h_order)));
    end
    
    switch D.decoder_type
        case { 2, 3 }
            D.freq_bands = 2;
            D.hf_gains = Gamma;
            D.lf_gains = ones(size(Gamma));
            D.description = [name, '_2_band'];
            
            M.lf=M_mm;
            M.hf=M_mm;  % we take care of gamma later
        case 1
            D.freq_bands = 1;
            D.gains = Gamma;
            D.description = [name, '_1_band'];
            
            M = M_mm;
        otherwise
            error('PINV decoder must be 1 or 2 bands');
    end
    
    D.delay_comp = 'on';
    D.level_comp = 'on';
    D.xover_freq  = 400;         % in Hz
    D.xover_ratio = 0.0;         % in dB (!)
    
    D.coeff_order = C.ordering_rule;
    D.coeff_scale = C.encoding_convention;
    if ~isfield(D, 'input_scale')
        D.input_scale = C.encoding_convention;
    end
    
    if max(S.r(:))/min(S.r(:)) < 1.1
        D.neff_comp = 'input';    % none, input, output
    else
        D.neff_comp = 'output';
    end
    
    
    
    %% write out configs
    if ~exist('out_path', 'var') || isempty(out_path)
        outdir = ambi_decoders_dir(true);
        out_path = fullfile(outdir, D.description);
    end
    
    %% ambdec backend
    if max(C.h_order,C.h_order)<=3 ...
            && ...
            (strcmpi(D.coeff_scale, 'fuma') ...
            || strcmpi(D.coeff_scale, 'n3d') ...
            || strcmpi(D.coeff_scale, 'sn3d') ) ...
            && ...
            (strcmpi(D.input_scale, 'fuma') ...
            || strcmpi(D.input_scale, 'n3d') ...
            || strcmpi(D.input_scale, 'sn3d') )
        write_ambdec_config(...
            [out_path '.ambdec'],...
            D, S, M, C);
    else
        warning('Skipping AmbDec output.');
    end
    
    %% faust backend
    if true
        write_faust_config(...
            [out_path '.dsp'],...
            D, S, M, C);
    end
    
    %% mk_Ambix backend
    if true
        write_mk_ambix_config([out_path '.config'], D, S, M, C);
    end
    
    %% write coeffs into a CSV file
    if true
        switch D.decoder_type  %#ok<UNRCH>
            case { 2, 3 }
                csvwrite(...
                    [out_path '-rEmax.csv'], ...
                    ambi_apply_gamma(M.hf, Gamma, C));
                csvwrite(...
                    [out_path '-basic.csv'], ...
                    M.lf);
                csvwrite(...
                    [out_path '-in_phase.csv'], ...
                    ambi_apply_gamma(M.lf, ...
                    ambi_in_phase_gains(C, S), C));
                
            case {1}
                csvwrite(...
                    [out_path '-rEmax.csv'], ...
                    ambi_apply_gamma(M, Gamma, C));
                csvwrite(...
                    [out_path '-in_phase.csv'], ...
                    ambi_apply_gamma(M, ...
                    ambi_in_phase_gains(C, S), C));
            otherwise
                error('unknown decoder type %d', D.decoder_type)
        end
    end
    
    %% Fini!
    
    
end

