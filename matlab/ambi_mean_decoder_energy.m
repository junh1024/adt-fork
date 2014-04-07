function [ E ] = ambi_mean_decoder_energy( M, C )
    %AMBI_MEAN_DECODER_ENERGY mean energy gain of decoder
    %   Eqn 27 from [1], useful for matching loudness of different decoders
    %   g_decoder = sqrt(E_target/E)  Eqn 18.
    
    % [1] F. Keiler, H. Kropp, A. Kruger, and J.-M. Batke, "Gain Adaption
    % for Ambisonics Decoders," presented at the International Conference
    % on Spatial Audio, Detmold, 2011, pp. 1?6.
    
    if C.v_order > 0
        % periphonic case, N_d = 3
        full_area = 4*pi;
    else
        % horizontal only, N_d = 2
        full_area = 2*pi; 
    end
    
    E = sum( abs(M(:)).^2 ) / full_area;
end

