function [ val ] = SPKR_ARRAY_CUBE()
    %ARRAY_CUBE
    %   Detailed explanation goes here
    
    val.name = 'cube';
        
    % X Y Z
    S = [
         1  1  1;
         1 -1  1;
        -1 -1  1;
        -1  1  1;
         1  1 -1;
         1 -1 -1;
        -1 -1 -1;
        -1  1 -1;
        ];
    
    [val.az val.el val.r] = cart2sph(S(:,1),S(:,2),S(:,3));
    
    [val.x val.y val.z] = sph2cart(val.az, val.el, 1);
    
    val.id = {'FLU', 'FRU', 'BRU', 'BLU', ...
              'FLD', 'FRD', 'BRD', 'BLD',};
    
end