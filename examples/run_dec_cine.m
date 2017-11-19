function [ output_args ] = run_dec_cine(n_spkrs)
    % example specifying speaker locations inline
    % see also AMBI_SPKR_ARRAY, AMBI_MAT2SPKR_ARRAY, AMBI_RUN_ALLRAD
    
    %% decoder specs
    % decoder_type = 'pinv'; %'allrad'; % pinv | allrad
        
    % mixed_order_scheme = 'HV';
    
    %% speaker array definition
	
    % array_name=strcat('71',int2str(num_top));
	
	h_order_range = 1:3; %1:2;
    v_order_range = 1:3; %1:min(h_order,2);
	
    % radius
    r = 6;    % feet
    
    h_ele = 45; % deg
    hz = r * tan( h_ele * pi/180 );
	% hz=h_ele;
	z = 0;
	
    switch n_spkrs
	        case 4
			S = ambi_spkr_array(...
			... % array name
			strcat('cine',int2str(n_spkrs)       ), ...
			... % coordindate codes, unit codes
			'ARZ', 'DMM', ...
			... % speaker name, [azimuth, radius, elevation]
			... % 'Ear Level'
			'L',  [  45, r, z ], ...
			'R',  [ -45, r, z ], ...
		...
			'BL', [ 145, r, z ], ...				
			'BR', [-145, r, z ] ...
			...
			);
        case 5
			S = ambi_spkr_array(...
			... % array name
			strcat('cine',int2str(n_spkrs)       ), ...
			... % coordindate codes, unit codes
			'ARZ', 'DMM', ...
			... % speaker name, [azimuth, radius, elevation]
			... % 'Ear Level'
			'L',  [  45, r, z ], ...
			'R',  [ -45, r, z ], ...
			'C', [0, r, z ], ...
			'BL', [ 145, r, z ], ...				
			'BR', [-145, r, z ] ...
			...
			);
		        case 6
			S = ambi_spkr_array(...
			... % array name
			strcat('cine',int2str(n_spkrs)       ), ...
			... % coordindate codes, unit codes
			'ARZ', 'DMM', ...
			... % speaker name, [azimuth, radius, elevation]
			... % 'Ear Level'
			'L',  [  45, r, z ], ...
			'R',  [ -45, r, z ], ...
			'C', [0, r, z ], ...
			'BL', [ 145, r, z ], ...				
			'BR', [-145, r, z ], ...
			'CS', [180, r, z ] ...
			...
			);
        case 7
			S = ambi_spkr_array(...
			... % array name
			strcat('cine',int2str(n_spkrs)       ), ...
			... % coordindate codes, unit codes
			'ARZ', 'DMM', ...
			... % speaker name, [azimuth, radius, elevation]
			... % 'Ear Level'
			'L',  [  45, r, z ], ...
			'R',  [ -45, r, z ], ...
			'C', [0, r, z ], ...
			'BL', [ 145, r, z ], ...				
			'BR', [-145, r, z ], ...
			'SL', [ 90, r, z ], ...
			'SR', [-90, r, z ] ...
			...
			);
		
		case 8
			S = ambi_spkr_array(...
			... % array name
			strcat('cine',int2str(n_spkrs)       ), ...
			... % coordindate codes, unit codes
			'ARZ', 'DMM', ...
			... % speaker name, [azimuth, radius, elevation]
			... % 'Ear Level'
			'L',  [  45, r, z ], ...
			'R',  [ -45, r, z ], ...
			'C', [0, r, z ], ...
			'BL', [ 145, r, z ], ...				
			'BR', [-145, r, z ], ...
			'SL', [ 90, r, z ], ...
			'SR', [-90, r, z ], ...
			'CS', [180, r, z ] ...
...
			);
			
			        case 9
			S = ambi_spkr_array(...
			... % array name
			strcat('cine',int2str(n_spkrs)       ), ...
			... % coordindate codes, unit codes
			'ARZ', 'DMM', ...
			... % speaker name, [azimuth, radius, elevation]
			... % 'Ear Level'
			'L',  [  45, r, z ], ...
			'R',  [ -45, r, z ], ...
			'C', [0, r, z ], ...
			'BL', [ 145, r, z ], ...				
			'BR', [-145, r, z ], ...
						...
				'HL',  [  45, r, hz ], ...
			'HR',  [ -45, r, hz ], ...
			'HBL', [ 135, r, hz ], ...				
			'HBR', [-135, r, hz ] ...
...
			);
			
						        case 10
			S = ambi_spkr_array(...
			... % array name
			strcat('cine',int2str(n_spkrs)       ), ...
			... % coordindate codes, unit codes
			'ARZ', 'DMM', ...
			... % speaker name, [azimuth, radius, elevation]
			... % 'Ear Level'
			'L',  [  45, r, z ], ...
			'R',  [ -45, r, z ], ...
			'C', [0, r, z ], ...
			'BL', [ 145, r, z ], ...				
			'BR', [-145, r, z ], ...
			'CS', [180, r, z ], ...
			...
			'HL',  [  45, r, hz ], ...
			'HR',  [ -45, r, hz ], ...
			'HBL', [ 135, r, hz ], ...				
			'HBR', [-135, r, hz ] ...
...
			);
			case 11
			S = ambi_spkr_array(...
			... % array name
			strcat('cine',int2str(n_spkrs)       ), ...
			... % coordindate codes, unit codes
			'ARZ', 'DMM', ...
			... % speaker name, [azimuth, radius, elevation]
			... % 'Ear Level'
			'L',  [  45, r, z ], ...
			'R',  [ -45, r, z ], ...
			'C', [0, r, z ], ...
			'BL', [ 145, r, z ], ...				
			'BR', [-145, r, z ], ...
			...
			'HL',  [  45, r, hz ], ...
			'HR',  [ -45, r, hz ], ...
			'HBL', [ 135, r, hz ], ...				
			'HBR', [-135, r, hz ], ...
			...
			'BTL',  [  45, r, -hz ], ...
			'BTR',  [ -45, r, -hz ] ...
...
			);

			
			case 12
			S = ambi_spkr_array(...
			... % array name
			strcat('cine',int2str(n_spkrs)       ), ...
			... % coordindate codes, unit codes
			'ARZ', 'DMM', ...
			... % speaker name, [azimuth, radius, elevation]
			... % 'Ear Level'
			'L',  [  45, r, z ], ...
			'R',  [ -45, r, z ], ...
			'C', [0, r, z ], ...
			'BL', [ 145, r, z ], ...				
			'BR', [-145, r, z ], ...
			'SL', [ 90, r, z ], ...
			'SR', [-90, r, z ], ...
			...
			'HL',  [  45, r, hz ], ...
			'HR',  [ -45, r, hz ], ...
			'HBL', [ 135, r, hz ], ...				
			'HBR', [-135, r, hz ] ...
...
			);

						
			case 13
			S = ambi_spkr_array(...
			... % array name
			strcat('cine',int2str(n_spkrs)       ), ...
			... % coordindate codes, unit codes
			'ARZ', 'DMM', ...
			... % speaker name, [azimuth, radius, elevation]
			... % 'Ear Level'
			'L',  [  45, r, z ], ...
			'R',  [ -45, r, z ], ...
			'C', [0, r, z ], ...
			'BL', [ 145, r, z ], ...				
			'BR', [-145, r, z ], ...
			'SL', [ 90, r, z ], ...
			'SR', [-90, r, z ], ...
...
			'HL',  [  45, r, hz ], ...
			'HR',  [ -45, r, hz ], ...
			'HBL', [ 135, r, hz ], ...				
			'HBR', [-135, r, hz ], ...
			...
			'BTL',  [  45, r, -hz ], ...
			'BTR',  [ -45, r, -hz ] ...
...
			);

						case 15
			S = ambi_spkr_array(...
			... % array name
			strcat('cine',int2str(n_spkrs)       ), ...
			... % coordindate codes, unit codes
			'ARZ', 'DMM', ...
			... % speaker name, [azimuth, radius, elevation]
			... % 'Ear Level'
			'L',  [  45, r, z ], ...
			'R',  [ -45, r, z ], ...
			'C', [0, r, z ], ...
			'BL', [ 145, r, z ], ...				
			'BR', [-145, r, z ], ...
			'SL', [ 90, r, z ], ...
			'SR', [-90, r, z ], ...
			...
			'HL',  [  45, r, hz ], ...
			'HR',  [ -45, r, hz ], ...
			'HBL', [ 135, r, hz ], ...				
			'HBR', [-135, r, hz ], ...
			'HSL', [ 90, r,  hz ], ...
			'HSR', [-90, r,  hz ], ...
			...
			'BTL',  [  45, r, -hz ], ...
			'BTR',  [ -45, r, -hz ] ...
...
			);
			
			
									case 18
			S = ambi_spkr_array(...
			... % array name
			strcat('cine',int2str(n_spkrs)       ), ...
			... % coordindate codes, unit codes
			'ARZ', 'DMM', ...
			... % speaker name, [azimuth, radius, elevation]
			... % 'Ear Level'
			'L',  [  45, r, z ], ...
			'R',  [ -45, r, z ], ...
			'BL', [ 145, r, z ], ...				
			'BR', [-145, r, z ], ...
			'SL', [ 90, r, z ], ...
			'SR', [-90, r, z ], ...
			...
			'HL',  [  45, r, hz ], ...
			'HR',  [ -45, r, hz ], ...
			'HBL', [ 135, r, hz ], ...				
			'HBR', [-135, r, hz ], ...
			'HSL', [ 90, r,  hz ], ...
			'HSR', [-90, r,  hz ], ...
			...
			'BTL',  [  45, r, -hz ], ...
			'BTR',  [ -45, r, -hz ], ...
			'BTBL', [ 150, r, -hz ], ...				
			'BTBR', [-150, r, -hz ], ...
			'BTSL', [ 90, r,  -hz ], ...
			'BTSR', [-90, r,  -hz ] ...
...
			);
			
												case 20

			S = ambi_spkr_array(...
			... % array name
			strcat('cine',int2str(n_spkrs)       ), ...
			... % coordindate codes, unit codes
			'ARZ', 'DMM', ...
			... % speaker name, [azimuth, radius, elevation]
			... % 'Ear Level'
			'L',  [  45, r, z ], ...
			'R',  [ -45, r, z ], ...
						'C', [0, r, z ], ...
			'BL', [ 145, r, z ], ...				
			'BR', [-145, r, z ], ...
			'SL', [ 90, r, z ], ...
			'SR', [-90, r, z ], ...
			...
			'CS', [180, r, z ], ...
			...
			'HL',  [  45, r, hz ], ...
			'HR',  [ -45, r, hz ], ...
			'HBL', [ 135, r, hz ], ...				
			'HBR', [-135, r, hz ], ...
			'HSL', [ 90, r,  hz ], ...
			'HSR', [-90, r,  hz ], ...
			...
			'BTL',  [  45, r, -hz ], ...
			'BTR',  [ -45, r, -hz ], ...
			'BTBL', [ 150, r, -hz ], ...				
			'BTBR', [-150, r, -hz ], ...
			'BTSL', [ 90, r,  -hz ], ...
			'BTSR', [-90, r,  -hz ] ...
...
			);


        case 24
			S = ambi_spkr_array(...
			... % array name
			strcat('cine',int2str(n_spkrs)       ), ...
			... % coordindate codes, unit codes
			'ARZ', 'DMM', ...
			... % speaker name, [azimuth, radius, elevation]
			... % 'Ear Level'
			'L',  [  45, r, z ], ...
			'R',  [ -45, r, z ], ...
			'C', [0, r, z ], ...
			'BL', [ 145, r, z ], ...				
			'BR', [-145, r, z ], ...
			'SL', [ 90, r, z ], ...
			'SR', [-90, r, z ], ...
			...
			'CS', [180, r, z ], ...
			...
			...
			'HL',  [  45, r, hz ], ...
			'HR',  [ -45, r, hz ], ...
			'HBL', [ 135, r, hz ], ...				
			'HBR', [-135, r, hz ], ...
			'HSL', [ 90, r,  hz ], ...
			'HSR', [-90, r,  hz ], ...
			...
			'HCF', [ 0, r,  hz ], ...
			'HCS', [180, r, hz ], ...
...
			...
			'BTL',  [  45, r, -hz ], ...
			'BTR',  [ -45, r, -hz ], ...
			'BTBL', [ 150, r, -hz ], ...				
			'BTBR', [-150, r, -hz ], ...
			'BTSL', [ 90, r,  -hz ], ...
			'BTSR', [-90, r,  -hz ], ...
			...
			...
			'BTCF', [ 0, r,  -hz ], ...
			'BTCS', [180, r, -hz ] ...
			...
			);
			end

		if (n_spkrs < 9)
			invisible_speakers_allrad=[0,0,1; 0,0,-1];
		elseif (n_spkrs < 15)
			invisible_speakers_allrad=[0,0,-1];
		else
			invisible_speakers_allrad=[];
		end
		
		
		for h_order = h_order_range
			for v_order = v_order_range
				ambi_run_allrad(S, [h_order,v_order], invisible_speakers_allrad);
				ambi_run_pinv(S, [h_order,v_order], []);
			end
		end
    
end

