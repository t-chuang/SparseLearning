% Givern the density u(x,t)
% Infer the interaction kernel phi

%%
clear all;
close all;
all_dir = add_path_create_dir();
 
%% load specified parameters
sysInfo = settings_DEs(1);
display_sysInfo(sysInfo);
% %% sysInfo settings (optional)
% sysInfo.L = 10;   
% sysInfo.M = 30;
% sysInfo.T = 1;
% sysInfo.dt = 0.1;
% sysInfo.Initial = 'DN_1_0.5';
% sysInfo.nlfn = 'power_3';
% sysInfo.v = 1;
% sysInfo = get_sysInfo_details(sysInfo);

% sysInfo.phi_kernel= @(x) x.^3;         % setting kernel by ourself if don't want to use the kernel in Lang and Lu's paper

%%
% manual parameters of library (basis of hypothesis space)to set
lib.exporder = 10;       % exponent order; r.^i
lib.usesine = 0;        % sine function; sin(i*r)
lib.usecos = 0;         % cosine function; cos(i*r)
lib.ratexp = 0;         % rational functions; r.^(-i) 
lib.chebyorder = 0 ;     % chebyshev polynomial of first kind
lib.legorder = 0;       % legendre polynomial of first kind
lib.cosker = 0;         % cosine kernel function; cos(pi*r/2), 0<r<1

%% Generate/Load Data U
fprintf(['Generate data U with M = ', num2str(sysInfo.M),'...\n'])
U = generate_data(sysInfo, all_dir, 1);
%% setting the library
psiLib = poolPsi(lib);
%% create the stack matrix A and stack vector b
A=Af(U,sysInfo,psiLib,1);
b=bf(U,sysInfo,psiLib,1);
%% get the vector c=A\b
c1=A\b;                 % back slash will automatically implement Least Square method
c2=findC_SLS(A,b,0.01);
c3=findC_LASSO(A,b);
disp('Using LS');
visualizeC(psiLib,c1,lib);
disp('Using SLS');
visualizeC(psiLib,c2,lib);
disp('Using LASSO');
visualizeC(psiLib,c3,lib);

%% plot true and identified kernel
bounds=max(sysInfo.rgrid); % domain of kernel
phi=sysInfo.phi_kernel; % true kernel
plotKernel(phi,c1,psiLib,bounds,1);
plotKernel(phi,c2,psiLib,bounds,2);
plotKernel(phi,c3,psiLib,bounds,3);

%% error metric 
rgrid=sysInfo.rgrid;
R=length(rgrid);
rgrid=rgrid(2:R);
normtype=2;
erro=errorMetric(normtype,c3,psiLib,phi,rgrid)
%% L2_rho
threshold=0.001;
sysInfo.rho=inference_get_rho(sysInfo,U,threshold);
L2rho=evaluation_error(sysInfo,c3,psiLib); 
%% plot rho function
plot_inference(sysInfo);




