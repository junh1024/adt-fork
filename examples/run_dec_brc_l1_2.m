function run_dec_brc_l1_2
    % allrad example specifying speaker locations inline
    % specifics are for BRC installation in NYC
    %
    % see also AMBI_MAT2SPKR_ARRAY, AMBI_RUN_ALLRAD
    
    %%
    decoder_type = 'pinv'; % pinv | allrad
    
    close all
    
    for decoder_type = 1:2
        for h_order = 1:2
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
                    1.0175  -141.84   00.00 ;... % // RB
                    1.0175   141.84   00.00 ;... % // LB
                    1.1315     0.00   45.00 ;... % // FU
                    1.1315     0.00  -45.00 ;... % // FD
                    1.1315   180.00   45.00 ;... % // BU
                    1.1315   180.00  -45.00 ;... % // BD
                    1.0175    90.00   51.84 ;... % // LU
                    1.0175    90.00  -51.84 ;... % // LD
                    1.0175   -90.00   51.84 ;... % // RU
                    1.0175   -90.00  -51.84 ;... % // RD
                    ], ...
                    'RAE',...            % locations
                    'MDD', ...           % in meters
                    'BRC1', ...            % name of array
                    {'LF','RF','RB','LB',...
                    'FU','FD','BU','BD',...
                    'LU','LD','RU','RD'} ...
                    );
                
                switch decoder_type
                    case {'allrad',1}
                        ambi_run_allrad(...
                            S, ...  % speaker array struct
                            [h_order,v_order], ...  % ambisonic order [h, v]
                            [], ... % imaginary speakers, none in this case
                            [], ... % pathname for output, [] = default
                            true, ... % do plots, default is true for MATLAB, false for Octave
                            mixed_order_scheme ... % mixed order scheme HV or HP
                            );
                    case {'pinv',2}
                        ambi_run_pinv(...
                            S, ...  % speaker array struct
                            [h_order,v_order], ...  % ambisonic order [h, v]
                            [], ... % imaginary speakers, none in this case
                            [], ... % pathname for output, [] = default
                            true, ... % do plots, default is true for MATLAB, false for Octave
                            mixed_order_scheme, ... % mixed order scheme HV or HP
                            1);
                end
            end
        end
    end
    
