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
        
        case {'fuma', 'fms', 'amb', 'icst', 1}
            % References:
            % D. G. Malham, "Higher order Ambisonic systems," Mphil Thesis,
            %   2003.
            %
            % ICST Externals for Ambisonics use FuMa since 2010
            % with options for ACN with SN3D or N3D.  See Section
            % 8.1 of
            % J. C. Schacher, “Seven Years of ICST Ambisonics Tools
            %   for MaxMSP - A Brief Report,” Paris, 2010, pp. 1-4.
            %   Available from http://ambisonics10.ircam.fr/drupal/index7522.html?q=proceedings/p1
            %
            % No support in ADT for pre-2010 ICST
            % "seminormalized semi-normalized form of the
            % Furse-Malham set."  See section 2.1 of
            %
            % J. C. Schacher and P. Kocher, "Ambisonics Spatialization
            %   Tools for Max/MSP," presented at the Proceedings of the 2006
            %   International Computer Music Conference, New Orleans, 2006,
            %   pp. 274–277.  Available from
            %   http://hdl.handle.net/2027/spo.bbp2372.2006.057
            
            if isempty(mixed_order_scheme)
                mixed_order_scheme = 'HP';
            end
            C = ambi_channel_definitions_fms(...
                ambi_order(1),ambi_order(2), ...
                mixed_order_scheme);
            
        case {'ambix', 'ambix2011', 'sn3d', 2}
            % Reference:
            % C. Nachbar, F. Zotter, E. Deleflie, and A. Sontacchi, "AmbiX
            %   - A Suggested Ambisonics Format," presented at the 3rd
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
            
        case {'ambix2009', 'n3d', 'mpegh', 3}
            % Reference: 
            % M. Chapman, W. Ritsch, T. Musil, I. Zmölnig, H.
            %   Pomberger, F. Zotter, and A. Sontacchi, "A standard for
            %   interchange of Ambisonic signal sets including a file
            %   standard with metadata," presented at the Proc. of the
            %   Ambisonics Symposium, Graz, 2009.
            %
            % ISO/IEC JTC1/SC29/WG11 MPEG2015//N15268 "Encoder Input Format
            %   for MPEG-H 3D Audio" (w15268, dated 2/2015; see
            %   Section 4.2).  Available from:
            %   http://mpeg.chiariglione.org/standards/mpeg-h/3d-audio/n15268-encoder-input-format-mpeg-h-3d-audio
            
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
            %  http://www.radio.uqam.ca/ambisonic/b2x.html
            
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
            
        case {'hoalib-broken'}
            % as of May 2017, plugins based on HOAlib use a broken
            % definition of the spherical harmonics. The three specific
            % errors are:
            %
            % 1. bad computation of the zenith angle from elevation... 
            %    + instead of -, which explains the Z inversion
            %    https://github.com/CICM/HoaLibrary-Light/blob/dev/correct-std/Sources/Encoder.hpp#L921
            %
            % 2. use of condon-shortley phase... recursive form of Legendre 
            %    polys has C-S, I see no code that removes it, e.g.,
            %    (-1)^(order)
            %
            % 3. order 0 spherical harmonics omit sqrt(1/(4pi)) scaling, 
            %    other orders have it... that accounts for W and Z agreeing
            %    and X and Y being lower, by about 3.5... looks like this 
            %    has been fixed in the current version.
            %
            % These were identified by Mathias Kronlachner, see
            % https://github.com/CICM/HoaLibrary-Light/issues/3
            % (sheesh!)
            
            % claims to be ACN and SN3D
            C = ambi_channel_definitions(...
                ambi_order(1), ambi_order(2), ...
                mixed_order_scheme, 'ACN', 'SN3D');
            % but ...
            % fix #1
            C.invert_Z = true;
            % fix #2
            C.sh_cs_phase = (-1).^abs(C.sh_m);
            % fix #3
            C.norm(C.sh_m~=0) = C.norm(C.sh_m~=0) / sqrt(4*pi);


        case {'mpeg4', 'mpegh2013', 6}
            % References:
            %
            % ISO/IEC 14496-11 "Information technology -- Coding of
            %   audio-visual objects -- Part 11: Scene description and
            %   application engine" (second edition, dated 11/2013; see 
            %   Table 9 in page 36).  Also known as MPEG-4, Part 11. 
            %   https://en.wikipedia.org/wiki/MPEG-4_Part_11
            %
            % ISO/IEC JTC1/SC29/WG11 WG11/N13412 "Encoder Input Format
            %   for MPEG-H 3D Audio" (w13412, dated 1/2013; see
            %   Table 3). Available from
            %   http://mpeg.chiariglione.org/standards/mpeg-h/3d-audio/encoder-input-format-mpeg-h-3d-audio
            
            C = ambi_channel_definitions(...
                ambi_order(1), ambi_order(2),...
                'HP', ...
                'SID', ...
                'N3D');
            
        otherwise
            error('unknown convention: %s', convention_name);
            
    end
    
    
end

