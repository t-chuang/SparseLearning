function rspan = getrSpan(X,bound,d,N,L,M)

Xreshape = reshape(X{1}(1,:),d,N)';
temp = [];

for i = 1:N
    Xreshapetemp = Xreshape;
    Xreshapetemp(i,:) = [];
    for j = 1:N-1            
        temp = [temp pdist([Xreshape(i,:); Xreshapetemp(j,:)])];
    end
end

rmin = min(temp);
rmax = max(temp);


for m = 1:M
    for l = 1:L        
        Xreshape = reshape(X{m}(l,:),d,N)';
        temp = [];

        for i = 1:N
            Xreshapetemp = Xreshape;
            Xreshapetemp(i,:) = [];
            for j = 1:N-1            
                temp = [temp pdist([Xreshape(i,:); Xreshapetemp(j,:)])];
            end
        end
        
        rmin = min([rmin, temp]);
        rmax = max([rmax, temp]);
    end
end

rspan = [rmin rmax];

% for N = 1 and same = true case
if isequal(rspan,[])
    rspan = [0 bound];
end

end

