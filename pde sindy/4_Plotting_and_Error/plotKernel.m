function [] = plotKernel(phi,c1,c2,c3,psiLib,bounds)
% plots the kernel function as well as the approximated kernel function using c and the psi library
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

x = linspace(0, bounds, 1000);

True = plot(x,phi(x),'-r','MarkerSize', 50,'LineWidth',5);
hold on 
Approxls = plot(x,idenls(x),':b','MarkerSize', 20,'LineWidth',5);
Approxsls = plot(x,idensls(x),'g','MarkerSize', 20,'LineWidth',5);
Approxlas = plot(x,idenlas(x),':y','MarkerSize', 20,'LineWidth',5);
leg1 = legend([True, Approxls,Approxsls,Approxlas],{'True Kernel', 'Approx Kernel (LS)','Approx Kernel (SLS)','Approx Kernel (LASSO)'});
set(leg1,'position',[1/2, 2/3, 0.2 0.2])


end 