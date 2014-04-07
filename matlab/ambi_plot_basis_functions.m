function [ output_args ] = ambi_plot_basis_functions( U, S, C )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    AEG = AzElGrid(-180:2:180,-90:2:90);
    Yfull = ambi_sample_Y_sph(AEG.az(:), AEG.el(:), C)';
    
    YSlep = U' * Yfull;
    %%
    figure1 = figure(); %figure(100);
    
    S = S/max(S(:));
    
    nfun = length(S);
    for m = 1:nfun
        
        subplot1 = subplot(ceil(nfun/ceil(sqrt(nfun))),ceil(sqrt(nfun)),m);
        
        sb{m} = subplot1;
        
        Yplot = reshape(YSlep(m,:), size(AEG.x));
        
        Yplot2 = abs(Yplot);
        
        %Yplot2 = 20*log10(abs(Yplot)+1);
        
        [p.x, p.y, p.z] = sph2cart(AEG.az, AEG.el, Yplot2);
        %[p.x, p.y, p.z] = sph2cart(AEG.az, AEG.el, Yplot);
        
        surf1=surf(p.x, p.y, p.z, Yplot); axis equal; axis vis3d;
        colormap jet
        
        if ~inOctave
            axis vis3d;
            %axis off
            %shading interp;
            shading(subplot1,'interp')
            
            set(surf1, ... %findobj(gca,'type','surface'),...
                'FaceLighting','phong',...
                'AmbientStrength',0.5,'DiffuseStrength',0.8,...
                'SpecularStrength',0.9,'SpecularExponent',25,...
                'BackFaceLighting','unlit');
            %lighting phong
            lightangle(-45,30)
            %set(figure1,'Renderer','opengl')
            %set(figure1,'Renderer', 'painters')
            
            %light('Position',[1 0 1],'Style','infinite');
        end
        xlabel('x'); ylabel('y'); zlabel('z');
        xlim([-3,3]);ylim([-3,3]);zlim([-3,3]);
        
        title0 = title(sprintf('$${\\bf\\lambda_{%d} = %5.3f}$$', m, S(m)));
        
        set(title0, 'interpreter', 'latex')
        set(title0, 'FontSize', 18);
        set(title0, 'FontWeight', 'bold');
        %set(title0,'Renderer','painters')
        
    end
    set(figure1,'Renderer', 'zbuffer'); %'opengl')
    opts.figureSnapMethod = 'antialiased';
    
    set(figure1, 'ResizeFcn',{@myresize, sb})
    
    
end

function  myresize(src, event, sb)
    for i = 1:length(sb)
        axes(sb{i});
        %xlabel('x'); ylabel('y'); zlabel('z');
        %xlim([-3,3]);ylim([-3,3]);zlim([-3,3]);
        axis equal
        axis vis3d
    end
end


