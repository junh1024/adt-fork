function [ w ] = kaiser_win( N,n,alpha )
    %UNTITLED2 Summary of this function goes here
    %   Detailed explanation goes here
    
    w = besseli(0, pi*alpha*sqrt(1 - (2*n./N - 1).^2)) ...
        ./ besseli(0, pi * alpha);
end

