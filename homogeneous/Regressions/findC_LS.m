function c = findC_LS(tA,XA,dotX,d,N,L,M,psiLib)
% taken from derivation of least squares to find C by Dongyang
% Least squares solution

right = 0;
left = 0;

for m = 1:M
    rtemp = 0;
    ltemp = 0;
    for l = 1:L
        Theta = generateTheta(tA(l),XA{m}(l,:)',psiLib,d,N); % d*N x n

        rtemp = rtemp + Theta'*dotX{m}(:,l);
        ltemp = ltemp + Theta'*Theta;
    end
    
    right = right + rtemp;
    left = left + ltemp;
end
    
c = left\right;

end