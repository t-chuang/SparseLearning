function dotXhat = RHShat(t,X,d,N,C,psiLib)
% creates the identified system that approximates dotX

% form Theta = [f_psi_1 ... f_psi_n]
Theta = generateTheta(t,X,psiLib,d,N);

dotXhat = Theta*C;
end

