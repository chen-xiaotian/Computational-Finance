cw_4_missingvalue;
cw_4_FTSE;
N=length(Return); % 759
FTSE_target=csvread('stock/FTSE 2016-2019.2.csv', 1, 5,[1 5 760 5]);
FTSE100=tick2ret(FTSE_target); % 759

y = FTSE100
R = Return;

n= 30;
tau = 0.0001;
cvx_begin quiet
variable w_sparse(n)
    minimize (norm(y-R*w_sparse) + tau* norm(w_sparse,1))
    subject to 
        w_sparse'*ones(n,1) ==1;

cvx_end
error_sparse = norm(y-R*w_sparse) + tau* norm(w_sparse,1);
mse_sparse = error_sparse/758; 
% re_6= find(abs(w_sparse)>0.01);
% re6_w = w_sparse(re_6);
[B,I] = maxk(w_sparse,6) % B: top 6 values; I: corresponding indexes

for i=1:6
    R_sparse(:, i) = R(:,I(i))
end

m=6
cvx_begin quiet
variable w_sparse(m)
    minimize (norm(y-R_sparse*w_sparse) + tau* norm(w_sparse,1))
    subject to 
        w_sparse'*ones(m,1) ==1;
cvx_end

error_sparse = norm(y-R_sparse*w_sparse) + tau* norm(w_sparse,1);
mse_sparse = error_sparse/758;

figure(1)
bar(I,w_sparse,0.9);
xlim([0 30])
for i = 1:length(I)
    text(I(i)-0.3,w_sparse(i),num2str(w_sparse(i),3),...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
end
title('Sparse Index Tracking using L1 Regularization','FontSize',16);
xlabel('Assets Picked by Sparse Portfolio (L1 Regularization) ', 'FontSize',16);
ylabel('Weights of Each Asset','FontSize',16);


figure(2);
plot(cumsum(y));
hold on;
plot(cumsum(R6*weight6));
hold on;
plot(cumsum(R_sparse*w_sparse));
title('Cumulative Return Series for FTSE, Greedy and Sparse','FontSize',16);
ylabel('Cumulative Return','FontSize',16);
xlabel('Time','FontSize',16);
legend('FTSE','Greedy','Sparse')
