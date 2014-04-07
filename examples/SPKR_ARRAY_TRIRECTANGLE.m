function [ val ] = SPKR_ARRAY_TRIRECTANGLE(spkr_ele, spkr_azi)
    % TRI_RECTANGLE ARRAY Speaker positions spkr ele and az are in degrees
    %   Detailed explanation goes here
    
    if ~exist('elevation', 'var')
        spkr_ele = 45;
    end
    
    if ~exist('azimuth', 'var')
        spkr_azi = 45;
    end
        
    dz = sin(spkr_ele * pi/180);

    val.name = 'hive-tri-rectangle';
        
    % X Y Z
    S = [
                  45.0      0.0    1.730
                 -45.0      0.0    1.730
                -135.0      0.0    1.730
                 135.0      0.0    1.730
                   0.0     45.0    1.730
                   0.0    -45.0    1.730
                 180.0     45.0    1.730
                 180.0    -45.0    1.730
                  90.0     45.0    1.730
                  90.0    -45.0    1.730
                 -90.0     45.0    1.730
                 -90.0    -45.0    1.730
        ];
    val.az = S(:,1) * pi/180;
    val.el = S(:,2) * pi/180;
    
    [val.x, val.y, val.z] = sph2cart(val.az, val.el, 1);
    
    val.id = {'LF', 'RF', 'RB', 'LB',
              'FU', 'FD', 'BU', 'BD',
              'LU', 'LD', 'RU', 'RD'
              };
    end
