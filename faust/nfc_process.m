function [ out ] = nfc_process( o, g, d, in, reset)
    %UNTITLED3 Summary of this function goes here
    %   Detailed explanation goes here
    out = zeros(size(in));
    
    persistent z
    
    if exist('z', 'var') && reset
        z= [];
    end
    
    if isempty(z), z = zeros(o,1); end
    
    switch o
        case 1  % first order NFC
            for i = 1:length(in)
                x = g * in(i);
                
                dx = d(1) * z(1);
                x = x - dx + 1e-30;
                z(1) = z(1) + x;
                
                out(i) = x;
            end
            
        case 2 % second order NFC
            for i = 1:length(in)
                
                if 0
                    % C++ from Ambdec
                    %x = g * *ip++ - _d1 * z1 - _d2 * z2 + 1e-20f;
                    %z2 += z1;
                    %z1 += x;
                    %*op++ = x;
                    x = g * in(i) - d(1)*z(1) - d(2)*z(2) + 1e-20;
                    z(2) = z(2) + z(1);
                    z(1) = z(1) + x;
                else
                    % from hoafilt
                    x = g * in(i);
                    
                    %dx = d(1)*z(1) - d(2)*z(2);  % wrongo! ajh 3/29/2014
                    dx = d(1)*z(1) + d(2)*z(2);
                    x = x - dx + 1e-30;
                    
                    z(2) = z(2) + z(1);
                    z(1) = z(1) + x;
                end
                out(i) = x;
            end
            
        case 3 % third order NFC
            for i = 1:length(in)
                x = g * in(i);
                %dx = d(1) * z(1) - d(2) * z(2); % wrong!
                dx = d(1) * z(1) + d(2) * z(2);
                x = x - dx + 1e-30;
                z(2) = z(2) + z(1);
                z(1) = z(1) + x;
                
                dx = d(3) * z(3);
                x = x - dx;
                z(3) = z(3) + x;
                
                out(i) = x;
            end
            
        case 4 % fourth order NFC
            for i = 1:length(in)
                x = g * in(i);
                dx = d(1)*z(1) + d(2)*z(2);
                x = x - dx + 1e-30;
                z(2) = z(2) + z(1);
                z(1) = z(1) + x;
                
                dx = d(3)*z(3) + d(4)*z(4);
                x = x - dx;
                z(4) = z(4) + z(3);
                z(3) = z(3) + x;
                
                out(i) = x;
            end
            
        case 5 % fifth order NFC
            for i = 1:length(in)
                x = g * in(i);
                dx = d(1)*z(1) + d(2)*z(2);
                x = x - dx + 1e-30;
                z(2) = z(2) + z(1);
                z(1) = z(1) + x;
                
                dx = d(3)*z(3) + d(4)*z(4);
                x = x - dx;
                z(4) = z(4) + z(3);
                z(3) = z(3) + x;
                
                dx = d(5)*z(5);
                x = x - dx;
                z(5) = z(5) + x;
                
                out(i) = x;
            end
            
    end
end

