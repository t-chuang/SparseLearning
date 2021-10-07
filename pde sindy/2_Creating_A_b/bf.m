function b=bf(U,sysInfo,psiLib,progressON)
if progressON
    fs={'\b\b%d%%','\b\b\b%d%%'};%waitbar
    fprintf('Generate stack vector b progress: 0%%');
end
J=length(psiLib);
L=sysInfo.TN+1; % number of time grid points 
b=zeros(J,1);
for l=1:L
    b=b+bl(U,sysInfo,psiLib,l);
    if progressON
        j= floor(l/(L/100));
        fprintf(fs{1+(j>=10)},j);
    end
end
if progressON; fprintf('\n'); end

end


