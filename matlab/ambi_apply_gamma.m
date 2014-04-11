function [M_hf, M_lf] = ambi_apply_gamma( M, Gamma, C )
    %ambi_apply_gamma() LF and HF matrices from basic solution and gamma
    %  M is basic solution matrix
    %  Gamma is vector of per-degree gains
    %  C is struct that defines the ambisonic channels.
    
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
    
    M_hf = M * diag(Gamma(C.sh_l+1));
    M_lf = M;
end

