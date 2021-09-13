function dotX = RHShetsys(t,X,d,N,phi)
% forms the heterogeneous system

X1 = X(1:d*N{1});
X2 = X(d*N{1}+1:d*(N{1}+N{2}));

f_11 = RHS(t,X1,X1,d,N{1},phi{1}); % d*N{1} x 1
f_12 = RHS(t,X1,X2,d,N{1},phi{2}); % d*N{1} x 1
f_21 = RHS(t,X2,X1,d,N{2},phi{3}); % d*N{2} x 1
f_22 = RHS(t,X2,X2,d,N{2},phi{4}); % d*N{2} x 1

dotX = [f_11+f_12; f_21+f_22]; % d*(N{1}+N{2}) x 1
end

