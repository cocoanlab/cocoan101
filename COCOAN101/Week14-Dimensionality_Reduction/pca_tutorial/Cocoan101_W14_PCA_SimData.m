%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     COCOAN101 W14 Dimensionality Reduction   %
%     Principal Component Analysis tutorial    %
%     Part A. Simulated Data                   %
%      by Dong Hee Lee                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 0. Generate Data
W = [ randn(500,1)+3 randn(500,1)+2 randn(500,1)-3]; % 500 x 3 matrix
scatter3(W(:,1),W(:,2),W(:,3),30,'filled')

A = rand(3,3);

X = W*A;

%% visualization
Xmin = min(min(X)); Xmax = max(max(X));
limits = max(abs(Xmin),abs(Xmax));
xyz_min = -limits;
xyz_max = limits;

%
figure;

subplot(131)
scatter(X(:,1), X(:,2),30, jet(size(X,1)), 'filled')
axis square
set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin')
xlabel('X1'), ylabel('X2')
title('X1 and X2')

subplot(132)
scatter(X(:,2), X(:,3),30, jet(size(X,1)), 'filled')
axis square
set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin')
xlabel('X2'), ylabel('X3')
title('X2 and X3')

subplot(133)
scatter(X(:,1), X(:,3),30, jet(size(X,1)), 'filled')
axis square
set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin')
xlabel('X1'), ylabel('X3')
title('X1 and X3')

%
figure;
set(gcf,'position',[316.2000  215.4000  904  420]);
scatter3(X(:,1),X(:,2),X(:,3),30,jet(size(X,1)),'filled') % 3D scatter plot
grid on;
title('Original Data coordinate system (X1, X2, X3)')
xlim([xyz_min, xyz_max]); ylim([xyz_min, xyz_max]); zlim([xyz_min, xyz_max])
xlabel('X1'); ylabel('X2'); zlabel('X3')
set(gcf,'color','white');

%% 1. PCA with Eigendecomposition of covariance matrix
% X: observations by variables
X = bsxfun(@minus,X,mean(X,1)); % mean centering
size(X) % always check the size to make sure it's the correct orientation
covmat_X = (X'*X) / length(X); % covariance matrix of X'
size(covmat_X) % # of features x # of features

% eigendecomposition of covariance matrix 
[evecsX, evalsX] = eig( covmat_X ); % [eigenvector, eigenvalue] = eig()

% sort according to eigenvalues
[evalsX,eidx] = sort(diag(evalsX),'descend'); 
evecsX = evecsX(:,eidx);

% see orthogonality for eigenvector matirx
isequal(evecsX'*evecsX, eye(3)) % precision problem.. but the two matrices are equal

% transform Data
C = X*evecsX;

var(C)
evalsX'


%% Visualization
% PCs in PC space
Cmin = min(min(C)); Cmax = max(max(C));
limits = max(abs(Cmin),abs(Cmax));
xyz_min = -limits;
xyz_max = limits;

figure;
set(gcf,'position',[316.2000  215.4000  904  420]);
scatter3(C(:,1),C(:,2),C(:,3),30,'k','filled') % 3D scatter plot
grid on;
title('PC coordinate system (C1, C2, C3)')
xlim([xyz_min, xyz_max]); ylim([xyz_min, xyz_max]); zlim([xyz_min, xyz_max])
xlabel('C1'); ylabel('C2'); zlabel('C3')
set(gcf,'color','white');
arrow(0,0,0, max(C(:,1)),0,0);
arrow(0,0,0, 0,max(C(:,2)),0);
arrow(0,0,0, 0,0,max(C(:,3)));

% 
figure;
subplot(131)
scatter(C(:,1), C(:,2),30, 'k', 'filled')
xlim([-max(max(C(:,1:2))), max(max(C(:,1:2)))]);
ylim([-max(max(C(:,1:2))), max(max(C(:,1:2)))]);
xlabel('C1'), ylabel('C2')
title('C1 and C2')

subplot(132)
scatter(C(:,2), C(:,3),30, 'k', 'filled')
xlim([-max(max(C(:,2:3))), max(max(C(:,2:3)))]);
ylim([-max(max(C(:,2:3))), max(max(C(:,2:3)))]);
xlabel('C2'), ylabel('C3')
title('C2 and C3')

subplot(133)
scatter(C(:,1), C(:,3),30, 'k', 'filled')
xlim([-max(max(C(:,[1 3]))), max(max(C(:,[1 3])))]);
ylim([-max(max(C(:,[1 3]))), max(max(C(:,[1 3])))]);
xlabel('C1'), ylabel('C3')
title('C1 and C3')



%% 2. number of components
% convert eigenvalues to %(explanied variable)
evalsX_percent = 100*evalsX/sum(evalsX); 
% Scree plot a.k.a. Eigenspectrum
% option 1: elbow point
figure;
plot(evalsX_percent(1:3),'ko-','markerfacecolor','w','linew',2)
title('Scree plot'), axis square
ylabel('Percent variance'), xlabel('Component number')

% option 2: select top K components that explain most variance in the data
i = 0; 
for k=1:numel(evalsX_percent)
    i = i + evalsX_percent(k,1);
    if i > 90 % example: > 90%
        top_k_comp = k;
        break
    end
end

explained_variance = sum(evalsX_percent(1:top_k_comp));

%% 3. Dimension Reduction
reduced_evecsX = evecsX(:,1:top_k_comp);

% transform Data
reducedX = X*reduced_evecsX; 

% visualization
figure;
hold on
scatter(reducedX(:,1), reducedX(:,2),30, 'k', 'filled')
line([max(reducedX(:,1)) min(reducedX(:,1))],[0 0],'linewidth', 3, 'color', 'r')
line([0 0],[max(reducedX(:,2)) min(reducedX(:,2))],'linewidth', 3, 'color', 'r')
xlim([-max(max(reducedX(:,1:2))), max(max(reducedX(:,1:2)))]);
ylim([-max(max(reducedX(:,1:2))), max(max(reducedX(:,1:2)))]);
xlabel('C1'), ylabel('C2')
title('C1 and C2 in reduced PC coordinate system (C1, C2) ')
axis square
hold off


% Reconstrut Data
Y = reducedX*reduced_evecsX';
figure;
scatter3(X(:,1),X(:,2),X(:,3),30,'b','filled')
hold on
scatter3(Y(:,1),Y(:,2),Y(:,3),30,'r','filled')
hold off

%% Bonous. PCA with Singular Value Decomposition of data matrix
% NOTE: In the video, I used the non-mean-centered data in the svd below.
%       The code is now corrected to use the mean-centered data.
[U,S,V] = svd( X , 'econ' );

% convert singular values to %
S = S.^2; % makes it comparable to eigenvalues
s = 100*diag(S)/sum(diag(S));

% Comparison between EIG and SVD
clf;
% plot eigenvalue/singular-value
hold on
plot(evalsX_percent,'bs-','markerfacecolor','w','markersize',10,'linew',2)
plot(s,'ro-','markerfacecolor','w','markersize',5)
xlabel('Component number'), ylabel('\lambda or \sigma')
legend({'eig';'svd'})
axis square
hold off
