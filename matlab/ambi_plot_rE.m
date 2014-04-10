function [gca1e, gca2] = ambi_plot_rE( S, V, M, C, fig_title, mode, ...
        ele_min, ele_max )
    %ambi_plot_rE() produce plots of rE vs stimulus direction
    %   S is real speaker array struct
    %   V is virutal speaker array struct
    %   M is decoder matrix
    %   C is the channel definition struct
    %   mode selects various plots, see switch statement
    %
    % TODO: needs a major cleanup
    
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
    
    %% defaults
    if ~exist('fig_title', 'var') || isempty(fig_title)
        fig_title = strrep(S.name,'_',' ');
    end;
    if ~exist('mode','var') || isempty(mode)
        mode = 5;
    end;
    
    if ~exist('ele_min', 'var') || isempty(ele_min)
        ele_min = -88;
    end
    
    if ~exist('ele_max', 'var') || isempty(ele_max)
        ele_max = +88;
    end
    
    shaded_renderer = ~inOctave();
    
    fig_title_sanitized = strrep(fig_title, '_', ' ');
    %% girds
    n_phi = 45;     % number of vertical divisions
    n_theta = 90;   % number of horizontal divisions
    
    d_phi = pi/n_phi;  % delta phi
    d_theta = 2*pi/n_theta;  % delta theta
    
    switch mode
        case 1  % full sphere
            [geo.az, geo.el] = meshgrid(...
                linspace(...
                0+d_theta/2,...    % ~0    0
                2*pi-d_theta/2,... % 2pi 360
                n_theta), ...      % 90
                linspace(...
                pi/2+d_phi/2,...       %~ +pi/2  +90
                -pi/2-d_phi-d_phi/2,...%~ -pi/2  -90
                n_phi));               %~  45
        case 2  % ??
            [geo.az, geo.el] = meshgrid(...
                [-pi/90,pi/90], ...
                linspace(0,2*pi,2*n_phi));
        case 3  % Y-plane circle
            [geo.az, geo.el] = meshgrid(...
                linspace(0+d_theta/2,    pi-d_theta/2,  n_theta), ...
                linspace(pi/2+d_phi/2, -pi/2-d_phi-d_phi/2, n_phi));
        case 4  % left hemisphere
            [geo.az, geo.el] = meshgrid(...
                linspace(0,180,n_theta+1) * pi/180, ...
                ...%linspace(0+d_theta/2, pi-d_theta/2,  n_theta), ...
                linspace(pi/2+d_phi/2, -pi/2-d_phi+d_phi/2, n_phi));
        case 5
            geo = AzElGrid(-180:4:180-4, ele_min:4:ele_max);
    end
    
    if false
        d_omega = cos(geo.el) * d_phi * d_theta;
        
        geo.az = geo.az;
        geo.el = geo.el;
        geo.w  = d_omega / (4*pi);
        [geo.x, geo.y, geo.z] = sph2cart(geo.az, geo.el, 1);
    end
    
    %%  compute rE and rV
    geo.a = ambi_sample_Y_sph(geo.az(:), geo.el(:), C)';
    
    [rV, rE, P, E] = ambi_rVrE_Y(M, [S.x, S.y, S.z]', geo.a);
    
    %% grid plots
    ambi_plot_dir_error_grid([], rE, geo, S, V, 'rE', fig_title, fig_title_sanitized);
    
    ambi_plot_dir_error_grid([], rV, geo, S, V, 'rV', fig_title, fig_title_sanitized);
    
    %% decoder energy per Batke
    %    nominally for matching loudness of different decoders
    decoder_energy = sum( abs(M(:)).^2 );
    fprintf('\ndecoder energy = %d\n', decoder_energy);
    
    %% rV rE direction difference plot
    if true
        gcadd = figure();
        set(gcadd,'numbertitle','on','name', 'rV rE direction difference');
        imagesc( geo.az(1,:)*180/pi, geo.el(:,1)*180/pi,...
            reshape(ambi_dir_diff(rV.u,rE.u) .* 180/pi, size(geo.x)));
        axis('xy');
        xlabel('right<--- azimuth (deg) --->left');
        ylabel('elevation (deg)');
        caxis([0,10]);
        title_bold18(sprintf('%s\nrV rE Direction Difference',fig_title_sanitized));
        colorbar
        
        print(gcadd,'-dpng','-r100',...
            fullfile(ambi_decoders_dir(true),[fig_title '-rVrE-diff.png']));
    end
    
    
    %%  3x2 panel of rE plots
    % FIXME this messes up in Octave 3.6.4 on MacOS
    % some clues here
    %    http://octave.1599824.n4.nabble.com/FLTK-refresh-required-td4655874.html
    if true
        
        gca2=figure();
        
        figtitle(fig_title_sanitized, ...
            'fontsize', 16, 'fontweight', 'bold');
        
        set(gca2,'units','normalized','outerposition',[0 0 1 1]);
        set(gca2,'numbertitle','on','name',fig_title);
        %set(gca2,'LooseInset',get(gca,'TightInset'));
        set(gca2, 'PaperPositionMode', 'auto');
        
        %% magnitude of rE
        sp231=subplot(2,3,1);  % top, left plot
        %mask = geo.az>=0;
        
        re.xx = reshape(rE.xyz(1,:), size(geo.x));
        re.yy = reshape(rE.xyz(2,:), size(geo.y));
        re.zz = reshape(rE.xyz(3,:), size(geo.z));
        re.rr  = reshape(rE.r, size(geo.x));
        
        %mesh(re.xx,re.yy,re.zz,re.rr);
        surf_rE = surf(re.xx,re.yy,re.zz,re.rr);
        caxis([0,1]);
        
        % set up view
        label_cardinal_directions(1.2*max(re.rr(:)));
        
        title_bold18('mag and dir of rE on the sphere');
        
        set_surface_rendering(sp231,surf_rE, shaded_renderer);
        
        % bottom, left plot
        sp234=subplot(2,3,4);
        % FIXME, want image flipped left right.
        imagesc(geo.az(1,:)*180/pi, geo.el(:,1)*180/pi, re.rr);
        caxis([0,1]);
        xlabel('right<--- azimuth (deg) --->left');
        ylabel('elevation (deg)');
        %set(sp234,'XDir','reverse')
        colorbar;
        title_bold18('magnitude of rE vs. test direction');
        %refresh;
        
        %% angular error in degrees
        sp232=subplot(2,3,2);  % top middle plot
        geo.u = [geo.x(:)'; geo.y(:)'; geo.z(:)'];
        angle_err = reshape(ambi_dir_diff(rE.u, geo.u), size(geo.x));
        surf_angle_err = surf(geo.x, geo.y, geo.z, angle_err*180/pi);
        caxis([0,10]);
        label_cardinal_directions(1.2)
        title_bold18('rE angular error (degrees)');
        %refresh;
        
        set_surface_rendering(sp232,surf_angle_err, shaded_renderer)
        
        
        % bottom, middle plot
        sp235=subplot(2,3,5);
        imagesc(geo.az(1,:)*180/pi, geo.el(:,1)*180/pi, angle_err*180/pi);
        caxis([0,10]);
        xlabel('right<--- azimuth (deg) --->left');
        ylabel('elevation (deg)');
        colorbar;
        title_bold18('rE angular error (degrees)');
        %refresh;
        
        %% Energy by source direction (not preceived direction!)
        sp236=subplot(2,3,6);  % bottom right plot
        E2 = reshape(E, size(geo.x));
        % find the energy closest to straight ahead
        E2_100 = squeeze(E2( ...
            abs(geo.az)==min(abs(geo.az(:))) & ...
            abs(geo.el)==min(abs(geo.el(:)))));
        E2 = 10 * log10(E2./E2_100(1));
        %set (sp236, 'zlim', [0 1]);
        imagesc(geo.az(1,:)*180/pi, geo.el(:,1)*180/pi, E2);
        xlabel('right<--- azimuth (deg) --->left');
        ylabel('elevation (deg)');
        colorbar;
        caxis([-6,6]);
        title_bold18('Energy gain vs. test dir');
        %refresh;
        
        %
        sp233= subplot(2,3,3); % top right plot
        %re.mmdb=10*log10(re.mm);
        %surf(geo.x.*re.mm, geo.y.*re.mm, geo.z.*re.mm, 85+10*log10(re.mm));
        E2pos = E2-min(E2(:)) + 6;
        %surf(geo.x.*E2pos, geo.y.*E2pos, geo.z.*E2pos, E2);
        surf_Egain = surf(...
            E2pos .* reshape(rE.u(1,:),size(geo.x)), ...
            E2pos .* reshape(rE.u(2,:),size(geo.y)), ...
            E2pos .* reshape(rE.u(3,:),size(geo.z)), ...
            E2);
        %caxis([-6,6]);
        
        label_cardinal_directions(1.2*max(E2(:)));
        
        title_bold18('mag and dir of Energy gain');
        
        set_surface_rendering(sp233,surf_Egain, shaded_renderer);
        
        
        
        %% figure title
        
        if false
            figtitle(strrep(fig_title, '_', '\_'), ...
                'fontsize', 16, 'fontweight', 'bold');
        end
        
        
        %%
        if inOctave
            % axis([sp231,sp232,sp233],'equal');  % doesn't work in Octave
            axis(sp231,'equal');
            axis(sp232,'equal');
            axis(sp233,'equal');
        else
            axis([sp231,sp232,sp233],'equal','vis3d');
            axis([sp234,sp235,sp236],'xy');
        end
        %refresh;
        
        %saveas(gca2,[fig_title '-spheres.pdf']);
        %orient(gca2,'landscape');
        print(gca2,'-dpng','-r100',...
            fullfile(ambi_decoders_dir(true),[fig_title '-rE-spheres.png']));
        %refresh;
        
    end
    % end of  3x2 panel of rE plots
    
    % try some plots for Paul
    ambi_plot_rV(rV,P, geo,fig_title, fig_title_sanitized);
end

function title_bold18(str)
    if inOctave()
        title(str);
    else
        title(str, 'FontSize', 18, 'FontWeight', 'bold');
    end
end

function label_cardinal_directions(radius)
    hold_state = ishold();
    if ~hold_state, hold on; end;
    qs = eye(3);
    qrad = 1.5;
    quiver3(-qrad*qs(:,1),-qrad*qs(:,2),-qrad*qs(:,3), ...
        qrad*qs(:,1), qrad*qs(:,2), qrad*qs(:,3), 2);
    
    radius=qrad;
    text(radius,0,0,  'Front', 'HorizontalAlignment', 'center');
    text(-radius,0,0, 'Back',  'HorizontalAlignment', 'center');
    text(0,radius,0,  'Left',  'HorizontalAlignment', 'center');
    text(0,-radius,0, 'Right', 'HorizontalAlignment', 'center');
    text(0,0,radius,  'Top',   'HorizontalAlignment', 'center');
    text(0,0,-radius, 'Bottom','HorizontalAlignment', 'center');
    hold off
    if ~hold_state, hold off; end;
end

function set_surface_rendering( axis, obj, shaded_renderer )
    if shaded_renderer
        shading(axis,'interp');
        set(obj, ... %findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','reverselit' ) %'unlit')
        %lighting phong
        camlight('left');
        %lightangle(-45,30)
        %set(figure1,'Renderer','opengl')
    end
end


function [ ] = ambi_plot_rV( rE, E, geo, fig_title, fig_title_sanitized )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    %%  3x2 panel of rE plots
    % FIXME this messes up in Octave 3.6.4 on MacOS
    % some clues here
    %    http://octave.1599824.n4.nabble.com/FLTK-refresh-required-td4655874.html
    
    shaded_renderer = ~inOctave();
    if true
        
        gca2=figure();
        
        figtitle(fig_title_sanitized, ...
            'fontsize', 16, 'fontweight', 'bold');
        
        set(gca2,'units','normalized','outerposition',[0 0 1 1]);
        set(gca2,'numbertitle','on','name',fig_title);
        %set(gca2,'LooseInset',get(gca,'TightInset'));
        set(gca2, 'PaperPositionMode', 'auto');
        
        %% magnitude of rV
        sp231=subplot(2,3,1);  % top, left plot
        %mask = geo.az>=0;
        
        re.xx = reshape(rE.xyz(1,:), size(geo.x));
        re.yy = reshape(rE.xyz(2,:), size(geo.y));
        re.zz = reshape(rE.xyz(3,:), size(geo.z));
        re.rr  = reshape(rE.r, size(geo.x));
        
        %mesh(re.xx,re.yy,re.zz,re.rr);
        surf_rE = surf(re.xx,re.yy,re.zz,re.rr);
        caxis([0,1]);
        
        % set up view
        label_cardinal_directions(1.2*max(re.rr(:)));
        
        title_bold18('mag and dir of rV on the sphere');
        
        set_surface_rendering(sp231,surf_rE, shaded_renderer);
        
        % bottom, left plot
        sp234=subplot(2,3,4);
        % FIXME, want image flipped left right.
        imagesc(geo.az(1,:)*180/pi, geo.el(:,1)*180/pi, re.rr);
        caxis([0,1]);
        xlabel('right<--- azimuth (deg) --->left');
        ylabel('elevation (deg)');
        %set(sp234,'XDir','reverse')
        colorbar;
        title_bold18('magnitude of rV vs. test direction');
        %refresh;
        
        %% angular error in degrees
        sp232=subplot(2,3,2);  % top middle plot
        geo.u = [geo.x(:)'; geo.y(:)'; geo.z(:)'];
        angle_err = reshape(ambi_dir_diff(rE.u, geo.u), size(geo.x));
        surf_angle_err = surf(geo.x, geo.y, geo.z, angle_err*180/pi);
        caxis([0,10]);
        label_cardinal_directions(1.2)
        title_bold18('rV angular error (degrees)');
        %refresh;
        
        set_surface_rendering(sp232,surf_angle_err, shaded_renderer)
        
        
        % bottom, middle plot
        sp235=subplot(2,3,5);
        imagesc(geo.az(1,:)*180/pi, geo.el(:,1)*180/pi, angle_err*180/pi);
        caxis([0,10]);
        xlabel('right<--- azimuth (deg) --->left');
        ylabel('elevation (deg)');
        colorbar;
        title_bold18('rV angular error (degrees)');
        %refresh;
        
        %% Pressure by source direction (not preceived direction!)
        if true
            sp236=subplot(2,3,6);  % bottom right plot
            E2 = reshape(E, size(geo.x));
            % find the Pressure closest to straight ahead
            E2_100 = squeeze(E2( ...
                abs(geo.az)==min(abs(geo.az(:))) & ...
                abs(geo.el)==min(abs(geo.el(:)))));
            E2 = 10 * log10(E2./E2_100(1));
            %set (sp236, 'zlim', [0 1]);
            imagesc(geo.az(1,:)*180/pi, geo.el(:,1)*180/pi, E2);
            xlabel('right<--- azimuth (deg) --->left');
            ylabel('elevation (deg)');
            colorbar;
            caxis([-6,6]);
            title_bold18('Pressure gain vs. test dir');
            %refresh;
            
            %
            sp233= subplot(2,3,3); % top right plot
            %re.mmdb=10*log10(re.mm);
            %surf(geo.x.*re.mm, geo.y.*re.mm, geo.z.*re.mm, 85+10*log10(re.mm));
            E2pos = E2-min(E2(:)) + 6;
            %surf(geo.x.*E2pos, geo.y.*E2pos, geo.z.*E2pos, E2);
            surf_Egain = surf(...
                E2pos .* reshape(rE.u(1,:),size(geo.x)), ...
                E2pos .* reshape(rE.u(2,:),size(geo.y)), ...
                E2pos .* reshape(rE.u(3,:),size(geo.z)), ...
                E2);
            caxis([-6,6]);
            
            label_cardinal_directions(1.2*max(E2(:)));
            
            title_bold18('mag and dir of Pressure gain');
            
            set_surface_rendering(sp233,surf_Egain, shaded_renderer);
        end
        
        
        
        %% figure title
        
        if false
            figtitle(strrep(fig_title, '_', '\_'), ...
                'fontsize', 16, 'fontweight', 'bold');
        end
        
        
        %%
        if inOctave
            % axis([sp231,sp232,sp233],'equal');  % doesn't work in Octave
            axis(sp231,'equal');
            axis(sp232,'equal');
            axis(sp233,'equal');
        else
            axis([sp231,sp232,sp233],'equal','vis3d');
            axis([sp234,sp235,sp236],'xy');
        end
        %refresh;
        
        %saveas(gca2,[fig_title '-spheres.pdf']);
        %orient(gca2,'landscape');
        print(gca2,'-dpng','-r100',...
            fullfile(ambi_decoders_dir(true),[fig_title '-rV-spheres.png']));
        %refresh;
        
    end
    % end of  3x2 panel of rE plots
end



