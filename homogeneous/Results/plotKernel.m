function [] = plotKernel(phi,c,psiLib,rspan,ttl)
% plots the kernel function as well as the approximated kernel function using c and the psi library

n = length(psiLib);
iden = @(r) 0;
for i = 1:n
    iden = @(r) iden(r) + c(i).*psiLib{i}(r);
end

if min(phi(rspan(1):0.01:rspan(2))) ~= max(phi(rspan(1):0.01:rspan(2)))
    rspan = [rspan(1) rspan(2) min(phi(rspan(1):0.01:rspan(2))) max(phi(rspan(1):0.01:rspan(2)))];  % [left right bottom top] bounds
else
    rspan = [rspan(1) rspan(2) min(phi(rspan(1):0.01:rspan(2)))-1 min(phi(rspan(1):0.01:rspan(2)))+1];
end

x = linspace(rspan(1), rspan(2), 1000);

figure
True = plot(x,phi(x),'r-');
hold on 
Approx = plot(x,iden(x),'b-');
hold off
legend([True, Approx],{'True Kernel', 'Approximate Kernel'})
title(ttl)
axis(rspan);
end 