 

datax = [1:30];
datay = [0.1:0.1:3] + randn(1,30).*2.5;

scatter(datax,datay);
l1 = lsline;
l1.LineWidth =3;
%%
datax2 = datax;
datax2(2) = -15;
datay2 = datay;
datay2(2) = 15;
scatter(datax2,datay2);
l2 = lsline;
l2.LineWidth = 3;
%%
create_figure;
subplot(1,2,1);
scatter(datax,datay,'filled');
l1 = lsline;
l1.LineWidth =3;
l1.Color = [1 0 1 0.5];
set(gca,'Ylim',[-4 16],'Xlim',[-20 30]);
subplot(1,2,2);
scatter(datax2,datay2,'filled');
l2 = lsline;
l2.LineWidth = 3;
l2.Color = [0.1 0.2 0.8 0.5];

%
[beta, stats] = robustfit([ones(1,30); datax2]', datay2,'bisquare', [], 'off');
h3 = refline([beta(2) beta(1)]);
h3.Color = [1 0 0.1 0.9];
h3.LineWidth = 2;
