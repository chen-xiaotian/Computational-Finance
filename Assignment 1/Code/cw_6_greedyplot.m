%cw_6_final_greedy;

portfolio=[opt_s1,opt_s2,opt_s3,opt_s4,opt_s5,opt_s6];
bar(portfolio,w,0.45);
xlim([0 30])
for i = 1:length(portfolio)
    text(portfolio(i)-0.3,w(i),num2str(w(i),3),...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
end
title('Index Tracking by Greedy Forward Selection','FontSize',16);
%legend('8','3','29','25','27','1','Location','northwest');
xlabel('Assets Picked by Greedy Forward Selection', 'FontSize',16);
ylabel('Weights of Each Asset','FontSize',16);