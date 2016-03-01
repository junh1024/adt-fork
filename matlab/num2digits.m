function [ out ] = num2digits( num, b, big_endian )
    %num2digits convert the number to digits in base b
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
    
    %% defaults
    if ~exist('b', 'var') || isempty(b), b = 2; end
    if ~exist('big_endian', 'var') || isempty(big_endian)
        big_endian = false;
    end
    
    %%
    out = [];
    while num > 0
        if big_endian
            out = [mod(num,b), out];
        else
            out = [out, mod(num, b)];
        end
        num = floor(num/b);
    end
end

