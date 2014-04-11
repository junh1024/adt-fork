function [ grid ] = AzElGrid( az_range, el_range )
%AzElGrid( az_range, el_range ) produce a grid with uniform geodetic sampling
%   az_range and el_range are in degrees
%   output struct is grid with fields az, el, x, y, z, w

%{
This file is part of the Ambisonic Decoder Toolbox (ADT).
Copyright (C) 2013 Aaron J. Heller

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
    if nargin < 2
        az_range = -180:4:180-4;
        el_range =  -88:4:88;
    end

    %%
    grid.az_range = az_range*pi/180;
    grid.el_range = el_range*pi/180;

    [grid.az, grid.el] = meshgrid(grid.az_range, grid.el_range);

    [grid.x, grid.y, grid.z] = ...
        sph2cart(grid.az, grid.el, 1);

    grid.w = cos(grid.el);

end
