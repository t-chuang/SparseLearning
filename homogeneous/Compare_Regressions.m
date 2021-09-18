close all; clear all; clc;
Startup_AddPaths()

% manual parameters to set
lib.exporder = 5;       % exponent order; r.^i
lib.usesine = 1;        % sine function; sin(i*r)
lib.usecos = 1;         % cosine function; cos(i*r)
lib.ratexp = 0;         % rational functions; r.^(-i) 
lib.chebyorder = 0;     % chebyshev polynomial of first kind
lib.legorder = 0;       % legendre polynomial of first kind
lib.cosker = 0;         % cosine kernel function; cos(pi*r/2), 0<r<1
lambda = 0.01;          % threshold parameter for SLS

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

%%
% Least squares
cB = findC_LS(tA_training,XA_training,dotX,d,N,T_L,M,psiLib);
visualizeC(psiLib,cB,lib,'Using Least Squares');

% create identified system
for m = 1:M
    % finds the right hand side of dotXhat in terms of functions from Theta
    [tB, X] = ode15s(@(tB,X) RHShat(tB,X,d,N,cB,psiLib), tspan, y0{m});
    
    XB{m} = X;
end

%%
% Sequential least squares
cC = findC_SLS(tA_training,XA_training,dotX,d,N,T_L,M,psiLib,lambda);
visualizeC(psiLib,cC,lib,'Using Sequential Least Squares');

% create identified system
for m = 1:M
    % finds the right hand side of dotXhat in terms of functions from Theta
    [tC, X] = ode15s(@(tC,X) RHShat(tC,X,d,N,cC,psiLib), tspan, y0{m});
    
    XC{m} = X;
end

%%
% Lasso
cD = findC_LASSO(tA_training,XA_training,dotX,d,N,T_L,M,psiLib);
visualizeC(psiLib,cD,lib,'Using Lasso');

% create identified system
for m = 1:M
    % finds the right hand side of dotXhat in terms of functions from Theta
    [tD, X] = ode15s(@(tD,X) RHShat(tD,X,d,N,cD,psiLib), tspan, y0{m});
    
    XD{m} = X;
end

%%
% plot and compare
rspan = getrSpan(XA,IC.rmax,d,N,L,M);

plotKernel(phi,cB,psiLib,rspan,'LS Kernel Comparison');  % LS is figure 1
plotKernel(phi,cC,psiLib,rspan,'Sequential LS Kernel Comparison');  % Sequential LS is figure 2
plotKernel(phi,cD,psiLib,rspan,'LASSO Kernel Comparison');  % Lasso is figure 3

plotSystem(tA, XA, d, N, M, T_L, "True System", 'r');
plotSystem(tB, XB, d, N, M, T_L, "Identified LS System", 'b');
plotSystem(tC, XC, d, N, M, T_L, "Identified Sequential LS System", 'm');
plotSystem(tD, XD, d, N, M, T_L, "Identified LASSO System", 'g');


% error metric
normtype = 2;                       % can edit; 1 for inf norm, 2 for L2 norm

Ker_ErrorLS = errorKer(normtype,cB,psiLib,phi,rspan)
Ker_ErrorSequentialLS = errorKer(normtype,cC,psiLib,phi,rspan)
Ker_ErrorLASSO = errorKer(normtype,cD,psiLib,phi,rspan)

Traj_ErrorLS = errorTraj(XA,XB,d,N,L,M)
Traj_ErrorSequentialLS = errorTraj(XA,XC,d,N,L,M)
Traj_ErrorLASSO = errorTraj(XA,XD,d,N,L,M)