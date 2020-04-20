m = [ 0.1; 0.2; 0.15 ];
C = [ 0.005,  -0.010,  0.004;
	-0.010,  0.04,  -0.002;
	0.004,  -0.002,  0.023 ];

m12 = [ 0.1; 0.2];
C12 = [ 0.005,  -0.010;
	-0.010,  0.04;];

m13 = [ 0.1; 0.15 ];
C13 = [ 0.005, 0.004;
	0.004, 0.023 ];

m23 = [ 0.2; 0.15 ];
C23 = [0.04,  -0.002;
	-0.002,  0.023 ];

p = Portfolio;
p = setAssetMoments(p, m, C);
p = setDefaultConstraints(p);

p12 = Portfolio;
p12 = setAssetMoments(p12, m12, C12);
p12 = setDefaultConstraints(p12);

p13 = Portfolio;
p13 = setAssetMoments(p13, m13, C13);
p13 = setDefaultConstraints(p13);

p23 = Portfolio;
p23 = setAssetMoments(p23, m23, C23);
p23 = setDefaultConstraints(p23);

plotFrontier(p, NumPorts);
hold on;
plotFrontier(p12, NumPorts);
hold on;
plotFrontier(p13, NumPorts);
hold on;
plotFrontier(p23, NumPorts);

title('Efficient Frontier','FontSize',16);
legend('Efficient Frontier ( Three assets )','Efficient Frontier ( Asset 1 and 2 )','Efficient Frontier ( Asset 1 and 3 )','Efficient Frontier ( Asset 2 and 3 )','Location','northwest')
saveas(gcf,'2_final.png')