function run_dec_CCRMA_LR_LAC2014( order )
    
    %% defaults
    if ~exist('order', 'var') || isempty(order)
        order = 3;
    end
    
    %%
    switch 2 % 'dome'
        case 1
            S = SPKR_ARRAY_CCRMA_LISTENING_ROOM('full');
        case 2
            S = SPKR_ARRAY_CCRMA_LISTENING_ROOM('dome');
    end
    
    order = 3;
    switch 1
        case 1 % AllRAD
            ambi_run_allrad(...
                S,...
                [order,order], ...      % ambisonic order
                [0 0 -1], ...  % imaginary speaker at bottom of dome
                [], ...         % default output
                true);         % don't do graphics
            
        case 2 % EvenEnergy
            ambi_run_pinv(...
                S,...
                [order,order], ...      % ambisonic order
                [0 0 -1], ...  % imaginary speaker at bottom of dome
                [], ...         % default output
                true, 'HV',...
                1);
            
        case 3 % Mode-Matching
            ambi_run_pinv(...
                S, ...
                [order,order], ...      % ambisonic order
                [0 0 -1], ...  % imaginary speaker at bottom of dome
                [], ...         % default output
                true, 'HV',...
                0);
            
        case 4 % Energy limited 50%
            ambi_run_pinv(...
                S, ...
                [order,order], ...      % ambisonic order
                [0 0 -1], ...  % imaginary speaker at bottom of dome
                [], ...         % default output
                true, 'HV',...
                1/2);
            
            
    end
end
