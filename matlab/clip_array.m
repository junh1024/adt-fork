function [ out ] = clip_array( A, upper, lower )
    %clip_array() clip array values to upper and lower
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
    % $Id: clip_array.m 26285 2013-04-08 00:20:41Z heller $
    
    out = A;
    
    if ~isempty(upper)
        out(A>upper)=upper;
    end
    
    if nargin > 2
        out(A<lower)=lower;
    end
    
end

