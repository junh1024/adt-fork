function [ S ] = SPKR_ARRAY_Pesaro()
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    %% defaults
    if ~exist('r','var'), r = 1; end
    if ~exist('te','var'), te = 45; end
    if ~exist('be','var'), be = -35; end

    t0 = 0;
    m0 = 22.5;
    b0 = 30;
    %%
    S = ambi_spkr_array(...
        'Pesaro', ...
        'ARE', 'DMD', ...
        'Z1',  [      0, r, 90 ], ...
        ...
        'T1',  [   0+t0, r, te ], ...
        'T2',  [  60+t0, r, te ], ...
        'T3',  [ 120+t0, r, te ], ...
        'T4',  [ 180+t0, r, te ], ...
        'T5',  [-120+t0, r, te ], ...
        'T6',  [ -60+t0, r, te ], ...
        ...
        'M01', [   0+m0, r,  0 ], ...
        'M02', [  30+m0, r,  0 ], ...
        'M03', [  60+m0, r,  0 ], ...
        'M04', [  90+m0, r,  0 ], ...
        'M05', [ 120+m0, r,  0 ], ...
        'M06', [ 150+m0, r,  0 ], ...
        'M07', [ 180+m0, r,  0 ], ...
        'M08', [ 210+m0, r,  0 ], ...
        'M09', [ 240+m0, r,  0 ], ...
        'M10', [ 270+m0, r,  0 ], ...
        'M11', [ 300+m0, r,  0 ], ...
        'M12', [ 330+m0, r,  0 ], ...
        ...
        'B1',  [   0+b0, r, be], ...
        'B2',  [  60+b0, r, be], ...
        'B3',  [ 120+b0, r, be], ...
        'B4',  [ 180+b0, r, be], ...
        'B5',  [-120+b0, r, be], ...
        'B6',  [ -60+b0, r, be] ...
        );
end

