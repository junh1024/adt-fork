function [ C ] = ambi_channel_definitions_fms( h_order, v_order, scheme )
    %AMBI_CHANNEL_DEFINITIONS_FMS set up channel definition struct
    % C = AMBI_CHANNEL_DEFINITIONS_FMS(h_order, v_order, scheme)
    % Sets up the channel definition struct for a given ambisonic order
    % using Furse-Malham Set (FMS) channel order and normalization.
    %
    %  h_order is horizontal order (highest zonal degree in use)
    %  v_order is vertical order (highest tesseral degree in use)
    %  scheme controls which sectoral harmonics are included in mixed-order
    %
    % See also AMBI_MIXED_ORDER_CHANNELS, AMBI_CHANNEL_DEFINITIONS_AMB,
    % AMBI_SAMPLE_YFMS_CART
    %
    % References:
    %  [1] D. G. Malham, "Higher order Ambisonic systems," Mphil Thesis,
    %  University at York, 2003.
    %
    %  [2] http://www.muse.demon.co.uk/3daudio.html
    
    
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
    if ~exist('v_order','var'), v_order=h_order; end
    if ~exist('scheme','var'),  scheme = 'AMB'; end
    
    if h_order > 3 || v_order > 3
        warning('maximum order for FMS is 3');
    end
    
    %% definitions
    % channel definintions and order
    % Table 1 Ambisonic B Format Channels to 3rd Order, from [1]
    %
    % l = degree, m = order of the real spherical harmonics
    %   (note Dave's paper uses m = degree, n = order)
    %
    %         W | X  Y  Z | R  S  T  U  V | K  L  M  N  O  P  Q
    sh.l  = [ 0   1  1  1   2  2  2  2  2   3  3  3  3  3  3  3 ];
    sh.m  = [ 0   1 -1  0   0  1 -1  2 -2   0  1 -1  2 -2  3 -3 ];
    
    % these produce FMS weighting from N3D
 
    norm =  [...
        1/sqrt(1) * 1/sqrt(2), ...            % W
        1/sqrt(3) * [1, 1, 1],...             % X Y Z
        1/sqrt(5), ...                        % R
        1/sqrt(5) * 2/sqrt(3) * [1,1,1,1],... % S T U V
        1/sqrt(7), ...                        % K
        1/sqrt(7) * sqrt(45/32) * [1,1], ...  % L M
        1/sqrt(7) * 3/sqrt(5) * [1, 1], ...   % N O
        1/sqrt(7) * sqrt(8/5) * [1, 1], ...   % P Q
        ];
    
    ch_names = 'WXYZRSTUVKLMNOPQ';
    
    %% set up C struct for channels in use
    [ch, scheme] = ambi_mixed_order_channels(sh, h_order,v_order,scheme);
    
    if nargout < 1
        fprintf('active channels = %s\n', ch_names(ch));
    else
        C.h_order = h_order;
        C.v_order = v_order;
        C.scheme  = scheme;
        
        C.sh_l = sh.l(ch);
        C.sh_m = sh.m(ch);
        C.sh_cs_phase = ones(size(C.sh_m));
        
        C.norm = norm(ch);
        
        C.names = ch_names( ch );
        C.channels = find( ch );
        C.mask = ch;
        
        C.ordering_rule = 'fuma';
        C.encoding_convention = 'fuma';
    end
    
end

