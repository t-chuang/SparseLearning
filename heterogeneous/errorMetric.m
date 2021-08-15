function error = errorMetric(normtype,c,psiLib,phi,rspan)

% create identified kernel
n = length(psiLib);
for j=1:4
    phihat = @(r) 0;
    for i = 1:n
        phihat = @(r) phihat(r) + c{j}(i).*psiLib{i}(r);
    end

    % compute error depending on norm
    switch normtype
        case 1              % Linf norm
            error(j) = norm(abs(phi{j}(rspan)-phihat(rspan)),inf);
        case 2              % L2 norm
            error(j)= norm(phi{j}(rspan)-phihat(rspan),2);
    end
end

end

