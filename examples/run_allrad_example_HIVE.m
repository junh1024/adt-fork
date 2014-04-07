function run_allrad_example_HIVE
% example reading speaker config from AmbDec config file
    
ambi_run_allrad(...
    ambdec2spkr_array('trisquare-2h2v_hive.ambdec','Hive'), ...
    [2,1], ...   % ambisonic order [h, v]
    [], ...      % no imaginary speakers
    [], ...      % default output path
    true, ...   % force plots, even in Octave
    'amb' ...   % conventional mixed order scheme
    );

ambi_run_allrad(...
    ambdec2spkr_array('trisquare-2h2v_hive.ambdec','Hive'), ...
    1 ...       % ambisonic order
    );
