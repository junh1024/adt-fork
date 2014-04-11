function [ sid ] = ambi_SID( degree, order )
%AMBI_ACN() Ambisonic Channel Single ID proposed by Daniel
%   degree = 0 .. N (N = Ambisonic order)
%   order = -degree .. degree
%
% NOTE: Ambisonics traditionally calls degree "order", and order
% "channel".  A&S [1], Mathematica, and MATLAB use n for degree and m
% for order, whereas Daniel uses m for degree, and n for order
% [2]. The AmbiX proposal [3] uses l,m in some places and n,m in
% others. Courville uses SID for his fifth-order plugins [4].
%
%
% [1] I. A. Stegun, "Legendre Functions," in Handbook of Mathematical
% Functions, M. Abramowitz and I. A. Stegun, Eds. Washington, DC:
% National Bureau of Standards, 1964, pp. 331?341.
%
% [2] J. Daniel, "Spatial Sound Encoding Including Near Field Effect:
% Introducing Distance Coding Filters and a Viable, New Ambisonic
% Format," Preprints 23rd AES International Conference, Copenhagen,
% 2003.
%
% [3] C. Nachbar, F. Zotter, E. Deleflie, and A. Sontacchi, "AMBIX - A
% SUGGESTED AMBISONICS FORMAT," presented at the 3rd International
% Symposium on Ambisonics and Spherical Acoustics, 2011.
%
% [4] D. Courville, "Ambisonic Studio: Fifth Order Planar B-Format
% Encoding and Decoding." http://www.radio.uqam.ca/ambisonic/5b.html

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
    m = degree;
    n = order;

    sid = m.^2 + 2.*(m-abs(n)) + (n<0);

end
