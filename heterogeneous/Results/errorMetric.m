function error = errorMetric(normtype,c,psiLib,phi,rspan)

% create identified kernel
n = length(psiLib);
for j=1:4
    phihat = @(r) 0;
    for i = 1:n
        phihat = @(r) phihat(r) + c{j}(i).*psiLib{i}(r);
    end
    
    span = rspan{j}(1):(rspan{j}(2)-rspan{j}(1))/100:rspan{j}(2);
    % compute error depending on norm
    switch normtype
        case 1              % Linf norm
            error(j) = norm(abs(phi{j}(span)-phihat(span)),inf);
        case 2              % L2 norm
            error(j)= norm(phi{j}(span)-phihat(span),2)/(norm(phi{j}(span))+eps);
    end
end

end

