function error = errorTraj(XA,XB,d,N,L,M)

agent_avg_error = zeros(M,1);
for m = 1:M
    traj_avg_error = zeros(N,1);
    for i = 1:d:N
        XA_agent = XA{m}(:,i:i+d-1);
        XB_agent = XB{m}(:,i:i+d-1);
        
        abs_error = XA_agent-XB_agent;
        rel_error = abs_error./XA_agent;
        
        squared_rel_error = rel_error.^2;
        sum = zeros(L,1);
        for j = 1:d
            sum = sum + squared_rel_error(:,j);
        end 
        pdist_rel_error = sqrt(sum);

        
        traj_avg_error(i) = mean(pdist_rel_error);
    end
    agent_avg_error(m) = mean(traj_avg_error);
end
sys_avg_error = mean(agent_avg_error);

error = sys_avg_error;
end

