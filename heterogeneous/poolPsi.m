function psiLib = poolPsi(lib)
% creates library of n amount of functions psi

%%
% generate functions

ind = 1;

% exporder
for i = 0:lib.exporder
    psiLib{:,ind} = @(r) r.^i;
    ind = ind+1;
end

% sine
if lib.usesine ~= 0
    for i = 1:lib.usesine
        psiLib{:,ind} = @(r) sin(i*r);
        ind = ind+1;
    end
end

% cosine
if lib.usecos ~= 0
    for i = 1:lib.usecos
        psiLib{:,ind} = @(r) cos(i*r);
        ind = ind+1;
    end
end

% rational numbers
if lib.ratexp ~= 0
    for i = 1:lib.ratexp
        psiLib{:,ind} = @(r) (r+eps).^(-i);
        ind = ind+1;
    end
end

% legendre polynomials
for i=1:lib.legorder
    psiLib{:,ind} = @(r) legendreP(i,r);
    ind = ind+1;
end

% Chebyshev polynomials
for i=1:lib.chebyorder
    psiLib{:,ind} = @(r) chebyshevT(i,r); 
    ind = ind+1;
end

% cosine kernel for funsies
if lib.cosker
    psiLib{:,ind} = @(r) ((r>0) & (r<1)) .* cos(pi*r/2);
    ind = ind+1;
end
