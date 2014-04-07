function [ C ] = ambi_channel_definitions_convention( ...
        ambi_order, ...
        convention_name, ...
        mixed_order_scheme)
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    %% defaults
    
    if ~exist('mixed_order_scheme','var') 
        mixed_order_scheme = [];
    end
    
    %  if we get a struct assume its a fully instantiatiated
    %    channel struct
    if isstruct(ambi_order)
        C = ambi_order;
        return
        
    elseif isnumeric(ambi_order)
        switch length(ambi_order)
            case 1
                ambi_order = [ambi_order,ambi_order];
            case 2
                % nada
            otherwise
                ambi_order = ambi_order(1:2);
                warning('ignoring extra entries in ambi_order');
        end
    end
    
    % defaults for convention
    %  if 3rd order or less use FUMA, otherwise AmbiX2011
    if ~exist('convention_name', 'var') || isempty(convention_name)
        %  3 or less use FMS, otherwise Ambix2011
        if max(ambi_order(:)) <= 3
            % use fuma
            convention_name = 'fuma';
        else
            convention_name = 'ambix2011';
        end
    end
    
    %% map convention_name to details
    switch lower(convention_name)
        case {'fuma', 'fms', 'amb'}
            if isempty(mixed_order_scheme)
                mixed_order_scheme = 'HP';
            end
            C = ambi_channel_definitions_fms(...
                ambi_order(1),ambi_order(2), ...
                mixed_order_scheme);
        case {'ambix', 'ambix2011'}
            if isempty(mixed_order_scheme)
                mixed_order_scheme = 'HV';
            end
            C = ambi_channel_definitions(...
                ambi_order(1),ambi_order(2),...
                mixed_order_scheme, ...
                'ACN', ... % ordering rule
                'SN3D' ... % normalization
                );
        case {'ambix2009'}
            if isempty(mixed_order_scheme)
                mixed_order_scheme = 'HV';
            end
            C = ambi_channel_definitions(...
                ambi_order(1),ambi_order(2),...
                mixed_order_scheme, ...  
                'ACN', ... % ordering rule
                'N3D' ... % normalization
                );
        case {'sn2dx2', 'courville', 'b2x'}
            if all( ambi_order <= [5;1] )
                C = ambi_channel_definitions(...
                    ambi_order(1),ambi_order(2), ...
                    'HP',...
                    'SID', ...
                    'SN2DXW');
            else
                error('%s not defined for greater than 5,1',...
                    convention_name);
            end
        case {'icst'}
            if ambi_order(2) <= 0
                C = ambi_channel_definitions(...
                    ambi_order(1),0, ...
                    'HP',...
                    'SID', ...
                    'N2D');
            else
                error('%s not defined for greater v_order > 0',...
                    convention_name);
            end
        case {'mpeg', 'mpegh'}
            % TODO: check these
            C = ambi_channel_definitions(...
                ambi_order(1), ambi_order(2),...
                'HP', ...
                'SID', ...
                'N3D');

        otherwise
            error('unknown convention: %s', convention_name);
            
    end
    
    
end

