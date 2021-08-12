function dotX = RHS(t,X,d,N,phi)
% creates the right hand side for the system of 1st order odes
% outputs dotX = [f_phi(1); f_phi(2);... ; f_phi(d*N)]


%% 
% reshape X so X = [x11; x12; ...; x1d; ....; xN1; ...; xNd]; d*N x 1
% turns into X = [x11, ..., xN1; x12, ...,xN2; ....; x1d, ..., xNd]; d x N
X = reshape(X,d,N);

%%
% create first-order system of ode
% dotX = f_phi
f_phi = zeros(d,N);
for i = 1:N
    r = X-repmat(X(:,i),1,N); % [x(1)-x(i), x(2)-x(i), ..., x(N)-x(i)]; d x N
    rNorm = sqrt(sum(r.^2,1)); % all dimensions collapse with norm; 1 x N
    
    interactKer = phi(rNorm)'; % plug each element of rNorm into function phi and transpose; N x 1
    
    f_phi_i = (1/N)*r*interactKer; % d x 1
    f_phi(:,i) = f_phi_i; % f_phi = [f_phi_1, ..., f_phi_N]; d x N
end

%%
% reshape so dotX is d*N x 1
dotX = reshape(f_phi, d*N, 1); % dotX = [dotx11; ...; dotx1d; ....; dotxN1; ...; dotxNd]; d*N x 1

end

