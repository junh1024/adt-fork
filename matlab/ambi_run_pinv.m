function [D, S, M, C] = ambi_run_pinv( S, ambi_order, imag_spkrs, ...
        out_path, do_plots, scheme, alpha) %#ok<*INUSL>
    %AMBI_RUN_PINV() ambisonic decoder using pseudoinverse (aka mode matching).
    %   top-level function to design a decoder using inversion [1,2]
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
    %  alpha is blend coefficient for inversion variants
    %       alpha = 0 -> mode matching
    %       alpha = 1 -> even energy
    %       0 < alpha < 1 -> blend of two
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
    % $Id: ambi_run_pinv.m 26470 2014-03-20 07:40:47Z heller $
    
    %% fill in defaults
    if ~exist('S','var')
        S = SPKR_ARRAY_CCRMA_LISTENING_ROOM(4);
    end;
    
    if ~exist('ambi_order','var') || isempty(ambi_order)
        ambi_order = 3;
    end;
    
    if ~exist('imag_spkrs','var')
        imag_spkrs = []; %#ok<*NASGU>
    end;
    
    if ~exist('out_path','var')
        out_path = [];
    end
    
    if ~exist('do_plots','var') || isempty(do_plots)
        do_plots = ~inOctave();
    end;
    
    if ~exist('scheme', 'var'), scheme = []; end;
    
    if ~exist('alpha', 'var'), alpha = 0; end;
    
    %% decoder type
    % set to:
    %  1 for 1 band, rE max
    %  2 for 2 band, shelf filters, one matrix
    %  3 for 2 band, vienna type, two matricies
    D.decoder_type = 2;
    
    %% build up description and filename in 'name'
    name = S.name;
    
    %% set up channel definitions
    
    C = ambi_channel_definitions_convention( ...
        ambi_order, [], scheme);
    
    %%
    switch C.scheme
        case 'HV'
            name = [name, sprintf('_%dh%dv', C.h_order, C.v_order)];
        case 'HP'
            name = [name, sprintf('_%dh%dp', C.h_order, C.v_order)];
    end
    
    %%
    if inOctave()
        sysver = ['GNU Octave Version ', version];
    else
        sysver = ['MATLAB Version ', version];
    end
    disp(sysver);
    
    if do_plots
        if numel(unique(S.z)) > 1
            H = convhulln([S.x,S.y,S.z]);
            ambi_plot_speakers(S,H);
        end
    end
    
    %% shelf filter gains
    % Gamma is the per-order gains for max_rE
    Gamma = ambi_shelf_gains(C, S, 'rms'); %'energy');   % 'amp','rms'
    
    %% noops from allrad code
    V = []; V2R = []; Sa = []; H=[];%#ok<NASGU> % no virtual speakers
    
    %% conventional mode matching
    Y = ambi_sample_Y_cart(S.x, S.y, S.z, C);
    
    if true
        gramian = Y'*Y;
        fprintf('det(gramian) = %d\n\n',det(gramian));
        if do_plots
            figure();
            imagesc(Y'*Y);
            title('Gramian Matrix -- spherical harmonic aliasing');
            colorbar;
        end
    end
    
    switch 2
        case 1   % straight up mode matching
            M_mm = pinv(Y)';
            switch D.decoder_type
                case {2,3}
                    name = [name, sprintf('_pinv_match_rV_max_rE')];
                case 1
                    name = [name, sprintf('_pinv_max_rE')];
            end
            
        case 2   % energy limited mode matching
            [ YU, YS, YV] = svd(Y);
            % Y = YU * YS * YV'
            % pinv(Y) = YV * pinv(YS) * YU'
            
            fprintf('singular values = '); disp(diag(YS));
            
            pinvYS = pinv(YS);
            pinvYSmean = pinvYS;
            pinvYSmean(pinvYS>1e-5) = mean(diag(pinvYS));
            
            % alpha = 0 -> mode matching
            % alpha = 1 -> even energy
            % 0 < alpha < 1 -> blend of two
            pinvYSblend = (1-alpha)*pinvYS + alpha*pinvYSmean;
            
            M_mm = (YV * pinvYSblend * YU')';
            if alpha == 0
                pinv_type = 'match';
            elseif alpha == 1
                pinv_type = 'even_energy';
            else
                pinv_type = sprintf('energy_limit_%03i', round(alpha*100));
            end
            name = [name, '_pinv_' pinv_type '_rVmax_rE' ];
    end
    
    if do_plots
        ambi_plot_rE(S, V, ambi_apply_gamma(M_mm, Gamma, C), C, name);
    end
    
    %%
    [M,D,name,out_path] = ...
        ambi_write_decoder_engine_configuration(S,C,M_mm,D,Gamma,name,out_path);
    
    %% save run for posterity
    save([out_path '-' datestr(clock,30) '.mat'], ...
        'S', 'C', 'M', 'V', 'H', 'V2R', 'Sa', 'D', 'Gamma', 'sysver');
    
    %% Fini!
    
end
