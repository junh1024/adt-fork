function [ gammas, g0 ] = ambi_in_phase_gains( C, S, type )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    M = max(C.v_order, C.h_order);
    m = 0:M;
    
    if C.v_order > 0
        %winFun = @(m) = prod( (n+1):M) ./ (M+1:
        gammas = (factorial(M+1) ./ factorial(M+m+1)) .* ...
            (factorial(M) ./ factorial(M-m));
    else
        gammas = (factorial(M) ./ factorial(M+m)) .* ...
            (factorial(M) ./ factorial(M-m));
    end
    
    
end

