function [ C ] = ambi_channel_definitions( h_order, v_order, ...
        mixed_order_scheme, orderingRule, encodingConvention )
%AMBI_CHANNEL_DEFINITIONS sets up channel definition struct
%
%  h_order is horizontal order (highest zonal degree in use)
%  v_order is vertical order (highest tesseral degree in use)
%  mixed_order_scheme controls which sectoral harmonics are
%    included in mixed-order
%
%  mixed_order_scheme = 'amb'|'hp'|'hv'|'travis'
%  orderingRule       = 'amb'|'fuma'|'sid'|'daniel'|'mpeg'|'acn'|'ambix'
%  encodingConvention = 'amb'|'fuma'|'sn3d'|'n3d'|'sn2d'|'n2d'|'ambix'
%
% See also AMBI_MIXED_ORDER_CHANNELS, AMBI_SAMPLE_Y_SPH 
%
% NOTE:
% Ambisonics traditionally calls degree "order", and order "channel". A&S
% [1], Mathematica, and MATLAB use n for degree and m for order. Daniel [2]
% and Malham [3] use m for degree, and n for order [2]. Halham also uses
% \varsigma to indicate cosine (=1) or sine(=-1) for the sectoral
% component. The 2011 AmbiX proposal [4] uses n,m, whereas the earlier one
% [5] and Chapman's website [6] use l,m. 
%
% References:
%
% [1] I. A. Stegun, "Legendre Functions," in Handbook of Mathematical
% Functions, M. Abramowitz and I. A. Stegun, Eds. Washington, DC: National
% Bureau of Standards, 1964, pp. 331?341.
%
% [2] J. Daniel, "Spatial Sound Encoding Including Near Field Effect:
% Introducing Distance Coding Filters and a Viable, New Ambisonic Format,"
% Preprints 23rd AES International Conference, Copenhagen, 2003.
%
% [3] D. G. Malham, "Higher order Ambisonic systems," Space in Music -
% Music in Space, 2003.
%
% [4] C. Nachbar, F. Zotter, E. Deleflie, and A. Sontacchi, "AMBIX - A
% SUGGESTED AMBISONICS FORMAT," presented at the 3rd International
% Symposium on Ambisonics and Spherical Acoustics, 2011.
%
% [5] M. Chapman, W. Ritsch, T. Musil, I. Zmölnig, H. Pomberger, F. Zotter,
% and A. Sontacchi, "A standard for interchange of Ambisonic signal sets
% including a file standard with metadata," presented at the Proc. of the
% Ambisonics Symposium, Graz, 2009.
%
% [6] M. Chapman, "The Ambisonics Association," http://ambisonics.ch

    %{
This file is part of the Ambisonic Decoder Toolbox (ADT).
Copyright (C) 2013  Aaron J. Heller

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
    %}
    
    % Author: Aaron J. Heller <heller@ai.sri.com>
    % $Id$
    
    %% defaults
    if ~exist('v_order', 'var') || isempty(v_order)
        v_order = h_order;
    end
    
    if ~exist('mixed_order_scheme','var') || isempty(mixed_order_scheme)
        mixed_order_scheme = 'HP';
    end
    
    if ~exist('orderingRule','var') || isempty(orderingRule)
        orderingRule = 'FuMa';
    end
    
    if ~exist('encodingConvention','var') || isempty(encodingConvention)
        encodingConvention = 'FuMa';
    end
    
    max_order = max(h_order,v_order);
    
    sh.index = 0:((max_order+1)^2-1);
    sh.l = zeros(size(sh.index));
    sh.m = zeros(size(sh.index));
    
    orderingRule = lower(orderingRule);
    encodingConvention = upper(encodingConvention);
    
    if ismember(orderingRule, {'amb', 'fuma'})
        if max_order <= 3
            C = ambi_channel_definitions_fms(h_order,v_order,mixed_order_scheme);
        else
            error('%s not defined for order > 3', orderingRule);
        end
    else
        
        %% fill in channel index, degree, order
        switch lower(orderingRule)
            case {'acn','ambix2009', 'ambix'}
                orderingRule = 'acn';
                sh.l = floor(sqrt(sh.index));
                sh.m = sh.index - sh.l.^2 - sh.l;
                
            case {'sid','daniel','mpeg'}
                orderingRule = 'sid';
                c = 1;
                for l = 0 : max_order
                    for m = l:-1:0
                        sh.l(c) = l;
                        sh.m(c) = m;
                        c = c + 1;
                        if m > 0
                            sh.l(c) = l;
                            sh.m(c) = -m;
                            c = c + 1;
                        end
                    end
                end
            otherwise
                error('Unknown ordering_rule: %s', ordering_rule);
        end
        
        %% mixed order calculation
        [ch, scheme] = ambi_mixed_order_channels(sh, h_order,v_order,...
            mixed_order_scheme);
        
        sh.l = sh.l(ch);
        sh.m = sh.m(ch);
        
        %% fill in normalization
        switch upper(encodingConvention)
            case {'SN3D', 'AMBIX', 'AMBIX2011'}
                norm = 1 ./ SN3D_to_N3D(sh.l);
                encodingConvention = 'SN3D';
                
            case {'N3D', 'AMBIX2009'}
                % N3D is native normalization for ambi_sample_Y
                norm = ones(size(sh.l));
                encodingConvention = 'N3D';
                
            case {'N2D', 'ICST'}
                norm = N3D_to_N2D(sh.l);
                encodingConvention = 'SN3D';
                
            case {'SN2D'}
                norm = N3D_to_N2D(sh.l) ...
                    .* N2D_to_SN2D(sh.l);
                encodingConvention = 'SN2D';
                
            case {'SN2DXW', 'COURVILLE'}
                norm = N3D_to_N2D(sh.l) ...
                    .* N2D_to_SN2D(sh.l);
                norm(1) = sqrt(1/2);
                encodingConvention = 'SN2DxW';
            case {'FUMA'}
                % fixme check this
                fms_norm =  [...
                    1/sqrt(2), ...                        % W
                    1/sqrt(3) * [1, 1, 1],...             % X Y Z
                    1/sqrt(5), ...                        % R
                    1/sqrt(5) * 2/sqrt(3) * [1,1,1,1],... % S T U V
                    1/sqrt(7), ...                        % K
                    1/sqrt(7) * sqrt(45/32) * [1,1], ...  % L M
                    1/sqrt(7) * 3/sqrt(5) * [1, 1], ...   % N O
                    1/sqrt(7) * sqrt(8/5) * [1, 1], ...   % P Q
                    ];
                %norm = fms_norm(ch);
                norm = [];  %fixeme check this
        end
        
        %% Condon-Shortly Phase
        %    no ambisonic conventions use CS phase
        switch false
            case false
                cs_phase = ones(size(sh.m));
            case true
                cs_phase = (-1)^abs(sh.m);
        end
        
        %% set up struct C for channels in use
        C.h_order = h_order;
        C.v_order = v_order;
        C.sh_l = sh.l;
        C.sh_m = sh.m;
        C.sh_cs_phase = cs_phase;
        C.scheme = scheme;
        C.norm = norm;
        C.ordering_rule = orderingRule;
        C.encoding_convention = encodingConvention;
        C.index = sh.index;
        
        C.names = ambi_channel_names(sh);
        C.channels = find( ch );
        C.mask = ch;
        
    end
    
    
end

%% conversion factors

% from Table 2 in [2]

function f = SN3D_to_N3D(m)
    f = sqrt(2*m + 1);
end

function f = N3D_to_N2D(m)
    f = sqrt( ((2.^(2.*m) .* (factorial(m).^2))) ...
        ./ factorial(2*m + 1) );
end

function f = SN3D_to_N2D(m)
    f = pi^(1/4) * sqrt(gamma(1+m)./gamma(1/2+m));
end

function f = N2D_to_SN2D(m)
    f = ones(size(m)) / sqrt(2);
    f(1) = 1;
end

function names = ambi_channel_names(sh, letter_limit)
    
    if ~exist('letter_limit', 'var') || isempty(letter_limit)
        letter_limit = 3;
    end
    
    if letter_limit > 3
        warning('No letter names above 3, using numbers');
        letter_limit = 3;
    end
    fuma_ch_names = {...
        'W',...
        'Y', 'Z', 'X', ...
        'V', 'T', 'R', 'S', 'U', ...
        'Q', 'O', 'M', 'K', 'L', 'N', 'P'};
    sc = {'S','C','C'};
    
    acn = ambi_ACN(sh.l, sh.m);
    names = cell(size(acn));
    
    names(sh.l<=letter_limit) = fuma_ch_names(acn(sh.l<=letter_limit)+1);
    
    for i = acn(sh.l>letter_limit)
        names{acn==i} = [...
            num2str(sh.l(acn==i)), ...
            num2str(abs(sh.m(acn==i))), ...
            sc{sign(sh.m(acn==i))+2} ];
    end
    
end
