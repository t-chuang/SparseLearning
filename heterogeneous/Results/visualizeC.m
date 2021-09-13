function [] = visualizeC(psiLib,c,lib,ttl)

output{1,1} = 'candidate psi functions';
output{1,2} = 'i';
output{1,3} = 'coefficients';

ind = 1;

for i = 0:lib.exporder
    output{ind+1,1} = psiLib{:,ind};
    output{ind+1,2} = strcat('i=', num2str(i));
    output{ind+1,3} = num2str(c(ind));
    ind = ind+1;
end

for i = 1:lib.usesine
    output{ind+1,1} = psiLib{:,ind};
    output{ind+1,2} = strcat('i=', num2str(i));
    output{ind+1,3} = num2str(c(ind));
    ind = ind+1;
end

for i = 1:lib.usecos
    output{ind+1,1} = psiLib{:,ind};
    output{ind+1,2} = strcat('i=', num2str(i));
    output{ind+1,3} = num2str(c(ind));
    ind = ind+1;
end

for i = 1:lib.ratexp
    output{ind+1,1} = psiLib{:,ind};
    output{ind+1,2} = strcat('i=', num2str(i));
    output{ind+1,3} = num2str(c(ind));
    ind = ind+1;
end

for i = 1:lib.cosker
    output{ind+1,1} = psiLib{:,ind};
    output{ind+1,2} = strcat('i=', num2str(i));
    output{ind+1,3} = num2str(c(ind));
    ind = ind+1;
end

for i = 1:lib.legorder
    output{ind+1,1} = psiLib{:,ind};
    output{ind+1,2} = strcat('i=', num2str(i));
    output{ind+1,3} = num2str(c(ind));
    ind = ind+1;
end

for i = 1:lib.chebyorder
    output{ind+1,1} = psiLib{:,ind};
    output{ind+1,2} = strcat('i=', num2str(i));
    output{ind+1,3} = num2str(c(ind));
    ind = ind+1;
end

disp(ttl)
disp(output)
end

