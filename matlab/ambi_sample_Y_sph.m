function [ Y ] = ambi_sample_Y_sph( az, el, C, n3d_flag )
    %AMBI_SAMPLE_Y_SPH sample the spherical harmonics at AZ, EL grid points
    %
    
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
    % $Id: ambi_sample_Y_sph.m 26469 2014-03-20 07:16:41Z heller $
    
    
    % remember this so we can reshape the result to match the inputs
    %result_size = [size(az), length(C.sh_l)];
    
    % old behavior if norm is 1, this produces SN3D normalization.
    % this always produced N3D, normalize on output
    
    if ~exist('n3d_flag','var') || isempty(n3d_flag)
        n3d_flag = false;
    end
    
    az = az(:);
    z = sin(el(:));
    
    Y = zeros(length(az),length(C.sh_l));
    
    n3d_norm = sqrt(2*C.sh_l + 1);
    
    for c = 1:length(C.sh_l)
        degree = C.sh_l(c);
        order  = C.sh_m(c);
        if n3d_flag
            norm = 1;
        else
            norm   = C.norm(c);
        end
        n3d    = n3d_norm(c);
        cs_phase = C.sh_cs_phase(c);
        
        % Legendre 'sch' and 'norm' do not include C-S phase
        % (but unnormalized does!)
        L = legendre(degree,z,'sch');
        
        if order >= 0
            Y(:,c) =  norm * n3d * cs_phase .* L(order+1,:)' .* cos(order*az);
        else
            order = -order;
            Y(:,c) =  norm * n3d * cs_phase .* L(order+1,:)' .* sin(order*az);
        end
    end
    
    % not sure we want to do this
    %Y = reshape(Y, result_size);
end
