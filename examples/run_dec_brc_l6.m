function run_dec_brc_l6
    % allrad example specifying speaker locations inline
    % specifics are for BRC installation in NYC
    %
    % see also AMBI_MAT2SPKR_ARRAY, AMBI_RUN_ALLRAD
    
    %%
    decoder_type = 'pinv'; % pinv | allrad
    for h_order = 1:2;
        for v_order = 1:min(h_order,2);
            mixed_order_scheme = 'HP';

            S = ambi_mat2spkr_array(...
                ... % adjust args according to data read from import file
                ... %   see ambi_mat2spkr_array for coord and unit codes
                ... %ID	r (m)	a (deg) e (deg) // Speaker Name
                ... %-----------------------------------------------
                [ ...
                0.8890	  45.00   00.00 ;... % // LF
                0.8890   -45.00   00.00 ;... % // RF
                0.8890  -135.00   00.00 ;... % // RB
                0.8890   135.00   00.00 ;... % // LB
                1.1315     0.00   45.00 ;... % // FU
                1.1315     0.00  -45.00 ;... % // FD
                1.1315   180.00   45.00 ;... % // BU
                1.1315   180.00  -45.00 ;... % // BD
                0.8890    90.00   45.00 ;... % // LU
                0.8890    90.00  -45.00 ;... % // LD
                0.8890   -90.00   45.00 ;... % // RU
                0.8890   -90.00  -45.00 ;... % // RD
                ], ...
                'RAE',...            % locations 
                'MDD', ...           % in meters
                'BRC6', ...            % name of array
                {'LF','RF','RB','LB',...
                 'FU','FD','BU','BD',...
                 'LU','LD','RU','RD'} ...
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
    end
    
