clear; clc; close all

load Data_AllGrps.mat

% Extract necessary variables from the loaded data
GRPS = data.GRPS; % produced ratios for each group
kernels = data.kernels; %kd of produced ratios
Xs = data.Xs; % resultant X of ksd for produced and target ratios
ci_sbjs = data.ci_sbj; % confidence intervals for kd
R = data.R; % original seed ratios
N_IT = data.N_IT; % number of total iterations

%%PARAMETTERS
NBOOT = 1000;
maxN = 3;
BW = 0.025;%band width for kde produced ratios
BW_SEED = 0.03;
N_boot = 1000;
font_nm = 'Arial';
f_sz = 30;
ln_wd = 4;
mkr_sz = 20;
color = mk_shade('CMYK_bright');
colors = [{color([2,3],:)},{color([8,9],:)},{color([6,7],:)}];
clrs = mk_shade('Berlin');




%%
%Find peaks and  compute significant peaks thanks to densitt of bootstraped peaks
% Retrive original data for each subject then find peaks for the data
GR = GRPS;
sbjs = {'Monkey','Humans V','Humans A'};

lcs = [];
pks_est = [];
num = 1;
x = 0:0.001:1;

%Seed distribution
[funS0,xiiS0] = ksdensity(R, x,'Bandwidth',BW_SEED); %kernel density for seeds
nS0 = funS0./sum(funS0);

rng('shuffle')
for J = 1:length(GR)
    pR = GR{J}(:,N_IT);
    fun = kernels{J}{:,N_IT}; %original kde
    xx = Xs{J,1}{1,1}{:,N_IT};

    %reshuffle of trials and create boostrapped datasets
    for B=1:NBOOT
        fprintf('now in bootstrapping %d of %d...\n',B,NBOOT);
        all_pos=  datasample(pR,size(pR,1)); %idx for reshuffle
        bootstrapped_dataset= all_pos;
        [f_boot, x_boot] = ksdensity(bootstrapped_dataset,x,'Bandwidth',BW); %to get the distribution of data obtained by permutations
        bootstrap_kdes(B, :) = f_boot/(sum(f_boot(:)));

        %Compute peak locations for the given bootstrap
        [PKSB,LOCSB]=findpeaks(f_boot/(sum(f_boot(:))),x_boot);  
        lcs = [lcs;LOCSB'];
    end

    %compute kde to identify categories in locations of peaks
    [de_boot,xi_b] = ksdensity(lcs,x,'Bandwidth',BW);%get f (probability density estimate) and xi (equally-spaced points)
    nBoot = de_boot/(sum(de_boot(:)));
    %identify peak categories
    [pks_boot, loc_boot] = findpeaks(nBoot,xi_b);
    %save location of peaks, these are the categories where to look
    loc{J} = loc_boot;
    % Calculate the 95% confidence intervals
    upB = mean(nBoot)+std(nBoot); 
    lwB = mean(nBoot)-std(nBoot);

    % figure(num)
    % hold on
    % tit = sprintf('boostraped peaks or prototypes %s ',sbjs{J});
    % title(tit,'FontWeight','normal');
    % plot(xi_b,nBoot,'-','Color',[95, 194, 8]./256,'LineWidth',1.5);
    % plot(loc_boot,pks_boot,'o','Color',clrs{2},'MarkerFaceColor',clrs{2});
    % num = num+1;
    % hold off

    %Revisiting bootstraped kde to select peaks around loc_boot
    all_loc = [];
    thr = 0.0333; %threshold to be consired inside the category
    for B=1:size(bootstrap_kdes,1)
        boot=bootstrap_kdes(B,:);
        [PKSB,LOCSB]=findpeaks(boot,xx);

        %Find minimum differences
        diffP = abs(loc_boot(:)' - LOCSB(:));
        isClose = diffP<=thr; 
        [idxs,~] = find(isClose);
        all_loc = [all_loc;LOCSB(idxs)'];

    end
    boot_ct = [];

    %group significant vals in the corresponding range
    isClose2 = (abs(all_loc(:)-loc_boot(:)'))<=thr;
    %find the occurrence of numbers between this edges
    tot_ct = sum(isClose2,1)';
    boot_ct(:,1) = tot_ct;

    for grp = 1:length(loc_boot)
        id = find(isClose2(:,grp));
        min_ct =min(all_loc(id)) - std(all_loc(id));
        max_ct =max(all_loc(id)) + std(all_loc(id));
        boot_ct(grp,2) = min_ct;
        boot_ct(grp,3) = max_ct;
        boot_ct(grp,4) = mean(all_loc(id));
    end 

    grp_boot_ct{J} = boot_ct;
    
    nb_boot = find(boot_ct(:,1)>=(N_boot*.8));
    d_pcks = boot_ct(nb_boot,:);

    

    ydata = [];
    for i = 1:size(d_pcks,1)
        [~, col] = min(abs(xx-d_pcks(i,4)));
        ydata(i,1) = fun(1,col)./nS0(1,col);
    end

    clr = colors{J};

    f1=figure(10+J);
    f1.Position = [1,1,1303,731];
    hold on
    plot(xx,fun./max(nS0),'-','Color',clr(2,:),'LineWidth',ln_wd);
    upB = ci_sbjs{J}{1,end}{1,1};
    lwB = ci_sbjs{J}{1,end}{1,2}; 
    fill([xx fliplr(xx)], [upB./max(nS0) fliplr(lwB./max(nS0))], clr(1,:), 'FaceAlpha', 0.2, 'EdgeColor', 'none'); %confidence int

    mx_y = (max(upB)/max(nS0))+0.1; 

    plot(d_pcks(:,4),ydata,'o','Color',clrs{2},'MarkerFaceColor',clrs{2},'MarkerSize',mkr_sz);

     y_pos = [0 0  mx_y mx_y] ;
    for p = 1:size(d_pcks,1)
        x_pos = [d_pcks(p,2) d_pcks(p,3)];
        fill([x_pos fliplr(x_pos)], y_pos, [0.5 0.5 0.5], 'FaceAlpha', 0.2, 'EdgeColor', 'none');
    end

    squareRatio2(maxN,mx_y,'--','k',32,2);

    ls_leg = sbjs{J};

    legend(ls_leg,"Box","off","Location","eastoutside","FontSize",f_sz-2)

    xlabel('Ratio')
    ylabel('Density estimate')
    xticks([0.1:0.1:0.9])
    ylim([0 3.5])

    set(gca,'FontName',font_nm,'FontSize',f_sz,'LineWidth',ln_wd,'TickDir','out','TickLength',[0.02 0.035])
end

%%
%Plot two subjects in a graph Monkey & Human Visual
kde = [kernels{2}{:,N_IT};kernels{1}{:,N_IT}];
suj = [2,1];

figure('Name','Last IT comparation','NumberTitle','off','Position',[1 1 1303 731])
hold on
n_q = [];
for J = 1:size(kde,1)
    id = suj(J); 
    fun = kde(J,:); %original kde
    xx = Xs{id,1}{1,1}{:,N_IT};
    boot_ct =  grp_boot_ct{id};

    nb_boot = find(boot_ct(:,1)>=(N_boot*.8));
    d_pcks = boot_ct(nb_boot,:);

    q = max(fun./nS0)*1.10;
    n_q = [n_q;q];

    ydata = [];
    for i = 1:size(d_pcks,1)
        [~, col] = min(abs(xx-d_pcks(i,4)));
        ydata(i,1) = fun(1,col)./nS0(1,col);
    end


    clr = colors{id};

    if J == 1
        plot(xx,fun./max(nS0),'--','Color',clr(2,:),'LineWidth',ln_wd);
        clr1 = clr(2,:);
    else
        plot(xx,fun./max(nS0),'-','Color',clr(2,:),'LineWidth',ln_wd);

        upB = ci_sbjs{id}{1,end}{1,1};
        lwB = ci_sbjs{id}{1,end}{1,2};
        fill([xx fliplr(xx)], [upB./max(nS0) fliplr(lwB./max(nS0))], clr(1,:), 'FaceAlpha', 0.2, 'EdgeColor', 'none'); %confidence int


        plot(d_pcks(:,4),ydata,'o','Color',clrs{2},'MarkerFaceColor',clrs{2},'MarkerSize',mkr_sz);

        mxY = (max(upB)/max(nS0))+0.1;

        mx_y = mxY; 
        y_pos = [0 0  mx_y mx_y] ;
        for p = 1:size(d_pcks,1)
            x_pos = [d_pcks(p,2) d_pcks(p,3)];
            fill([x_pos fliplr(x_pos)], y_pos, [0.5 0.5 0.5], 'FaceAlpha', 0.2, 'EdgeColor', 'none');
        end
        ylim([0 3.5])

        squareRatio2(maxN,mx_y,'--','k',32,2);

        ls_leg = {'Humans V','Monkey M'};
        
        legend(ls_leg,"Box","off","Location","bestoutside","FontSize",f_sz-2)
        xlabel('Ratio')
        ylabel('Density estimate')
        xticks([0.1:0.1:0.9])

        set(gca,'FontName',font_nm,'FontSize',f_sz,'LineWidth',ln_wd,'TickDir','out','TickLength',[0.02 0.035])
    end
end