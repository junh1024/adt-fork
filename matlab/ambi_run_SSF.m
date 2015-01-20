function [D, Spkr, M, C] = ambi_run_SSF( Spkr, ambi_order, imag_spkrs, ...
        out_path, do_plots, scheme, alpha, elevation_range) %#ok<*INUSL>

     %AMBI_RUN_SSF() ambisonic decoder using spherical slepian functions
    %
    %  S is speaker array struct
    %  ambi_order is ambisonic order, scalar is full periphonic array,
    %     vector specified mixed order array.
    %  scheme is HP or AMB for conventional mixed orders used in AMB files,
    %     HV for newer scheme from [3]
    %  imag_spkrs is not used here, but kept so that the arglist is the
    %     same as for AllRad.
    %  out_path is path for AmbDec config file
    %  do_plots is a boolen that controls the performance plots, default is
    %     to produce plots in MATLAB, no plots in Octave.
    %  alpha is blend coefficient for inversion variants (pinv only)
    %       alpha = 0 -> mode matching
    %       alpha = 1 -> even energy
    %       0 < alpha < 1 -> blend of two
    %  elevation_range in degrees (for SSF only)
    %       if empty, assume a hemispherical dome and use min from Zotter's calculations
    %       if a scalar it is the minimum elevation
    %       if a two-element vector, [min, max]
    %
    % [1] M. A. Gerzon, "Practical Perphony: The Reproduction of Full-Sphere
    %     Sound," Preprints of the 65th AES Convention,  no. 1571, p. 11, 1980.
    % [2] A. Heller, R. Lee, and E. M. Benjamin, "Is My Decoder Ambisonic?,"
    %     AES 125th Convention, San Francisco, pp. 1-21, Dec. 2008.
    % [3] C. Travis, "A New Mixed-Order Scheme for Ambisonic Signals,"
    %     Proc. 1st Ambisonics Symposium, 2009, Graz
    
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
    if ~exist('do_plots','var') || isempty(do_plots)
        do_plots = ~inOctave();
    end
    
    if ~exist('scheme', 'var') || isempty(scheme)
        scheme = 'HP';
    end
    
    % FIXME  SSF is not mixed order right now
    if length(ambi_order) >= 2 && ambi_order(1) ~= ambi_order(2)
        warning('Mixed order not supported for SSF');
    end
    ambi_order = ambi_order([1,1]);
    
    %% region limits by ambisonic order from Zotter's email.
    e_min = [-15 -24 -23 -21 -18 -16 -14];
    
    if ~exist('elevation_range', 'var') || isempty(elevation_range)
        elevation.min = e_min(ambi_order(2));
        elevation.max = 90;
    elseif isscalar(elevation_range)
        elevation.min = elevation_range;
        elevation.max = 90;
    else
        elevation.min = elevation_range(1);
        elevation.max = elevation_range(2);
    end
    
    alpha_min = 1/2;
    basis_only = false;
    
    plot_ele.min = max(-90, elevation.min-20);
    plot_ele.max = min(+90, elevation.max+20);
    
    
    %%
   if do_plots
        if numel(unique(Spkr.z)) > 1
            H = convhulln([Spkr.x,Spkr.y,Spkr.z]);
            ambi_plot_speakers(Spkr,H);
        end
    end
    
    %for ambi_order = ambi_order(1)
    if true
        % elevation.min = e_min(ambi_order);
        
        %% set up channels
        if ambi_order <= 3
            C = ambi_channel_definitions(ambi_order(1),ambi_order(2),...
                scheme,'FUMA');
        else
            C = ambi_channel_definitions_convention(ambi_order,'AmbiX');
        end
        
        %% 'regular' sampling upper hemisphere
        
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
        
        % note: have to use N3D here, then fix later.
        %  use transpose to be consitent with papers
        yn = ambi_sample_Y_sph(V_inR.az(:), V_inR.el(:),C, true)';
        
        %% svd to find new basis
        
        %[ynU, ynS, ynV] = svd(yn, 'econ');
        [ynU, ynS, ynV] = svd(yn .* sqrt(V_inR.w(:,ones(1,size(yn,1))))', 'econ'); %#ok<ASGLU>
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
    if basis_only, return; end %#ok<UNRCH>
    
    %% build decoder
    
    Yspkr = ambi_sample_Y_sph(Spkr.az(:), Spkr.el(:),C, true)';
    
    Ysl = U' * Yspkr;
 
    %M = pinv(Ysl) * U';
    % do pseudoinverse by hand, so we can control the largest singular
    % value used
    [YslU, YslS, YslV] = svd(Ysl,'econ');
    invYslS = YslS;
    invYslS(YslS > 1e-2) = 1 ./ YslS(YslS > 1e-2);
    %invYslS = eye(size(invYslS));
    
    % fix normalization here with diagonal matrix
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
    
    D.input_scale = C.encoding_convention;
    
    ambi_write_decoder_engine_configuration(Spkr,C,M,D,Gamma); %,name,out_path);
    
end
