function L2rho = evaluation_error(sysInfo,c,psiLib)
% get L^2(rho)
n = length(psiLib);
iden = @(r) 0;

for i = 1:n
iden = @(r) iden(r) + c(i).*psiLib{i}(r);
end


dx = sysInfo.dx;
xgrid = sysInfo.xgrid;
rho = sysInfo.rho;
phi= sysInfo.phi_kernel;;

phiv=phi(xgrid)';
idenv=iden(xgrid)';

%% L2_rho
L2rho = sqrt(trapz(((idenv-phiv).^2.*rho.val_fine))*dx);
end