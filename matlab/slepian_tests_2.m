function slepian_tests_2 (basis_only)
    
    if ~exist('basis_only', 'var') || isempty(basis_only)
        basis_only = false;
    end
    
    do_plots = true;
    
    %% region limit from Zotter's email.
    e_min = [-15 -24 -23 -21 -18 -16 -14];
    
    %%  which example?
    switch 9
        
        case 1
            Spkr = SPKR_ARRAY_BING_2013FEB12();
            ambi_order = 3;
            alpha_min = 1/2;
            elevation.min = e_min(ambi_order);
            elevation.max =  90;
            
        case 2
            % used for LAC2014 paper
            Spkr = SPKR_ARRAY_CCRMA_LISTENING_ROOM('dome');
            ambi_order = 3;
            alpha_min = 1/2;
            elevation.min = -30;
            elevation.max =  90;
            plot_ele.min = -90;
            plot_ele.max =  90;
            
        case 3
            Spkr = SPKR_ARRAY_CCRMA_LISTENING_ROOM('dome');
            ambi_order = 1:3;
            alpha_min = 0;
            elevation.min = e_min(ambi_order);
            elevation.max =  90;
            
        case 4
            Spkr = SPKR_ARRAY_CCRMA_LISTENING_ROOM('dome');
            ambi_order = 5;
            alpha_min = 0;
            elevation.min =   -15;
            elevation.max =  90;
            
        case 5
            Spkr = SPKR_ARRAY_CCRMA_LISTENING_ROOM('dome');
            ambi_order = 3;
            alpha_min = 1/2;
            elevation.min = e_min(ambi_order);
            elevation.max =  90;
            
        case 6
            Spkr = ambdec2spkr_array('BingStudio-spkrs.ambdec','BingStudio-Apr2013');
            ambi_order = 3;
            alpha_min = 1/2;
            elevation.min = -20;
            elevation.max =  85;
        case 7
            Spkr = SPKR_ARRAY_Pesaro;
            ambi_order = 3;
            alpha_min = 1/2;
            elevation.min = -45;
            elevation.max =  90;
            
        case 8
            path = 'rescoeff.mat';
            DD = load(path);
            Spkr = ambi_mat2spkr_array(...
                [DD.THETA;DD.PHI;ones(size(DD.THETA))]',...
                'EAR','RRM', ...
                'IDHOA 1');
            ambi_order = 3;
            alpha_min = 1/2;
            elevation.min = -35;
            elevation.max =  90;
            
        case 9
            Spkr = ambi_mat2spkr_array(...
                ... % adjust args according to data read from import file
                ... %   see adt_mat2spkr_array for coord and unit codes
                ... %ID	r (m)	a (deg) e (deg) // Speaker Name
                ... %-----------------------------------------------
                [ ...
                4.4500	 -22.50   18.89 ;... % // L1U
                4.4500	  22.50   18.89 ;... % // R1U
                3.2500	 -67.50   25.12 ;... % // L2U
                3.2500	  67.50   25.12 ;... % // R2U
                3.2500	-112.50   25.12 ;... % // L3U
                3.2500	 112.50   25.12 ;... % // R3U
                4.4500	-157.50   18.89 ;... % // L4U
                4.4500	 157.50   18.89 ;... % // R4U
                4.1900	 -22.50   00.00 ;... % // L1M
                4.1900	  22.50   00.00 ;... % // R1M
                2.8700	 -67.50   00.00 ;... % // L2M
                2.8700	  67.50   00.00 ;... % // R2M
                2.8700	-112.50   00.00 ;... % // L3M
                2.8700	 112.50   00.00 ;... % // L3M
                4.1900	-157.50   00.00 ;... % // L4M
                4.1900	 157.50   00.00 ;... % // R4M
                4.4500	 -22.50  -18.89 ;... % // L1D
                4.4500	  22.50  -18.89 ;... % // R1D
                3.2500	 -67.50  -25.12 ;... % // L2D
                3.2500	  67.50  -25.12 ;... % // R2D
                3.2500	-112.50  -25.12 ;... % // L3D
                3.2500	 112.50  -25.12 ;... % // R3D
                4.4500	-157.50  -18.89 ;... % // L4D
                4.4500	 157.50  -18.89 ;... % // R4D
                2.2593   -45.00   60.00 ;... % // L1T
                2.2593	  45.00   60.00 ;... % // R1T
                2.2593	-135.00   60.00 ;... % // L2T
                2.2593	 135.00   60.00 ;... % // R2T
                ], ...
                'RAE',...            % locations
                'MDD', ...           % in meters
                'DOGP', ...          % name of array
                {'L1U','R1U','L2U','R2U','L3U','R3U','L4U','R4U',...
                'L1M','R1M','L2M','R2M','L3M','R3M','L4M','R4M',...
                'L1D','R1D','L2D','R2D','L3D','R3D','L4D','R4D',...
                'L1T','R1T','L2T','R2T'} ...
                );
            
            
            ambi_order = 3;
            alpha_min = 1/2;
            elevation.min = -35;
            elevation.max =  85 ;
            plot_ele.min = -35;
            plot_ele.max =  85;
            
            
    end
    
    %%
    if do_plots
        if numel(unique(Spkr.z)) > 1
            H = convhulln([Spkr.x,Spkr.y,Spkr.z]);
            ambi_plot_speakers(Spkr,H);
        end
    end
    
    for ambi_order = ambi_order
        % elevation.min = e_min(ambi_order);
        
        %% set up channels
        %clear all
        %close all
        %C = ambi_channel_definitions(3,3,'HP','ACN','N3D');
        %C = ambi_channel_definitions(ambi_order,ambi_order,'HP','ACN','N3D');
        
        C = ambi_channel_definitions(ambi_order,ambi_order,'HP','FUMA');
        %% 'regular' sampling upper hemisphere
        
        %elevation.min = -35;
        %elevation.max =  90;
        
        switch 2
            case 1
                V = spherical_t_design(3, 240, 21);
                V.w = ones(size(V.x));
            case 2
                V = LebedevGrid(32); %25);
            case 3
                V = AzElGrid(-180:1:180-1, -90:1:90);
        end
        
        [V.az, V.el] = cart2sph(V.x, V.y, V.z);
        
        inR = V.el>=elevation.min*pi/180 & V.el<=elevation.max*pi/180;
        
        %Rin(:) = true;
        V_inR.az = V.az(inR);
        V_inR.el = V.el(inR);
        V_inR.w  = V.w(inR);
        
        %% project on to SH basis
        %  use transpose to be consitent with papers
        
        yn = ambi_sample_Y_sph(V_inR.az(:), V_inR.el(:),C, true)';
        
        %% svd to find new basis
        
        %[ynU, ynS, ynV] = svd(yn, 'econ');
        [ynU, ynS, ynV] = svd(yn .* sqrt(V_inR.w(:,ones(1,size(yn,1))))', 'econ');
        %[ynU, ynS, ynV] = svd(yn .* (V_inR.w(:,ones(1,size(yn,1))))', 'econ');
        
        %[ynU,ynS] = eig(yn*(yn' .* V_uh.w(:,ones(1,size(yn,1)))));
        
        ynS = diag(ynS);
        
        %[ynS,perm] = sort(ynS, 'descend');
        %ynU = ynU(:,perm);
        %ynS = sqrt(ynS);
        
        % singular values are the square roots of the eigenvalues of the gram
        % matrix
        lambda = ynS.^2;
        lambda_max = max(lambda);
        
        %% build matrix of eigenvectors with eigenvalues > alpha
        
        alpha = alpha_min;
        Sbig = lambda/lambda_max >= alpha;
        %Sbig(:) = true;
        U = ynU(:,Sbig );
        S = lambda(Sbig);
        
        %% plot some of these
        
        if do_plots
            ambi_plot_basis_functions(U, S, C);
        end
    end
    
    %% possibly dive out here
    if basis_only, return; end
    
    %% build decoder
    
    Yspkr = ambi_sample_Y_sph(Spkr.az(:), Spkr.el(:),C, true)';
    
    Ysl = U' * Yspkr;
    
    [YslU, YslS, YslV] = svd(Ysl,'econ');
    
    %M = pinv(Ysl) * U';
    invYslS = YslS;
    invYslS(YslS > 1e-2) = 1 ./ YslS(YslS > 1e-2);
    %invYslS = eye(size(invYslS));
    
    M =  YslV * invYslS * YslU' * U' * diag(1 ./ C.norm);
    
    Gamma = ambi_shelf_gains(C, Spkr, 'amp');
    
    %%
    if do_plots
        ambi_plot_rE(Spkr, [], ambi_apply_gamma(M,Gamma,C), C,...
            ambi_make_description_string(Spkr,C, ['Slepian', num2str(sum(Sbig))],' '),...
            [],...
            ... %elevation.min, elevation.max);
            plot_ele.min, plot_ele.max );
        
    end
    
    %%
    D.description = ...
        ambi_make_description_string(Spkr,C, ['Slepian', num2str(sum(Sbig))],'_');
    
    %% decoder type
    % set to:
    %  1 for 1 band, rE max
    %  2 for 2 band, shelf filters, one matrix
    %  3 for 2 band, vienna type, two matricies
    D.decoder_type = 1;
    D.input_scale = 'fuma';
    
    ambi_write_decoder_engine_configuration(Spkr,C,M,D,Gamma); %,name,out_path);
    
