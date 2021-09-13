function c = findC_SLS(tA,X,Xprime,dotX,d,N,L,M,psiLib,lambda)
% compute Sparse regression: sequential least squares

c = findC_LS(tA,X,Xprime,dotX,d,N,L,M,psiLib);  % initial guess: Least-squares

% lambda is our sparsification knob.
for k=1:10
    smallinds = (abs(c)<lambda);   % find small coefficients
    c(smallinds)=0;                % and threshold
    
    biginds = ~smallinds;
    % Regress dynamics onto remaining terms to find sparse Xi
    c(biginds) = findC_LS(tA,X,Xprime,dotX,d,N,L,M,psiLib(biginds)); 
end

end

