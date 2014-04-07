function [ val ] = SPKR_ARRAY_CCRMA_PATIO( )
    %SPKR_ARRAY_CCRMA_PATIO() speaker configuration used for CCRMA concerts 9/27&28/2012
    % Main ring of 8 speakers (on stands):
    % azimuth: 22.5, 67.5, 112.5, 157.5, 202.5, 247.5, 292.5, 337.5
    %
    % Upper ring of 8 speakers (balconies and tall stands in the back):
    % azimuth: 0, 45, 90, 135, 180, 225, 270, 315
    % elevation: about 35 degrees
    % (azimuth is offset with respect to the lower ring)
    %
    % Top speaker:
    % elevation: 90
    %
    % Lower ring, probably 7 speakers (for a total of 24)
    % azimuth: 0, 51, 103, 154, 206, 257, 309
    % elevation: oh well, maybe -10 degrees?
    % (these speakers will be on the floor so they are a little lower
    % than the main ring but not a lot - 6/7 feet)

    %%
    R = 5.0;
    S = [ ...
        % Main ring of 8 speakers (on stands):
        % azimuth: 22.5, 67.5, 112.5, 157.5, 202.5, 247.5, 292.5, 337.5
          22.5000         0    R
          67.5000         0    R
         112.5000         0    R
         157.5000         0    R
        -157.5000         0    R
        -112.5000         0    R
         -67.5000         0    R
         -22.5000         0    R
         ...
         % Upper ring of 8 speakers (balconies and tall stands in the back):
         % azimuth: 0, 45, 90, 135, 180, 225, 270, 315
         % elevation: about 35 degrees
           0.0000        35    R
          45.0000        35    R
          90.0000        35    R
         135.0000        35    R
         180.0000        35    R
         225.0000        35    R
         270.0000        35    R
         315.0000        35    R
         ...
         % Lower ring, probably 7 speakers (for a total of 24)
         % azimuth: 0, 51, 103, 154, 206, 257, 309
         % elevation: oh well, maybe -10 degrees?
           0.0000        -10    R
          51.0000        -10    R
         103.0000        -10    R
         154.0000        -10    R
         206.0000        -10    R
         257.0000        -10    R
         309.0000        -10    R
         ...
         % Top speaker:
         % elevation: 90
           0.0000         90    R
          ... % 0.0000         -90   R
        ];
    
    %%
    val.az = S(:,1)*pi/180;
    val.el = S(:,2)*pi/180;
    [val.x, val.y, val.z] = sph2cart(val.az, val.el, 1);
    val.r = S(:,3);
    val.id = {'M1', 'M2', 'M3', 'M4', 'M5', 'M6', 'M7', 'M8', ...
        'U1', 'U2', 'U3', 'U4', 'U5', 'U6', 'U7', 'U8', ...
        'L1', 'L2', 'L3', 'L4', 'L5', 'L6', 'L7', ...
        'TT' };
    val.name = 'CCRMA_Patio';
    
end

% Main ring of 8 speakers (on stands):
% azimuth: 22.5, 67.5, 112.5, 157.5, 202.5, 247.5, 292.5, 337.5
%
% Upper ring of 8 speakers (balconies and tall stands in the back):
% azimuth: 0, 45, 90, 135, 180, 225, 270, 315
% elevation: about 35 degrees
% (azimuth is offset with respect to the lower ring)
%
% Top speaker:
% elevation: 90
%
% Lower ring, probably 7 speakers (for a total of 24)
% azimuth: 0, 51, 103, 154, 206, 257, 309
% elevation: oh well, maybe -10 degrees?
% (these speakers will be on the floor so they are a little lower
% than the main ring but not a lot - 6/7 feet)
