function run_dec_Fliege16
    % allrad and pinv example specifying speaker locations inline
    % 16 Fliege nodes on sphere, see:
    %  http://www.personal.soton.ac.uk/jf1w07/nodes/nodes.html
    %  the columns are X, Y, Z and weight (weight is ignored)
    %
    % see also AMBI_MAT2SPKR_ARRAY, AMBI_RUN_ALLRAD_AMBDEC
    
    %%
    decoder_type = 'pinv'; % pinv | allrad
    h_order = 3;
    v_order = 3;
    
    mixed_order_scheme = 'HP';
    
        
    
    S = ambi_mat2spkr_array(...
        ... % adjust args according to data read from import file
        ... %   see ambi_mat2spkr_array for coord and unit codes
        ... %	x (m)  y (m)  z (m) weight (ignored)
        ... %-----------------------------------------------
        [ ...
        ... from http://www.personal.soton.ac.uk/jf1w07/nodes/16.txt
 0.00000000000000e+00   0.00000000000000e+00   1.00000000000000e+00   7.55674118356721e-01
 7.53978824073000e-01   0.00000000000000e+00   6.56898723434000e-01   7.55673975187776e-01
 3.90242135404000e-01   8.06032074954000e-01  -4.44998168424000e-01   7.55674013381465e-01
 4.94869602332000e-01  -1.27854920906000e-01  -8.59509857936000e-01   8.74570763750276e-01
 3.55503473986000e-01   8.06424122874000e-01   4.72543557812000e-01   8.74570753060101e-01
-4.46397177021000e-01   8.79481067712000e-01  -1.65053360715000e-01   7.55673876104811e-01
 1.68791062107000e-01  -8.79481021131000e-01  -4.44997427885000e-01   7.55673961615957e-01
 9.50370026986000e-01   2.63731117349000e-01  -1.65053656574000e-01   7.55673979483462e-01
-5.91868553094000e-01  -8.06032223202000e-01   1.91599013900000e-03   7.55674124026700e-01
-5.27292524396000e-01   5.93408701303000e-01   6.08135434697000e-01   7.55673985216451e-01
-7.48743750927000e-01  -2.63731093071000e-01   6.08135433925000e-01   7.55673818818350e-01
-9.73131512786000e-01   1.27854998926000e-01  -1.91489315819000e-01   8.74570818789155e-01
-2.60381218011000e-01   3.93874693307000e-01  -8.81512533819000e-01   7.55673916307309e-01
 8.04899141573000e-01  -5.93408545353000e-01   1.91577591800000e-03   7.55674020114415e-01
 1.22758388462000e-01  -8.06424045147000e-01   5.78455389352000e-01   8.74570596431787e-01
-4.93598041398000e-01  -3.93874951475000e-01  -7.75386030393000e-01   7.55673893711746e-01           
        ], ...
        'XYZ',...            % locations
        'MMM', ...           % in meters
        'Fliege16' ...          % name of array
        );
    
    switch decoder_type
        case 'allrad'
            ambi_run_allrad(...
                S, ...  % speaker array struct
                [h_order,v_order], ...  % ambisonic order [h, v]
                [], ... % imaginary speakers, none in this case
                [], ... % pathname for output, [] = default
                [], ... % do plots, default is true for MATLAB, false for Octave
                mixed_order_scheme ... % mixed order scheme HV or HP
                );
        case 'pinv'
            ambi_run_pinv(...
                S, ...  % speaker array struct
                [h_order,v_order], ...  % ambisonic order [h, v]
                [], ... % imaginary speakers, none in this case
                [], ... % pathname for output, [] = default
                [], ... % do plots, default is true for MATLAB, false for Octave
                mixed_order_scheme ... % mixed order scheme HV or HP
                );
    end
end
    
