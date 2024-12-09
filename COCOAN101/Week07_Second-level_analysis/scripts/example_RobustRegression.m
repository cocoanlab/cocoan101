%% Examples: Robust Regression Toolbox
% Written by Suhwan Gim
basedir = '/Users/suhwan/Dropbox/github/coursework/advancedfmrianalysis_2019fall_Week/week2/';
%basedir = '/Users/WIWIFH/Dropbox/github/coursework/advancedfmrianalysis_2019fall_Week/week2/';
datdir = fullfile(basedir,'khbm2019_RSA_tutorial/tutorial/data/contrast_images');
% addpath(genpath(~canlabCORE)) % github.com/canlab/canlabCORE
% addpath(genpath(~cocoanCORE)) % github.com/cocoanlab/cocoanCORE
% addpaht(genpath(~RobustRegressionToolbox)); % github.com/canlab/RobustToolbox
maskdir = fullfile(basedir,'khbm2019_RSA_tutorial','tutorial','masks');
AImask = fullfile(maskdir, 'aINS_smooth_mirror.nii');
dACCmask = fullfile(maskdir, 'dACC_smooth_mirror.nii');
gmmask = which('gray_matter_mask.nii');
%%
friend_beta = filenames(fullfile(datdir,'friend*.nii'));
reject_beta = filenames(fullfile(datdir,'reject*.nii'));
% load fMRI data with Anterio Insula mask
dat_friend = fmri_data(friend_beta, gmmask);
dat_reject = fmri_data(reject_beta, gmmask);
%% ttest against zero for each condition
stats_img1=ttest(dat_friend,0.001,'fdr');
stats_img2=ttest(dat_reject,0.001,'fdr');
t_friend=threshold(stats_img1,0.001,'fdr','k',10);
canlab_results_fmridisplay(region(t_friend));
%orthviews_multiple_objs({stats_img1 stats_img2});
%% RUN ROBUST REGRESSION WITH fmri_data.regress fucntion
dat_friend = fmri_data(friend_beta, gmmask);
dat_friend.X = ones(1,59)';
out_robust = regress(dat_friend, .05, 'unc', 'robust', 'nodisplay');
canlab_results_fmridisplay(threshold(out_robust.b,.001,'fdr','k',10));
%% RUN ROBUST REGRESSION using ROBUST REGREESION TOOLBOX
% 1. First we should make EXPT data strucutre
% ========================================================================
% EXPT.SNPM.P           Cell vector. Each cell specifies images for one analysis.
%                       Each cell contains a string matrix with image names for the analysis.
%                       Image files can be 3-D or 4-D images.
%
% EXPT.SNPM.connames    Cell vector.
%                       Each cell contains a string with the analysis name (e.g., contrast name) for this contrast
%
% EXPT.SNPM.connums     Vector of contrast numbers.
%                       Determines folder names (e.g., 1 = robust0001
%
% EXPT.cov              [n x k] matrix of n observations (must match number of images) empty for 1-sample ttest, or containing covariates
%
% EXPT.mask             Optional mask file image name, for voxels to include
% ========================================================================
EXPT = [];
friend_beta_char = filenames(fullfile(datdir,'friend*.nii'),'char');
EXPT.SNPM.P{1} = friend_beta_char; % We could have multiple analyses in {2} {3} etc.
EXPT.SNPM.connames = {'friend vs. zero'}; % name of model
EXPT.SNPM.connums = 1; % number of model
%EXPT.mask = fullfile(maskdir, 'dACC_smooth_mirror.nii');
EXPT.mask = which('gray_matter_mask.nii');
EXPT.cov = [ones(1,59)'];
EXPT = robfit(EXPT, 1:length(EXPT.SNPM.connums), 0, EXPT.mask);
%%
robustdir = '/Users/suhwan/Documents/rob/robust0001/robust0001/robust0001/robust0001';
effect_img = fullfile(robustdir,'rob_beta_0001.nii'); % or 'rob_beta_0001.img'
pval_img = fullfile(robustdir,'rob_p_0001.nii'); % or 'rob_p_0001.img'
mask_img = fullfile(robustdir,'mask.nii'); % or 'rob_beta_0001.img'

rob_dat = statistic_image('image_names', effect_img, 'type', 'generic');
[datp, volInfo] = iimg_threshold(pval_img, 'mask', mask_img);

datp(datp == 0 & isnan(rob_dat.dat)) = NaN;
rob_dat.p = datp;
rob_dat_th=threshold(rob_dat, 0.001, 'fdr','k',10);
canlab_results_fmridisplay(region(rob_dat_th))
%% RUN ROBUST REGRESSION WITH fmri_data.regress fucntion
cont_dat  = [];
temp_dat1 = fmri_data(friend_beta, gmmask);
temp_dat2 = fmri_data(reject_beta, gmmask);
dat_total = [temp_dat1.dat temp_dat2.dat];
cont_dat = temp_dat1;
cont_dat.dat = dat_total;
cont_dat.X =[ones(1,59) ones(1,59).*-1]';

out_robust_cont = regress(cont_dat, .05, 'unc', 'robust', 'nodisplay');
orthviews(threshold(out_robust_cont.b,.001,'fdr','k',10)) 

%% ========================================================================







%% 
%%
% rob_dat = remove_empty(rob_dat);
% rob_dat_output = pruning_img(rob_dat, [.01 .005 FDR(datp,0.01)], [1 1 10]);
% r = region(rob_dat_output);
% %canlab_results_fmridisplay(r)
% for i = 1:numel(r)
%     r(i).Z = r(i).val';
% end
%[out, o2] = brain_activations_wani(r,'all2','pruned', 'depth', 2);
%% Robust regression with Robustfit
robustdir = fullfile(outputbasedir, 'robust');

if ~exist(robustdir, 'dir'), mkdir(robustdir); end

res= []; stats = [];
for i =1:length(dat.dat)
    [res(i), stats{i}] = robustfit(ones(1,59), dat.dat(i,:),'bisquare', [], 'off');
end
%%
pt = [];
for i =1:195612; pt(i) = stats{i}.p; end;

maskdat = dat;
maskdat.dat = (res').* double(pt<FDR(pt,0.001))';%cat(1,res{:});
orthviews(maskdat);
