function [ perm, gain ] = ambi_channel_permutation_gain( Cin, Cout, ...
        channel_index_base )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    
    %% find the input channel and gain for each output channel
    n_Cout = length(Cout.norm);
    gain = zeros(1, n_Cout);
    perm = zeros(1, n_Cout);
    
    for i_out = 1:n_Cout
        i_in = find((Cout.sh_l(i_out) == Cin.sh_l) & ...
                    (Cout.sh_m(i_out) == Cin.sh_m) );
        if ~isempty(i_in)
            perm(i_out) = i_in;
            gain(i_out) = Cout.norm(i_out)/Cin.norm(i_in) * ...
                Cout.sh_cs_phase(i_out)*Cin.sh_cs_phase(i_in);
        end
    end
    
    %% adjust permuation base index, if needed
    if exist('channel_index_base', 'var') && ~isempty(channel_index_base)
        perm = perm - 1 + channel_index_base;
    end
    
end

