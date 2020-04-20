% % % % % % % % % original % % % % % % % % % % % % % % %
% function [ theta, P, e ] = kalman_filter( ts, alpha )
%     N = size(ts, 1);
%     m = ar(ts, 3);
%     R = m.NoiseVariance;
% 
%     thetas = zeros(N, 3);
%     theta = (m.a(2:4) * -1)';
%     P = ones(3, 3);
%     Q = alpha * eye(3);
%     e = zeros(N, 1);
% 
%     for n = 4:N
%         P = P + Q;
%         x = ts((n - 3):(n - 1));
%         e(n) = ts(n) - theta' * x;
%         K = (P * x) / (R + x' * P * x);
%         theta = theta + K * e(n);
%         thetas(n, :) = theta;
%         P = (eye(3) - K * x') * P;
%     end
%     
%     figure;
%     plot(thetas(4:N, :));
%     title('Estimated value of \theta over time');
%     xlabel('n');
%     legend('\theta_1', '\theta_2', '\theta_3');
% end

function [ theta, P, e ] = kalman_filter( ts, alpha )
    N = size(ts, 1); % ts: time series data (input,true value)
    m = ar(ts, 3); % 3rd order ar model
    R = m.NoiseVariance;

    thetas = zeros(N, 3); % initialise estimated data
    theta = (m.a(2:4) * -1)'; 
    P = ones(3, 3);
    Q = alpha * eye(3);
    e = zeros(N, 1); % error/residual

    for n = 4:N
        P = P + Q;
        x = ts((n - 3):(n - 1)); % x_(n-1)~x_(n-3)
        e(n) = ts(n) - theta' * x; % error/residual
        K = (P * x) / (R + x' * P * x); 
        theta = theta + K * e(n); 
        thetas(n, :) = theta;
        P = (eye(3) - K * x') * P;
    end
    
    figure;
    plot(thetas(4:N, :));
    title('Estimated value of \theta over time');
    xlabel('n');
    legend('\theta_1', '\theta_2', '\theta_3');
end