function [ output_args ] = run_brh_spring2017( input_args )
    %UNTITLED4 Summary of this function goes here
    %   Detailed explanation goes here
    
    C = ambi_channel_definitions(4, 4, [], 'acn', 'sn3d');
    %C = ambi_channel_definitions(3, 3, [], 'fuma', 'fuma');
    S = speakers_brh_spring2017();
    
    %D = ambi_run_SSF(S,C,[],[],[],[],[],[])
    D = ambi_run_allrad(S,C)
    
end

