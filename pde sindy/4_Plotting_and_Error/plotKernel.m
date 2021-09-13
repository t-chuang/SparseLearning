function [] = plotKernel(phi,c,psiLib,bounds,regtype)
% plots the kernel function as well as the approximated kernel function using c and the psi library

n = length(psiLib);
iden = @(r) 0;

for i = 1:n
iden = @(r) iden(r) + c(i).*psiLib{i}(r);
end

x = linspace(0.1, bounds, 1000);  % not start with 0 since some functions will explode at 0, which may not show the difference between true and identified kernel directly and clearly.

 figure
 True = plot(x,phi(x),'r-');
 hold on 
 Approx = plot(x,iden(x),'b--');
 hold off
 legend([True, Approx],{'True Kernel', 'Approximate Kernel'});
switch regtype
    case 1 
        title('LS');
    case 2
        title('SLS');
    case 3
        title('LASSO');
end

        
        
% figure
% True = plot(x,phi(x),'r-');
% legend(True,{'True Kernel'});
% 
% figure
% Approx = plot(x,iden(x),'b--');
% legend( Approx,{'Approximate Kernel'});

end 