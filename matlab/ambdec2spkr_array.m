function [ S ] = ambdec2spkr_array(configpath, arrayname)
%ambdec2spkr_array() extracts a SPKR_ARRAY sturct from an AmbDec config file
%   configpath is path to AmbDec config file
%   arrayname is name for array (defaults to name part of configpath)
%
%  See also AMBI_MAT2SPKR_ARRAY

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

%% argument defaults
    fid = fopen(configpath,'r');
    if fid < 0
        error('%s not found.',configpath);
    end

    if ~exist('arrayname','var')
        [~, arrayname] = fileparts(configpath);
    end

    %% read the file
    tline = fgetl(fid);
    ns = 0;
    while ischar(tline)
        if inOctave()
            % Octave is broken here , so we have to resort to sprintf
            C = strsplit(tline, sprintf(' \f\n\r\t\v'), true);
        else
            C = strsplit(tline);
        end
        if ~isempty(C)
            switch lower(strtrim(C{1}))
              case '/dec/speakers'
                nspkr = str2double(C{2});
                id = cell(1,nspkr);
                x = cell(nspkr,3);

              case 'add_spkr'
                if ns == 0
                    get_connections = length(C)>5;
                    conns = cell(1,nspkr);
                end
                ns = ns + 1;
                id{ns} = C{2};
                x{ns,1}=str2double(C{3});
                x{ns,2}=str2double(C{4});
                x{ns,3}=str2double(C{5});
                if get_connections
                    conns{ns}=C{6};
                end

              otherwise
                % ignore everything else for now
            end
        end
        tline = fgetl(fid);
    end

    if ns ~= nspkr
        error('number of speakers read differs from number declared: %d %d',...
              nspkr, ns)
    end

    %% set up SPKR struct
    S = ambi_mat2spkr_array(cell2mat(x),'rae','mdd');
    S.id = id;
    S.name = arrayname;
    if get_connections
        S.conns = conns;
    end
end

