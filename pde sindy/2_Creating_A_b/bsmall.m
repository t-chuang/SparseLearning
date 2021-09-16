function b=bsmall(U,sysInfo,psiLib,progressON,k)
if progressON
    fs={'\b\b%d%%','\b\b\b%d%%'};%waitbar
    fprintf('Generate stack vector bsmall progress: 0%%');
end

L=sysInfo.TN+1; % number of time grid points 
b=[];
for l=1:k:L
    b=[b;bl(U,sysInfo,psiLib,l)];
    if progressON
        j= floor(l/(L/100));
        fprintf(fs{1+(j>=10)},j);
    end
end
if progressON; fprintf('\n'); end

end


