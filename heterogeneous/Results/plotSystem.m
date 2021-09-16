function [] = plotSystem(t, X, d, N, M, T_L, ttl)
% plots system depending on dimension

%%
% plot

Ntotal = N{1}+N{2};
for m = 1:M
    X1{m} = X{m}(:,1:d*N{1});
    X2{m} = X{m}(:,d*N{1}+1:d*(N{1}+N{2}));
    
    if d == 1
        figure
        title(strcat(ttl, ", m = ", num2str(m)));
        
        training_interval = plot(t(T_L),X{m}(T_L,:),append(clr,'o')); % plot training inverval as 'o'
        hold on;
        
        for i = 1:N{1}        
            traj1 = plot(t,X1{m}(:,i),'r-');            
        end
        
        for i = 1:N{2} 
            traj2 = plot(t,X2{m}(:,i),'b-');
        end   
        
        legend([traj1(1), traj2(1)],{'Species 1', 'Species 2'});
        
        hold off;
    elseif d == 2
        figure
        
        axis1 = axes;
        title(strcat(ttl, ", m = ", num2str(m)));
        axis2 = axes;
        axis2.Visible = 'off';
        axis2.XTick = [];
        axis2.YTick = [];
        
        training_interval = plot(axis1, X{m}(T_L,1:d:d*Ntotal), X{m}(T_L,2:d:d*Ntotal), 'o', 'MarkerSize', 3, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');
        hold on;
        
        for i = 1:d:d*N{1}
            traj1 = patch(axis1, [X1{m}(:,i)', NaN], [X1{m}(:,i+1)', NaN], [0:t(length(t))/(size(X1{m},1)-1):t(length(t)), NaN], 'EdgeColor', 'interp', 'LineStyle', '-', 'LineWidth', 1.5);
            set(traj1, 'EdgeAlpha', 0.5);   
        end
        
        for i = 1:d:d*N{2}
            traj2 = patch(axis2, [X2{m}(:,i)', NaN], [X2{m}(:,i+1)', NaN], [0:t(length(t))/(size(X2{m},1)-1):t(length(t)), NaN], 'EdgeColor', 'interp', 'LineStyle', '-', 'LineWidth', 1.5);          
            set(traj2, 'EdgeAlpha', 0.5);
        end
        linkaxes([axis1,axis2]);
        link = linkprop([axis1,axis2],{'XLim','YLim','ZLim','CameraUpVector','CameraPosition','CameraTarget'});
        setappdata(gcf, 'StoreTheLink', link);
        
        clabels = {'0', 'T_L', 'T_f'};
        cticks = [0 t(T_L) t(length(t))];
        
        colormap(axis1,'spring');
        cbar1 = colorbar(axis1, 'YTickLabel', clabels, 'YTick', cticks, 'AxisLocation', 'in', 'Position', [0.02 0.1095 0.0381 0.8167]);
        set(cbar1, 'FontSize', 15);
        title(cbar1, 'First species');
        colormap(axis2,'winter')
        cbar2 = colorbar(axis2, 'YTickLabel', clabels, 'YTick', cticks, 'Position', [0.925 0.1095 0.0381 0.8167]);
        set(cbar2, 'FontSize', 15);
        title(cbar2, 'Second species');
        
        hold off;
    else
        figure 
        
        axis1 = axes;
        title(strcat(ttl, ", m = ", num2str(m)));
        axis2 = axes;
        axis2.Visible = 'off';
        axis2.XTick = [];
        axis2.YTick = [];
        
        training_interval = plot3(axis1, X{m}(T_L,1:d:d*Ntotal), X{m}(T_L,2:d:d*Ntotal), X{m}(T_L,3:d:d*Ntotal), 'o', 'MarkerSize', 3, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');
        hold on;
        
        for i = 1:d:d*N{1}
            traj = patch(axis1, [X1{m}(:,i)', NaN], [X1{m}(:,i+1)', NaN], [X1{m}(:,i+2)', NaN], [0:t(length(t))/(size(X1{m},1)-1):t(length(t)), NaN], 'EdgeColor', 'interp', 'LineStyle', '-', 'LineWidth', 1.5);
            set(traj, 'EdgeAlpha', 0.5);
        end
        
        for i = 1:d:d*N{2}
            traj = patch(axis2, [X2{m}(:,i)', NaN], [X2{m}(:,i+1)', NaN], [X2{m}(:,i+2)', NaN], [0:t(length(t))/(size(X2{m},1)-1):t(length(t)), NaN], 'EdgeColor', 'interp', 'LineStyle', '-', 'LineWidth', 1.5);
            set(traj, 'EdgeAlpha', 0.5);
        end
        link = linkprop([axis1,axis2],{'XLim','YLim','ZLim','CameraUpVector','CameraPosition','CameraTarget'});
        setappdata(gcf, 'StoreTheLink', link);

        clabels = {'0', 'T_L', 'T_f'};
        cticks = [0 t(T_L) t(length(t))];
        
        colormap(axis1,'spring');
        cbar1 = colorbar(axis1, 'YTickLabel', clabels, 'YTick', cticks, 'AxisLocation', 'in', 'Position', [0.02 0.1095 0.0381 0.8167]);
        set(cbar1, 'FontSize', 15);
        title(cbar1, 'First species');
        colormap(axis2,'winter')
        cbar2 = colorbar(axis2, 'YTickLabel', clabels, 'YTick', cticks, 'Position', [0.925 0.1095 0.0381 0.8167]);
        set(cbar2, 'FontSize', 15);
        title(cbar2, 'Second species');
        
        hold off;
    end
end

end
