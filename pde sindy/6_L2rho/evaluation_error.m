function reL2rho = evaluation_error(sysInfo,c,psiLib)
% get L^2(rho)
n = length(psiLib);
iden = @(r) 0;

for i = 1:n
iden = @(r) iden(r) + c(i).*psiLib{i}(r);
end


dx = sysInfo.dx;
rgrid = sysInfo.rgrid;
rho = sysInfo.rho;
phi= sysInfo.phi_kernel;;
index=rho.support_index-sysInfo.mid+1;

phiv=phi(rgrid(1:index))';
idenv=iden(rgrid(1:index))';

%% L2_rho
L2rho = sqrt(trapz(((idenv-phiv).^2.*rho.val_fine(1:index)))*dx);
%% relative error
L2_norm = sqrt(trapz(phiv.^2 .* rho.val_fine(1:index))* dx);
reL2rho=L2rho/L2_norm;
end