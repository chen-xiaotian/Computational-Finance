m = [ 0.2; 0.15 ];
C = [0.04,  -0.002;
	-0.002,  0.023 ];
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
title('Efficient Frontier (Asset 2 and 3)','FontSize',16);
legend('Efficient Frontier','Random Portfolios','Location','northwest')
saveas(gcf,'2.2_2_3.png')