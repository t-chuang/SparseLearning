function error = errorMetric(normtype,c,psiLib,phi,rgrid,index)

% create identified kernel
n = length(psiLib);
phihat = @(r) 0;

for i = 1:n
    phihat = @(r) phihat(r) + c(i).*psiLib{i}(r);
end

% compute error depending on norm
rgrid=rgrid(1:index);
switch normtype
    case 1              % Linf norm
        error = norm(abs(phi(rgrid)-phihat(rgrid)),inf)/norm(abs(phi(rgrid)),inf);
    case 2              % L2 norm
        error= norm(phi(rgrid)-phihat(rgrid),2)/norm(phi(rgrid),2);
end


end

