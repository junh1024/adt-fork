function [ out ] = parse_name_value_args( fnames_or_defaults, varargin )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    % check name, value pairs
    if mod(length(varargin), 2) == 1
        error('No value for last name: %s', varargin{end});
    end
    
    if isstruct(fnames_or_defaults)
        out = fnames_or_defaults;
        fnames = fieldnames(fnames_or_defaults);
    else
        out = struct();
        fnames = fnames_or_defaults;
    end
    
    names = varargin(1:2:end);
    values = varargin(2:2:end);
    
    if isempty(fnames_or_defaults)
        out=cell2struct(values,names,2);
    else
        for i = 1:length(names)
            keyword = names{i};
            matches = strncmpi(keyword, fnames, length(keyword));
            switch sum(matches)
                case 0
                    error('No matches for keyword: %s', keyword);
                case 1
                    out.(fnames{matches}) = values{i};
                otherwise
                    error('Ambigous keyword: %s', keyword);
            end
        end
    end
end

