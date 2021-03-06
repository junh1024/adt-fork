function [ S ] = SPKR_ARRAY_BatkeKeiler16( radius )
    %SPKR_ARRAY_BatkeKeiler16 
    %   This is the array used in:
    % J.-M. Batke and F. Keiler, ?Investigation of Robust Panning Functions 
    %  for 3D Loudspeaker Setups,? presented at the AES 128th Convention, 
    %  London, 2010.
    
    % More detailed, eight of the loudspeakers are equally distributed on 
    % a circle around the listener?s head, enclosing angles of 45 degrees.
    % Additional four speakers are located at the top and the bottom, 
    % enclosing azimuth angles of 90 degrees. In this arrangement, the 
    % radius of the circle in the middle is 1.4 m. The top loudspeakers are
    % approximately 80 cm above the middle, and the bot- tom loudspeakers 
    % about 1 m below. With regard to Ambisonics this setup is irregular 
    % and leads to problems in decoder design [8].
    
    
    if ~exist('radius', 'var'), radius = 1.4; end  % 1.4 meters
   
    Z_top = 0.80;
    Z_mid = 0;
    Z_bot = -1.00;
    az = 0:45:(360-1);
    
    S = ambi_spkr_array(...
        'BK16', ...
        'AZR', 'DMM', ...
        ... % middle ring
        'M1', [az(1), Z_mid, radius], ...
        'M2', [az(2), Z_mid, radius], ...
        'M3', [az(3), Z_mid, radius], ...
        'M4', [az(4), Z_mid, radius], ...
        'M5', [az(5), Z_mid, radius], ...
        'M6', [az(6), Z_mid, radius], ...
        'M7', [az(7), Z_mid, radius], ...
        'M8', [az(8), Z_mid, radius], ...
        ... % 
        ... %'T1', [az(1), Z_top, radius], ...
        'T2', [az(2), Z_top, radius], ...
        ... %'T3', [az(3), Z_top, radius], ...
        'T4', [az(4), Z_top, radius], ...
        ... %'T5', [az(5), Z_top, radius], ...
        'T6', [az(6), Z_top, radius], ...
        ... %'T7', [az(7), Z_top, radius], ...
        'T8', [az(8), Z_top, radius], ...
        ... %
        ... % 'B1', [az(1), Z_bot, radius], ...
        'B2', [az(2), Z_bot, radius], ...
        ... %'B3', [az(3), Z_bot, radius], ...
        'B4', [az(4), Z_bot, radius], ...
        ... %'B5', [az(5), Z_bot, radius], ...
        'B6', [az(6), Z_bot, radius], ...
        ... %'B7', [az(7), Z_bot, radius], ...
        'B8', [az(8), Z_bot, radius] ...
        );
       
end

