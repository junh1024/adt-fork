function [ S ] = ambi_mat2spkr_array(A, coord_code, unit_code, name, ids, origin_xyz)
    %AMBI_MAT2SPKR_ARRAY convert matrix of speaker coordinates to SPKR_ARRAY struct
    %   A is nx3 matrix of speaker coordinates
    %     if A is a string, read coordinates from file
    %
    %   coord_code identifies each coordinate (default: AER)
    %     A, E, R = azimuth, elevation, radius
    %     N = zeNith angle, angle fron North pole (can't use Z)
    %     X, Y, Z = cartesian coordinates
    %     can be in any order and mixed, e.g. ARZ for cylindrical.
    %
    %   unit_code indentifes units for each coordinate (default: DDM)
    %     D = degrees
    %     R = radians
    %     G = grads
    %     C = centimeters
    %     M = meters
    %     F = feet
    %     I = inches
    %
    %   name optional name of speaker array, defaults to filename
    %
    %   See also AMBDEC2SPKR_ARRAY, RUN_ALLRAD_EXAMPLE_IEM_CUBE, IMPORTDATA
    
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
    % $Id: ambi_mat2spkr_array.m 26385 2013-08-18 20:43:22Z heller $
    
    %% argument defaults
    if ~exist('coord_code','var'), coord_code = 'AER'; end;
    if ~exist('unit_code','var'),  unit_code  = 'DDM'; end
    
    if ~exist('origin_xyz', 'var')
        origin_xyz = zeros(3,1);
    else
        warning('Origin shift not implemented yet.');
    end
    
    % when A is a string, read coordinates from file
    if ischar(A)
        if ~exist('name','var')
            [junk1, name, junk2] = fileparts(A); 
        end
        A = importdata(A);
    end
    
    if exist('name', 'var')
        S.name = name;
    end
    
    %%
    
    A = double(A);
    
    %% unit conversions
    for iCol = 1:numel(unit_code)
        switch unit_code(iCol)
            case { 'd', 'D' }  % degrees
                A(:,iCol) = A(:,iCol) * pi/180;
            case { 'g', 'G' }  % gradians (gon
                A(:,iCol) = A(:,iCol) * pi/200;
            case { 'r', 'R' }  % radians
                %nada
            case { 'c', 'C' }  % centimeters
                A(:,iCol) = A(:,iCol) / 100;
            case { 'f', 'F' }  % feet
                A(:,iCol) = A(:,iCol) * 12*2.54/100;
            case { 'i', 'I' }  % inches
                A(:,iCol) = A(:,iCol) * 2.54/100;
            case { 'm', 'M' }  % meters
                %nada
            otherwise
                error('unknown unit_code: %c', unit_code(iCol));
        end
    end
    
    %% coordinate decoding
    AA = zeros(size(A,1),3);
    Ac = '   ';
    for iCol = 1:numel(coord_code)
        switch coord_code(iCol)
            case {'x', 'X'}  % Cartesian X
                AA(:,1) = A(:,iCol);
                Ac(1)='x';
            case {'y', 'Y'}  % Cartesian Y
                AA(:,2) = A(:,iCol);
                Ac(2)='y';
            case {'z', 'Z'}  % Cartesian Z
                AA(:,3) = A(:,iCol);
                Ac(3)='z';
            case {'a', 'A'}  % spherical or cylindrical azimuth
                AA(:,1) = A(:,iCol);
                Ac(1) = 'a';
            case {'e', 'E'}  % spherical elevation
                AA(:,3) = A(:,iCol);
                Ac(3) = 'e';
            case {'n', 'N'}  % spherical zenith angle
                AA(:,3) = pi/2 - A(:,iCol);
                Ac(3) = 'e';
            case {'r', 'R'}; % spherical radius
                AA(:,2) = A(:,iCol);
                Ac(2) = 'r';
            otherwise
                error('unknown coord_code: %c', coord_code(iCol));
        end
    end
    
    %% coordinate untangling
    %    note that S.x, S.y, S.z are the components of a unit vector
    %    (FIXME should change to ux, uy, uz at some point)
    switch Ac
        case 'xyz' % cartesian
            % AA = AA - origin_xyz(ones(length(AA),1),:);
            
            [S.az, S.el, S.r] = cart2sph(AA(:,1),AA(:,2),AA(:,3));
            [S.x, S.y, S.z] = sph2cart(S.az, S.el, 1);
        case 'are' % spherical
            % first a round trip to Cartisian and back to put angle in
            % principle range, to fix error reported by Paul Power
            [tx, ty, tz] = sph2cart(AA(:,1), AA(:,3), AA(:,2));
            [S.az, S.el, S.r] = cart2sph(tx, ty, tz);
            % FIXME -- make sure az and el are in principle range FIXME
            %[S.az, S.r, S.el] = deal(AA(:,1), AA(:,2), AA(:,3));
            [S.x, S.y, S.z] = sph2cart(S.az, S.el, 1);
        case 'arz' % cylindrical
            [S.x, S.y, S.z] = pol2cart(AA(:,1), AA(:,2), AA(:,3));
            [S.az, S.el, S.r] = cart2sph(S.x, S.y, S.z);
            [S.x, S.y, S.z] = sph2cart(S.az, S.el, 1);
        otherwise
            error('ambigous coordinate combination: %s', Ac);
    end
    
    %% speaker IDs
    if exist('ids', 'var')
        S.id = ids;
    else
        % gensym speaker IDs
        S.id = arrayfun(@(i)sprintf('S%02i', i), 1:numel(S.x),...
            'UniformOutput', false);
    end
    
end
