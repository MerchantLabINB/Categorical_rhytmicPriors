clc; clear; close all

load Data_AllGrps.mat

% Extract necessary variables from the loaded data
GRPS = data.GRPS; % produced ratios for each group
kernels = data.kernels; %ksd of produced ratios
R_target = data.R_target; % target ratios for each group 
Xs = data.Xs; % resultant X of ksd for produced and target ratios
R = data.R; % original seed ratios
N_IT = data.N_IT; % number of total iterations

%%PARAMETTERS
NBOOT = 1000;
BW = 0.025;
x = 0:0.001:1;
font_nm = 'Arial';
f_sz = 28;

%%%%%%


%%
%compute significance distance seed and iter
%Randomize seed distribution for each iteration 
sbj= 1; % 1: mky, 2: human visual 3: human audio
N = 4; %iteration to start

fun = kernels{sbj}; %original kde
S0 =  R_target{sbj}(:,1); %seed0 
fun0 = ksdensity(S0,x,"Bandwidth",BW);

%original data
d_fun0 = zeros(1,N_IT);
for j = 2:N_IT  
    d_fun0(1,j) = JSD(fun{1,j},fun0);
end

d_seed = [];
rng('shuffle')
for k = N:N_IT
    seeds = R_target{sbj,1}(:,1); %seed first iteration
    tR = R_target{sbj,1}(:,k); %seeds for each iteration
    se =[];
    for j =1:NBOOT
        [~,idx]= datasample(seeds,size(seeds,1)); %idx for reshuffle
        fprintf('.')

        se(:,j) = tR(idx',1); %seeds reshuffled
    end
    s1 = mean(se,2);
    [funS,xs] = ksdensity(s1, x,'Bandwidth',BW);

    [funS0,xs0] = ksdensity(seeds, x,'Bandwidth',BW);
    
    d_seed(1,k) = JSD(funS,funS0);

end

signif = sum(d_seed<d_fun0)/NBOOT 

valJSD = mean(d_seed(N:end));
minJSD = min(d_seed(N:end));
maxJSD = max(d_seed(N:end));

%%
%compute convergence by comparing sets of iterations
% sb: subjects (mky = 1; h vision = 2; h audio = 3)
sb = 3;
NB = 5;

% Comparison set 1-5 vs 6-10
% lst_IT = GRPS{sb,1}(:,6:10); 
% nb_IT = GRPS{sb,1}(:,1:nb); 

% Comparison set 6-10 vs 11-15
lst_IT = GRPS{sb,1}(:,11:N_IT); 
nb_IT = GRPS{sb,1}(:,6:10); 

% Comparison set 1-4 vs 11-15
% lst_IT = GRPS{sb,1}(:,11:N_IT); % last 5 iteration
% nb_IT = GRPS{sb,1}(:,1:NB); % first 5 iterations 

lst_IT0=lst_IT;
nb_IT0=nb_IT;

lst = reshape(lst_IT,[],1);
nbIT = reshape(nb_IT,[],1);

[f_IT,x_IT] = ksdensity(lst,x,'Bandwidth',BW);
[f_nb,x_nb] = ksdensity(nbIT,x,'Bandwidth',BW);

d0 = JSD(f_IT,f_nb)

rng('shuffle')
sig = [];
for tss = 1:10
    for b = 1:NBOOT
        fprintf('.')
        toss = rand(size(lst_IT0,1),1);
        idx_toss = find(toss<0.5); %idx to flip into the other iteration

        lst_IT= lst_IT0;
        nb_IT=nb_IT0;
        m = lst_IT(idx_toss,:);
        n = nb_IT(idx_toss,:);
        lst_IT(idx_toss,:) = n;
        nb_IT(idx_toss,:) = m;

        lst_IT = reshape(lst_IT,[],1);
        nb_IT = reshape(nb_IT,[],1);

        [fun_lst,xlst] = ksdensity(lst_IT, x,'Bandwidth',BW);
        [fun_nb,xnb] = ksdensity(nb_IT, x,'Bandwidth',BW);

        d(b) = JSD(fun_lst,fun_nb);

    end

    sig(tss,1) = sum(d>d0)/NBOOT;
end

sigf=mean(sig)


clearvars m n lst_IT nb_IT idx_toss

%%
% Compute original JSD
fun1 = kernels{1}{1,N_IT};
fun2 = kernels{2}{1,N_IT};
d0_MV = JSD(fun1,fun2);

fun1 = kernels{1}{1,N_IT};
fun2 = kernels{3}{1,N_IT};
d0_MA = JSD(fun1,fun2);

fun1 = kernels{2}{1,N_IT};
fun2 = kernels{3}{1,N_IT};
d0_AV = JSD(fun1,fun2);

% Compute JSD between groups mky = 1, human visual = 2, human audio = 3 
% Change the number for the subject depending on the comparation you need
sbj1= 1;
sbj2= 3;

A = GRPS{sbj1,1}(:,N_IT); %last IT
B = GRPS{sbj2,1}(:,N_IT);

C = [A;B];
rng('shuffle')
x = 0.1:0.001:1;
for i = 1:NBOOT
    shC = C(randperm(length(C))); %shuffled C
     fprintf('.')

    %kde for the first elements
    N = shC(1:length(A));
    [fun,xii] = ksdensity(N, x,'Bandwidth',BW); 
    g1 = fun./sum(fun);

    %kde for the last elements
    M = shC(length(A)+1:end);
    [fun,xii] = ksdensity(M, x,'Bandwidth',BW); 
    g2 = fun./sum(fun);

    %compute JSD
    d(i) = JSD(g1,g2);

end
fprintf('\n')

% Compute significance
if sbj1 == 1 &&  sbj2 ==2
    msg = sprintf('monkey vs h visual JSD: %d',d0_MV);
    disp(msg);
    signif = sum(d>d0_MV)/NBOOT
elseif sbj1 == 1 &&  sbj2 ==3
    msg = sprintf('monkey vs h audio JSD: %d',d0_MA);
    disp(msg)
    signif = sum(d>d0_MA)/NBOOT
elseif sbj1 == 2 &&  sbj2 ==3
    msg = sprintf('monkey vs h audio JSD: %d',d0_AV);
    disp(msg)
    signif = sum(d>d0_AV)/NBOOT
end
