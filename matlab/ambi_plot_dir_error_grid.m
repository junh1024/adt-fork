function [gca] = ambi_plot_dir_error_grid(gca, re, geo, S, V, var_name, ...
                                          fig_title, fig_title_sanitized)
    %%  rE direction error figure
    
    if ~exist('gca', 'var') || isempty(gca)
        gca = figure;
    end
    
    if ~ inOctave()
        set(gca,'units','normalized','outerposition',[0 0 1 1]);
        set(gca,'numbertitle','on','name',fig_title_sanitized);
        set(gca,'PaperPositionMode', 'auto');
    end
    
%    set(gca,'XDir','reverse')
    
    figtitle(fig_title_sanitized, 'fontsize', 16, 'fontweight', 'bold');
    
    [re.az, re.el] = cart2sph(re.u(1,:), re.u(2,:), re.u(3,:));
    
    re.az = reshape(re.az, size(geo.az));
    re.el = reshape(re.el, size(geo.az));
    % unwrap re.az
    if true
        fixup = (re.az-geo.az)>pi;
        re.az(fixup)=re.az(fixup)-(2*pi);
        fixup = (re.az-geo.az)<-pi;
        re.az(fixup)=re.az(fixup)+(2*pi);
    end
    
    
    i = 1:size(re.az,1);
    %     plot(re.az(i,:)'*180/pi, ... % X
    %         re.el(i,:)'*180/pi);     % Y
    %
    %     hold on;
    %     plot(re.az(i,:)*180/pi, ...
    %         re.el(i,:)*180/pi);

    plot(re.az'*180/pi, re.el'*180/pi);
    hold on
    plot(re.az*180/pi, re.el*180/pi);
    
    % real speaker locations
    %plot(S.az*180/pi,S.el*180/pi, '*k')
    
    if exist('S', 'var') && ~isempty(S)
        plot(S.az*180/pi,S.el*180/pi, ...
            'kh', 'MarkerFaceColor', 'k', 'MarkerSize', 20);
        text(S.az*180/pi,S.el*180/pi, ...
            cellfun(@(s)['    ',s],S.id,'UniformOutput', false),...
            'HorizontalAlignment', 'left', 'FontSize', 18);
    end
    
    if exist('V', 'var') && ~isempty(V)
        % virtual speaker locations
        [Vaz,Vel] = cart2sph(V.x, V.y, V.z);
        plot(Vaz*180/pi,Vel*180/pi, 'sk');
    end
    
    hold off
    title_bold18([ var_name, ' Direction']);
    xlabel('Azimuth (deg ccw, 0=front)');    xlim([-200,200]);
    
    ylabel('Elevation (deg, 0=horizontal)'); ylim([-90,90]);
    if ~ inOctave()
        legend(num2str(geo.el(i,1)*180/pi,3), ...
            'Location', 'NorthEastOutside');
    end
    %saveas(gca1,[fig_title '_rE-grid.pdf']);
    % uncomment for landscape
    %orient(gca1,'landscape');
    print(gca,'-dpng','-r100',...
        fullfile(ambi_decoders_dir(true), ...
                 [fig_title '-' var_name '-grid.png']));
    
end

function title_bold18(str)
    if inOctave()
        title(str);
    else
        title(str, 'FontSize', 18, 'FontWeight', 'bold');
    end
end
