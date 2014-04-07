function [ p, f, r ] = BesselPoly( mm )
    %BESSEL_POLY Construct the bessel polynomial and factor it into irreducable polynomials over the reals.
    %
    % mm is the order or set of orders
    %  (Note: MATLAB's root function is good to about 40th order)
    %
    % p is the polynomial in MATLAB representation (array of coefficients
    %   in increasing order)
    % f is a cell array of the factors
    % r the array of the roots
    %
    % See Sec 3.2 of [1] for how this applies to Ambisonic near-field
    % compensation (NFC) filters.
    % 
    %
    % [1]   J. Daniel, "Spatial Sound Encoding Including Near Field Effect: 
    %       Introducing Distance Coding Filters and a Viable, New Ambisonic
    %       Format," Preprints 23rd AES International Conference, 
    %       Copenhagen, 2003.
    %    
    % [2]   Weisstein, Eric W. "Bessel Polynomial." From MathWorld--A 
    %       Wolfram Web Resource. 
    %       http://mathworld.wolfram.com/BesselPolynomial.html
    
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
    
    %% argument checking
    if any(mm > 40)
        warning('Results may not be accurate for higher than 24th order')
    end
    
    %% build the polynomial
    p = [];
    for m = mm
        for i = 0:m
            p = [p, bessel_coeff(m,i)];
        end
    end
    
    %% find the roots
    r = roots(p);
    
    %% construct the set of irreducable polynomial factors over the reals
    f = {};
    i = 1;
    j = 1;
    while i <= length(r)
        if isreal(r(i))
            ii = i;
            i = i + 1;
        else
            ii = i:(i+1);
            i = i + 2;
        end
        f{j} = poly(r(ii));
        j = j + 1;
    end
    
end

function a = bessel_coeff(m,i)
    %a = factorial(m+i)/factorial(m-i)/factorial(i)/2^i;
    
    % this is better numerically
    a = nchoosek(m,i) * ...
        prod( (m+(1:i)) ./ linspace(2,2,i) );
end

