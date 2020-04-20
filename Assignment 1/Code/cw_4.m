x=[17,13,22]
%x=randperm(30,3); % choose unique random int from 1:30, return 3*1 matrix
for i=1:3
    asset(:,i)=Return(:,x(i));
end

%means = tick2ret(assets);
%split data into training & test set
asset_train=asset(1:380,:);
asset_test=asset(381:759,:);
%calculate mean/covariance of training assets
m_train = mean(asset_train,1); % 1-mean of each column; 2-mean of each row

N=3; % 3 assests
covariance = zeros(N, N);
for t = 1:380
    covariance = covariance + (asset_train(t, :) - m_train)' * (asset_train(t, :) - m_train);
end
covariance = covariance / 380;

V0 = zeros(N, 1);
V1 = ones(1, N);
% Find the maximum expected return
%MaxReturnWeights = linprog(-ERet, [], [], V1, 1, V0);
%cvx_begin quiet
%    variable MaxReturnWeights(N,1)
%    maximize ( m_train * MaxReturnWeights)
%    subject to
%        V1*MaxReturnWeights== 1;
%        MaxReturnWeights >= V0;
%cvx_end;

[PRisk, PRoR, PWts] = NaiveMV(m_train, covariance,1);
Weight_N=[1/3, 1/3, 1/3];

figure(1);
plot(cumsum(asset_test * PWts'));
hold on;
plot(cumsum(asset_test * Weight_N'));

title('Cumulative Return Series for NaiveMV and 1/N Portfolio','FontSize',16);
ylabel('Cumulative Return','FontSize',16);
xlabel('Time','FontSize',16);
legend('Efficient portfolio','1/N portfolio')

figure(2);
plot(asset_test * PWts');
hold on;
plot(asset_test * Weight_N');
title('Return Series for NaiveMV and 1/N Portfolio','FontSize',16);
ylabel('Daily Return','FontSize',16);
xlabel('Time','FontSize',16);
legend('Efficient portfolio','1/N portfolio')
% load FundMarketCash 
% Returns = tick2ret(TestData);
% Riskless = mean(Returns(:,3))
% Sharpe = sharpe(Returns, Riskless)

Ratio_naiveMV = sharpe(asset_test*PWts') % risky
Ratio_N = sharpe(asset_test * Weight_N') % mean (riskless)

Ratio_naiveMV1 = sharpe(asset_test,asset_test*PWts') % risky
Ratio_N1 = sharpe(asset_test,asset_test * Weight_N') % mean (riskless)

%Return_mv=asset_test*PWts'
%Return_n=asset_test * Weight_N'
%Ratio_naiveMV2 = sharpe(Return_mv,mean(Return_mv)) % risky
%Ratio_N2 = sharpe(Return_n,mean(Return_n)) % mean (riskless)

