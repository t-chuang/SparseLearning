function Theta = generateTheta(t,X,Xprime,psiLib,d,N)
    
n = length(psiLib); % number of candidate functions psi
Theta = zeros(d*N, n);
    
for i = 1:n
    Theta(:,i) = RHS(t,X,Xprime,d,N,psiLib{:,i}); % Theta is d*N x n
end

end