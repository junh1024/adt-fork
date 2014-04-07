function [ val ] = SPKR_ARRAY_BING_REVA( )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    R = 5.0;
    S = [ ...
        % lower ring (12)
        -15	0 R
        15	0 R
        -45	0 R
        45	0 R
        -75	0 R
        75	0 R
        -105	0 R
        105	0 R
        -135	0 R
        135	0 R
        -165	0 R
        165	0 R
        ...
        % medium ring (8)
        -22.5	45 R
        22.5	45 R
        -67.5	45 R
        67.5	45 R
        -112.5	45 R
        112.5	45 R
        -157.5	45 R
        157.5	45 R
        ...
        % upper ring (4)
        -45	70 R
        45	70 R
        -135	70 R
        135	70 R
        ];
    
    val.az = S(:,1)*pi/180;
    val.el = S(:,2)*pi/180;
    [val.x, val.y, val.z] = sph2cart(val.az, val.el, 1);
    val.r = S(:,3);
    val.id = {
        'L1', 'L2', 'L3', 'L4', 'L5', 'L6', 'L7', 'L8', 'L9', 'LA', 'LB', 'LC',...
        'M1', 'M2', 'M3', 'M4', 'M5', 'M6', 'M7', 'M8', ...
        'T1', 'T2', 'T3', 'T4',  ...
        };
    val.name = 'BING_REVA';
    
end

