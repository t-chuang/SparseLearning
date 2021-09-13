function b=bf(U,sysInfo,psiLib,progressON)
if progressON
    fs={'\b\b%d%%','\b\b\b%d%%'};%waitbar
    fprintf('Generate stack vector b progress: 0%%');
end

TN=sysInfo.TN+1; % number of time grid points 
b=[];
for l=1:TN
    b=[b;bl(U,sysInfo,psiLib,l)];
    if progressON
        j= floor(l/(TN/100));
        fprintf(fs{1+(j>=10)},j);
    end
end
if progressON; fprintf('\n'); end

end
%%

function bl = bl(U,sysInfo,psiLib,l)
phi=sysInfo.phi_kernel;
J=length(psiLib);
bl=zeros(J,1);
for i=1:J
    bl(i)=Gip(U,sysInfo,phi,psiLib{i},l); 
end
end

