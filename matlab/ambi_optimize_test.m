%% clear ws and load test data
clear
if false
    load('ambi_optimize_test.mat');
else
    S = SPKR_ARRAY_CCRMA_LISTENING_ROOM('full');
    %S = speakers_brh_spring2017;
    C = ambi_channel_definitions(3,3,[],'acn', 'n3d');
    [D, S, M]= ambi_run_allrad(S,C);
    
    test_dirs = load(fullfile(ambi_dir('data'), ...
        'Design_5200_100_random.mat'));
    test_dirs.u = [test_dirs.x, test_dirs.y test_dirs.z]';
    test_dirs.Y = ambi_sample_Y_sph(test_dirs.az, test_dirs.el, C)';
    
    Gamma = ambi_shelf_gains(C,S,'rms');
    
    M.hf = ambi_apply_gamma(M.lf,Gamma,C);
end
%%
x = ambi_optimize_matrix2(M.lf, C, S, test_dirs);

%% things to look at
%shelf_gains = M.hf \ M.lf
%shelf_diag = diag(shelf_gains)

ambi_plot_rE(S,[],x,C)
%%
ambi_plot_rE(S,[],M.hf,C)
