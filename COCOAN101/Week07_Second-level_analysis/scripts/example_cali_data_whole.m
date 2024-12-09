%% SET PATH
% calibration datasets
datdir = '/Users/WIWIFH/Dropbox/Projects/SEMIC/data_NAS/behavioral/raw/CALI_SEMIC_data'; % macbook
%datdir = '/Users/suhwan/Dropbox/Projects/SEMIC/data_NAS/behavioral/raw/CALI_SEMIC_data'; % sein
matlist = filenames(fullfile(datdir,'*.mat'));
%~% LOAD DATA
cal_dat = []; 
for i = 1:length(matlist)
    cal_dat{i}=load(matlist{i},'reg');
end
%% Single-level linear regression 
% and comparison to each first-level regression model coefficients
create_figure;
set(gca,'Ylim',[0 100],'Xlim', [40 50]);
clear h1line;
col = colorcube(length(cal_dat));
col = col(shuffles(1:length(cal_dat)),:);

for i = 1:length(cal_dat)
    h1line(i) = refline([cal_dat{i}.reg.total_fit.Coefficients.Estimate(2) cal_dat{i}.reg.total_fit.Coefficients.Estimate(1)]); 
    h1line(i).LineWidth = 3;    
    h1line(i).Color = [col(i,:) 0.2];
    
    hold on;
end

hold off;

%
%fitlm(cal_dat{i}.reg.stim_degree, cal_dat{i}.reg.stim_rating)
% 2. single-level regression model
rating = []; 
degree = []; 
for i = 1:length(cal_dat)
    degree = [degree cal_dat{i}.reg.stim_degree];

    rating = [rating cal_dat{i}.reg.stim_rating];
end
res_lm = fitlm(degree, rating); 

clear h2line 
h2line = refline([res_lm.Coefficients.Estimate(2) res_lm.Coefficients.Estimate(1)]);
h2line.Color = [1 0 1 0.9];
h2line.LineWidth= 8;

%% Multilevel linear regression 
x1 = []; 
y = []; 
% making data structure
for i = 1:length(cal_dat)
    x1{i} = cal_dat{i}.reg.stim_degree'; 
    y{i}  = cal_dat{i}.reg.stim_rating';   
end
% 
stats = glmfit_multilevel(y,x1,[],'names',{'intercept','temperature'},'verbose');
%%
clear h3line 
h3line = refline([stats.beta(2) stats.beta(1)]);
h3line.Color = [1 0 0.1 0.9];
h3line.LineWidth= 8;
%% Multielvel linear regression with several options 
% bootstrap and weigthed options 
stats2 = glmfit_multilevel(y, x1, [], 'names', {'intercep','temp'}, 'verbose', 'boot', 'nresample', 10000,'weighted');

clear h4line 
h4line = refline([stats2.beta(2) stats2.beta(1)]);
h4line.Color = [0.23 0.21 0.1 0.9];
h4line.LineWidth= 8;
%% Weigth
create_figure;
bar(stats2.W(:,2))
%% IGLS
xx1 = []; 
yy = [];
for i = 1:length(cal_dat)
    xx1(i,:) = cal_dat{i}.reg.stim_degree'; 
    yy(i,:)  = cal_dat{i}.reg.stim_rating';   
end

out = igls(yy', xx1','covariate',(1:84));  % for igls