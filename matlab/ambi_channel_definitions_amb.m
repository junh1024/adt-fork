function [ C ] = ambi_channel_definitions_amb( n_channels )
%AMBI_CHANNEL_DEFINITIONS_AMB() set up channel struct for an AMB file
% C = AMBI_CHANNEL_DEFINITIONS_AMB(n_channels) Sets up the channel
% definition struct for an AMB file with a certain number of channels.
%
%   n_channels is number of channels in AMB file
%
% AMB files use FMS channel order and and normalization.  Each channel
% count is associated with a unique horizontal and vertical order.
%
% Further info at:
%  http://members.tripod.com/martin_leese/Ambisonic/B-Format_file_format.html
%
% Number of channels	Malham notation	Soundfield type	Horizontal order Height order	Channels
%  3	h	horizontal	1	0	WXY
%  4	f	full-sphere	1	1	WXYZ
%  5	hh	horizontal	2	0	WXYUV
%  6	fh	mixed-order	2	1	WXYZUV
%  9	ff	full-sphere	2	2	WXYZRSTUV
%  7	hhh	horizontal	3	0	WXYUVPQ
%  8	fhh	mixed-order	3	1	WXYZUVPQ
% 11	ffh	mixed-order	3	2	WXYZRSTUVPQ
% 16	fff	full-sphere	3	3	WXYZRSTUVKLMNOPQ
    
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
    
%% set up the tables
    n = NaN;
    %          1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
    fuma.ho = [0 n 1 1 2 2 3 3 2  n  3  n  n  n  n  3];
    fuma.vo = [0 n 0 1 0 1 0 1 2  n  2  n  n  n  n  3];
    
    % same table for Travis HV scheme, included here for reference
    %trav.ho = [0 n 1 1 2 n 3 2 2  n  n  3  n  n  3  3];
    %trav.vo = [0 n 0 1 0 n 0 1 2  n  n  1  n  n  2  3];
    
    %% fill in struct
    if n_channels > 16 || isnan(fuma.ho(n_channels))
        error('invalid channel count for AMB file');
    else
        C = ambi_channel_definitions_fms(...
            fuma.ho(n_channels),fuma.vo(n_channels),...
            'AMB');
    end
end
