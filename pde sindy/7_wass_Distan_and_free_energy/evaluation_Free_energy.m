function free_Engy = evaluation_Free_energy(sysInfo, c,psiLib, U)
% Compute the free energy along the solution
% create identified kernel
n = length(psiLib);
phihat = @(r) 0;

for i = 1:n
    phihat = @(r) phihat(r) + c(i).*psiLib{i}(r);
end
%% Load parameters
dx = sysInfo.dx;
L = sysInfo.L;
mid = sysInfo.mid;
xgrid = -L:dx:L;
%% interaction potential: est and true
Phi_potential.true = sysInfo.Phi_potential(xgrid');
Phi_potential.true = Phi_potential.true - Phi_potential.true(mid);
phihatv=phihat(xgrid');
if isnan(phihatv(mid))
    phihatv(mid)=0;
end

temp = cumsum(phihatv)*dx;
Phi_potential.est = temp - temp(mid);


%% Free energy along the data u
free_Engy.est  = free_energy(U, Phi_potential.est, dx, sysInfo.v);
free_Engy.true = free_energy(U, Phi_potential.true, dx, sysInfo.v);

end