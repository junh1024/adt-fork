function [ output_args ] = run_dec_itu( n_spkrs, radius)
    %UNTITLED Summary of this function goes here
    % * Channel order has been made SMPTE-like
	% * Channel names have been tweaked
    % * 7.0 layout has been completed
	% -junh1024
    
    %% fill in default arguments
    if ~exist('radius', 'var') || isempty(radius)
        radius = 2;  % in meters!!
    end
    
    if ~exist('n_spkrs', 'var') || isempty(n_spkrs)
        n_spkrs = 5;
    end
    
    
    % distance to center speaker, assuming it is in the
    %  plane as the left and right.
    
    [fl_x, fl_y, fl_z] = sph2cart(-30*pi/180, 0, radius);
    
    switch n_spkrs
        case 5
            S = ambi_spkr_array(...
                ... % array name
                'itu50', ...
                ... % coordinate codes, unit codes
                ... % Azimuth, Elevation, Radius; Degrees, Degrees, Meters
                'AER', 'DDM', ...
                ... % speaker name, [azimuth, elevation, radius]
                'FL', [  30, 0, radius], ...
                'FR', [ -30, 0, radius], ...
                'FC', [   0, 0, fl_x], ...
                'BL', [ 110, 0, radius], ...
                'BR', [-110, 0, radius] ...
                );
        case 7
		%ITU PDF is unclear/conflicting in this area so resorting to dolby. BL & BR can be placed 135-150* so a conservative 140 is used.
            S = ambi_spkr_array(...
                ... % array name
                'itu50', ...
                ... % coordinate codes, unit codes
                ... % Azimuth, Elevation, Radius; Degrees, Degrees, Meters
                'AER', 'DDM', ...
                ... % speaker name, [azimuth, elevation, radius]
                'FL', [  30, 0, radius], ...
                'FR', [ -30, 0, radius], ...
                'FC', [   0, 0, fl_x], ...
				'BL', [ 100, 0, radius], ...
                'BR', [-100, 0, radius] ...
				'SL', [ 140, 0, radius], ...
                'SR', [ -140, 0, radius] ...
                );
    end
	
	% TODO: (from ITU-R BS.2159-6 2013)
		%10.2A L C R BS LS RS LW RW 60*, LH RH 45*,45*H
		%10.2B For Korea UHDTV L C R CHS 135*H LS RS 90 BL BR 135 LH RH 45*,45*H 
		%22.2 top & bottom layers are 45* & 30*, from a guess
		
    ambi_run_allrad(S, [2,0], [0,0,1; 0,0,-1]);
end
