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

% find dotX
for m = 1:M
    for l = 1:L
        X_l = XA{m}(l,:)';  % d*N x 1
        
        dotX{m}(:,l) = RHS(tA(l),X_l,d,N,phi); % d*N x L
    end
end

% finds c the coefficient vector
c = findC_LASSO(tA,XA,dotX,d,N,L,M,psiLib);
visualizeC(psiLib,c,lib,'');

% create identified system
for m = 1:M
    % finds the right hand side of dotXhat in terms of functions from Theta
    [tB, X] = ode15s(@(tB,X) RHShat(tB,X,d,N,c,psiLib), tspan, y0{m});
    
    XB{m} = X;
end

% plot the systems
plotSystem(tA, XA, d, N, M, "True System", 'r');
plotSystem(tB, XB, d, N, M, "Identified System", 'b');

% plots the true and approximated kernel as an error metric
if min(phi(0:0.01:IC.rmax)) ~= max(phi(0:0.01:IC.rmax))
    bounds = [0 IC.rmax min(phi(0:0.01:IC.rmax)) max(phi(0:0.01:IC.rmax))];  % [left right bottom top] bounds
else
    bounds = [0 IC.rmax min(phi(0:0.01:IC.rmax))-1 min(phi(0:0.01:IC.rmax))+1];
end
plotKernel(phi,c,psiLib,bounds,'Kernel Comparison');

% error metric
normtype = 2;       % can edit; 1 for inf norm, 2 for L2 norm
rspan = 0:IC.rmax/100:IC.rmax;    % can edit; span of r to consider for kernel
error = errorMetric(normtype,c,psiLib,phi,rspan)

