function [ Y ] = ambi_sample_Y_cart( Vx, Vy, Vz, C, n3d_flag )
%AMBI_SAMPLE_Y_CART sample the spherical harmonics at Vxyz grid points
%  This converts to spherical coordinates and calls ambi_sample_Y_sph
%
% See also AMBI_SAMPLE_Y_SPH


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

%%    
    [az, el] = cart2sph(Vx, Vy, Vz);
    
    if nargin > 4
        Y = ambi_sample_Y_sph(az, el, C, n3d_flag);
    else
        Y = ambi_sample_Y_sph(az, el, C);
    end
end
