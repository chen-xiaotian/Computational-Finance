[Call,txt_c,raw_c] = xlsread('FTSEOptionsData.xlsx','Calls');
% Call=fillmissing(Call,'previous'); % get true call option price
[Put,txt_p,raw_p] = xlsread('FTSEOptionsData.xlsx','Puts');
%Put=fillmissing(Put,'constant',0); % get true put option price
[FTSE100,txt_FTSE100,raw_FTSE100] = xlsread('FTSEOptionsData.xlsx','FTSE Index');
%rand= [47,54,57,66];  % for convenient, fix the random numbers
rand=[55,60,62,58]; % km choice
Calls=Call(:,rand); % call option price starts from the 2nd column
Puts=Put(:,rand+1);
stock=char(txt_c(1,rand+1)); % get attribute of the random picked stocks
index=str2num(stock(:,16:19)); % get stock code/number
K=index;
K=sort(K); % for scatter plot
%r=FTSE100(:,3);
r=0.014;
volatility = std(tick2ret(FTSE100(:, 2), [], 'Continuous')) / sqrt(275 / 252);

% split training set/test set
trainN = 0.6*length(FTSE100);
testN=length(FTSE100)-trainN;
ii = randperm(length(FTSE100)); % shuffle
%ii=sort(ii);
train_index=ii(1:trainN);
test_index=ii(trainN+1:end);
train_set=FTSE100(train_index,2);% train_set for stock price (FTSE100)
test_set=FTSE100(test_index,2);

% true option price
call_train_set=Call(train_index,2);
C_train = [call_train_set / K(1); call_train_set / K(2); call_train_set / K(3); call_train_set / K(4)];
call_test_set=Call(test_index,2);
C_test = [call_test_set / K(1); call_test_set / K(2); call_test_set / K(3); call_test_set / K(4)];
% useless parameter
% strike_prices = [ones(length(FTSE100), 1) * K(1); ones(length(FTSE100), 1) * K(2); ones(length(FTSE100), 1) * K(3); ones(length(FTSE100), 1) * K(4)];

% (S/X) S:stock X: strike Actual prices normalised by strike price 
S = [FTSE100(:, 2) / K(1); FTSE100(:, 2) / K(2); FTSE100(:, 2) / K(3); FTSE100(:, 2) / K(4)];
S_train = [train_set / K(1); train_set / K(2); train_set / K(3); train_set / K(4)];
%S_train = [call_train_set / K(1); call_train_set / K(2); call_train_set / K(3); call_train_set / K(4)];

% Time to expiration (T - t)
t = linspace(length(FTSE100) / 252, 0.0000001, length(FTSE100))';
t_train=t(train_index);
t_test=t(test_index);
T_t = [t; t; t; t];
T_t_train=[t_train; t_train; t_train; t_train];
T_t_test=[t_test; t_test; t_test; t_test];

% N_train: used to calculate volatility
N_train = size(train_set, 1);
% volatility = std(tick2ret(train_set, [], 'Continuous')) / sqrt(N_train / 252);


% Stock 1
[call, put] = blsprice(train_set, K(1), r, t_train, volatility);
delta_K1 = blsdelta(call+0.000001, K(1), r, t_train, volatility); % train_set:underlying asset?
call_K1 = call / K(1); % normalize

% Stock 2
[call, put] = blsprice(train_set, K(2), r, t_train, volatility);
delta_K2 = blsdelta(call+0.000001, K(2), r, t_train, volatility);
call_K2 = call / K(2);

% Stock 3
[call, put] = blsprice(train_set, K(3), r, t_train, volatility);
delta_K3 = blsdelta(call+0.000001, K(3), r, t_train, volatility);
call_K3 = call / K(3);

% Stock 4
[call, put] = blsprice(train_set, K(4), r, t_train, volatility);
delta_K4 = blsdelta(call+0.000001, K(4), r, t_train, volatility);
call_K4 = call / K(4);


% Black-Scholes predicted call option prices normalised by strike price:
% C/X
C_bls = [call_K1; call_K2; call_K3; call_K4];
delta_bls = [delta_K1; delta_K2; delta_K3; delta_K4];

% figure 1 estimated price - training set
% Simulated call option prices normalized by strike price:C/X and plotted versus
% stock pric:S/X and time to expiration.
RBF_plot_mesh_scatter(S_train, T_t_train, C_bls);
xlabel('S/X'); % true
ylabel('T - t');
zlabel('C/X'); % estimation
%title('Simulated call prices by BS normalized by strike price:C/X vs S/X')
saveas(gcf,'5_figure4.png');

%%%%%%%%%%%%%%%%%%%% Part 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% training phase %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = [S_train T_t_train]; % data vector,for GMModel
N = size(data, 1);

%GMModel = fitgmdist(data, 4, 'Options', statset('MaxIter', 1000));
GMModel = fitgmdist(data, 4, 'Options', statset('MaxIter', 1000),'SharedCovariance',true);

design_matrix = zeros(N, 7);
design_matrix(:, 7) = ones(N, 1);

design_matrix(:, 5:6) = data;

for j = 1:4
    mean_train = GMModel.mu(j, :)';
    cov_train = GMModel.Sigma;
    %cov = GMModel.Sigma(:, :, j);
    for n = 1:N
        x = data(n, :)';
        design_matrix(n, j) = sqrt((x - mean_train)' * cov_train * (x - mean_train));
    end
end

w = pinv(design_matrix' * design_matrix) * design_matrix' * C_bls; % artifical call price
%w = pinv(design_matrix' * design_matrix) * design_matrix' * S_train;

rbf_prices = design_matrix * w;

%%%%%%%%%% test phase %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S_test= [test_set / K(1); test_set/ K(2); test_set/ K(3); test_set/ K(4)];
%S_test = [call_test_set / K(1); call_test_set / K(2); call_test_set / K(3); call_test_set / K(4)];
data_test=[S_test T_t_test];
N = size(data_test, 1);
GMModel_test = fitgmdist(data_test, 4, 'Options', statset('MaxIter', 1000),'SharedCovariance',true);
N_test = size(test_set, 1);
%volatility_test = std(tick2ret(test_set, [], 'Continuous')) / sqrt(N_test / 252);

design_matrix_test = zeros(N, 7);
design_matrix_test(:, 7) = ones(N, 1);
design_matrix_test(:, 5:6) = data_test;

for j = 1:4
    mean = GMModel_test.mu(j, :)';
    cov = GMModel_test.Sigma;
    %cov = GMModel.Sigma(:, :, j);
    for n = 1:N
        x = data_test(n, :)';
        design_matrix_test(n, j) = sqrt((x - mean)' * cov * (x - mean));
    end
end

rbf_prices_test=design_matrix_test * w;

% calculate test set bls call price
[call, put] = blsprice(test_set, K(1), r, t_test, volatility);
%delta_test1=blsdelta(call+1, K(1), r, t_test, volatility);
%delta_test1=blsdelta(call_test_set, K(1), r, t_test, volatility);
call_K1 = call / K(1); % normalize
[call, put] = blsprice(test_set, K(2), r, t_test, volatility);
%delta_test2=blsdelta(call+1, K(2), r, t_test, volatility);
%delta_test2=blsdelta(call_test_set, K(2), r, t_test, volatility);
call_K2 = call / K(2); % normalize
[call, put] = blsprice(test_set, K(3), r, t_test, volatility);
%delta_test3=blsdelta(call+1, K(3), r, t_test, volatility);
%delta_test3=blsdelta(call_test_set, K(3), r, t_test, volatility);
call_K3 = call / K(3); % normalize
[call, put] = blsprice(test_set, K(4), r, t_test, volatility);
%delta_test4=blsdelta(call+1, K(4), r, t_test, volatility);
%delta_test4=blsdelta(call_test_set, K(4), r, t_test, volatility);
call_K4 = call / K(4); % normalize

C_bls_test = [call_K1; call_K2; call_K3; call_K4];


S_test = [test_set/ K(1); test_set/ K(2); test_set/ K(3); test_set/ K(4)];
size_rbf = length(rbf_prices_test);
delta = zeros(size_rbf,1);
for i = 1:size_rbf
    curr_S = S_test(i);
    dx_dS = [1;0];
    for j = 1:4
        xm = curr_S - GMModel_test.mu(j, :)';
        p1 = xm' * GMModel_test.Sigma * dx_dS;
        p2 = (xm' * GMModel_test.Sigma * xm) .^ (-1/2);
        delta(i) = delta(i) + p1 * p2;
    end
    delta(i) = delta(i) + w(7) * dx_dS(1);
end
rbfDeltas = delta; % rbf_test delta
avgrbfDeltas = sum(rbfDeltas)/length(rbfDeltas);
testDeltas = normcdf(S_test); % true delta

%delta_bls_true = [delta_test1; delta_test2; delta_test3; delta_test4]; % true call
delta_bls_true1=normcdf(C_test);
delta_bls_test1=normcdf(C_bls_test); %% ???
% %delta_rbf_test=normcdf(S_test); % S_test Gaussian distribution
% delta_rbf_test1=normcdf(rbf_prices_test); % delta hat?


RBF_plot_mesh(S_test, T_t_test, rbfDeltas);
xlabel('S/X');
ylabel('T - t');
zlabel('Delta');
%title('Network delta');
saveas(gcf,'5_figure5b.png');

%RBF_plot_mesh(S_test, T_t_test, rbfDeltas-delta_bls_true1);
RBF_plot_mesh(S_test, T_t_test, rbfDeltas-delta_bls_test1);
%RBF_plot_mesh(S_test, T_t_test, rbfDeltas-delta_bls_true);
xlabel('S/X');
ylabel('T - t');
zlabel('Delta error');
%title('Delta error');
saveas(gcf,'5_figure5d.png');


% RBF_plot_mesh(S_test, T_t_test, delta_bls_test1);
% xlabel('S/X');
% ylabel('T - t');
% zlabel('Delta');
% title('delta_bls_test(normcdf)');

% % % figure 5a
% % % network call price: C/X hat
RBF_plot_mesh(S_test, T_t_test, rbf_prices_test);
xlabel('S/X');
ylabel('T - t');
zlabel('C/X');
%title('Network call price');
saveas(gcf,'5_figure5a.png');

% % % % figure 5c
% % % % call price error: C/X hat-C/X . C/X-blackshole?true?
%RBF_plot_mesh(S_test, T_t_test,rbf_prices_test - C_test);
RBF_plot_mesh(S_test, T_t_test,rbf_prices_test - C_bls_test);
xlabel('S/X');
ylabel('T - t');
zlabel('C/X error');
title('Call price error');
saveas(gcf,'5_figure5c.png');


%  
% % figure 6
% % price diff
% figure;
% plot(rbf_prices_test);
% % hold on;
% % plot(C_bls_test);
% hold on;
% plot(S_test);
% legend('RBF', 'BLS','true');

%Rsq1 = 1 - sum((C_bls_test- rbf_prices_test).^2)/sum((C_bls_test - sum(C_bls_test)/length(C_bls_test)).^2);
Rsq1 = 1 - sum((C_test- rbf_prices_test).^2)/sum((C_test - sum(C_test)/length(C_test)).^2);