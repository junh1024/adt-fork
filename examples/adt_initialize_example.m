function adt_initalize
    
    [status,message] = fileattrib(fullfile('..','matlab'));
    if status == 1
        addpath(message.Name);
    else
        error(m);
    end
end
