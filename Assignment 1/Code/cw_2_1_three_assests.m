m = [ 0.1; 0.2; 0.15 ];
C = [ 0.005,  -0.010,  0.004;
	-0.010,  0.04,  -0.002;
	0.004,  -0.002,  0.023 ];
for i=1:100
    weight=rand(3,1);
    sum_weight=sum(weight);
    x=weight/sum_weight;
    E(i)=x.'*m; % expected return
    V(i)=sqrt(x.'*C*x); % standard deviation
end
NumPorts = 100;

p = Portfolio;
p = setAssetMoments(p, m, C);
p = setDefaultConstraints(p);

plotFrontier(p, NumPorts);
hold on;
scatter(V,E,7);
title('Efficient Frontier (Three-asset model)','FontSize',16);
legend('Efficient Frontier','Random Portfolios','Location','northwest')
saveas(gcf,'2.1.png')
