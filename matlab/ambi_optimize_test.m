%% clear ws and load test data
clear
load('ambi_optimize_test.mat');
%%
x = ambi_optimize_matrix(M.lf, C, S, test_dirs);

%% things to look at
shelf_gains = M.hf \ M.lf
shelf_diag = diag(shelf_gains)

