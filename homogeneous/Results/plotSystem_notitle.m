function [] = plotSystem_notitle(t, X, d, N, M, T_L, clr)
% plots system depending on dimension

%%
% plot

for m = 1:M
    if d == 1
        figure
        training_interval = plot(t(T_L),X{m}(T_L,:),append(clr,'o')); % plot end of learning interval
        hold on;
        for i = 1:N        
            traj = plot(t,X{m}(:,i),append(clr,'-'));
        end
        legend([training_interval(1), traj(1)],{'learning end', 'trajectory'});
        hold off;
    elseif d == 2
        figure
        training_interval = plot(X{m}(T_L,1:d:d*N), X{m}(T_L,2:d:d*N), 'o', 'MarkerSize', 3, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');
        hold on;
        for j = 1:d:d*N
            colormap('winter');
            traj = patch([X{m}(:,j)', NaN], [X{m}(:,j+1)', NaN], [0:t(length(t))/(size(X{m},1)-1):t(length(t)), NaN], 'EdgeColor', 'interp', 'LineStyle', '-', 'LineWidth', 1.5);
            set(traj, 'EdgeAlpha', 0.5);
        end
        clabels = {'0', 'T_L', 'T_f'};
        cticks = [0 t(T_L) t(length(t))];
        cbar = colorbar('YTickLabel', clabels, 'YTick', cticks, 'Location', 'Eastoutside');
        set(cbar, 'FontSize', 15);
        hold off;
    else
        figure
        training_interval = plot3(X{m}(T_L,1:d:d*N), X{m}(T_L,2:d:d*N), X{m}(T_L,3:d:d*N), 'o', 'MarkerSize', 3, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');
        hold on;
        for j = 1:d:d*N
            colormap('winter');
            traj = patch([X{m}(:,j)', NaN], [X{m}(:,j+1)', NaN], [X{m}(:,j+2)', NaN], [0:t(length(t))/(size(X{m},1)-1):t(length(t)), NaN], 'EdgeColor', 'interp', 'LineStyle', '-', 'LineWidth', 1.5);
            set(traj, 'EdgeAlpha', 0.5);
        end
        clabels = {'0', 'T_L', 'T_f'};
        cticks = [0 t(T_L) t(length(t))];
        cbar = colorbar('YTickLabel', clabels, 'YTick', cticks, 'Location', 'Eastoutside');
        set(cbar, 'FontSize', 15);
        hold off;
    end
end

end
