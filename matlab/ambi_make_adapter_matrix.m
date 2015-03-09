function [ A ] = ambi_make_adapter_matrix( Cin, Cout )
    %AMBI_MAKE_ADAPTER_MATRIX convert signal set from Cin channels to Cout
    %
    %   S_out = A * S_in
    %   Cin and Cout are channel structs made by one of the
    %   ambi_channel_definitions_* functions
    %   channels in the input that are not in the output are discarded
    %   channels in the output that are not in the input are zero
    
        %{
This file is part of the Ambisonic Decoder Toolbox (ADT).
Copyright (C) 2014  Aaron J. Heller

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
 
    n_Cin = length(Cin.norm);
    n_Cout = length(Cout.norm);
    A = zeros(n_Cout, n_Cin);
    
    for i_in = 1:n_Cin
        i_out = find((Cout.sh_l == Cin.sh_l(i_in)) & (Cout.sh_m == Cin.sh_m(i_in)));
        if ~isempty(i_in)
            A(i_out, i_in) = Cout.norm(i_out)/Cin.norm(i_in) * ...
                Cout.sh_cs_phase(i_out)*Cin.sh_cs_phase(i_in);
        end
    end
    
end

