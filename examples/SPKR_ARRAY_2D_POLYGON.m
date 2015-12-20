function [ S ] = SPKR_ARRAY_2D_POLYGON( N, radius, ...
        start_angle, ...
        array_name, ...
        speaker_ids)
    %SPKR_ARRAY_2D_POLYGON horizontal polygon array
    %   Detailed explanation goes here
    
    %% defaults
    
    % radius in meters
    if ~exist('radius', 'var') || isempty(radius)
        radius = 1;
    end
    
    % start angle in degrees
    %  if auto, make it 1/2 spacing
    if ~exist('start_angle', 'var') || isempty(start_angle)
        start_angle = 0;
    end
    
    % array name
    if ~exist('array_name', 'var') || isempty(array_name)
        S.name = sprintf('sa_%d_gon_%d', N, start_angle);
    else
        S.name = array_name;
    end
    
    % speaker ids
    if ~exist('speaker_ids', 'var') || isempty(speaker_ids)
        S.id = arrayfun(@(n) num2str(n,'S%02d'), 1:N,...
            'UniformOutput', false);
    else
        S.id = speaker_ids;
    end
    
    %%
    thetas = linspace(0,360,N+1);
    if ischar(start_angle) && strcmpi(start_angle, 'auto')
        thetas = thetas + 180/N;
    else
        thetas = thetas + start_angle;
    end
    thetas = thetas(1:end-1);
    
    S.az = thetas(:)*pi/180;
    S.el = zeros(size(S.az));
    % to unit vectors
    [S.x, S.y, S.z] = sph2cart(S.az, S.el, 1);
    % and back to spherical with az in range -pi to +pi
    [S.az, S.el, S.r] = cart2sph(radius*S.x, radius*S.y, radius*S.z);

end

