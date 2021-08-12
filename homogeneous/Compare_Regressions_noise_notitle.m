close all; clear all; clc;
Startup_AddPaths()

% manual parameters to set
lib.exporder = 10;       % exponent order; r.^i
lib.usesine = 0;        % sine function; sin(i*r)
lib.usecos = 0;         % cosine function; cos(i*r)
lib.ratexp = 0;         % rational functions; r.^(-i) 
lib.chebyorder = 0;     % chebyshev polynomial of first kind
lib.legorder = 0;       % legendre polynomial of first kind
lib.cosker = 0;         % cosine kernel function; cos(pi*r/2), 0<r<1
lambda = 0.01;          % threshold parameter for SLS
eta = 0.01;             % magnitude of noise to add to dotX

% user prompts to create structure for our ODE system
[N,d,tspan,L,M,phi,IC] = generateData();

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

% add noise
for m = 1:M
    noise{m} = 2*eta*rand(L,d*N)-eta;
    XA{m} = XA{m} + noise{m};
end

% find dotX
for m = 1:M
    for l = 1:L
        X_l = XA{m}(l,:)';  % d*N x 1
        
        dotX{m}(:,l) = RHS(tA(l),X_l,d,N,phi); % d*N x L
    end
end

%%
% Least squares
cB = findC_LS(tA,XA,dotX,d,N,L,M,psiLib);
visualizeC(psiLib,cB,lib,'Using Least Squares');

% create identified system
for m = 1:M
    % finds the right hand side of dotXhat in terms of functions from Theta
    [tB, X] = ode15s(@(tB,X) RHShat(tB,X,d,N,cB,psiLib), tspan, y0{m});
    
    XB{m} = X;
end

%%
% Lasso
cC = findC_LASSO(tA,XA,dotX,d,N,L,M,psiLib);
visualizeC(psiLib,cC,lib,'Using Lasso');

% create identified system
for m = 1:M
    % finds the right hand side of dotXhat in terms of functions from Theta
    [tC, X] = ode15s(@(tC,X) RHShat(tC,X,d,N,cC,psiLib), tspan, y0{m});
    
    XC{m} = X;
end

%%
% Sequential least squares
cD = findC_SLS(tA,XA,dotX,d,N,L,M,psiLib,lambda);
visualizeC(psiLib,cD,lib,'Using Sequential Least Squares');

% create identified system
for m = 1:M
    % finds the right hand side of dotXhat in terms of functions from Theta
    [tD, X] = ode15s(@(tD,X) RHShat(tD,X,d,N,cD,psiLib), tspan, y0{m});
    
    XD{m} = X;
end

%%
% plot and compare
if min(phi(0:0.01:IC.rmax)) ~= max(phi(0:0.01:IC.rmax))
    bounds = [0 IC.rmax min(phi(0:0.01:IC.rmax)) max(phi(0:0.01:IC.rmax))];  % [left right bottom top] bounds
else
    bounds = [0 IC.rmax min(phi(0:0.01:IC.rmax))-1 min(phi(0:0.01:IC.rmax))+1];
end 
plotKernel(phi,cB,psiLib,bounds,'');  % LS is figure 1
plotKernel(phi,cC,psiLib,bounds,'');  % Lasso is figure 2
plotKernel(phi,cD,psiLib,bounds,'');  % Sequential LS is figure 3

plotSystem_notitle(tA, XA, d, N, M, "", 'r');
plotSystem_notitle(tB, XB, d, N, M, "", 'b');
plotSystem_notitle(tC, XC, d, N, M, "", 'm');
plotSystem_notitle(tD, XD, d, N, M, "", 'g');

% error metric
normtype = 2;                       % can edit; 1 for inf norm, 2 for L2 norm
rspan = 0:IC.rmax/100:IC.rmax;      % span of r to consider for kernel error
ErrorLS = errorMetric(normtype,cB,psiLib,phi,rspan)
ErrorLASSO = errorMetric(normtype,cC,psiLib,phi,rspan)
ErrorSequentialLS = errorMetric(normtype,cD,psiLib,phi,rspan)
