function [ S ] = SPKR_ARRAY_Shoebox()
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    %% defaults

    %%
    S = ambi_spkr_array(...
        'Shoebox', ...
        'ARE', 'DMD', ...
        ... % first ring of 9
        'S11', [   0 ,  5.0 ,     0 ], ...
        'S12', [  40 ,  5.1 ,     0 ], ...
        'S13', [  80 , 3.25 ,     0 ], ...
        'S14', [ 120 , 3.58 ,     0 ], ...
        'S15', [ 160 ,  5.1 ,     0 ], ...
        'S16', [-160 , 5.46 ,     0 ], ...
        'S17', [-120 ,  4.0 ,     0 ], ...
        'S18', [ -80 , 4.06 ,     0 ], ...
        'S19', [ -40 , 4.68 ,     0 ], ...
        ... % second ring of 9
        'S21', [  20 , 5.44 ,  18.0 ], ...
        'S22', [  60 , 3.71 , 26.75 ], ...
        'S23', [ 100 , 3.28 ,  30.6 ], ...
        'S24', [ 140 , 4.45 , 22.18 ], ...
        'S25', [ 180 , 4.85 , 20.52 ], ...
        'S26', [-140 , 4.79 , 20.92 ], ...
        'S27', [-100 , 3.36 ,  29.6 ], ...
        'S28', [ -60 ,  3.6 ,  27.8 ], ...
        'S29', [ -20 ,  5.0 , 19.63 ], ...
        ... % third ring of 5
        'S31', [   0 , 3.49 ,  48.9 ], ...
        'S32', [  72 , 3.49 , 50.42 ], ...
        'S33', [ 144 , 3.55 , 48.04 ], ...
        'S34', [-144 , 3.54 ,  49.2 ], ...
        'S35', [ -72 , 3.52 ,  49.1 ], ...
        ... % zenith
        'SZZ', [   0 , 2.19 ,    90 ] ...
        );
end
%{
|   N |  Azi | Dist |  Elev |
|-----+------+------+-------|
|  1: |    0 |  5.0 |     0 |
|  2: |   40 |  5.1 |     0 |
|  3: |   80 | 3.25 |     0 |
|  4: |  120 | 3.58 |     0 |
|  5: |  160 |  5.1 |     0 |
|  6: | -160 | 5.46 |     0 |
|  7: | -120 |  4.0 |     0 |
|  8: |  -80 | 4.06 |     0 |
|  9: |  -40 | 4.68 |     0 |
|-----+------+------+-------|
| 10: |   20 | 5.44 |  18.0 |
| 11: |   60 | 3.71 | 26.75 |
| 12: |  100 | 3.28 |  30.6 |
| 13: |  140 | 4.45 | 22.18 |
| 14: |  180 | 4.85 | 20.52 |
| 15: | -140 | 4.79 | 20.92 |
| 16: | -100 | 3.36 |  29.6 |
| 17: |  -60 |  3.6 |  27.8 |
| 18: |  -20 |  5.0 | 19.63 |
|-----+------+------+-------|
| 19: |    0 | 3.49 |  48.9 |
| 20: |   72 | 3.49 | 50.42 |
| 21: |  144 | 3.55 | 48.04 |
| 22: | -144 | 3.54 |  49.2 |
| 23: |  -72 | 3.52 |  49.1 |
|-----+------+------+-------|
| 24: |    0 | 2.19 |    90 |
%}
