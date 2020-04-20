plot([0.0025,0.005], [0.1,0.1] ,'LineWidth', 2);
hold on;
scatter(0.0025,0.1,27);
axis([0 0.006 0 0.2]);
title('Mean Variance Portfolio','FontSize',16)
xlabel('Portfolio Risk ( V )', 'FontSize',16)
ylabel('Portfolio Return ( M )','FontSize',16);
legend('Mean Variance Portfolio','Efficient Frontier');
grid on
saveas(gcf,'1.png')