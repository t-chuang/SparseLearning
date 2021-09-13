function c = findC_SLS(A,b,lambda)
% compute Sparse regression: sequential least squares

c = A\b;  % initial guess: Least-squares
L=length(A(:,1))/length(A(1,:));
% lambda is our sparsification knob.
for k=1:10
    smallinds = (abs(c)<lambda);   % find small coefficients
    c(smallinds)=0;                % and threshold
    
    bigindsc= ~smallinds;
    bigindsA=bigindsc';
%     bigindsb=[];
%     for i=1:L
%         bigindsb=[bigindsb;bigindsc];
%     end
%     bigindsb=logical(bigindsb);
    % Regress dynamics onto remaining terms to find sparse Xi
    c(bigindsc) = A(:,bigindsA)\b; 
end
end 
