function [ x ] = ambi_optimize_matrix( M, C, S, test_dirs )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    if ~exist('test_dirs', 'var') || isempty(test_dirs)
        test_dirs = load(fullfile(ambi_dir('data'), ...
            'Design_5200_100_random.mat'));
        test_dirs.u = [test_dirs.x, test_dirs.y test_dirs.z]';
        test_dirs.Y = ambi_sample_Y_sph(test_dirs.az, test_dirs.el, C)';
        fprintf('loading test_dirs');
    end
    
    n_test_dirs = length(test_dirs.az);
    Su = [ S.x, S.y, S.z ]';
    
    [DAG,DDAG] = generate_dags(@compute_fom) ;
    
    options = optimoptions('fmincon',...
        'SpecifyObjectiveGradient',true ...
        ,'Display','iter');
    %options = optimoptions( options, 'CheckGradients', true);
    options = optimoptions(options, 'StepTolerance', 1e-30);
    options = optimoptions(options, 'ConstraintTolerance', 1e-10);
    
    fun = @cost;
    x0 = M;
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    lb = zeros(size(M))-2;
    ub = zeros(size(M))+2;
    
    % fix M(1,1)
    lb(1,1) = M(1,1);
    ub(1,1) = M(1,1);
    
    nonlcon = [];
    x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
    
    1; % place to put a breakpoint
    % end ambi_optimize_matrix
    
    function [f, g] = cost(M)
        f = evaluate_dag(DAG, M);
        [~, g] = evaluate_dag(DDAG, M, 1);
        g = g.';
    end
    
    function fom = compute_fom(M)
        
        g = M * test_dirs.Y;

        % velocity localization vector, rV
        if false
            P = sum(g,1);
            %rV.xyz = real((Su * g) ./ P([1 1 1], :)); % assume g is real
            rV.xyz = ((Su * g) ./ P([1 1 1], :)); % assume g is real
            rV.r = sqrt( sum(rV.xyz.^2, 1) );
            rV.u = rV.xyz ./ rV.r([1 1 1], :);
        end
        
        % energy localization vector, rE
        if false % for now assume g is real
            g2 = g.*conj(g);
        else
            g2 = g.^2;
        end
        
        E = sum(g2, 1);
        rE.xyz = (Su * g2) ./ E([1 1 1], :);
        
        % only give credit for rE in the test direction
        rE.rt = vector_dot( rE.xyz, test_dirs.u );
        % mean magnitude, max is around 0.8611
        mean_rE_mag = sum(rE.rt, 2) ./ n_test_dirs;
        
        % 3rd order max for |rE| is 0.8611 (largest root of Legendre poly)
        fom = 0.8611 - mean_rE_mag;
        
        if true % gets error during DDAG 
            rE.r2 = vector_dot( rE.xyz, rE.xyz);
            rE.r = rE.r2 .^ 0.5;
            rE.u = rE.xyz ./ rE.r([1 1 1], :);
            mean_dir_error = sum(vector_dot(rE.u, test_dirs.u), 2) ...
                ./ n_test_dirs;
            fom = fom + (1 - mean_dir_error);
        end
    end
    
    
end

function val = vector_dot( A, B )
    val = sum( A .* B, 1);
end
    
function [DAG,DDAG] = generate_dags(fn)
    % function [DAG,DDAG] = generate_dags(fn)
    
    DAG_B1 = dag_builder();     % create a blank dag_builder
    DAG_BN = build_dag(DAG_B1,fn);    % process the blank to generate the final
    DAG = get_dag(DAG_BN);      % extract the dag from the dag_ builder
    clear DAG_B1 DAG_BN      % clear the dag_builder objects
    lf = get_dag_size(DAG);
    
    % set the exits (passing back inter1nediate values
    ex= false(lf,1);
    ex(lf) = true;
    set_exits(DAG,ex);
    
    % start differentiating
    DDAG = duplicate_dag(DAG);
    DDAG_D = dag_radiff(DDAG);
    gen_helper(DDAG_D);
    build_radiff_dag(DDAG_D);
    
    % pull the stuff out
    DDAG = get_dag(DDAG_D);
    dex = get_exits(DDAG);
    dex(end) = 1;
    set_exits(DDAG,dex)
    
end

