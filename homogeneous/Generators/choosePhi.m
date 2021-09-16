function phi = choosePhi(N)
% choose which kernel function to use

% prompt
phiType = input("Enter:" + newline + "1 for $\phi(r)=\cos{\frac{\pi*r}{2}}, 0<r<1" + newline + "2 for custom phi" + newline);

% phi(r) = 1 or phi(r) = cos(pi*r/2)
switch phiType
    case 1
        phi = @(r) ((r>0) & (r<1)) .* cos(pi*r/2);         % kernel for phi(r) = cos(pi*r/2)
    case 2
        phi = input("phi(r) = ")
    otherwise
        error('Enter a value of 1 or 2');
end

end

