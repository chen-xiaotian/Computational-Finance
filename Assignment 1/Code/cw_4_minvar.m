x=randperm(30,3); % choose unique random int from 1:30, return 3*1 matrix
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
options = optimset('LargeScale', 'off');
MinVarWeights = quadprog(covariance,V0,[],[],V1,1,V0,[],[],options);

Weight_N=[1/3, 1/3, 1/3];

plot(cumsum(asset_test * MinVarWeights));
%plot(asset_test * MaxReturnWeights);
hold on;
plot(cumsum(asset_test * Weight_N'));
%plot(asset_test * Weight_N');
%title('Cumulative return over time for efficient and 1/N portfolios');
title('Return over time for MaxReturn and 1/N portfolios');
ylabel('Return');
xlabel('Time');
legend('MaxReturn portfolio','1/N portfolio')
