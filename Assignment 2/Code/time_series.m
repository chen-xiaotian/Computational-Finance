clear;
load('workspace.mat');

N = 1000;

ts = zeros(N, 1);
noise = wgn(N, 1, 20);

ts(1:3) = ones(3, 1) * 2000;
for n = 4:N
    ts(n) = 0.5 * ts(n - 1) + 0.6 * ts(n - 2) - 0.1 * ts(n - 3) + noise(n);
end

[ theta, P, e ] = kalman_filter(ts, 0.000000001);

% figure;
% plot(ts);
% title('Time series');
% xlabel('n');
% ylabel('y(n)');
% 
% figure;
% hold on;
% plot(e);
% plot(noise);
% title('Residual');
% xlabel('n');
% ylabel('e(n)');
% legend('Residual', 'Known random variance');

figure;
plot(e-noise);