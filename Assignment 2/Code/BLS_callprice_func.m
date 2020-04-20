function [call_price,diff_call,volatility] = BLS_callprice_func(FTSE100,Calls,K)
S=FTSE100(:,2); % the value of the underlying asset (the FTSE index)
Yield=FTSE100(:,3);
% Stock price at end of ith interval: S(i)
T= length(S); % Time
tau= 1/252; % Length of time interval in years- trading days of one year
% ref. p329 explanation
window = round(T/4); % sliding window: t-T/4~t
% T-window : time of maturity, i.e. T (in the slides)
r = 0.06;
call_price = zeros((T-window),1);
put_price = zeros((T-window),1);
volatility= zeros((T-window),1);

for t= 1:1:(T-window)
    time = (T-window-t)*tau; 
    volatility(t,1) = blsimpv(S(t+window,1),K,r,time,Calls(t+window,1),'Yield',Yield(t+window,1),'Class', {'Call'});
    % The life of an option=Number of trading days until option maturity/252
    % formula T: t/252
    volatility=fillmissing(volatility,'previous');
    [call_price(t,1),put_price(t,1)] = blsprice(S(t+window,1),K,r,time,volatility(t,1));
end
% diff = abs(dt(57:222,2)-price_bs);
diff_call = Calls(window+1:T)-call_price;
end