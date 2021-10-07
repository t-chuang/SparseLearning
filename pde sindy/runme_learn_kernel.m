% Givern the density u(x,t)
% Infer the interaction kernel phi

%%
clear all;
close all;
clc;
all_dir = add_path_create_dir();


%% load specified parameters
sysInfo = settings_DEs(1);
display_sysInfo(sysInfo);

%%
% manual parameters of library (basis of hypothesis space)to set
lib.exporder =10;       % exponent order; r.^i
lib.usesine = 5;        % sine function; sin(i*r)
lib.usecos = 5;         % cosine function; cos(i*r)
lib.ratexp = 0;         % rational functions; r.^(-i) 
lib.chebyorder = 0 ;     % chebyshev polynomial of first kind
lib.legorder = 0;       % legendre polynomial of first kind
lib.cosker = 0;         % cosine kernel function; cos(pi*r/2), 0<r<1

%% Generate/Load Data U with fine resolution M=300 and TN=1000 so that SPCC could give a fine solution to the mean field pde 
fprintf(['Generate data U with M = ', num2str(sysInfo.M),'...\n'])
U = generate_data(sysInfo, all_dir, 1);
plot_U(U, sysInfo, all_dir, 1);
shading interp;
%% setting the library
psiLib = poolPsi(lib);
%% create the stack matrix A and stack vector b
A=Af(U,sysInfo,psiLib,1);
b=bf(U,sysInfo,psiLib,1);
    
%% get the vector c=A\b
c1=findC_LS(A,b);                 
c2=findC_SLS(A,b,0.01);
c3=findC_LASSO(A,b);
disp('Using LS');
visualizeC(psiLib,c1,lib);
disp('Using SLS');
visualizeC(psiLib,c2,lib);
disp('Using LASSO');
visualizeC(psiLib,c3,lib);
%% rho
threshold=0.001;
sysInfo.rho=inference_get_rho(sysInfo,U,threshold);
%% plot true and identified kernel and rho
%bounds=max(sysInfo.rgrid); % domain of kernel
bounds=sysInfo.rho.support;   % learning interval
figure
phi=sysInfo.phi_kernel; % true kernel
plotKernel(phi,c1,c2,c3,psiLib,bounds,sysInfo);

%% error metric 
rgrid=sysInfo.rgrid;
R=length(rgrid);
index=sysInfo.rho.support_index-sysInfo.mid+1;
normtype=1;
disp('L-infnity norm');
errols  =errorMetric(normtype,c1,psiLib,phi,rgrid,index)
fprintf('L-infinity LS relative error = %2.2f%% \n', errols);
errosls =errorMetric(normtype,c2,psiLib,phi,rgrid,index)
fprintf('L-infinity SLS relative error = %2.2f%% \n', errosls);
errolas =errorMetric(normtype,c3,psiLib,phi,rgrid,index)
fprintf('L-infinity LASSO relative error = %2.2f%% \n', errolas);

normtype=2;
disp('L-2 norm');
errols2  =errorMetric(normtype,c1,psiLib,phi,rgrid,index)
fprintf('L2 LS relative error = %2.2f%% \n', errols2);
errosls2 =errorMetric(normtype,c2,psiLib,phi,rgrid,index)
fprintf('L2 SLS relative error = %2.2f%% \n', errosls2);
errolas2 =errorMetric(normtype,c3,psiLib,phi,rgrid,index)
fprintf('L2 LASSO relative error = %2.2f%% \n', errolas2);
%% relative error
disp('L2 rho norm');
L2rhols  =evaluation_error(sysInfo,c1,psiLib)
fprintf('L2 rho LS relative error = %2.2f%% \n', L2rhols);
L2rhosls =evaluation_error(sysInfo,c2,psiLib)
fprintf('L2 rho SLS relative error = %2.2f%% \n', L2rhosls);
L2rholas =evaluation_error(sysInfo,c3,psiLib)
fprintf('L2 rho LASSO relative error = %2.2f%% \n', L2rholas);

%% Wasserstein distance
new_initial = 'DN_2_0.5';
ws_dist = evaluation_Wasserstein_distance(sysInfo, psiLib,c3, U, new_initial);
plot_Wasserstein_distance(ws_dist, sysInfo, all_dir, 0);

%% Free energy
free_Engy = evaluation_Free_energy(sysInfo, c3,psiLib, U);
plot_Free_energy(free_Engy, sysInfo, all_dir, 0);

