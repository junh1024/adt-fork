function [ ] = write_faust_adapter_matrix( A, fid )
    %UNTITLED2 Summary of this function goes here
    %   Detailed explanation goes here
    
    if ~exist('fid', 'var'),
        fid = 1;
    end
    s = num2str(A, '%0.10g, ');
    for row = 1:(size(A,1)) 
        fprintf(fid, 'A(%02d) = (%s);\n', row-1, s(row,1:end-1));
    end
end

