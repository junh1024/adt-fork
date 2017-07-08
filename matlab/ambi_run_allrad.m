function [D, S, M, C, out_path] = ambi_run_allrad( S, ambi_order, imag_spkrs, ...
        out_path, do_plots, scheme )
    %AMBI_RUN_ALLRAD ambisonic decoder using hybrid ambi/vbap scheme
    %   top-level function to design a decoder using Zotter/Framk AllRAD hybrid
    %   ambi/vbap appoarch [1,2]
    %
    %AMBI_RUN_ALLRAD( S, ambi_order, imag_spkrs, out_path, do_plots, scheme )
    %  S is speaker array struct
    %  ambi_order is ambisonic order, scalar is full periphonic array,
    %     vector specified mixed order array.
    %  imag_spkrs is an Nx3 array giving the location of imaginary
    %     speakers added to the array to enclose the listener. See Sec 1.1
    %     of [1].  Set to false or [] for no imaginary speakers.
    %  out_path is path for AmbDec config file
    %  do_plots is a boolen that controls the performance plots, default is
    %     to produce plots in MATLAB, no plots in Octave.
    %  scheme is HP or AMB for conventional mixed orders used in AMB files,
    %     HV for newer scheme from [3]
    %
    % [1] F. Zotter and M. Frank, "All-Round Ambisonic Panning and
    % Decoding," J. Audio Eng Soc, vol. 60, no. 10, pp. 807?820,
    % Nov. 2012.
    %
    % [2] F. Kaiser, "A Hybrid Approach for Three-Dimensional Sound
    % Spatialization," Algorithmen in Akustik und Computermusik 2, SE, May
    % 2011.
    %
    % [3] C. Travis, "A New Mixed-Order Scheme for Ambisonic Signals,"
    % Proc. 1st Ambisonics Symposium, 2009, Graz
    
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
    % $Id: 01c2daa29b210fb29a8c6a0ecbde86c1a48202fd $
    
    %% fill in defaults
    if ~exist('S','var')
        S = SPKR_ARRAY_CCRMA_LISTENING_ROOM(4);
    end;
    
    if ~exist('ambi_order','var') || isempty(ambi_order)
        ambi_order = [3,3];
    end;
    
    if ~exist('imag_spkrs','var')
        imag_spkrs = [0 0 -0.5];
    end;
    
    if ~exist('out_path','var')
        out_path = [];
    end
    
    % if ~exist('do_plots','var') || isempty(do_plots)
        % do_plots = ~inOctave();
    % end
    
    if ~exist('scheme', 'var'), scheme = 'amb'; end;
    
    %% decoder type
    % set to:
    %  1 for 1 band, rE max
    %  2 for 2 band, shelf filters, one matrix
    %  3 for 2 band, vienna type, two matricies
    D.decoder_type = 2; %1;
    
    %% build up description and filename in 'name'
    name = S.name;
    
    %% set up channel definitions
    
    C = ambi_channel_definitions_convention( ambi_order, [], scheme);
    
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
    
    %% virtual t design procedure
    
    % V the virtual speaker array
    % V2R is the matrix that map the virtual solution to the real array
    % Sa is the augmented speaker array (real + imaginary speakers)
    % H is the convex hull of Sa
    
    [V, V2R, Sa, H] = ambi_allrad_V2R(S, C, imag_spkrs);
    
    % if do_plots
        % ambi_plot_speakers(Sa, H, V);
    % end
    
    name = [name, sprintf('_allrad_%d', length(V.x))];
    
    %% K is the sampling of the sphere
    %K_old = ambi_sample_Yfms_cart(V.x, V.y, V.z, C);
    K = ambi_sample_Y_cart(V.x, V.y, V.z, C);
    %% M is the basic solution matrix
    Ma = V2R * pinv(K)';
    
    M_mm = Ma(Sa.real,:);
    
    %% shelf filters
    % Gamma is the per-order gains for max_rE
    Gamma = ambi_shelf_gains(C, S, 'amp');
    
    name = [name, '_rE_max'];
    
    % if do_plots
        % ambi_plot_rE(S, V, ambi_apply_gamma(M_mm, Gamma, C), C, name);
    % else
        % ambi_save_plot_data(S, V, ambi_apply_gamma(M_mm, Gamma, C), C, name);
    % end
    
    %%
    [M,D,name,out_path] = ...
        ambi_write_decoder_engine_configuration(S,C,M_mm,D,Gamma,name,out_path);
    
    %% save run for posterity
    save([out_path '-' datestr(clock,30) '.mat'], ...
        'S', 'C', 'M', 'V', 'H', 'V2R', 'Sa', 'D', 'Gamma', 'sysver');
    
    %% Fini!
    
end
