function [ angle ] = ambi_dir_diff( uvec1, uvec2 )
    %AMBI_DIR_DIFF angle between to unit vectors
    %   Detailed explanation goes here
    
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
    % $Id: ambi_dir_diff.m 26435 2013-12-11 01:23:33Z heller $
    
    % this is faster than MATLAB's dot function (due to less arg checking)
    dot_prod = sum(uvec1 .* uvec2);
    
    % due to round off this can be larger than 1 which results in complex
    % values of acos, so clip at 1
    dot_prod(dot_prod>1) = 1;
    
    angle = acos(dot_prod);
    
    % if less than a milliRadian, set to 0 to clean up plots
    fuzz = 1e-3;
    angle(angle<fuzz) = 0;
end

