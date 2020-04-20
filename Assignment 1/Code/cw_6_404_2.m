clear all
% Return=tick2ret(stocks);
cw_4_missingvalue;
cw_4_FTSE;
N=length(Return); % 759
FTSE_target=csvread('stock/FTSE 2016-2019.2.csv', 1, 5,[1 5 760 5]);
FTSE100=tick2ret(FTSE_target); % 759

y = FTSE100
R = Return;

 % sparse portfolio

array= zeros(400,2);
n=0;
for s = 0.01:0.5:200
    n=n+1;
    tau = s;
    cvx_begin quiet
    variable w_sparse(30);
    minimize (norm(y-R*w_sparse) + tau* norm(w_sparse,1));
    subject to 
        w_sparse'*ones(30,1) ==1;
    cvx_end
    coff_nzero= numel(find(abs(w_sparse)>0.00131752));
    array(n,1)=s;
    array(n,2)=coff_nzero;
end
figure(4)
plot(array(:,1),array(:,2),'rx','LineWidth',2)
ylabel('Number of Non-zero coefficients', 'FontSize', 14);
xlabel('Regularization', 'FontSize', 14);

x1 = array(:,1)
y1 = array(:,2)