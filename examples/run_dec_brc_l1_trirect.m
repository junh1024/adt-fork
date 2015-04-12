function run_dec_brc_l1_trirect
    % allrad example specifying speaker locations inline
    % specifics are for BRC installation in NYC
    %
    % see also AMBI_MAT2SPKR_ARRAY, AMBI_RUN_ALLRAD
    
    %%
    decoder_type = 'pinv'; % pinv | allrad
    mixed_order_scheme = 'HP';
    
    % AK uses Navigational Cartesian system
    dx = 49.5/2;  % left-right, right is +
    dy = 63.0/2;  % front-back, front is +
    dz = 72.0/2;  % up-down, up is +
    
    unit_code = 'III'; % inches
    coord_code = 'YXZ'; % fix X,Y swap,  X is front-back, Y is left-right
    dx = -dx; % fix L-R reversal
    
    for h_order = 1:2;
        for v_order = 1:min(h_order,2);
            
            S = ambi_mat2spkr_array(...
                ... % adjust args according to data read from import file
                ... %   see ambi_mat2spkr_array for coord and unit codes
                ... %ID	r (m)	a (deg) e (deg) // Speaker Name
                ... %-----------------------------------------------
                [ ...
                -dx +dy 0.0 ;... % // LF
                +dx +dy 0.0 ;... % // RF
                +dx -dy 0.0 ;... % // RB
                -dx -dy 0.0 ;... % // LB
                ...
                +dx 0.0 0.0 ;... % // Right NEW
                -dx 0.0 0.0 ;... % // Left  NEW
                ...
                0.0 +dy +dz ;... % // FU
                0.0 +dy -dz ;... % // FD
                0.0 -dy +dz ;... % // BU
                0.0 -dy -dz ;... % // BD
                ...
                -dx 0.0 +dz ;... % // LU
                -dx 0.0 -dz ;... % // LD
                +dx 0.0 +dz ;... % // RU
                +dx 0.0 -dz ;... % // RD
                ], ...
                coord_code,...           % coordinate
                unit_code, ...           % units
                'BRC1.even_energy', ...            % name of array
                {'LF','RF','RB','LB',...
                 'RR','LL',...
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
    
