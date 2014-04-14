function [] = ambi_plot_speakers(S, H, V, figure_title)
    
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
    
    % reuse the figures for the speaker plots
    persistent gcaV gcaP

    if ~exist('figure_title', 'var') || isempty(figure_title)
        figure_title = sprintf('Speaker Locations for %s', ...
            strrep(S.name, '_', ' '));
    end
    
    if exist('V', 'var') && isstruct(V) && isfield(V,'xyz')
        % allrad
        if isempty(gcaV) || ~ishandle(gcaV)
            gca1 = figure();
            gcaV = gca1;
        else
            gca1 = gcaV;
            figure(gca1);
        end
    else
        % pinv
        if isempty(gcaP) || ~ishandle(gcaP)
            gca1 = figure;
            gcaP = gca1;
        else
            gca1 = gcaP;
            figure(gca1);
        end
    end
    
    
    %% plot speaker locations  FIXME FIXME
    
    if ~isfield(S,'real')
        S.real = true(size(S.x));
    end
    
    %Sr_norm = 3/4; %* S.r/mean(S.r(:));
    Sr_norm = 0.8*min(S.r(S.real));
    
    plot3(S.x*Sr_norm, S.y*Sr_norm, S.z*Sr_norm, ...
        'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 8);
    hold on
    
    % plot the actual locations of the real ones with a star
    % and label them
    
    plot3(S.x(S.real).*S.r(S.real), ...
        S.y(S.real).*S.r(S.real), ...
        S.z(S.real).*S.r(S.real), ...
        'gs', 'MarkerFaceColor', 'k', 'MarkerSize', 20);
    text(S.x(S.real).*S.r(S.real), ...
        S.y(S.real).*S.r(S.real), ...
        S.z(S.real).*S.r(S.real), ...
        cellfun(@(s)['   ',s],S.id,'UniformOutput', false),...
        'HorizontalAlignment', 'left', 'FontSize', 18);
    
    % put a + at the origin
    plot3(0,0,0,'k+', 'MarkerFaceColor', 'k', 'MarkerSize', 10);
    
    %% if we have a convex hull plot it
    if exist('H','var') && ~isempty(H)
        if numel(H) < 2
            H = convhulln([S.x(:), S.y(:), S.z(:)]);
        end
        if false %~inOctave()
            % octave now has trisurf(), but keep code if breaks in the future
            for i = 1:size(H,1)
                j = H(i, [1 2 3 1]);
                patch(S.x(j), S.y(j), S.z(j), rand(), 'FaceAlpha', 0.6);
            end
        else
            trisurf(H, S.x*Sr_norm, S.y*Sr_norm, S.z*Sr_norm, rand(size(S.x)),...
                'FaceAlpha', 0.6);
            axis equal
        end
    end
    
    %% if we have virtual speakers plot them and the barycentric coordinates
    if exist('V', 'var') && isstruct(V) && isfield(V,'xyz')
        if false
            quiver3(V.x, V.y, V.z, -V.x, -V.y, -V.z, 0.3, ...
                'bo', 'MarkerFaceColor','b', 'MarkerSize',4);
        end
        hold on
        plot3(V.xyz(:,1)*Sr_norm,...
            V.xyz(:,2)*Sr_norm,...
            V.xyz(:,3)*Sr_norm,...
            'g*');
    end
    
    %% make nice speaker stands the way Furse does.
    zz = min(S.z .* S.r) - .2;
    for i = 1:length(S.x)
        line(...
            [ 0, S.x(i)*S.r(i), S.x(i)*S.r(i) ], ...
            [ 0, S.y(i)*S.r(i), S.y(i)*S.r(i) ], ...
            [ zz,  zz,          S.z(i)*S.r(i) ]);
    end
    
    hold off
    
    % set up view
    %  Struth!  Octave needs 'center' to be lower case.
    if true
        dr = 1.4;
        text( dr*max(S.x(:).*S.r(:)), 0, 0, 'Front', 'HorizontalAlignment', 'center');
        text( dr*min(S.x(:).*S.r(:)), 0, 0, 'Back', 'HorizontalAlignment', 'center');
        text( 0, dr*max(S.y(:).*S.r(:)), 0, 'Left', 'HorizontalAlignment', 'center');
        text( 0, dr*min(S.y(:).*S.r(:)), 0, 'Right', 'HorizontalAlignment', 'center');
        text( 0, 0, dr*max(S.z(:).*S.r(:)), 'Top', 'HorizontalAlignment', 'center');
        text( 0, 0, dr*min(S.z(:).*S.r(:)), 'Bottom', 'HorizontalAlignment', 'center');
    end
    
    
    % do fancy stuff for MATLAB
    if ~inOctave()
        view(3), axis equal on tight vis3d; camzoom(1.2);
        grid on
        %box on
        colormap(spring);
        rotate3d on
        %set(gca1,'units','normalized','outerposition',[0 0 1 1]);
        set(gca1,'numbertitle','on','name',[ S.name ' speaker directions']);
        set(gca1,'PaperPositionMode', 'auto');
        ntitle(figure_title, 'fontsize', 14, 'fontweight', 'bold');
    end
    
    
end
