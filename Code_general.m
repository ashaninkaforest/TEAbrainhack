clear all
close all
clc

cd ('/home/TEA')

%% Open and extraction data, set parameters 
% load your database (update with information)
load('database.mat')

%set tested thresholds and evaluate its length
tested_th=[0.5:0.1:1.6]; %to update by the user 
n_th=length(tested_th);

%count the subject number
Nsub=size(Day2, 1);
% data extraction 
for s=1:1:Nsub

	for i=1:1:9

	data(:,i,s)=Day2{s,i};

	end

end

%% TE estimation with normalization at different thresholds
% parameters for the estimation of TE 
[check_general_Atplus1_At_Bt, check_general_Atplus1_At, check_general_At_Bt, check_general_At] = check_general();
for s=1:1:Nsub

    disp(s)
    
    count_Th=1; % counter of Th estimation
    
    for t=1:n_th % threshold
    
        Th=tested_th(t);        
        data_sub=data(:,:,s); % extracting time series of single subject
    
        
        % TE estimation: PWTE= local transfer entropy for each combination
        % (27=3^3); norm_Atplus1_At_Bt= probability P(At,At+1,Bt) for each
        % combination; TE= total transfer entropy; TE_Hnorm= normalizaed TE.
        % Note, that in case we calculated the TE and TE_Hnorm for each
        % subject for the next analysis, other outputs are neglected!
        [PWTE, norm_Atplus1_At_Bt, TE(:,s,count_Th), TE_Hnorm(:,s,count_Th)] = lTE_th(data_sub,Th,check_general_Atplus1_At_Bt, check_general_Atplus1_At, check_general_At_Bt, check_general_At);

        count_Th=count_Th+1;
        
    end
    
end

clear count_Th s t PWTE norm_Atplus1_At_Bt
%% Null model
% initialize the variable for the normalized TE (real forward and null backward)
Th_07=3; % TE estimated at 0.7 threshold.
TE_Hnorm_allS_real=[];
TE_Hnorm_allS_null=[];

for s=1:1:Nsub
    
    %read the current subject
    Cdata_real=data(:,:,s);
    
    %create the null matrix for the current subject
    Cdata_null=flip(Cdata_real,1);
    disp(s)
    
    count_Th=1; % counter of Th estimation
    
    for t=1:n_th % threshold
    
        Th=tested_th(t);        
        data_sub=data(:,:,s); % extracting time series of single subject
    
        
        % TE estimation for the null model: PWTE= local transfer entropy for each combination
        % (27=3^3); norm_Atplus1_At_Bt= probability P(At,At+1,Bt) for each
        % combination; TE= total transfer entropy; TE_Hnorm= normalizaed TE.
        % Note, that in case we calculated the TE and TE_Hnorm for each
        % subject for the next analysis, other outputs are neglected!
        [PWTE_null, norm_Atplus1_At_Bt_F, TE_null(:,s,count_Th), TE_Hnorm_null(:,s,count_Th)] = lTE_th(Cdata_null,Th,check_general_Atplus1_At_Bt, check_general_Atplus1_At, check_general_At_Bt, check_general_At);

        count_Th=count_Th+1;
        
    end
    
end

clear count_Th s t PWTE norm_Atplus1_At_Bt Cdata_real Cdata_null

% calculate the delta between the real and the null TE estimation at 0.7
% threshold
Delta_TE_Hnorm=TE_Hnorm(:,:,Th_07) - TE_Hnorm_null(:,:,Th_07);

% one sample t-test against 0 to check whether the delta values are
% significantly above 0 for each ROI-to-ROI connection
[h, p, ci, stats] = ttest(Delta_TE_Hnorm','','Tail','right');

% graphical representation of the obtained p value in ROI matrix
Mp = reshape(p(1,:), 9, 9);
figure
imagesc(Mp)

%% Mean and SD of estimated TE and TE_Hnorm
% Mean and standard deviation of sum of TE across subjects
sum_TE(:,:)=sum(TE,1);
sum_TE_Hnorm(:,:)=sum(TE_Hnorm,1);

mean_TE_nTE(:,1) = mean(sum_TE);
std_TE_nTE(:,1) = std(sum_TE);
mean_TE_nTE(:,2) = mean(sum_TE_Hnorm);
std_TE_nTE(:,2) = std(sum_TE_Hnorm);

% Create bar plot of the mean and error bars with standard deviation at 0.7
figure;
subplot(1,2,1)
bar(mean_TE_nTE(:,1));                   
hold on;
er = errorbar(1:n_th, mean_TE_nTE(:,1), std_TE_nTE(:,1), '.k', 'LineWidth', 1.5);  % '.k' = nero
xlabel('Threshold');
ylabel('Total TE');
xticks(1:n_th);  
xticklabels({tested_th});
title('TE')

subplot(1,2,2)
bar(mean_TE_nTE(:,2));                   
hold on;
er = errorbar(1:n_th, mean_TE_nTE(:,2), std_TE_nTE(:,2), '.k', 'LineWidth', 1.5);  % '.k' = nero
xlabel('Threshold');
ylabel('Total TE');
xticks(1:n_th);  
xticklabels({tested_th});
title('TE normalized')

save wkspace