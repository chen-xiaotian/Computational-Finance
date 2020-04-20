% clear;
% load('workspace.mat');

N = 500;

ts = zeros(N, 1);
noise = wgn(N, 1, 20);
% noise= normrnd(0,2,[1,N]); % replace to normal distribution

ts(1:3) = ones(3, 1) * 5000;
for n = 4:N
    ts(n) = 0.2 * ts(n - 1) + 0.8 * ts(n - 2) - 0.1 * ts(n - 3) + noise(n);
end

[ theta, P, e ] = kalman_filter(ts, 0.000000001);

figure;
plot(ts); % true value
title('Time series');
xlabel('n');
ylabel('y(n)');

figure;
hold on;
plot(e); %  error/residual
plot(noise);
title('Residual');
xlabel('n');
ylabel('e(n)');
legend('Residual', 'Known random variance');
