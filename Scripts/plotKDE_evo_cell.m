%plotKDE_evo is a function to plot the kernel density across the
%iterations
%INPUT: all_Pr - array with all the mean produced ratios; allTr - ratios in Initial seed distribution; 
% N_IT - number of iterations for the data; colors - cell with the name of palette color to
%use; sz - Font size; bw - bandwidth to compute kernel density
function plotKDE_evo_cell(all_Pr,X, allTr,N_IT,colors,sz,maxN,BWS)
figure('Name','Kernel Density Evolution','NumberTitle','off')
series = [1,5,10,15];
xx = 0:0.001:1;
[den_est,xi] = ksdensity(allTr,xx,'Bandwidth',BWS);%get f (probability density estimate) and xi (equally-spaced points)
normTr = den_est/(sum(den_est(:))); 
posK = normTr./max(normTr); %scaling to 1 

hold all
plot(xi,posK,'-','Color',colors{1,5},'LineWidth',1.5); %Seeds blue:#0D47A1 green: [0.4660 0.6740 0.1880]

ct = 0;
for i = 1:N_IT
    hold all
    nBySD = all_Pr{1,i};
    posK = (nBySD./max(nBySD))+i;
    xii = X{1,1}{:,i};
    if ismember(i,series)
        ct = ct + 1;
        clr = colors{1,ct};
    else
        clr = colors{1,ct};
    end

    plot(xii,posK,'-','Color',clr,'LineWidth',2); %Produced Ratios
    yline(i)

end

squareRatio2(maxN,(N_IT+1)+0.2,'--',[0.5 0.5 0.5],sz-6,1.5)

xlim([0.15 0.85])
xlabel('Ratio (first interval/total duration)','FontSize',sz)
ax = gca;
ax.FontSize = sz-2;

set(gcf, 'WindowState', 'maximized');

end