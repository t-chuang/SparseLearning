function [] = plotSystem(t, X, d, N, M, ttl, clr)
% plots system depending on dimension

%%
% plot

for m = 1:M
    if d == 1
        figure
        IC = plot(0,X{m}(1,:),append(clr,'o')); % plot initial position as 'o'
        hold on;
        for i = 1:N        
            traj = plot(t,X{m}(:,i),append(clr,'-'));
        end
        title(strcat(ttl, ", m = ", num2str(m)));
        legend([IC(1), traj(1)],{'IC', 'trajectory'});
        hold off;
    elseif d == 2
        figure
        IC = plot(X{m}(1,1:d:d*N), X{m}(1,2:d:d*N), 'o', 'MarkerSize', 3, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');
        hold on;
        for j = 1:d:d*N
            colormap('winter');
            traj = patch([X{m}(:,j)', NaN], [X{m}(:,j+1)', NaN], [0:t(length(t))/(size(X{m},1)-1):t(length(t)), NaN], 'EdgeColor', 'interp', 'LineStyle', '-', 'LineWidth', 1.5);
            set(traj, 'EdgeAlpha', 0.5);
        end
        title(strcat(ttl, ", m = ", num2str(m)));
        clabels = {'0', 'tf'};
        cticks = [0 t(length(t))];
        cbar = colorbar('YTickLabel', clabels, 'YTick', cticks, 'Location', 'Eastoutside');
        set(cbar, 'FontSize', 15);
        hold off;
    else
        figure
        IC = plot3(X{m}(1,1:d:d*N), X{m}(1,2:d:d*N), X{m}(1,3:d:d*N), 'o', 'MarkerSize', 3, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');
        hold on;
        for j = 1:d:d*N
            colormap('winter');
            traj = patch([X{m}(:,j)', NaN], [X{m}(:,j+1)', NaN], [X{m}(:,j+2)', NaN], [0:t(length(t))/(size(X{m},1)-1):t(length(t)), NaN], 'EdgeColor', 'interp', 'LineStyle', '-', 'LineWidth', 1.5);
            set(traj, 'EdgeAlpha', 0.5);
        end
        title(strcat(ttl, ", m = ", num2str(m)));
        clabels = {'0', 'tf'};
        cticks = [0 t(length(t))];
        cbar = colorbar('YTickLabel', clabels, 'YTick', cticks, 'Location', 'Eastoutside');
        set(cbar, 'FontSize', 15);
        hold off;
    end
end

end
