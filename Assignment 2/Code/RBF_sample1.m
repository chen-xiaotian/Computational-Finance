[Call,txt_c,raw_c] = xlsread('FTSEOptionsData.xlsx','Calls');
%Call=fillmissing(Call,'constant',0); % get true call option price
[Put,txt_p,raw_p] = xlsread('FTSEOptionsData.xlsx','Puts');
%Put=fillmissing(Put,'constant',0); % get true put option price
[FTSE100,txt_FTSE100,raw_FTSE100] = xlsread('FTSEOptionsData.xlsx','FTSE Index');
rand= [47,54,57,66];  % for convenient, fix the random numbers
Calls=Call(:,rand); % call option price starts from the 2nd column
Puts=Put(:,rand+1);
stock=char(txt_c(1,rand+1)); % get attribute of the random picked stocks
index=str2num(stock(:,16:19)); % get stock code/number
K=index;
K=sort(K); % for scatter plot
r=FTSE100(:,3);

strike_prices = [ones(length(FTSE100), 1) * K(1); ones(length(FTSE100), 1) * K(2); ones(length(FTSE100), 1) * K(3); ones(length(FTSE100), 1) * K(4)];

% Actual prices normalised by strike price (S/X) S:stock X: strike
actual_prices = [FTSE100(:, 2) / K(1); FTSE100(:, 2) / K(2); FTSE100(:, 2) / K(3); FTSE100(:, 2) / K(4)];
% actual_prices = strike_prices/FTSE100(:, 2);

% Times (T - t)
t = linspace(length(FTSE100) / 252, 0, length(FTSE100))';
times = [t; t; t; t];

N = size(FTSE100(:, 2), 1);
% Stock 1
volatility = std(tick2ret(FTSE100(:, 2), [], 'Continuous')) / sqrt(N / 252);
[call, put] = blsprice(FTSE100(:, 2), K(1), r, t, volatility);
delta_K1 = blsdelta(call + 1, K(1), r, t + 1, volatility);
call_K1 = call / K(1);

% Stock 2
volatility = std(tick2ret(FTSE100(:, 2), [], 'Continuous')) / sqrt(N / 252);
[call, put] = blsprice(FTSE100(:, 2), K(2), r, t, volatility);
delta_K2 = blsdelta(call + 1, K(2), r, t + 1, volatility);
call_K2 = call / K(2);

% Stock 3
volatility = std(tick2ret(FTSE100(:, 2), [], 'Continuous')) / sqrt(N / 252);
[call, put] = blsprice(FTSE100(:, 2), K(3), r, t, volatility);
delta_K3 = blsdelta(call + 1, K(3), r, t + 1, volatility);
call_K3 = call / K(3);

% Stock 4
N = size(FTSE100(:, 2), 1);
volatility = std(tick2ret(FTSE100(:, 2), [], 'Continuous')) / sqrt(N / 252);
[call, put] = blsprice(FTSE100(:, 2), K(4), r, t, volatility);
delta_K4 = blsdelta(call + 1, K(4), r, t + 1, volatility);
call_K4 = call / K(4);


% Black-Scholes predicted call option prices normalised by strike price
% (C/X)
bls_prices = [call_K1; call_K2; call_K3; call_K4];

bls_deltas = [delta_K1; delta_K2; delta_K3; delta_K4];

% figure 1
% Simulated call option prices normalized by strike price:C/X and plotted versus
% stock pric:S/X and time to expiration.
RBF_plot_mesh(actual_prices, times, bls_prices);
xlabel('S/X');
ylabel('T - t');
zlabel('C/X');

% Part 2
data = [actual_prices times];
N = size(data, 1);

%result = fitgmdist(data, 4, 'Options', statset('MaxIter', 1000));
result = fitgmdist(data, 4, 'Options', statset('MaxIter', 1000),'SharedCovariance',true);

design_matrix = zeros(N, 7);
design_matrix(:, 7) = ones(N, 1);

design_matrix(:, 5:6) = data;

for j = 1:4
    mean = result.mu(j, :)';
    cov = result.Sigma;
    %cov = result.Sigma(:, :, j);
    for n = 1:N
        x = data(n, :)';
        design_matrix(n, j) = sqrt((x - mean)' * cov * (x - mean));
    end
end

w = inv(design_matrix' * design_matrix) * design_matrix' * bls_prices;

rbf_prices = design_matrix * w;
% figure 2
% network call price: C/X hat
RBF_plot_mesh(actual_prices, times, rbf_prices);
xlabel('S/X');
ylabel('T - t');
zlabel('C/X');

% figure 3
% network delta
RBF_plot_mesh(actual_prices, times, bls_deltas);
xlabel('S/X');
ylabel('T - t');
zlabel('Delta');

% figure 4
% call price error: C/X hat-C/X
RBF_plot_mesh(actual_prices, times, rbf_prices - bls_prices(:, 1));
xlabel('S/X');
ylabel('T - t');
zlabel('C/X error');

% figure 5
% delta error: 


% figure 6
% price diff
figure;
plot(bls_prices);
hold on;
plot(rbf_prices);
legend('Black-Scholes', 'RBF');