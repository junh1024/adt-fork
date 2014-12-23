function [ ] = performance_plots( )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    [M,D] = ambdec2mat('/Users/heller/.ambdecrc/thepit-3h3v-nocomp.ambdec');
    
    C = ambi_channel_definitions(3,3,'HV',D.coeff_order, D.coeff_scale);
    
    S = SPKR_ARRAY_CCRMA_LISTENING_ROOM();
    
    MM = ambi_apply_gamma(M.hf, D.hf_gains, C);
    
    ambi_plot_rE(S,[],MM,C);
end

