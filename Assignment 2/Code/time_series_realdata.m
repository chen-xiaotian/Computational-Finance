clear;
load('workspace.mat');

% alphas = zeros(100, 1);
% errors = zeros(100, 1);
% for i = 1:100
%     alphas(i) = 10^-(i/10);
%     [ theta, P, e ] = kalman_filter(SP500, alphas(i));
%     errors(i) = sum(abs(e));
% end
% 
% figure;
% plot(alphas, errors);
% title('Absolute error as a function of \alpha');
% xlabel('\alpha');
% ylabel('Sum of absolute residual');
% set(gca, 'XScale', 'log');

[ theta, P, e ] = kalman_filter(SP500, 10^-3);

figure;
plot(SP500);
title('Time series');
xlabel('n');
ylabel('y(n)');

figure;
plot(e);
title('Residual');
xlabel('n');
ylabel('e(n)');
