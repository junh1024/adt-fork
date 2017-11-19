function [ output_args ] = run_dec_itu( n_spkrs, radius, alt)
    %UNTITLED Summary of this function goes here
    % * Channel order has been made SMPTE-like
	% * Channel names have been tweaked
    % * 7.0 layout has been completed
    % * alt layouts added
	% -junh1024
    
	% decoder_type = 'pinv'; %'allrad'; % pinv | allrad
    
    h_order_range = 1:3; %1:2;
    v_order_range = 1:3; %1:min(h_order,2);
	
    %% fill in default arguments
    if ~exist('radius', 'var') || isempty(radius)
        radius = 2;  % in meters!!
		% disp("no rad");
    end
    
    if ~exist('n_spkrs', 'var') || isempty(n_spkrs)
        n_spkrs = 5;
    end
    
	array_name=strcat('itu',int2str(n_spkrs),'0');
	
	if exist('alt', 'var') 
		alt=1;
		array_name=strcat(array_name,'alt');
	else
		alt=0;
	end
    
    % distance to center speaker, assuming it is in the
    %  plane as the left and right.
    
    [fl_x, fl_y, fl_z] = sph2cart(-30*pi/180, 0, radius);
    
    switch n_spkrs
        case 5
            S = ambi_spkr_array(...
                ... % array name
                array_name, ...
                ... % coordinate codes, unit codes
                ... % Azimuth, Elevation, Radius; Degrees, Degrees, Meters
                'AER', 'DDM', ...
                ... % speaker name, [azimuth, elevation, radius]
                'FL', [  30+alt*5, 0, radius], ...
                'FR', [ -30-alt*5, 0, radius], ...
                'FC', [   0, 0, fl_x], ...
                'BL', [ 110+alt*15, 0, radius], ...
                'BR', [-110-alt*15, 0, radius] ...
                );
        case 7
		%ITU PDF is unclear/conflicting in this area so resorting to dolby. BL & BR can be placed 135-150* so a conservative 140 is used.
            S = ambi_spkr_array(...
                ... % array name
                array_name, ...
                ... % coordinate codes, unit codes
                ... % Azimuth, Elevation, Radius; Degrees, Degrees, Meters
                'AER', 'DDM', ...
                ... % speaker name, [azimuth, elevation, radius]
                'FL', [  30, 0, radius], ...
                'FR', [ -30, 0, radius], ...
                'FC', [   0, 0, fl_x], ...
				'BL', [ 100-alt*10, 0, radius], ...
                'BR', [-100+alt*10, 0, radius], ...
				'SL', [ 140+alt*10, 0, radius], ...
                'SR', [-140-alt*10, 0, radius] ...
                );
    end
	
	% TODO: (from ITU-R BS.2159-6 2013)
		%10.2A L C R BS LS RS LW RW 60*, LH RH 45*,45*H
		%10.2B For Korea UHDTV L C R CHS 135*H LS RS 90 BL BR 135 LH RH 45*,45*H 
		%22.2 top & bottom layers are 45* & 30*, from a guess
	for h_order = h_order_range
        for v_order = v_order_range
			ambi_run_allrad(S, [h_order,v_order], [0,0,1; 0,0,-1]);
			ambi_run_pinv(S, [h_order,v_order], []);
		end
	end
end
