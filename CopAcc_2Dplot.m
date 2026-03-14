clear; clc; close all

load Data_AllGrps.mat


typeC = 'CMYK_bright';
colors = mk_shade(typeC);

% Extract necessary variables from the loaded data
GRPS = data.GRPS;
R_target = data.R_target;
targ_int = data.targ_int;
pInt = data.pInt; % Extract produced intervals
N_IT = data.N_IT; % number of iterations
font_nm = 'Arial'; 
f_sz = 28; 

% Compute copying accuracy: the average distance between response and stimuli
clrs = [colors(3,:);colors(9,:);colors(7,:)];
mCA_sbj = cell(length(GRPS), 5); % Initialize cell array to store mean copying accuracy results
av_it = cell(length(GRPS), 3); % Initialize cell array for average iteration results
for gr = 1:length(targ_int)
    seed_grp = targ_int{gr}; %seeds for the group
    resp_grp = pInt{gr}; %produced intervals for the group
    clr = clrs(gr,:);
    cacc = [];
    if gr ==1
        for i = 1:length(seed_grp)
            A = seed_grp{i,1};
            B = resp_grp{i,1};
            cop_acc = sqrt((sum((A - B).^2,2))/2);
            cacc = [cacc,cop_acc];
        end

        for it = 1:N_IT-1
            u = cacc(it,:);
            w = cacc(it+1,:);
            [h, pt, ci, stats] = ttest(u,w);
            tt(it) = pt;
            ci_t(it) = {ci};
            t_stat(it) = {stats};
        end
        m_ca = mean(cacc,2); %get mean copying accuracy by iteration
        mCA_sbj{gr,1} = m_ca;
        mCA_sbj{gr,2} = tt;
        mCA_sbj{gr,3} = ci_t;
        mCA_sbj{gr,4} = t_stat;
        mCA_sbj{gr,5} = cacc;
    else
        for i = 1:length(seed_grp)
            s_gr = seed_grp{i,1};
            r_gr = resp_grp{i,1};
            for fgr = 1:length(s_gr)
                A = s_gr{fgr,1};
                B = r_gr{fgr,1};
                cop_acc = sqrt((sum((A - B).^2,2))/2);
                cacc = [cacc,cop_acc];
            end
        end

        for it = 1:N_IT-1
            u = cacc(it,:);
            w = cacc(it+1,:);
            [h, pt, ci, stats] = ttest(u,w);
            tt(it) = pt;
            ci_t(it) = {ci};
            t_stat(it) = {stats}; 
        end

        m_ca = mean(cacc,2);
        mCA_sbj{gr,1} = m_ca;
        mCA_sbj{gr,2} = tt;
        mCA_sbj{gr,3} = ci_t;
        mCA_sbj{gr,4} = t_stat;
        mCA_sbj{gr,5} = cacc;
    end

    figure(1)
    hold on

    plot(1:N_IT,m_ca,'o-','Color',clr,'LineWidth',2,'MarkerFaceColor',clr);
    axis square
    
end

set(gca,'LineWidth',3,'FontName',font_nm,'FontSize',f_sz,'TickDir','out','TickLength',[0.02 0.03])
lgd = legend('Monkey M','Human V','Human A');
lgd.Box = "off";
lgd.Location = "bestoutside";

xlabel('Iteration')
ylabel('Copying accuracy (ms)')


% Compute copying accuracy: the average distance between response and stimuli
% cumpute accuray by averaging 1-5, 6-10 and 11-15
clrs = [colors(3,:);colors(9,:);colors(7,:)];
kit = [1,6,11];

for s = 1:length(GRPS)
    sj = mCA_sbj{s,5};
    %retrive the data for the key iterations
    it1 = mean(sj(kit(1):kit(1)+4,:));
    it2 = mean(sj(kit(2):kit(2)+4,:));
    it3 = mean(sj(kit(3):end,:));

    %compute t-test for paired measures
    [h1, pt1, ci1, stats1] = ttest(it1,it2);
    [h2, pt2, ci2, stats2] = ttest(it1,it3);
    [h3, pt3, ci3, stats3] = ttest(it2,it3);

    %save results
    av_it{s,1} = [pt1;pt2;pt3];
    av_it{s,2} = {[ci1;ci2;ci3]};
    av_it{s,3} = [{stats1};{stats2};{stats3}];

end

%%
% 2D plot for produced ratios last iteration for monkey
allPr = GRPS{1,1}; % all produced ratios
pr = allPr(:,N_IT); % take last iteration
allTr = R_target{1,1}; % all target ratios
t_rat = allTr(:,1); %take seed

nbins = 50;

xedges = linspace(0.15, 0.85, nbins); 
yedges = linspace(0.15, 0.85, nbins); 

H = histcounts2(t_rat, pr, xedges, yedges);
H = imgaussfilt(H,2);
H = H./max(H,[],"all");


figure(101)
imagesc(xedges, yedges, H')
square4Ratio(3,max(pr)+0.08,'--','#808080',24,1.5);
axis xy

hold on
scatter(t_rat, pr, 14, 'w', 'filled')
hold off
box off

ax = gca;

xlabel('Target ratio')
xlim([0.15 0.85])
ylabel('Produced ratio')

ax.LineWidth = 3;
ax.FontSize = f_sz;

axis square

set(gca, 'FontName', font_nm);
set(gca,'TickDir','out');
%%
% 2D plotfor produced ratios last iteration for human visual 
allPr = GRPS{2,1};
pr = allPr(:,N_IT);
allTr = R_target{2,1}; 
t_rat = allTr(:,1); 

nbins = 50;

xedges = linspace(0.15, 0.85, nbins); 
yedges = linspace(0.15, 0.85, nbins);

H = histcounts2(t_rat, pr, xedges, yedges);
H = imgaussfilt(H,2);
H = H./max(H,[],"all");


figure(102)
imagesc(xedges, yedges, H')
square4Ratio(3,max(pr)+0.08,'--','#808080',24,1.5);
axis xy

hold on
scatter(t_rat, pr, 14, 'w', 'filled')
hold off
box off

ax = gca;

xlabel('Target ratio')
xlim([0.15 0.85])
ylabel('Produced ratio')

ax.LineWidth = 3;
ax.FontSize = f_sz;

axis square

set(gca, 'FontName', font_nm);
set(gca,'TickDir','out');

%%
% 2D plot for produced ratios last iteration for human audio
allPr = GRPS{3,1};
pr = allPr(:,N_IT);
allTr = R_target{3,1}; 
t_rat = allTr(:,1); 

nbins = 50;

xedges = linspace(0.15, 0.85, nbins); 
yedges = linspace(0.15, 0.85, nbins); 

H = histcounts2(t_rat, pr, xedges, yedges);
H = imgaussfilt(H,2);
H = H./max(H,[],"all");


figure(103)
imagesc(xedges, yedges, H')
colorbar
square4Ratio(3,max(t_rat)+0.08,'--','#808080',24,1.5);
axis xy

hold on
scatter(t_rat, pr, 14, 'w', 'filled')
hold off
box off

ax = gca;

xlabel('Target ratio')
xlim([0.15 0.85])
ylabel('Produced ratio')

ax.LineWidth = 3;
ax.FontSize = f_sz;

axis square

set(gca, 'FontName', font_nm);
set(gca,'TickDir','out');