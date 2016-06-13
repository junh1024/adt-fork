function [ S ] = ambi_spkr_array( name, coord_code, unit_code, varargin )
%AMBI_SPKR_ARRAY instantiate speaker array struct
%   see run_dec_3D7 for an example
%   see ambi_mat2spkr_array for an explanation of coord and unit codes

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

    S = ambi_mat2spkr_array(...
        vertcat(varargin{2:2:length(varargin)}),...
        coord_code, unit_code,name,...
        {varargin{1:2:length(varargin)}});

end
