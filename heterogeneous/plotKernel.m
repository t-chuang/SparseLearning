function [] = plotKernel(phi,c,psiLib,rmax,ttl)
% plots the kernel function as well as the approximated kernel function using c and the psi library

n = length(psiLib);
iden = @(r) 0;
for i = 1:n
    iden = @(r) iden(r) + c(i).*psiLib{i}(r);
end

if min(phi(0:0.01:rmax)) ~= max(phi(0:0.01:rmax))
    bounds = [0 rmax min(phi(0:0.01:rmax)) max(phi(0:0.01:rmax))];  % [left right bottom top] bounds
else
    bounds = [0 rmax min(phi(0:0.01:rmax))-1 min(phi(0:0.01:rmax))+1];
end

x = linspace(0, bounds(2), 1000);

figure
True = plot(x,phi(x),'r-');
hold on 
Approx = plot(x,iden(x),'b-');
hold off
legend([True, Approx],{'True Kernel', 'Approximate Kernel'})
title(ttl)
axis(bounds);

end 