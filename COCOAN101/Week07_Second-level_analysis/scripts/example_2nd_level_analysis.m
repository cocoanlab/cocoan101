basedir = '/Users/suhwan/Dropbox/github/coursework/advancedfmrianalysis_2019fall_Week/week2/';
datdir = fullfile(basedir,'khbm2019_RSA_tutorial/tutorial/data/contrast_images');
% addpath(genpath(~canlabCORE)) % github.com/canlab/canlabCORE
% addpath(genpath(~cocoanCORE)) % github.com/cocoanlab/cocoanCORE
%%
friend_beta = filenames(fullfile(datdir,'friend*.nii'));

dat = fmri_data(friend_beta,which('gray_matter_mask.nii'));
%%
tdat = ttest(dat,0.001,'fdr');

%%
res= []; stats = []; 
for i =1:length(dat.dat)    
    [res(i), stats{i}] = robustfit(ones(1,59), dat.dat(i,:),'bisquare', [], 'off');
end
%%
pt = []; 
for i =1:195612; pt(i) = stats{i}.p; end;

maskdat = dat;
maskdat.dat = (res').* double(pt<FDR(pt,0.01))';%cat(1,res{:});
orthviews(maskdat);