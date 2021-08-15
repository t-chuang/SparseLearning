function c = findC_LS(tA,X,Xprime,dotX,d,N,L,M,psiLib)
% taken from derivation of least squares to find C by Dongyang
% Least squares solution

right = 0;
left = 0;

for m = 1:M
    rtemp = 0;
    ltemp = 0;
    for l = 1:L
        Theta = generateTheta(tA(l),X{m}(l,:)',Xprime{m}(l,:)',psiLib,d,N); % d*N x n
        
        rtemp = rtemp + Theta'*dotX{m}(:,l);
        ltemp = ltemp + Theta'*Theta;
    end
    
    right = right + rtemp;
    left = left + ltemp;
end

if N ~= 1
    c = left\right;
else
    c = zeros(size(psiLib'));
end

end