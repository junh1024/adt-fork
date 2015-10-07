function [ val ] = SPKR_ARRAY_2D_POLYGON( N, r, type )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    thetas = linspace(0,360,N+1) + (type==1)*180/N; 
    thetas = thetas(1:end-1)';
    
    S = [ thetas, zeros(size(thetas)), r*ones(size(thetas)) ];
    
    val.az = S(:,1)*pi/180;
    val.el = S(:,2)*pi/180;
    [val.x, val.y, val.z] = sph2cart(val.az, val.el, 1);
    val.r = S(:,3);
    
    val.id = cell(size(thetas));
    for i=1:size(thetas)
        val.id{i}=sprintf('S%02d', round(thetas(i)/10'));
    end
    
    val.name = sprintf('sa_%d_gon_%d', N, type);
end

