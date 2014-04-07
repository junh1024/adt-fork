function run_dec_pubw
    % allrad example specifying speaker locations inline
    % specifics are for Paul Powers' octagon-cube configuration
    %
    % see also ADT_MAT2SPKR_ARRAY, ADT_RUN_ALLRAD_AMBDEC
    
    %%
    decoder_type = 'pinv'; % pinv | allrad
    h_order = 3;
    v_order = 0;

	mixed_order_scheme = 'HP';
    
    %R = 7.885; % array radius, feet
    
    S = ambi_spkr_array(...
        'PUBW', ...
        'AER', 'DDM', ...
        'L1', [ 22.5, 0, 3.5052], ...
        'R1', [337.5, 0, 3.5052], ...
        'L2', [ 67.5, 0, 2.5382], ...
        'R2', [292.5, 0, 2.5832], ...
        'L3', [112.5, 0, 2.5832], ...
        'R3', [247.5, 0, 2.5832], ...
        'L4', [157.5, 0, 3.5052], ...
        'R4', [202.5, 0, 3.5052]  ...
       );
    
    
     switch decoder_type
		case 'allrad'
			ambi_run_allrad(...
				S, ...  % speaker array struct
				[h_order,v_order], ...  % ambisonic order [h, v]
				[], ... % imaginary speakers, none in this case
				[], ... % pathname for output, [] = default
				true, ... % do plots, default is true for MATLAB, false for Octave
				mixed_order_scheme ... % mixed order scheme HV or HP
				);
		case 'pinv'
			ambi_run_pinv(...
				S, ...  % speaker array struct
				[h_order,v_order], ...  % ambisonic order [h, v]
				[], ... % imaginary speakers, none in this case
				[], ... % pathname for output, [] = default
				true, ... % do plots, default is true for MATLAB, false for Octave
				mixed_order_scheme ... % mixed order scheme HV or HP
				);
    end
end

    
