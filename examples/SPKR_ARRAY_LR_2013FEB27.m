function [ val ] = SPKR_ARRAY_LR_2013FEB27( )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here

    R = 5.0;
    S = [ ...
        % == Floor:
         22.5 0  R
        -22.5 0  R
         67.5 0 R
        -67.5 0 R
         112.5 0 R
        -112.5 0 R
         157.5 0 R
        -157.5 0 R
        ...
        % == Ceiling
         30  40    R
        -30  40    R
         90  40    R
        -90  40    R
        150  40    R
       -150  40    R
	
	0 90 R
        ];

    val.az = S(:,1)*pi/180;
    val.el = S(:,2)*pi/180;
    [val.x, val.y, val.z] = sph2cart(val.az, val.el, 1);
    val.r = S(:,3);
    val.id = {
        'L01', 'L02', 'L03', 'L04', 'L05', 'L06', 'L07', 'L08', ...
        'M09', 'M10', 'M11', 'M12', 'M13', 'M14', ...
        'H15', ...
        };
    val.name = 'LR_2013FEB27';

end
