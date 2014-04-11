function [gammas, g0] = ambi_shelf_gains( C, S, type )
%AMBI_SHELFS  compute shelf gains for Decodage max_rE
%   C is channel definition struct
%   S is speaker array definition struct
%   type is one of:
%      'energy' for 'conservation de l'énergie totale' [2]
%      'amp' for 'préservation de l'amplitude' [2]
%      'rms' for BLaH/Gerzon [1,3]
%
% See also AMBI_APPLY_GAMMA
%
% References:
%
%  [1] M. A. Gerzon, "Practical Perphony: The Reproduction of
%  Full-Sphere Sound," Preprints of the 65th AES Convention, no. 1571,
%  p. 11, 1980.
%
%  [2] J. Daniel, "Représentation de champs acoustiques, application à
%  la transmission et à la reproduction de scènes sonores complexes
%  dans un contexte multimédia," PhD Thesis, 2001.
%
%  [3] A. Heller, R. Lee, and E. M. Benjamin, "Is My Decoder
%  Ambisonic?," AES 125th Convention, San Francisco, pp. 1?21, Dec.
%  2008.
%
%  [4] A. Heller, E. M. Benjamin, and R. Lee, "A Toolkit for the
%  Design of Ambisonic Decoders," presented at the Linux Audio
%  Conference 2012, 2012, pp. 1?12.


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
    if C.v_order > 0
        windowPoly = @(n)LegendrePoly(n);
    else
        windowPoly = @(n)ChebyshevPoly(n);
    end

    L = length(S.x);
    M = max(C.v_order,C.h_order);
    m = 0:M;

    max_rE = max(roots(windowPoly(M+1)));
    Gamma_max_rE = arrayfun(@(n)polyval(windowPoly(n),max_rE), m);

    ch_gammas = Gamma_max_rE(C.sh_l+1);
    E_max_rE = ch_gammas * ch_gammas';

    switch type
      case {'energy', 1}
        g0_max_rE = sqrt( L / E_max_rE );
      case {'rms', 2}
        g0_max_rE = sqrt( numel(m) / E_max_rE );
      case {'amp', 3}
        g0_max_rE = 1;
      otherwise
        display(type);
        error('type should be 1, 2, 3, ''energy'', ''rms'', or ''amp''');
    end

    % et voila!
    gammas = Gamma_max_rE * g0_max_rE;

    if nargout > 1
        g0 = g0_max_rE;
    end

end
