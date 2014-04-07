function [ val ] = SPKR_ARRAY_DODECAHEDRON2()
    %ARRAY_DODECAHEDRON2 Furse-Malham Dodecahedron2
    %
    % see http://www.muse.demon.co.uk/ref/speakers.html
    % Dodecahedron2
    % Rig Overview
    %                       First Order	  Second Order
    % Recreated Harmonics:	W, X, Y, Z	  W, X, Y, Z, R, S, T, U, V
    % Absent Harmonics:	-	-
    % Discarded Ambiguous Harmonics:	-	-
    % Discarded Coarse Harmonics:	-	-
    % Symmetry Distortion Rating:	0.0000	0.0000

    val.name = 'Furse-Malham Dodecahedron2';
    
    % X, Y, Z
    S = [
         1.0000         0         0;
        -1.0000         0         0;
         0.4472         0   -0.8944;
        -0.4472         0    0.8944;
         0.4472    0.8507   -0.2764;
        -0.4472   -0.8507    0.2764;
         0.4472   -0.8507   -0.2764;
        -0.4472    0.8507    0.2764;
         0.4472    0.5257    0.7236;
        -0.4472   -0.5257   -0.7236;
         0.4472   -0.5257    0.7236;
        -0.4472    0.5257   -0.7236;
        ];

    [val.az val.el val.r] = cart2sph(S(:,1),S(:,2),S(:,3));

    [val.x val.y val.z] = sph2cart(val.az, val.el, 1);

    val.id = {'top', 'bot', ...
              '3', '4', '5', '6', ...
              '7', '8', '9', '10', ...
              '11', '12'};
    
end