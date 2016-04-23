function [ s ] = write_sox_remix_adapter( Cin, Cout )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    [perm,  gain] = ambi_channel_permutation_gain(Cin, Cout);
  
    % compose sox remix string
    s = 'remix -m';
    for i_out = 1:length(perm)
        s = sprintf('%s %i', s, perm(i_out));
        if perm(i_out) > 0 && gain(i_out) ~= 1
            s = sprintf('%sv%f', s, gain(i_out));
        else

        end
    end
end

