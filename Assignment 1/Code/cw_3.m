m = [ 0.1; 0.2; 0.15 ];
C = [ 0.005,  -0.010,  0.004;
	-0.010,  0.04,  -0.002;
	0.004,  -0.002,  0.023 ];
% Calculate portfolio by NaiveMV linprog, quadprog)
[PRisk1, PRoR1, PWts1] = NaiveMV(m, C, 10)
% Calculate portfolio by NaiveMV_CVX
[PRisk2, PRoR2, PWts2] = NaiveMV_CVX(m, C, 10)

NumPorts = 100;

p = Portfolio;
p = setAssetMoments(p, m, C);
p = setDefaultConstraints(p);

figure(1);
plotFrontier(p, NumPorts);
hold on;
scatter(PRisk1,PRoR1,60,'b');
hold on;
scatter(PRisk2,PRoR2,20);

title('Optimal Portfolios by linprog/quadprog and CVX ','FontSize',16);
legend('Financial Toolbox','linprog/quadprog','CVX','Location','northwest');
xlabel('Portfolio Risk ( V )', 'FontSize',16);
ylabel('Portfolio Return ( M )','FontSize',16);
saveas(gcf,'3.png');

display(immse(PRisk1,PRisk2))
display(immse(PRoR1,PRoR2))
title('mse','FontSize',16);