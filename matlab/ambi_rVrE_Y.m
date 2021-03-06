function [ rV, rE, P, E ] = ambi_rVrE_Y( M, Su, test_dirs_Y )
%AMBI_rVrE_Y computes rV and rE from decoder matrix, speaker
%array, and test directions projected onto the spherical
%harmonic basis

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


% I did some simple speed tests of alternative ways to do the 
% calculation inspired by Loren's blog post:
%  http://blogs.mathworks.com/loren/2008/08/04/comparing-repmat-and-bsxfun-performance/

    g = M * test_dirs_Y;
    
    % this is faster than abs(g).^2
    g2 = g.*conj(g);

    P = sum(g, 1);
    
    % this is faster than bsxfun(@rdivide, (Su * g), P);
    rV.xyz = real((Su * g)  ./ P([1 1 1], :));

    rV.r = sqrt( dot(rV.xyz, rV.xyz ));
    rV.u = rV.xyz ./ rV.r([1 1 1], :);

    E = sum(g2, 1);
    rE.xyz = (Su * g2) ./ E([1 1 1], :);

    % dot(x,x) is the same speed at sum(x.^2)
    rE.r = sqrt( dot(rE.xyz, rE.xyz) );
    rE.u = rE.xyz ./ rE.r([1 1 1], :);

end

