function [ val ] = digits2num( v, b, big_endian )
    %digits2num convert the base b digits in v to a number
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
    % $Id: digits2num.m 26285 2013-04-08 00:20:41Z heller $
    
    %% defaults
    if ~exist('b','var') || isempty(b), b = 2; end
    if ~exist('big_endian','var'), big_endian = false; end
    
    %%
    if big_endian
        pv = b.^(numel(v)-1:-1:0);
    else
        pv = b.^(0:numel(v)-1);
    end
    
    val = pv * v(:);
end

