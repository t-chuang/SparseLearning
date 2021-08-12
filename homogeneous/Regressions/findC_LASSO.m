function c = findC_LASSO(tA,XA,dotX,d,N,L,M,psiLib)
% LASSO

% Stack thetas and dotX_l for each time step and system
Theta = [];
dotX_stack = [];
for m = 1:M
    for l = 1:L
        dotX_stack = [dotX_stack; dotX{m}(:,l)]; % d*N*M*L x 1
        Theta = [Theta; generateTheta(tA(l),XA{m}(l,:)',psiLib,d,N)]; % d*N*M*L x n
    end
end

% perform lasso algorithm
[C FitInfo] = lasso(Theta,dotX_stack,'CV',size(Theta,2)); 
c_hat = C(:,FitInfo.Index1SE);

debiasedc = pinv(Theta(:,abs(c_hat)>0))*dotX_stack;

ind = 1;
for i = 1:length(c_hat)
    if abs(c_hat(i))>0
        c_hat(i) = debiasedc(ind);
        ind = ind + 1;
    end
end

c = c_hat;

end