function [ ch_mask, scheme ] = ambi_mixed_order_channels( sh, h_order, v_order, scheme)
    %ambi_mixed_order_channels() return channel mask for mixed order schemes
    % [ ch_mask, scheme ] = ambi_mixed_order_channels(sh, h_order, v_order, scheme)
    % creates the channel mask for the horizontal and vertical order
    % according to the specified mixed-order scheme.
    %
    %  sh is the degree/order struct for the current encoding
    %  h_order is horizontal order (highest zonal degree in use)
    %  v_order is vertical order (highest tesseral degree in use)
    %  scheme controls mixed-order scheme (HP, HV)
    %
    % There are two mixed order schemes in use.  Travis [1] calls them HP
    % and HV.  HP is the original scheme used in AMB files [2].  HV is the
    % newer scheme used in the config files supplied with AmbDec 0.51.
    %
    % [1] C. Travis, "A New Mixed-Order Scheme for Ambisonic Signals,"
    % Proc. 1st Ambisonics Symposium, 2009, Graz
    %
    % [2] http://members.tripod.com/martin_leese/Ambisonic/B-Format_file_format.html
    
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
    % $Id: ambi_mixed_order_channels.m 26442 2014-01-09 23:28:41Z heller $
    
    %% defaults
    if ~exist('v_order','var') || isempty(v_order)
        v_order = h_order; 
    end; % is there a better option?
    if ~exist('scheme','var') || isempty(scheme)
        scheme = 'AMB'; 
    end;
    
    %%
    switch upper(scheme)
        case {'HP', 'AMB'}
            % used in AMB files, h and v orders independant
            %  this is what .AMB files use
            sh_zonal_p    = sh.m == 0;
            sh_tesseral_p = sh.l == abs(sh.m);
            sh_sectoral_p = ~sh_zonal_p & ~sh_tesseral_p;
            
            ch_mask = ...
               (  sh_tesseral_p & (sh.l <= h_order) ) | ...
               ( ~sh_tesseral_p & (sh.l <= v_order) );
            scheme = 'HP';
            
        case {'HV', 'TRAVIS'}
            % Travis HV scheme, see [1]
            ch_mask = sh.l-abs(sh.m) <= v_order & (sh.l<=max(h_order,v_order));
            scheme = 'HV';
            
        otherwise
            error('unknown mixed-order scheme: "%s" ', scheme);
    end
end

