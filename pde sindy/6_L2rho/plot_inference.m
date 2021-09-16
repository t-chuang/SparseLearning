function plot_inference(sysInfo)
% generate the figures of spline and rkhs results
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

fig = figure;
left_color = [0 0.4470 0.7410];
right_color = [0 0 0];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);

yyaxis right
fill([dx,dx:dx:L,L],[0 rho(mid+1:end)' 0],'k','EdgeColor','k','FaceColor',[0.5,0.5,0.5],'FaceAlpha',0.2);ylabel('\rho(r)')
xlim([dx rho_supp]);    
end