function error = errorMetric(normtype,c,psiLib,phi,rspan)

% create identified kernel
n = length(psiLib);
phihat = @(r) 0;
for i = 1:n
    phihat = @(r) phihat(r) + c(i).*psiLib{i}(r);
end

span = rspan(1):(rspan(2)-rspan(1))/100:rspan(2);
% compute error depending on norm
switch normtype
    case 1              % Linf norm
        error = norm(abs(phi(span)-phihat(span)),inf);
    case 2              % L2 norm
        error = norm(phi(span)-phihat(span),2)/(norm(phi(span))+eps); % gives relative error
end

end

