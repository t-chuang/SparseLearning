function rspan = getrSpan(X,Xprime,bound,d,N,L,M)
% retrieves minimum pairwise distance and max pairwise distance across M and L

% check if given matrices are the same
same = isequal(X,Xprime);
Nprime = length(Xprime{1}(1,:))/d;

% initialize rmin and rmax
if same
    Xreshape = reshape(X{1}(1,:),d,N)';
    Xprimereshape = reshape(Xprime{1}(1,:),d,N)';
    temp = [];
    
    for i = 1:N
        Xprimetemp = Xprimereshape;
        Xprimetemp(i,:) = [];
        for j = 1:N-1            
            temp = [temp pdist([Xreshape(i,:); Xprimetemp(j,:)])];
        end
    end
else
    Xreshape = reshape(X{1}(1,:),d,N)';
    Xprimereshape = reshape(Xprime{1}(1,:),d,Nprime)';
    temp = [];
    
    for i = 1:N
        for j = 1:Nprime            
            temp = [temp pdist([Xreshape(i,:); Xprimereshape(j,:)])];
        end
    end
end
rmin = min(temp);
rmax = max(temp);

for m = 1:M
    for l = 1:L        
        if same
            Xreshape = reshape(X{m}(l,:),d,N)';
            Xprimereshape = reshape(Xprime{m}(l,:),d,N)';
            temp = [];

            for i = 1:N
                Xprimetemp = Xprimereshape;
                Xprimetemp(i,:) = [];
                for j = 1:N-1            
                    temp = [temp pdist([Xreshape(i,:); Xprimetemp(j,:)])];
                end
            end
        else
            Xreshape = reshape(X{m}(l,:),d,N)';
            Xprimereshape = reshape(Xprime{m}(l,:),d,Nprime)';
            temp = [];

            for i = 1:N
                for j = 1:Nprime            
                    temp = [temp pdist([Xreshape(i,:); Xprimereshape(j,:)])];
                end
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

