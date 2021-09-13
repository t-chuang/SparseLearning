function Gl = G(U,sysInfo,l,r,s)
% G^l(r,s)
% r and s here are index
xgrid=sysInfo.xgrid;
M=sysInfo.M+1;
temp={};
for i=1:4
    temp{i}=[];
end 
for m=1:M
    temp{1}=[temp{1} u3(U,m,l,r,1,s,1)];
    temp{2}=[temp{2} u3(U,m,l,r,-1,s,1)];
    temp{3}=[temp{3} u3(U,m,l,r,1,s,-1)];
    temp{4}=[temp{4} u3(U,m,l,r,-1,s,-1)];
end 
    Gl=trapz(temp{1},xgrid)-trapz(temp{2},xgrid)-trapz(temp{3},xgrid)+trapz(temp{4},xgrid);
end

%%
function intgr = u3(U,x,l,r,theta,s,eta)
% u(x-r,t_l)*u(x-s,t_l)*u(x,t_l)
% r and s here are index 
n=length(U(:,1)); % get the number of rows in U
m1=x+r*theta;
m2=x+s*eta;
m3=x;
if (m1<=0 | m1>n| m2<=0 | m2>n| m3<=0 | m3>n) 
    intgr=0;   
else
    intgr=U(m1,l)*U(m2,l)*U(m3,l);
end

end