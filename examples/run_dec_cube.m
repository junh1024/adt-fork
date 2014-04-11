function [ output_args ] = run_dec_cube( )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    S = SPKR_ARRAY_CUBE();
    
    ambi_run_pinv(S,1);
end

