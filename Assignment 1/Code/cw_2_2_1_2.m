m = [ 0.1; 0.2];
C = [ 0.005,  -0.010;
	-0.010,  0.04;];
for i=1:100
    weight=rand(2,1);
    sum_weight=sum(weight);
    x=weight/sum_weight;
    E(i)=x.'*m;
    V(i)=sqrt(x.'*C*x);
end
NumPorts = 100;

p = Portfolio;
p = setAssetMoments(p, m, C);
p = setDefaultConstraints(p);

plotFrontier(p, NumPorts);hold on;scatter(V,E,7);
title('Efficient Frontier (Asset 1 and 2)','FontSize',16);
legend('Efficient Frontier','Random Portfolios','Location','northwest')
saveas(gcf,'2.2_1_2.png')