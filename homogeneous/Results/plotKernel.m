function [] = plotKernel(phi,c,psiLib,bounds,ttl)
% plots the kernel function as well as the approximated kernel function using c and the psi library

n = length(psiLib);
iden = @(r) 0;
for i = 1:n
    iden = @(r) iden(r) + c(i).*psiLib{i}(r);
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