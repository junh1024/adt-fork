switch 2
    
    case 1
        Spkr = SPKR_ARRAY_CCRMA_LISTENING_ROOM('dome');
        
    case 2
        Spkr = ambi_mat2spkr_array(...
            ... % adjust args according to data read from import file
            ... %   see adt_mat2spkr_array for coord and unit codes
            ... %ID	r (m)	a (deg) e (deg) // Speaker Name
            ... %-----------------------------------------------
            [ ...
            4.4500	 -22.50   18.89 ;... % // L1U
            4.4500	  22.50   18.89 ;... % // R1U
            3.2500	 -67.50   25.12 ;... % // L2U
            3.2500	  67.50   25.12 ;... % // R2U
            3.2500	-112.50   25.12 ;... % // L3U
            3.2500	 112.50   25.12 ;... % // R3U
            4.4500	-157.50   18.89 ;... % // L4U
            4.4500	 157.50   18.89 ;... % // R4U
            4.1900	 -22.50   00.00 ;... % // L1M
            4.1900	  22.50   00.00 ;... % // R1M
            2.8700	 -67.50   00.00 ;... % // L2M
            2.8700	  67.50   00.00 ;... % // R2M
            2.8700	-112.50   00.00 ;... % // L3M
            2.8700	 112.50   00.00 ;... % // L3M
            4.1900	-157.50   00.00 ;... % // L4M
            4.1900	 157.50   00.00 ;... % // R4M
            4.4500	 -22.50  -18.89 ;... % // L1D
            4.4500	  22.50  -18.89 ;... % // R1D
            3.2500	 -67.50  -25.12 ;... % // L2D
            3.2500	  67.50  -25.12 ;... % // R2D
            3.2500	-112.50  -25.12 ;... % // L3D
            3.2500	 112.50  -25.12 ;... % // R3D
            4.4500	-157.50  -18.89 ;... % // L4D
            4.4500	 157.50  -18.89 ;... % // R4D
            2.2593   -45.00   60.00 ;... % // L1T
            2.2593	  45.00   60.00 ;... % // R1T
            2.2593	-135.00   60.00 ;... % // L2T
            2.2593	 135.00   60.00 ;... % // R2T
            ], ...
            'RAE',...            % locations
            'MDD', ...           % in meters
            'DOGP', ...          % name of array
            {'L1U','R1U','L2U','R2U','L3U','R3U','L4U','R4U',...
            'L1M','R1M','L2M','R2M','L3M','R3M','L4M','R4M',...
            'L1D','R1D','L2D','R2D','L3D','R3D','L4D','R4D',...
            'L1T','R1T','L2T','R2T'} ...
            );
        
        
        ambi_order = 3;
        alpha_min = 1/2;
        elevation.min = -35;
        elevation.max =  85 ;
        plot_ele.min = -35;
        plot_ele.max =  85;
end



fprintf('PHI   = [');
fprintf('%f, ', 180/pi * Spkr.az(1:end-1)');
fprintf('%f];\n', 180/pi * Spkr.az(end)');

fprintf('THETA = [');
fprintf('%f, ', 180/pi * Spkr.el(1:end-1)');
fprintf('%f];\n', 180/pi * Spkr.el(end)');

