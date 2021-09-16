close all; clear all; clc;
Startup_AddPaths()

%%
% functions in library
lib.exporder    = 5;        % exponent order; r.^i
lib.usesine     = 1;        % sine function; sin(i*r)
lib.usecos      = 1;        % cosine function; cos(i*r)
lib.ratexp      = 3;        % rational functions; r.^(-i) 
lib.chebyorder  = 0;        % chebyshev polynomial of first kind
lib.legorder    = 0;        % legendre polynomial of first kind
lib.cosker      = 0;        % cosine kernel function; cos(pi*r/2), 0<r<1

% system parameters
d               = 2;
L               = 100;
M               = 2;
tspan           = [0:10/(L-1):10];

% agent of first kind
N{1} = 9;
phi{1} = @(r)PS_1st_order_prey_on_prey(r,1);
phi{2} = @(r)PS_1st_order_predator_on_prey(r,2);

% agent of second kind
N{2} = 1;
phi{3} = @(r)PS_1st_order_prey_on_predator(r,3.5,3);
phi{4} = @(r)PS_1st_order_predator_on_predator(r);

% IC parameters
IC.d = d;
IC.N1 = N{1};
IC.N2 = N{2};
IC.shape = 2;
IC.centerx = 0;
IC.centery = 0;
IC.radius = 5;
IC.rmax = 2*IC.radius;

%%
% learning interval (T_L)
T_L = floor(L/2);

% creates library of n amount of functions psi
psiLib = poolPsi(lib);

% generates the data needed to construct our system
for m = 1:M
    % generates initial conditions
    y0{m} = generateIC(IC);

    % create true system
    % RHS - creates the right hand side for the system of 1st order odes
    % RHS - outputs dotX = [f_phi(1); f_phi(2);... ; f_phi(d*N)]
    [tA, X] = ode15s(@(tA,X) RHShetsys(tA,X,d,N,phi), tspan, y0{m}); % deval
    
    XA{m} = X;
end

% take training interval from trajectory data
tA_training = tA(1:T_L);

for m = 1:M
    XA_training{m} = XA{m}(1:T_L,:);
end

% find dotX
for m = 1:M
    XA1{m} = XA_training{m}(:,1:d*N{1});
    XA2{m} = XA_training{m}(:,d*N{1}+1:d*(N{1}+N{2}));
    for l = 1:T_L
        X_l1 = XA1{m}(l,:)';  % d*N{1} x 1
        X_l2 = XA2{m}(l,:)'; % d*N{2} x 1
        
        dotX11{m}(:,l) = RHS(tA(l),X_l1,X_l1,d,N{1},phi{1});
        dotX12{m}(:,l) = RHS(tA(l),X_l1,X_l2,d,N{1},phi{2});
        dotX21{m}(:,l) = RHS(tA(l),X_l2,X_l1,d,N{2},phi{3});
        dotX22{m}(:,l) = RHS(tA(l),X_l2,X_l2,d,N{2},phi{4});
    end
end

% finds c the coefficient vector
regtype = input('Regression type: 1 for LS, 2 for SLS, 3 for LASSO: ');
switch regtype
    case 1
        c11 = findC_LS(tA,XA1,XA1,dotX11,d,N{1},T_L,M,psiLib);
        c12 = findC_LS(tA,XA1,XA2,dotX12,d,N{1},T_L,M,psiLib);
        c21 = findC_LS(tA,XA2,XA1,dotX21,d,N{2},T_L,M,psiLib);
        c22 = findC_LS(tA,XA2,XA2,dotX22,d,N{2},T_L,M,psiLib);
    case 2
        lambda = input('Lambda: ');
        c11 = findC_SLS(tA,XA1,XA1,dotX11,d,N{1},T_L,M,psiLib,lambda);
        c12 = findC_SLS(tA,XA1,XA2,dotX12,d,N{1},T_L,M,psiLib,lambda);
        c21 = findC_SLS(tA,XA2,XA1,dotX21,d,N{2},T_L,M,psiLib,lambda);
        c22 = findC_SLS(tA,XA2,XA2,dotX22,d,N{2},T_L,M,psiLib,lambda);
    case 3
        c11 = findC_LASSO(tA,XA1,XA1,dotX11,d,N{1},T_L,M,psiLib);
        c12 = findC_LASSO(tA,XA1,XA2,dotX12,d,N{1},T_L,M,psiLib);
        c21 = findC_LASSO(tA,XA2,XA1,dotX21,d,N{2},T_L,M,psiLib);
        c22 = findC_LASSO(tA,XA2,XA2,dotX22,d,N{2},T_L,M,psiLib);
end     
c = {c11, c12, c21, c22};


% visualize c
visualizeC(psiLib,c{1},lib,'For phi_11:');
visualizeC(psiLib,c{2},lib,'For phi_12:');
visualizeC(psiLib,c{3},lib,'For phi_21:');
visualizeC(psiLib,c{4},lib,'For phi_22:');

% create identified system
for m = 1:M
    % finds the right hand side of dotXhat in terms of functions from Theta
    [tB, X1] = ode15s(@(tB,X) RHShat(tB,X,d,N,c,psiLib), tspan, y0{m});
    
    XB{m} = X1;
end

% plot the systems
plotSystem(tA, XA, d, N, M, T_L, "True System");
plotSystem(tB, XB, d, N, M, T_L, "Identified System");


% find interval to evaluate on
for m = 1:M
    XA1r{m} = XA{m}(:,1:d*N{1});
    XA2r{m} = XA{m}(:,d*N{1}+1:d*(N{1}+N{2}));
end
rspan1 = getrSpan(XA1r,XA1r,IC.rmax,d,N{1},L,M);
rspan2 = getrSpan(XA1r,XA2r,IC.rmax,d,N{1},L,M);
rspan3 = getrSpan(XA2r,XA1r,IC.rmax,d,N{2},L,M);
rspan4 = getrSpan(XA2r,XA2r,IC.rmax,d,N{2},L,M);
rspan = {rspan1, rspan2, rspan3, rspan4};

% plots the true and approximated kernel as an error metric
plotKernel(phi{1},c{1},psiLib,rspan{1},'\phi_{11} Comparison');
plotKernel(phi{2},c{2},psiLib,rspan{2},'\phi_{12} Comparison');
plotKernel(phi{3},c{3},psiLib,rspan{3},'\phi_{21} Comparison');
plotKernel(phi{4},c{4},psiLib,rspan{4},'\phi_{22} Comparison');

% error metric
normtype = 2;       % can edit; 1 for inf norm, 2 for L2 norm
error = errorMetric(normtype,c,psiLib,phi,rspan)
