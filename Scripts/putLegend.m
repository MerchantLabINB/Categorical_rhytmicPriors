% putLegend is a function to put the legend for specific points, you can
% customize the number of legends that you need, you only need to add or
% delete the NaN plots to make in the figure
% INPUT: leg - structure with the strings for the legend; mkr - marker
% specification; colors - structure with the colors, msz - marker size; wd
% - width for the line
function putLegend(ls_leg,mkr,colors,msz,wd,sz,opt)
switch opt
    case 'all_IT'
        gcf
        hold on
        L(1) = plot(nan, nan, mkr{1,1},'Color',colors{1,4},'MarkerSize',msz,'LineWidth',wd);
        L(2) = plot(nan, nan, mkr{1,1},'Color',colors{1,3},'MarkerSize',msz,'LineWidth',wd);
        L(3) = plot(nan, nan, mkr{1,1},'Color',colors{1,2},'MarkerSize',msz,'LineWidth',wd);
        % UNCOMMENT if you have iterations
        L(4) = plot(nan, nan, mkr{1,1},'Color',colors{1,1},'MarkerSize',msz,'LineWidth',wd);
        L(5) = plot(nan, nan, mkr{1,1},'Color',colors{1,5},'MarkerSize',msz,'LineWidth',wd);

        leg = legend(L,ls_leg)
        leg.EdgeColor = 'none';
        leg.FontName = 'Arial';
        leg.FontSize = sz;
        leg.Location = "bestoutside";

    case 'lastIT'
        gcf
        hold on
        for n = 1:length(ls_leg)
            L(n) = plot(nan, nan, mkr{1,1},'Color',colors{1,n},'MarkerSize',msz,'LineWidth',wd);
        end

        % L(1) = plot(nan, nan, mkr{1,1},'Color',colors{1,1},'MarkerSize',msz,'LineWidth',wd);
        % L(2) = plot(nan, nan, mkr{1,1},'Color',colors{1,2},'MarkerSize',msz,'LineWidth',wd);
        % L(3) = plot(nan, nan, mkr{1,1},'Color',colors{1,3},'MarkerSize',msz,'LineWidth',wd);


        leg = legend(L,ls_leg);
        leg.EdgeColor = 'none';
        leg.FontName = 'Arial';
        leg.FontSize = sz;
        leg.Location = "bestoutside";
    case 'Sync'
        gcf
        hold on
        L(1) = plot(nan, nan, mkr{1,1},'Color',colors{1,1},'MarkerSize',msz,'LineWidth',wd);
        L(2) = plot(nan, nan, mkr{1,2},'Color',colors{1,2},'MarkerSize',msz,'LineWidth',wd);

        leg = legend(L,ls_leg)
        leg.EdgeColor = 'none';
        leg.FontName = 'Arial';
        leg.FontSize = sz;
        leg.Location = "bestoutside";
end


end