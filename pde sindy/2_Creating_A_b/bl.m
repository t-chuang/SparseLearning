function bl = bl(U,sysInfo,psiLib,l)
phi=sysInfo.phi_kernel;
J=length(psiLib);
bl=zeros(J,1);
for i=1:J
    bl(i)=Gip(U,sysInfo,phi,psiLib{i},l); 
end
end
