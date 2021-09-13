function c = findC_LASSO(A,b)
% LASSO
% perform lasso algorithm
[C FitInfo] = lasso(A,b,'CV',size(A,2)); 
c_hat = C(:,FitInfo.Index1SE);

debiasedc = pinv(A(:,abs(c_hat)>0))*b;

ind = 1;
for i = 1:length(c_hat)
    if abs(c_hat(i))>0
        c_hat(i) = debiasedc(ind);
        ind = ind + 1;
    end
end

c = c_hat;

end