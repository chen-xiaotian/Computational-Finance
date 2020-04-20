[Call,txt_c,raw_c] = xlsread('FTSEOptionsData.xlsx','Calls');
%Call=fillmissing(Call,'constant',0); % get true call option price
[Put,txt_p,raw_p] = xlsread('FTSEOptionsData.xlsx','Puts');
%Put=fillmissing(Put,'constant',0); % get true put option price
[FTSE100,txt_FTSE100,raw_FTSE100] = xlsread('FTSEOptionsData.xlsx','FTSE Index');
%FTSE100= fillmissing(FTSE100,'constant',0);
rand= randperm(83,5); % pick 30 stocks, starts from the 2nd column (1st col is date)
%rand=[15,54,60,52,36]; % for convenient, fix the random numbers
S=FTSE100(:,2); % the value of the underlying asset (the FTSE index)
Yield=FTSE100(:,3);
T= length(S); % Time
rand_day=randi([(round(T/4)+1) (T-30)],1); % pick a random 30-day set from T/4+1 :T
%rand_day=240; %fixed,for convenient use

Calls=Call(:,rand+1); % call option price starts from the 2nd column
Puts=Put(:,rand+1);
tau= 1/252; % Length of time interval in years- trading days of one year
stock=char(txt_c(1,rand+1)); % get attribute of the random picked stocks
index=str2num(stock(:,16:19)); % get stock code/number
%K=index;
K=[7300,7350,7400,7500,7600]; % FIX K
%K=[6750,7875,7025,6875,6400];
K=sort(K); % for scatter plot
% initialize
Call_est=zeros(30,5); % estimated call option price
Put_est=zeros(30,5);
diff_call=zeros(30,5);
diff_put=zeros(30,5);
volatility_c=zeros(30,5);
volatility_p=zeros(30,5);
volatility_implied= zeros(30,5);
volatility_implied_p= zeros(30,5);

%function [call_price,diff_call,volatility] = BLS_callprice(FTSE,Calls,K)

window = 30; % sliding window: 30
n=window-1; % n+1: observations
%T-window : time of maturity, i.e. T (in the slides)
%u_i= zeros((T-window),4);
u_i = zeros(window,5);
r = 0.06;
for i=1:1:length(index)
    for t= 1:1:30  %for t= 1:1:(T-round(T/4))   
        u_i(t,i)=log(S(t+rand_day-1,1)/S(t+rand_day-2,1)); % starts from rand_day   
        %the u_i per annum
        volatility_c(t,i)= sqrt(sum(u_i(:,i).^2)/(n-1)-((sum(u_i(:,i))^2)/(n*(n-1))))/sqrt(tau); % volatility estimated using sliding window: t-T/4 to t,i.e. n=T/4-1
        volatility_p(t,i)= sqrt(sum(u_i(:,i).^2)/(n-1)-((sum(u_i(:,i))^2)/(n*(n-1))))/sqrt(tau); 
    % The life of an option=Number of trading days until option maturity/252
        time = (rand_day+30-t)*tau;
    %if no solution is found, blsimpv returns NaN!!!
    %volatility_implied(t,i) = blsimpv(S(t+rand_day-1,1),K(i),r,time,Calls(t+rand_day-1,i),'Yield',Yield(t+rand_day-1,1),'Class', {'Call'});
    %volatility_implied(t,i) = blsimpv(S(t+rand_day-1,1),K(i),r,time,Calls(t+rand_day-1+30,i),'Yield',Yield(t+rand_day-1,1),'Class', {'Call'});
        volatility_implied(t,i) = blsimpv(S(t+rand_day-1,1),K(i),r,time,Calls(t+rand_day-1,i),'Limit',0.5,'Yield',0,'Class', {'Call'});
%     volatility_implied_p(t,i) = blsimpv(S(t+rand_day-1,1),K(i),r,time,Puts(t+rand_day-1,i),'Yield',Yield(t+rand_day-1,1),'Class', {'Put'});
        volatility_implied_p(t,i) = blsimpv(S(t+rand_day-1,1),K(i),r,time,Puts(t+rand_day-1,i),'Limit',0.5,'Yield',0,'Class', {'Put'});
    end
% diff = abs(dt(57:222,2)-price_bs);
% diff_call = Calls(window+1:T)-call_price;
end
% end

title1=zeros(length(K),4);
for m=1:1:length(K)
title1(m,:) = num2str(K(m));
end

figure(1);
%%%%%%%plot for call option%%%%%%%
scatter(volatility_c(:,1),volatility_implied(:,1),'filled');
hold on;
scatter(volatility_c(:,2),volatility_implied(:,2),'filled');
hold on;
scatter(volatility_c(:,3),volatility_implied(:,3),'filled');
hold on;
scatter(volatility_c(:,4),volatility_implied(:,4),'filled');
hold on;
scatter(volatility_c(:,5),volatility_implied(:,5),'filled');
% ylim([0,2]);
% xlim([0,0.2]);
title('Estimated Volatility vs Implied Volatility (Call Option)','FontSize',16);
legend(strcat('c',title1(1,:)),strcat('c',title1(2,:)),strcat('c',title1(3,:)),strcat('c',title1(4,:)),strcat('c',title1(5,:)));
xlabel('Estimated Volatility','FontSize',14);
ylabel('Implied Volatility','FontSize',14)
% % saveas(gcf,'c.png')



% figure(2);
% %%%%%%%%plot for put option%%%%%%%
% scatter(volatility_p(:,1),volatility_implied_p(:,1),'filled');
% hold on;
% scatter(volatility_p(:,2),volatility_implied_p(:,2),'filled');
% hold on;
% scatter(volatility_p(:,3),volatility_implied_p(:,3),'filled');
% hold on;
% scatter(volatility_p(:,4),volatility_implied_p(:,4),'filled');
% hold on;
% scatter(volatility_p(:,5),volatility_implied_p(:,5),'filled');
% % ylim([0,2]);
% % xlim([0,0.2]);
% title('Estimated Volatility vs Implied Volatility (Put Option)','FontSize',16);
% legend(strcat('p',title1(1,:)),strcat('p',title1(2,:)),strcat('p',title1(3,:)),strcat('p',title1(4,:)),strcat('p',title1(5,:)));
% xlabel('Estimated Volatility','FontSize',14);
% ylabel('Implied Volatility','FontSize',14)
% saveas(gcf,'c_put.png')

%%%%% fill NaN %%%%%% 
% volatility_implied= fillmissing(volatility_implied,'Previous'); % yield=0,volatility_implied is easy to be NaN
% volatility_implied_p= fillmissing(volatility_implied_p,'Previous');


%%%%% plot call smile %%%%%%%%%
figure(3)
plot(K,volatility_implied(28,:));
xlabel('Strike Price','FontSize',14);
ylabel('Implied Volatility','FontSize',14)
saveas(gcf,'smile1.png')

figure(4)
plot(K,volatility_implied(29,:));
xlabel('Strike Price','FontSize',14);
ylabel('Implied Volatility','FontSize',14)
saveas(gcf,'smile2.png')

figure(5)
plot(K,volatility_implied(30,:));
xlabel('Strike Price','FontSize',14);
ylabel('Implied Volatility','FontSize',14)
saveas(gcf,'smile3.png')


%%%%%%%%%% where is the smile??? %%%%%%%%%%%%%%%%
% figure(6)
% plot(K,volatility_implied(28,:)+volatility_implied_p(28,:));
% xlabel('Strike Price','FontSize',14);
% ylabel('Implied Volatility','FontSize',14)
% saveas(gcf,'smile4.png')
% 
% figure(7)
% plot(K,volatility_implied(29,:)+volatility_implied_p(29,:));
% xlabel('Strike Price','FontSize',14);
% ylabel('Implied Volatility','FontSize',14)
% saveas(gcf,'smile5.png')
% 
% figure(8)
% plot(K,volatility_implied(30,:)+volatility_implied_p(30,:));
% xlabel('Strike Price','FontSize',14);
% ylabel('Implied Volatility','FontSize',14)
% saveas(gcf,'smile6.png')