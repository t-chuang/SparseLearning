function [] = plotKernel(phi,c1,c2,c3,psiLib,bounds,sysInfo)
% plots the kernel function as well as the approximated kernel function using c and the psi library
fig = figure;
marker_pal = {'o', '*'; 's', '^'; 'o', '*'};  % marker palette
color_pal = {'k', 'r-'; 'b', 'm'; 'b', 'm'};   % color palette

n = length(psiLib);
idenls = @(r) 0;
idensls = @(r) 0;
idenlas = @(r) 0;

for i = 1:n
idenls = @(r) idenls(r)+ c1(i).*psiLib{i}(r);
end
for i = 1:n
idensls = @(r) idensls(r) + c2(i).*psiLib{i}(r);
end
for i = 1:n
idenlas = @(r) idenlas(r) + c3(i).*psiLib{i}(r);
end

x = linspace(0.00001, bounds, 1000);

True = plot(x,phi(x),'-r','MarkerSize', 50,'LineWidth',5);
hold on 
Approxls = plot(x,idenls(x),':b','MarkerSize', 20,'LineWidth',5);
Approxsls = plot(x,idensls(x),':g','MarkerSize', 20,'LineWidth',5);
Approxlas = plot(x,idenlas(x),':y','MarkerSize', 20,'LineWidth',5);
ylim([-10,50]);
%% parameters
rho = sysInfo.rho.val_fine;
dx = sysInfo.dx;
%% -------- plotting -------

xgrid = sysInfo.xgrid;
mid = sysInfo.mid;
LW = 4;
L = sysInfo.L;

threshold = 0.001;
ind_temp = find(rho > threshold);
ind_temp = ind_temp(end);
rho_supp = xgrid(ind_temp);


left_color = [0 0.4470 0.7410];
right_color = [0 0 0];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);

yyaxis right
rho = fill([dx,dx:dx:L,L],[0 rho(mid+1:end)' 0],'k','EdgeColor','k','FaceColor',[0.5,0.5,0.5],'FaceAlpha',0.2);ylabel('\rho(r)')
xlim([dx rho_supp]);
leg1 = legend([True, Approxls,Approxsls,Approxlas,rho],{'True Kernel', 'Approx Kernel (LS)','Approx Kernel (SLS)','Approx Kernel (LASSO)','ρ'});
set(leg1,'position',[1/2, 2/3, 0.2 0.2])
set(gca,'FontSize',14);



end 