function a=Af(U,sysInfo,psiLib,progressON)
if progressON
    fs={'\b\b%d%%','\b\b\b%d%%'};%waitbar
    fprintf('Generate stack Matrix A progress: 0%%');
end

L=sysInfo.TN+1; % the number of time grid points
a=[];
for l=1:L
    a=[a;Al(U,sysInfo,psiLib,l)];
    if progressON
        j= floor(l/(L/100));
        fprintf(fs{1+(j>=10)},j);
    end
end
if progressON; fprintf('\n'); end
end
