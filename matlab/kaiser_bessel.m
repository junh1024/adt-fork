function [ g ] = kaiser_bessel( N )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    len = 2*N + 1;
    width = N + 1;
    
    for n = 1:(N+1)
        g(n) = besseli(0, width*sqrt(1 - ( (2*(n+N-1))/(len-1) -1)^2)) ...
            / besseli(0,width);
    end
end

