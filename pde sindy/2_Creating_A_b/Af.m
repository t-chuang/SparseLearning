function a=Af(U,sysInfo,psiLib,progressON)
if progressON
    fs={'\b\b%d%%','\b\b\b%d%%'};%waitbar
    fprintf('Generate stack Matrix A progress: 0%%');
end

TN=sysInfo.TN+1; % the number of time grid points
a=[];
for l=1:TN
    a=[a;Al(U,sysInfo,psiLib,l)];
    if progressON
        j= floor(l/(TN/100));
        fprintf(fs{1+(j>=10)},j);
    end
end
if progressON; fprintf('\n'); end
end

%%

function al = Al(U,sysInfo,psiLib,l)
J=length(psiLib);
for i=1:J
    for j=i:J
        al(i,j)=Gip(U,sysInfo,psiLib{j},psiLib{i},l);
        al(j,i)=al(i,j);
    end
end
end
