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
    
    %  if we get a struct, assume its a fully instantiatiated
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
    
    % defaults for convention_name
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
        
        case {'fuma', 'fms', 'amb', 'icst2', 1}
            % References:
            % D. G. Malham, ?Higher order Ambisonic systems,? Mphil Thesis,
            %   2003.
            %
            % ICST Externals for Ambisonics use FuMa since 2010 according to
            %   http://www.jasch.ch/pub/Ambisym10_ICST_report_final.pdf
            %   (no support for pre-2010 "seminormalized" convention)
            
            if isempty(mixed_order_scheme)
                mixed_order_scheme = 'HP';
            end
            C = ambi_channel_definitions_fms(...
                ambi_order(1),ambi_order(2), ...
                mixed_order_scheme);
            
        case {'ambix', 'ambix2011', 2}
            % Reference:
            % C. Nachbar, F. Zotter, E. Deleflie, and A. Sontacchi, ?AMBIX
            %   - A SUGGESTED AMBISONICS FORMAT,? presented at the 3rd
            %   International Symposium on Ambisonics and Spherical
            %   Acoustics, Lexington, KY, 2011.
            
            if isempty(mixed_order_scheme)
                mixed_order_scheme = 'HV';
            end
            C = ambi_channel_definitions(...
                ambi_order(1),ambi_order(2),...
                mixed_order_scheme, ...
                'ACN', ... % ordering rule
                'SN3D' ... % normalization
                );
            
        case {'ambix2009', 'n3d', 3}
            % Reference: 
            % M. Chapman, W. Ritsch, T. Musil, I. Zmölnig, H.
            %   Pomberger, F. Zotter, and A. Sontacchi, ?A standard for
            %   interchange of Ambisonic signal sets including a file
            %   standard with metadata,? presented at the Proc. of the
            %   Ambisonics Symposium, Graz, 2009.
            
            if isempty(mixed_order_scheme)
                mixed_order_scheme = 'HV';
            end
            C = ambi_channel_definitions(...
                ambi_order(1),ambi_order(2),...
                mixed_order_scheme, ...
                'ACN', ... % ordering rule
                'N3D' ... % normalization
                );
            
        case {'sn2dx2', 'courville', 'b2x', 4}
            % reverse engineered form B2X plugins at
            %   http://www.radio.uqam.ca/ambisonic/b2x.html
            
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
            
        case {'cicm', 5}
            % reverse engineered from Faust implementation in
            %  http://cicm.github.io/HoaLibrary-Light/index.html
            
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
            
        case {'mpeg', 'mpegh', 6}
            % References:
            %
            % ISO/IEC 14496-11 "Information technology ? Coding of
            %   audio-visual objects ?Part 11: Scene description and
            %   application engine" (second edition, dated 11/2013; see 
            %   Table 9 in page 36)
            %
            % ISO/IEC JTC1/SC29/WG11 MPEG2015//N15268 "Encoder Input Format
            %   for MPEG-H 3D Audio" (w15286, dated 2/2015; see Section 4.1)
            
            C = ambi_channel_definitions(...
                ambi_order(1), ambi_order(2),...
                'HP', ...
                'SID', ...
                'N3D');
            
        otherwise
            error('unknown convention: %s', convention_name);
            
    end
    
    
end

