function [ o, b1, b2 ] = spherical_harmonic_test( order )
    %SPHERICAL_HARMONIC_TEST spherical harmonics sampled on Lebedev grid 
    %   This function produce two CSV files:
    %   . a file of the Lebedev grid points and weights for a given order
    %   . the real apherical harmonics sampled at those points
    %
    %   The intent is to use this to test implementations the spherical 
    %   harmonics for interoperability with the ADT (and other libraries
    %   with correct definitions).
    %
    %   We also check that the N3D spherical harmonics are orthonormal.
    
    
    a = LebedevGrid(order);
    a.w = a.w / (4*pi); % unit normalization
    
    dlmwrite(fullfile(ambi_dir('data'), ...
        ['lebedev-grid-points-az-el-order_', num2str(order), '.csv']), ...
        ... azimuth, elevation, and weight
        [a.theta, a.phi, a.w], ...
        'precision', 10);
       
    
    % ambix
    ordering_rule = 'acn';
    encoding_convention = 'sn3d';
    
    C_sn3d = ambi_channel_definitions(order, order, [], ...
        ordering_rule, encoding_convention);
    
    Y = ambi_sample_Y_sph(a.theta, a.phi, C_sn3d);
    
    dlmwrite(fullfile(ambi_dir('data'), ...
        ['real_spherical_harmonics_', ...
        'order_', num2str(order),...
        '_', ordering_rule, ...
        '_', encoding_convention, ...
        '.csv']), ...
        Y,...
        'precision', 10);
    
    encoding_convention = 'n3d';
    C_n3d = ambi_channel_definitions(order, order, [], ...
        ordering_rule, encoding_convention);
    Y = ambi_sample_Y_sph(a.theta, a.phi, C_n3d);
    
    dlmwrite(fullfile(ambi_dir('data'), ...
        ['real_spherical_harmonics_', ...
        'order_', num2str(order),...
        '_', ordering_rule, ...
        '_', encoding_convention, ...
        '.csv']), ...
        Y,...
        'precision', 10);

   % check that the N3D spherical harmonics are orthonormal
   n_ch = length(C_n3d.channels);
   o = zeros(length(n_ch), length(n_ch));
   
   Y_w = Y .* sqrt(a.w(:,ones(1,n_ch)));
   o = Y_w' * Y_w;

   t = (o - eye(length(n_ch))) > eps*1e2;
   if any(t(:))
       disp('FAIL')
       [b1, b2] = ind2sub(size(t), find(t));
   else
       disp('PASS')
       b1 = []; b2 = [];
   end
end

