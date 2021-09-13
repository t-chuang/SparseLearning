function dotXhat = RHShat(t,X,d,N,c,psiLib)
% creates the identified system that approximates dotX

X1 = X(1:d*N{1});
X2 = X(d*N{1}+1:d*(N{1}+N{2}));

% form Theta = [f_psi_1 ... f_psi_n]
Theta11 = generateTheta(t,X1,X1,psiLib,d,N{1});
Theta12 = generateTheta(t,X1,X2,psiLib,d,N{1});
Theta21 = generateTheta(t,X2,X1,psiLib,d,N{2});
Theta22 = generateTheta(t,X2,X2,psiLib,d,N{2});

dotXhat = [Theta11*c{1} + Theta12*c{2}; Theta21*c{3} + Theta22*c{4}];
end

