function [ a ] = EigenMikeGrid( )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    % References:
    % [1] Appendix of "em32 Eigenmike® microphone array release notes
    % (v17.0)", October 30, 2013, available from
    %  http://www.mhacoustics.com/sites/default/files/ReleaseNotes.pdf
    radius = 4.2; % cm
    
    % theta and phi in degrees
    % zenith angle and azimuth (determined from photos in release notes)
    zen_azi = pi/180 * ...
    [ 69 0
        90 32
        111 0
        90 328
        32 0
        55 45
        90 69
        125 45
        148 0
        125 315
        90 291
        55 315
        21 91
        58 90
        121 90
        159 89
        69 180
        90 212
        111 180
        90 148
        32 180
        55 225
        90 249
        125 225
        148 180
        125 135
        90 111
        55 135
        21 269
        58 270
        122 270
        159 271];
    
    [a.x, a.y, a.z] = sph2cart(zen_azi(:,2), pi/2-zen_azi(:,1), 1);
    [a.theta, a.phi] = cart2sph(a.x, a.y, a.z);
    a.radius = radius/100 * ones(size(a.theta));
    
    
end


