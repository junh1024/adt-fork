function [V, V2R, Sa, H] = ambi_allrad_V2R( S, C, imag_spkr )
    %AMBI_ALLRAD_V2R() VBAP panning gains for virtual to real array
    %   computes convex-hull and does ray intersection to derive VBAP gains
    %   for the virtual to real speaker array, including any imaginary
    %   speakers.
    %  S is speaker array struct
    %  C is ambisonic channel definition struct
    %  imag_spkr is Nx3 array of locations of imaginary speakers
    % return values:
    %  V the virtual speaker array
    %  V2R is the matrix that map the virtual solution to the real array
    %  Sa is the augmented speaker array (real + imaginary speakers)
    %  H is the convex hull of Sa
    %
    % For more on spherical designs, see:
    %  http://www2.research.att.com/~njas/sphdesigns/
    %
    % AllRad Reference:
    %  [1]	F. Zotter and M. Frank, ?All-Round Ambisonic Panning and
    %       Decoding,? J. Audio Eng Soc, vol. 60, no. 10, pp. 807?820, Nov.
    %       2012.
    %
    % VBAP references
    %  [2]	H. Choi, "An Alternative Implementation of VBAP with Graphical
    %       Interface for Sound Motion Design," presented at the 18th
    %       International Conference on Auditory Display, Atlanta, 2012.
    %  [3]	V. Pulkki, "Virtual Sound Source Positioning Using Vector Base
    %       Amplitude Panning," J. Audio Eng Soc, vol. 45, no. 6,
    %       pp. 456?466, Jun. 1997.
    %  [4]	V. Pulkki, "Compensating displacement of amplitude-panned
    %       virtual sources," presented at the AES 22nd International
    %       Conference on Virtual, Synthetic and Entertainment Audio,
    %       Espoo, 2002.
    
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
    % $Id: ambi_allrad_V2R.m 26401 2013-11-26 05:25:50Z heller $
    
    %% supply defaults to make it earier to use debugger
    if nargin == 0
        S = SPKR_ARRAY_BING_2013FEB12();
        N = 3;  % ambisonic order
        C = ambi_channel_definitions_fms(N,N);
        imag_spkr = [0 0 -1/2];
    else
        N = max(C.h_order,C.v_order);
    end
    
    %% augment real array with an additional imaginary speaker, if needed
    if isempty(imag_spkr)
        Sa = S;
        % all speakers are real
        Sa.real = true(size(Sa.x));
    else
        
        Sa.x = [S.x; imag_spkr(:,1)];
        Sa.y = [S.y; imag_spkr(:,2)];
        Sa.z = [S.z; imag_spkr(:,3)];
        
        % Sa.real = true for real speakers, false for imaginary
        Sa.real=false(size(Sa.x));
        Sa.real(1:numel(S.x))=true;
        
        % fill in the other fields in S, so plotting works correctly.
        Sa.id = S.id;
        Sa.name = S.name;
        
        [Sa.az, Sa.el, Sa.r] = cart2sph(Sa.x, Sa.y, Sa.z);
        % put in correct radius for real speakers
        Sa.r(Sa.real) = S.r;
    end
    
    
    
    %% compute convex hull of augmented array
    if true %inOctave()
        % Octave convhull is 2-D only!
        H = convhulln([Sa.x,Sa.y,Sa.z]);
    else
        % MATLAB 2013a docs say use this for 2-D or 3-D
        %  doesn't work in 2010b
        H = convhull(Sa.x,Sa.y,Sa.z);
    end
    
    %% TODO: check for >90deg between speakers
    
    %% create 3-D virtual speaker array according to spherical t design
    min_t = 2*N + 1; % minimum "t" for given order
    d=3; t = 13;
    
    if (t < min_t)
        warning('t is less than min_t, t=%i, min_t=%i', t, min_t);
    end
    
    % load spherical t design
    %V = spherical_t_design(d,100,t);
    V = spherical_t_design(d,240,21);
    
    % virtual to real gains matrix
    V2R = zeros(size(Sa.x,1),size(V.x,1));
    
    % find triad and gains for each of the virtual speakers
    o = [0,0,0]; % origin
    Vdirs = [V.x, V.y, V.z];
    V.xyz = zeros(size(Vdirs));
    for i = 1 : numel(V.x)    % virtual speakers
        %d  = [V.x(i), V.y(i), V.z(i)];
        for j = 1 : size(H,1)  % faces of conv hull of real and img. spkrs
            p0 = [Sa.x(H(j,1)), Sa.y(H(j,1)), Sa.z(H(j,1))];
            p1 = [Sa.x(H(j,2)), Sa.y(H(j,2)), Sa.z(H(j,2))];
            p2 = [Sa.x(H(j,3)), Sa.y(H(j,3)), Sa.z(H(j,3))];
            
            % flag = true if ray intersects triangle
            % b_u & _v are the barycentric coordinate of the intersection
            % b_t is distance along ray of intersection
            [flag, b_u, b_v, b_t] = ...
                rayTriangleIntersection(o, Vdirs(i,:), p0, p1, p2);
            b_w = 1 - b_u - b_v;
            
            % check if we have a good point
            if flag && b_t > 0
                %display([i,j,b_u,b_v,b_t]);
                V.tri(i)= j;    % face #
                
                % check barycentric coordinates
                Vxyz = b_w*p0 + b_u*p1 + b_v*p2;
                
                % fill in gains, normalize for energy
                V2R(H(j,:),i) = [b_w b_u b_v] ...
                    / sqrt([b_w b_u b_v] * [b_w b_u b_v]');
                break
            end
        end
        V.xyz(i,:) = Vxyz;
    end
    
end

