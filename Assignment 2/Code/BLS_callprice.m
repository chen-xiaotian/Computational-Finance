function [call_price,diff_call,volatility] = BLS_callprice(FTSE,Calls,K,rate)
S=FTSE; % the value of the underlying asset (the FTSE index)
% Stock price at end of ith interval: S(i)
T= length(S); % Time
tau= 252; % Length of time interval in years- trading days of one year
% ref. p329 explanation
window = round(T/4); % sliding window: t-T/4~t
n=window-1;
% T-window : time of maturity, i.e. T (in the slides)
%u_i= zeros((T-window),4);
u_i = zeros(window,1);
%r = 0.06;
r=rate;
call_price = zeros((T-window),1);
volatility= zeros((T-window),1);
for t= 1:1:(T-window)
    if t==1
        u_i(t,1)=log(S(t,1)/S(t,1));
        for t=2:1:window
            u_i(t,1)=log(S(t,:)/S(t-1,:));
        end
    else
        for i = 1:1:window
            u_i(i,1)= log(S(t+i-1,:)/S(t+i-2,:));
        end
    end
    %volatility(t)= sqrt(sum(u_i(t).^2)/(n-1)-(sum(u_i(t))^2/(n*(n-1))))/sqrt(tau);
    %the u_i per annum
    volatility(t)= sqrt(sum(u_i.^2)/(n-1)-((sum(u_i)^2)/(n*(n-1))))/sqrt(tau); % volatility estimated using sliding window: t-T/4 to t,i.e. n=T/4-1
    % The life of an option=Number of trading days until option maturity/252
    % formula T: t/252
    time = (T-window-t)/tau; 
    d1= (log(S(t+window,1)/K)+(r(t+window,1)+volatility(t)^2/2)*time)/(volatility(t)*sqrt(time));
    d2= d1- volatility(t)*sqrt(time);
    call_price(t)= S(t+window,1)* normcdf(d1)- K*exp(-r(t+window,1)*time)* normcdf(d2);
end
% diff = abs(dt(57:222,2)-price_bs);
diff_call = Calls(window+1:T)-call_price;

end