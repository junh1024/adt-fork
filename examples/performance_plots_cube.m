function [ ] = performance_plots_cube( )
    %UNTITLED2 Summary of this function goes here
    %   Detailed explanation goes here
    
    % PINV decoder for a cube, first-order, FuMa
    M = [0.1768    0.2165    0.2165    0.2165
         0.1768    0.2165   -0.2165    0.2165
         0.1768   -0.2165   -0.2165    0.2165
         0.1768   -0.2165    0.2165    0.2165
         0.1768    0.2165    0.2165   -0.2165
         0.1768    0.2165   -0.2165   -0.2165
         0.1768   -0.2165   -0.2165   -0.2165
         0.1768   -0.2165    0.2165   -0.2165 ];
    
    C = ambi_channel_definitions(1,1,'HP', 'fuma', 'fuma');
    
    S = SPKR_ARRAY_CUBE();
    
    % rV matching
    %ambi_plot_rE(S,[],M,C);
    
    % rE max
    gamma = ambi_shelf_gains(C,S,'rms');   
    ambi_plot_rE(S,[], ambi_apply_gamma(M,gamma,C), C);
    
end

