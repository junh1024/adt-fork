function [ s ] = spherical_t_design( dim, np, t )
    %SPHERICAL_T_DESIGN loads sphereical t-design from file
    % spherical_t_design( dim, np, t ) loads and returns the
    % specified spherical t-design.  For more information see
    %   http://www2.research.att.com/~njas/sphdesigns/index.html
    
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
    if  exist(sprintf('des_%i_%i_%i.m', dim, np, t),'file')
        fh = str2func(sprintf('des_%i_%i_%i', dim, np, t));
        d = fh(); %des_3_240_21();
    else
        path = fullfile('sphdesigns',...
            sprintf('dim%i', dim),...
            sprintf('des.%i.%i.%i.txt',dim, np, t));
        
        if inOctave
            d = load(path);
        else
            d = importdata(path);
        end
        
        d = reshape(d, 3, floor(numel(d)/3))';
    end
    
    s.x = d(:,1);
    s.y = d(:,2);
    s.z = d(:,3);
    
end
