function inp = Gip(U,sysInfo,phi,psi,l)
%<<phi,psi>>_{G^l}
rgrid=sysInfo.rgrid;
R=length(rgrid);
%  intgr2=[];
%  for s=2:R     % starts from index 2 since index 1 include 0 in domain, which might return NaN.  
%      intgr1=[];
%      for r =2:R
%          intgr1=[intgr1 phi(rgrid(r))*psi(rgrid(s))*G(U,sysInfo,l,r,s)];
%      end
%      intgr2=[intgr2 trapz(intgr1,rgrid(2:R))];
%  end 
%  inp=trapz(intgr2,rgrid(2:R));

 x=rgrid(2:R);
 y=rgrid(2:R);
 [X,Y]=meshgrid(x,y);
 Gm=zeros(R-1,R-1);
 for s=2:R     % starts from index 2 since index 1 include 0 in domain, which might return NaN.  
      for r =s:R
          Gm(s-1,r-1)=G(U,sysInfo,l,r,s);
          Gm(r-1,s-1)=Gm(s-1,r-1);%
      end
 end 
 F=phi(X).*psi(Y).*Gm;
 
 inp= trapz(y,trapz(x,F,2));

end 

