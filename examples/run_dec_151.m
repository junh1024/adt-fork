function [ output_args ] = run_dec_151(enc)
    % example specifying speaker locations inline
    % see also AMBI_SPKR_ARRAY, AMBI_MAT2SPKR_ARRAY, AMBI_RUN_ALLRAD
    
    %% decoder specs
    % decoder_type = 'pinv'; %'allrad'; % pinv | allrad
        
    % mixed_order_scheme = 'HV';
    
    %% speaker array definition
    
	h_order_range = 1:3; %1:2;
    v_order_range = 1:3; %1:min(h_order,2);
	
    % radius
    r = 6;    % feet
    
    h_ele = 45; % deg
    hz = r * tan( h_ele * pi/180 );
	% hz=h_ele;
	z = 0;
	
    switch enc
		case 0
			S = ambi_spkr_array(...
			... % array name
			'151DEC', ...
			... % coordindate codes, unit codes
			'ARZ', 'DMM', ...
			... % speaker name, [azimuth, radius, elevation]
			... % 'Ear Level'
			'L',  [  30, r, z ], ...
			'R',  [ -30, r, z ], ...
			'C', [0, r, z ], ...
			'BL', [ 150, r, z ], ...				
			'BR', [-150, r, z ], ...
			'SL', [ 90, r, z ], ...
			'SR', [-90, r, z ], ...
			...
			'HL',  [  30, r, hz ], ...
			'HR',  [ -30, r, hz ], ...
			'HBL', [ 150, r, hz ], ...				
			'HBR', [-150, r, hz ], ...
			'HSL', [ 90, r,  hz ], ...
			'HSR', [-90, r,  hz ], ...
			...
			'BTL',  [  30, r, -hz ], ...
			'BTR',  [ -30, r, -hz ] ...

			...
			);
		
        case 1
			S = ambi_spkr_array(...
			... % array name
			'151ENC', ...
			... % coordindate codes, unit codes
			'ARZ', 'DMM', ...
			... % speaker name, [azimuth, radius, elevation]
			... % 'Ear Level'
			'L',  [  30, r, z ], ...
			'R',  [ -30, r, z ], ...
			'BL', [ 150, r, z ], ...				
			'BR', [-150, r, z ], ...
			'SL', [ 90, r, z ], ...
			'SR', [-90, r, z ], ...
			...
			'HL',  [  30, r, hz ], ...
			'HR',  [ -30, r, hz ], ...
			'HBL', [ 150, r, hz ], ...				
			'HBR', [-150, r, hz ], ...
			'HSL', [ 90, r,  hz ], ...
			'HSR', [-90, r,  hz ], ...
			...
			'BTL',  [  30, r, -hz ], ...
			'BTR',  [ -30, r, -hz ], ...
			'BTBL', [ 150, r, -hz ], ...				
			'BTBR', [-150, r, -hz ], ...
			'BTSL', [ 90, r,  -hz ], ...
			'BTSR', [-90, r,  -hz ]...
			...
			);
		end


	for h_order = h_order_range
        for v_order = v_order_range
			ambi_run_allrad(S, [h_order,v_order], [0,0,-1]);
			ambi_run_pinv(S, [h_order,v_order], []);
		end
	end
    
end

