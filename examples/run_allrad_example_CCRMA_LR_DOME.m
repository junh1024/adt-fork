function run_allrad_example_CCRMA_LR_DOME( order )
    
    %% defaults
    if ~exist('order', 'var') || isempty(order)
        order = 3;
    end
    
    %%
    ambi_run_allrad(...
        SPKR_ARRAY_CCRMA_LISTENING_ROOM('dome'), ... % upper hemisphere
        [order,order], ...      % ambisonic order
        [0 0 -1], ...  % imaginary speaker at bottom of dome
        [], ...         % default output
        true);         % don't do graphics

    
end
