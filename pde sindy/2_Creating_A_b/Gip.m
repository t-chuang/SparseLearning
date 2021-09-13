function inp = Gip(U,sysInfo,phi,psi,l)
%<<phi,psi>>_{G^l}
rgrid=sysInfo.rgrid;
R=length(rgrid);
intgr2=[];
for s=2:R     % starts from index 2 since index 1 include 0 in domain, which might return NaN.  
    intgr1=[];
    for r =2:R
        intgr1=[intgr1 phi(rgrid(r))*psi(rgrid(s))*G(U,sysInfo,l,r,s)];
    end
    intgr2=[intgr2 trapz(intgr1,rgrid(2:R))];
end 
inp=trapz(intgr2,rgrid(2:R));
end 

