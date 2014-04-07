function [speaker_array srf speaker_names] = ambisonic_rigs(rig_name, varargin)
    % [speaker_array srf speaker_names] = ambisonic_rigs( rig_name, parameters )

    % returns positions of speakers for standard ambisonic playback arrays
    % call with rig name only to get info about additional arguments
    %  Definitions and speaker names are taken from
    %    [1] Gerzon, Michael A., "Practical Periphony: The Reproduciton of
    %        Full-Sphere Sound"  AES Preprint 1571; 65th AES Convention, London.
    %    [2] Furse, Richard W.E., "First and Second Order Ambisonic
    %        Decoding Equations"
    %        http://www.muse.demon.co.uk/ref/speakers.html


    switch lower(rig_name)

        case 'mono'
            speaker_array = [ 1 0 0 ];
            srf = 'c';
        case 'stereo'
            speaker_array = [ 0 1 0; 0 -1 0 ];
            srf = 'c';
        case 'square'
            speaker_array = [ 45 0; 135 0; -135 0; -45 0 ];
            srf = 'sd';
        case 'rectangle'
            if nargin < 2
                error('Rig=%s needs one argument:\n\t angle between front speakers in degrees',...
                    rig_name);
            else
                %  phi is angle between front speakers in degrees
                phi = varargin{1};
                speaker_array = [ phi/2 0; 180-phi/2 0; 180+phi/2 0; -phi/2 0 ];
                srf = 'sd';
                speaker_names = { 'LF', 'LR', 'RR', 'RF' };
            end

        case 'hexagon'
            [speaker_array srf] = ...
                ambisonic_rigs('polygon', 6, 30);
            speaker_names = { 's1' 's2' 's3' 's4' 's5' 's6' };

        case 'octagon1'
            [speaker_array srf] = ...
                ambisonic_rigs('polygon', 8, 22.5);
            speaker_names = { 's1' 's2' 's3' 's4' 's5' 's6' 's7' 's8' };
        case 'octagon2'
            [speaker_array srf] = ...
                ambisonic_rigs('polygon', 8, 0);
            speaker_names = { 's1' 's2' 's3' 's4' 's5' 's6' 's7' 's8' };

        case {'surround1', 'surround', '5.1', 'itu'}
            speaker_array = [ 0 0 1; 30 0 1; 120 0 1; -120 0 1; -30 0 1 ];
            srf = 'sd';
            speaker_names = {'C' 'L' 'LS' 'RS' 'R'};

        case 'cube'
            [speaker_array srf] = ...
                ambisonic_rigs('cuboid', 1, 1, 1);

        case 'lateral-birectangle'
            if nargin < 3
                error('Rig=%s needs two arguments:\n\t front-angle, side-angle (degrees)',...
                    rig_name);
            else
                fa = varargin{1}/2;
                sa = varargin{2}/2;

                speaker_array = [
                    fa 0 1; -fa 0 1; fa-180 0 1; 180-fa 0 1;
                    90 sa 1; 90 -sa 1; 270 sa 1; 270 -sa 1];
                srf = 'sd';
                speaker_names = {'LF', 'RF', 'RR', 'LR', 'LU', 'LD', 'RU', 'RD'};
            end

        case 'cuboid'
            if nargin < 4
                error('Rig=%s needs three arguments:\n\t width, length, and height',...
                    rig_name);
            else
                x = varargin{1}/2;
                y = varargin{2}/2;
                z = varargin{3}/2;

                speaker_array = [
                    x y -z; x -y -z; -x -y -z; -x y -z; ...
                    x y +z; x -y +z; -x -y +z; -x y +z ];
                srf = 'c';
                speaker_names = {
                    'LFD' 'RFD' 'RBD' 'LBD' ...
                    'LFU' 'RFU' 'RBU' 'LBU' };

            end

        case 'octahedron'
            if nargin < 4
                error('Rig=%s needs three arguments:\n\t width, length, and height',...
                    rig_name);
            else
                x = varargin{1}/2;
                y = varargin{2}/2;
                z = varargin{3}/2;

                speaker_array = [
                    x 0 z; -x 0 z; -x 0 -z; x 0 -z; ...
                    0 y 0; 0 -y 0 ];
                srf = 'c';
                speaker_names = {
                    'FU' 'BU' 'BD' 'FD' ...
                    'L' 'R' };

            end

        case 'icosahedron' %'dodecahedron'
            speaker_array = [
                0.0000,0.0000,1.0000;
                0.0000,0.0000,-1.0000;
                0.7236,0.5257,0.4472;
                -0.7236,-0.5257,-0.4472;
                0.7236,-0.5257,0.4472;
                -0.7236,0.5257,-0.4472;
                -0.2764,0.8507,0.4472;
                0.2764,-0.8507,-0.4472;
                -0.2764,-0.8507,0.4472;
                0.2764,0.8507,-0.4472;
                -0.8944,0.0000,0.4472;
                0.8944,0.0000,-0.4472];
            srf = 'c';
            
        case 'dodecahedron'
            %  http://en.wikipedia.org/wiki/Dodecahedron
            tau = (1+sqrt(5))/2;  %golden ratio
            speaker_array = [
                1,1,1;
                1,1,-1;
                1,-1,1;
                1,-1,-1;
                -1,1,1;
                -1,1,-1;
                -1,-1,1;
                -1,-1,-1;
                0,1/tau, tau;
                0,-1/tau, tau;
                0, 1/tau, -tau;
                0,-1/tau, -tau;
                1/tau, tau, 0;
                1/tau,-tau, 0;
                -1/tau,tau, 0;
                -1/tau,-tau, 0;
                tau, 0, 1/tau;
                tau, 0,-1/tau;
                -tau, 0, 1/tau;
                -tau, 0,-1/tau] ./ sqrt(3);
            srf = 'c';

        case 'bubble'
            speaker_array = zeros(24,3);
            i_spkr = 1;
            r = 132 * 0.0254; % inches to meters
            for ele = {0, pi/6, pi/3}
                angle = pi/8;
                for i = 1:8
                    speaker_array(i_spkr,:) = [ angle, ele{1}, r ];
                    angle = angle - pi/4;
                    i_spkr = i_spkr + 1;
                end
            end
            srf = 'sr';
            
        case 'bubble-idealized'  % 3D center at 82 inches.
            speaker_array = zeros(24,3);
            i_spkr = 1;
            r = 132 * 0.0254; % inches to meters
            for ele = {-0.3960, 0, 0.3960}
                angle = pi/8;
                for i = 1:8
                    speaker_array(i_spkr,:) = [ angle, ele{1}, r ];
                    angle = angle - pi/4;
                    i_spkr = i_spkr + 1;
                end
            end
            srf = 'sr';
            
            
        case 'bubble-existing'  % 3D center at 82 inches.
            speaker_array = zeros(24,3);
            i_spkr = 1;
            r = 132 * 0.0254; % inches to meters
            for ele = {-0.3960, -0.0096, 0.3960}
                angle = pi/8;
                for i = 1:8
                    speaker_array(i_spkr,:) = [ angle, ele{1}, r ];
                    angle = angle - pi/4;
                    i_spkr = i_spkr + 1;
                end
            end
            srf = 'sr';
                
        case 'bubble-emb'  % 3D center at 82 inches.
            speaker_array = zeros(24,3);
            i_spkr = 1;
            r = 132 * 0.0254; % inches to meters
            for ele = {-0.4324, 0.0247, 0.4324}
                angle = pi/8;
                for i = 1:8
                    speaker_array(i_spkr,:) = [ angle, ele{1}, r ];
                    angle = angle - pi/4;
                    i_spkr = i_spkr + 1;
                end
            end
            srf = 'sr';
            
        case 'bubble-nd-43.3'  % 3D center at 82 inches.
            speaker_array = zeros(24,3);
            i_spkr = 1;
            r = 132 * 0.0254; % inches to meters
            for ele = {-0.1178, 0.3330, 0.7152}
                angle = pi/8;
                for i = 1:8
                    speaker_array(i_spkr,:) = [ angle, ele{1}, r ];
                    angle = angle - pi/4;
                    i_spkr = i_spkr + 1;
                end
            end
            srf = 'sr';
            
            
        case 'bubble-nd-60'  % 3D center at 82 inches.
            speaker_array = zeros(24,3);
            i_spkr = 1;
            r = 132 * 0.0254; % inches to meters
            for ele = {-0.2427, 0.1903, 0.5934}
                angle = pi/8;
                for i = 1:8
                    speaker_array(i_spkr,:) = [ angle, ele{1}, r ];
                    angle = angle - pi/4;
                    i_spkr = i_spkr + 1;
                end
            end
            srf = 'sr';
            
            
        case 'bubble-hack'
            e = varargin{1};
            speaker_array = zeros(16,3);
            i_spkr = 1;
            r = 132 * 0.0254; % inches to meters
            for ele = {-e, e}
                angle = pi/8;
                for i = 1:8
                    speaker_array(i_spkr,:) = [ angle, ele{1}, r ];
                    angle = angle - pi/4;
                    i_spkr = i_spkr + 1;
                end
            end
            srf = 'sr';
            
        case {'rhombicuboctahedron', '24'}
            vv = [1, 1, 1+sqrt(1+sqrt(2))];
            vv = vv / sqrt( vv * vv'); % normalize
            s = unique(perms( vv ), 'rows');
            
            speaker_array = [
                s; 
                s(:,1), s(:,2), s(:,3)*-1;
                s(:,1), s(:,2)*-1, s(:,3);
                s(:,1), s(:,2)*-1, s(:,3)*-1;
                s(:,1)*-1, s(:,2), s(:,3);
                s(:,1)*-1, s(:,2), s(:,3)*-1;
                s(:,1)*-1, s(:,2)*-1, s(:,3);
                s(:,1)*-1, s(:,2)*-1, s(:,3)*-1 ];

            
            srf = 'c';
            
        case {'tetrahedron', '4'}
            speaker_array = [
                 1,  1,  1;  % front-left-up
                -1,  1, -1;  % back-left-down
                -1, -1,  1;  % back-right-down
                 1, -1, -1   % front-right-down
                 ];
             srf = 'c';
             speaker_names = { 'FLU', 'BLD', 'BRD', 'FRD' };

        case 'polygon'
            if nargin < 3
                error('Rig=%s needs two arguments:\n\t number of speakers, and start angle in degrees',...
                    rig_name);
            else

                nspkrs = varargin{1};   % number of speakers
                angle  = varargin{2};   % start angle in degrees
                speaker_array = zeros(nspkrs,3);
                for i = 1:nspkrs
                    speaker_array(i,:) = [ angle 0 1 ];
                    angle = angle + 360/nspkrs;
                end
                srf = 'sd';
            end


        otherwise
            error('Unknown rig_name = %s\n', rig_name );


    end
end
