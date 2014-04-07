function [ val ] = SPKR_ARRAY_DODECAHEDRON1()
    %ARRAY_DODECAHEDRON1 Furse-Malham Dodecahedron1
    %
    % see http://www.muse.demon.co.uk/ref/speakers.html
    % Dodecahedron1
    % Rig Overview
    %                       First Order   Second Order
    % Recreated Harmonics:	W, X, Y, Z    W, X, Y, Z, R, S, T, U, V
    % Absent Harmonics:	-	-
    % Discarded Ambiguous Harmonics:	-	-
    % Discarded Coarse Harmonics:	-	-
    % Symmetry Distortion Rating:	0.0000	0.0000

    val.name = 'Furse-Malham Dodecahedron1';
    
    % X Y Z 
    S = [
         0.0000   0.0000   1.0000
         0.0000   0.0000  -1.0000
         0.7236   0.5257   0.4472
        -0.7236  -0.5257  -0.4472
         0.7236  -0.5257   0.4472
        -0.7236   0.5257  -0.4472
        -0.2764   0.8507   0.4472
         0.2764  -0.8507  -0.4472
        -0.2764  -0.8507   0.4472
         0.2764   0.8507  -0.4472
        -0.8944   0.0000   0.4472
         0.8944   0.0000  -0.4472
        ];

    [val.az val.el val.r] = cart2sph(S(:,1),S(:,2),S(:,3));

    [val.x val.y val.z] = sph2cart(val.az, val.el, 1);

    val.id = {'top', 'bot', ...
              '3', '4', '5', '6', ...
              '7', '8', '9', '10', ...
              '11', '12'};

end