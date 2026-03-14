% %Plot succesive iterations

load Data_AllGrps.mat

% Extract necessary variables from the loaded data
GRPS = data.GRPS;
kernels = data.kernels;
Xs = data.Xs;
R = data.R;
N_IT = data.N_IT;

% Set figure parametters
f_sz = 28; % Font size for plots
maxN = 4; % Max number for integer ratios
BW_SEED = 0.03; % Bandwidth for seed distribution
font_nm = 'Arial'; % Font name for plots
colors = mk_shade('rainbow');

a = {'[0.34,0.43,0.79]'};
clrs = [colors,a];

for j = 1:length(GRPS)
    fun = kernels{j};
    X = Xs{j};

    plotKDE_evo_cell(fun,X, R,N_IT,clrs,f_sz,maxN,BW_SEED);

    ylabel('Iteration num')
    yticks([1.5:N_IT+.5])
    iter_n = string(1:N_IT);
    yticklabels(iter_n)
    ylim([0 N_IT+1])
    axis square

    set(gca,'LineWidth',3,'FontName',font_nm,'FontSize',f_sz,'TickDir','out','TickLength',[0.025 0.03])

    ls_leg = {'iteration 15','iteration 10','iteration 5','iteration 1','seed distribution'};
    mkr = {'-'};

    putLegend(ls_leg,mkr,clrs,16,2,24,'all_IT')


end