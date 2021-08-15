function y0 = generateIC(IC)
% generate initial conditions in a domain
d = IC.d;
N = IC.N1 + IC.N2;

switch d
    case 1        
        y0 = (IC.x2-IC.x1)*rand(d*N,1)+IC.x1;
    case 2
        switch IC.shape
            case 1 
                tempx = (IC.x2-IC.x1)*rand(N,1)+IC.x1;
                tempy = (IC.y2-IC.y1)*rand(N,1)+IC.y1;
                
                y0(1:d:d*N) = tempx;
                y0(2:d:d*N) = tempy;
            case 2
                theta = 2*pi*rand(1,N);
                r = IC.radius*rand(1,N);
                tempx = r.*cos(theta)+IC.centerx;
                tempy = r.*sin(theta)+IC.centery;
                
                y0(1:d:d*N) = tempx;
                y0(2:d:d*N) = tempy;   
            case 3
                theta = 2*pi*rand(1,N);
                r = (IC.radius2-IC.radius1)*rand(1,N)+IC.radius1;
                tempx = r.*cos(theta)+IC.centerx;
                tempy = r.*sin(theta)+IC.centery;

                y0(1:d:d*N) = tempx;
                y0(2:d:d*N) = tempy;
        end
    case 3
        switch IC.shape
            case 1
                tempx = (IC.x2-IC.x1)*rand(N,1)+IC.x1;
                tempy = (IC.y2-IC.y1)*rand(N,1)+IC.y1;
                tempz = (IC.z2-IC.z1)*rand(N,1)+IC.z1;

                y0(1:d:d*N) = tempx;
                y0(2:d:d*N) = tempy;
                y0(3:d:d*N) = tempz;
            case 2
                phi = 2*pi*rand(1,N);
                theta = 2*pi*rand(1,N);
                r = IC.radius*rand(1,N);                
                tempx = r.*cos(theta).*sin(phi)+IC.centerx;
                tempy = r.*sin(theta).*sin(phi)+IC.centery;
                tempz = r.*cos(phi)+IC.centerz;
                
                y0(1:d:d*N) = tempx;
                y0(2:d:d*N) = tempy;
                y0(3:d:d*N) = tempz;
        end
end

end
