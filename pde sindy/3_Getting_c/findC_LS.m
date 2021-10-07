function  c= findC_LS(A,b)
X=transpose(A)*A;
Y=transpose(A)*b;
c=inv(X)*Y;
end