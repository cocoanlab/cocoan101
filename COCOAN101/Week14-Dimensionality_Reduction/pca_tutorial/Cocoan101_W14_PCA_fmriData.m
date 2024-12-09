%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     COCOAN101 W14 Dimensionality Reduction   %
%     Principal Component Analysis tutorial    %
%     Part B. fMRI Data                        %
%      by Dong Hee Lee                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Path
addpath(genpath('/Users/donghee/github/canlab-repos/CanlabCore/'));
addpath(genpath('/Users/donghee/cocoanlab Dropbox/resources/spm12'));

%% Directory
basedir = '/Users/donghee/cocoanlab Dropbox/Lee Dong Hee/COCOAN LAB/COCOAN101/raw/W14-Dimension_Reduction/tutorial/PCA';
datdir = 'example_data/bmrk3_temp_avg';

imgs = filenames(fullfile(datdir, 'sub*heat*nii'));

%% 
% behavior data
load(fullfile(datdir, 'bmrk3_temp_data_descript.mat'));

sub_idx = repmat(1:33, 6, 1);
sub_idx = sub_idx(:);

%%

% prediction

dat_gray = fmri_data(imgs, which('gray_matter_mask.nii'));
pred_y = bmrkdata.ratings';
dat_gray.Y = pred_y(:);

wh_fold = sub_idx;

[cverr, stats, optout] = predict(dat_gray, 'algorithm_name', 'cv_pcr', 'nfolds', wh_fold);

%[yfit, vox_weights, intercept] = cv_pcr(dat_gray.dat, dat_gray.Y, xtest, cv_assignment, varargin)

close all;
orthviews(stats.weight_obj)