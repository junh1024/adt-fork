function run_dec_BBC16
    
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
                1.0175	  38.16   00.00 ;... % // LF
                1.0175   -38.16   00.00 ;... % // RF
                1.0175  -128.16   00.00 ;... % // RB
                1.0175   128.16   00.00 ;... % // LB
                1.4583     0.00   56.73 ;... % // FU
                1.4583     0.00  -56.73 ;... % // FD
                1.4583   180.00   56.73 ;... % // BU
                1.4583   180.00  -56.73 ;... % // BD
                1.3717    90.00   62.72 ;... % // LU
                1.3717    90.00  -62.72 ;... % // LD
                1.3717   -90.00   62.72 ;... % // RU
                1.3717   -90.00  -62.72 ;... % // RD
                ], ...
                'RAE',...            % locations 
                'MDD', ...           % in meters
                'BRC1', ...            % name of array
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
    
