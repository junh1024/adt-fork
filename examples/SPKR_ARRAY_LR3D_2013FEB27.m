function [ val ] = SPKR_ARRAY_LR3D_2013FEB27( )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here

    % add_spkr    H1     3.120     22.5      0.0
    % add_spkr    H2     3.120     67.5      0.0
    % add_spkr    H3     3.120    112.5      0.0
    % add_spkr    H4     3.120    157.5      0.0
    % add_spkr    H5     3.120   -157.5      0.0
    % add_spkr    H6     3.120   -112.5      0.0
    % add_spkr    H7     3.120    -67.5      0.0
    % add_spkr    H8     3.120    -22.5      0.0
    % add_spkr    T1     2.120     30.0     40.0
    % add_spkr    T2     2.230     90.0     40.0
    % add_spkr    T3     2.110    150.0     40.0
    % add_spkr    T4     2.110   -150.0     40.0
    % add_spkr    T5     2.230    -90.0     40.0
    % add_spkr    T6     2.120    -30.0     40.0
    % add_spkr    B1     2.330     30.0    -50.0
    % add_spkr    B2     2.280     90.0    -50.0
    % add_spkr    B3     2.220    150.0    -50.0
    % add_spkr    B4     2.220   -150.0    -50.0
    % add_spkr    B5     2.280    -90.0    -50.0
    % add_spkr    B6     2.330    -30.0    -50.0
    % add_spkr    TT     1.440      0.0     90.0
    % add_spkr    BB     1.900      0.0    -90.0

    R = 5.0;
    S = [ ...
        % == Floor:
         22.5 0  R
         67.5 0 R
         112.5 0 R
         157.5 0 R
        -157.5 0 R
        -112.5 0 R
        -67.5 0 R
        -22.5 0  R
        ...
        % == Ceiling
         30  40    R
         90  40    R
        150  40    R
       -150  40    R
        -90  40    R
        -30  40    R

	% == Pit
         30  -50    R
         90  -50    R
        150  -50    R
       -150  -50    R
        -90  -50    R
        -30  -50    R

	% == Zenith/Nadir
	0 90 R
	0 -90 R
        ];

    val.az = S(:,1)*pi/180;
    val.el = S(:,2)*pi/180;
    [val.x, val.y, val.z] = sph2cart(val.az, val.el, 1);
    val.r = S(:,3);
    val.id = {
        'H1', 'H2', 'H4', 'H6', 'H8', 'H7', 'H5', 'H3', ...
        'T1', 'T2', 'T4', 'T6', 'T5', 'T3', ...
        'B1', 'B2', 'B4', 'B6', 'B5', 'B3', ...
        'TT', 'BB', ...
        };
    val.name = 'LR3D_2013FEB27';

end
