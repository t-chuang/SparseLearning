close all; clear all; clc;
Startup_AddPaths()

%% System parameters and given

% manual parameters to set
lib.exporder = 5;       % exponent order; r.^i
lib.usesine = 1;        % sine function; sin(i*r)
lib.usecos = 1;         % cosine function; cos(i*r)
lib.ratexp = 3;         % rational functions; r.^(-i) 
lib.chebyorder = 0;     % chebyshev polynomial of first kind
lib.legorder = 0;       % legendre polynomial of first kind
lib.cosker = 0;         % cosine kernel function; cos(pi*r/2), 0<r<1
lambda = 0.01;          % thresholding parameter for SLS regression

% user prompts to create structure for our ODE system
[N,d,tspan,L,M,phi,IC] = generateData();

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
    [tA, X] = ode15s(@(tA,X) RHS(tA,X,d,N,phi), tspan, y0{m}); % deval
    
    XA{m} = X;
end

%% Learning

% take training interval from trajectory data
tA_training = tA(1:T_L);

for m = 1:M
    XA_training{m} = XA{m}(1:T_L,:);
end

% find dotX
for m = 1:M
    for l = 1:T_L
        X_l = XA_training{m}(l,:)';  % d*N x 1
        
        dotX{m}(:,l) = RHS(tA_training(l),X_l,d,N,phi); % d*N x L
    end
end

% finds c the coefficient vector with regression
reg_type = input('1 for LS, 2 for SLS, 3 for LASSO: ');
switch reg_type
    case 1
        c = findC_LS(tA_training,XA_training,dotX,d,N,T_L,M,psiLib);
    case 2
        c = findC_SLS(tA_training,XA_training,dotX,d,N,T_L,M,psiLib,lambda);
    case 3
        c = findC_LASSO(tA_training,XA_training,dotX,d,N,T_L,M,psiLib);
end
visualizeC(psiLib,c,lib,'');

% create identified system
for m = 1:M
    % finds the right hand side of dotXhat in terms of functions from Theta
    [tB, X] = ode15s(@(tB,X) RHShat(tB,X,d,N,c,psiLib), tspan, y0{m});
    
    XB{m} = X;
end

% plot the systems
plotSystem(tA, XA, d, N, M, T_L, "True System", 'r');
plotSystem(tB, XB, d, N, M, T_L, "Identified System", 'b');

% plots the true and approximated kernel as an error metric
rspan = getrSpan(XA,IC.rmax,d,N,L,M);

plotKernel(phi,c,psiLib,rspan,'Kernel Comparison');

% error metric
normtype = 2;       % can edit; 1 for inf norm, 2 for L2 norm
kernel_error = errorKer(normtype,c,psiLib,phi,rspan)
trajectory_error = errorTraj(XA,XB,d,N,L,M)
