[Call,txt_c,raw_c] = xlsread('FTSEOptionsData.xlsx','Calls');
%Call=fillmissing(Call,'constant',0); % get true call option price
[Put,txt_p,raw_p] = xlsread('FTSEOptionsData.xlsx','Puts');
%Put=fillmissing(Put,'constant',0); % get true put option price
[FTSE100,txt_FTSE100,raw_FTSE100] = xlsread('FTSEOptionsData.xlsx','FTSE Index');
%FTSE100= fillmissing(FTSE100,'constant',0);
%rand= randperm(83,5); % pick 5 stocks, starts from the 2nd column (1st col is date)
%rand= [47,54,57,66,74];  % for convenient, fix the random numbers
rand=[53,54,60,62,57]; 
Calls=Call(:,rand); % call option price starts from the 2nd column
Puts=Put(:,rand+1);
stock=char(txt_c(1,rand+1)); % get attribute of the random picked stocks
index=str2num(stock(:,16:19)); % get stock code/number
K=index;
K=sort(K); % for scatter plot
tau= 252;
T= length(Calls); % Time
window = round(T/4);
%r=0.06;
r=FTSE100(:,3)/100;
Call_est=zeros(T-window,5); % estimated call option price
Put_est=zeros(T-window,5);
diff_call=zeros(T-window,5);
diff_put=zeros(T-window,5);
volatility_c=zeros(T-window,5);
volatility_p=zeros(T-window,5);
volatility_implied= zeros(T-window,5);
volatility_implied_p= zeros(T-window,5);

S=FTSE100(:,2); % the value of the underlying asset (the FTSE index)
Yield=FTSE100(:,3);


for i=1:5
    [Call_est(:,i),diff_call(:,i),volatility_c(:,i)] = BLS_callprice(S,Calls(:,i),index(i),r);
    [Put_est(:,i),diff_put(:,i),volatility_p(:,i)] = BLS_putprice(S,Puts(:,i),index(i),r);    
    for t=1:1:(T-window)
        time = (T-window-t)/tau; 
        volatility_implied(t,i) = blsimpv(S(t,1),K(i),r(t,1),time,Calls(t,i),200,0,{'Call'});
        volatility_implied_p(t,i) = blsimpv(S(t,1),K(i),r(t,1),time,Puts(t,i),200,0,{'Put'});
    end
end    

title1=zeros(length(K),4);
for m=1:1:length(K)
title1(m,:) = num2str(K(m));
end

%rand_day=randi([(round(T/4)+1) (T-30)],1);
rand_day=207; % fixed, for convenient
range=(rand_day-round(T/4):rand_day-round(T/4)+29);


x = linspace(0,10);
y = x;


figure(8);
scatter(volatility_c(range,1),volatility_implied(range,1),'filled');
hold on;
scatter(volatility_c(range,2),volatility_implied(range,2),'filled');
hold on;
scatter(volatility_c(range,3),volatility_implied(range,3),'filled');
hold on;
scatter(volatility_c(range,4),volatility_implied(range,4),'filled');
hold on;
scatter(volatility_c(range,5),volatility_implied(range,5),'filled');
hold on;
line(x,y)
xlim([0.00043 0.00048])
ylim([-0.01 0.25])
title('Estimated Volatility vs Implied Volatility (Call Option)','FontSize',16);
legend(strcat('c',title1(1,:)),strcat('c',title1(2,:)),strcat('c',title1(3,:)),strcat('c',title1(4,:)),strcat('c',title1(5,:)),'y=x');
xlabel('Estimated Volatility','FontSize',14);
ylabel('Implied Volatility','FontSize',14)  
saveas(gcf,'c_compare_ref.png');


figure(1);
scatter(volatility_c(range,1),volatility_implied(range,1),'filled');
hold on;
scatter(volatility_c(range,2),volatility_implied(range,2),'filled');
hold on;
scatter(volatility_c(range,3),volatility_implied(range,3),'filled');
hold on;
scatter(volatility_c(range,4),volatility_implied(range,4),'filled');
hold on;
scatter(volatility_c(range,5),volatility_implied(range,5),'filled');
title('Estimated Volatility vs Implied Volatility (Call Option)','FontSize',16);
legend(strcat('c',title1(1,:)),strcat('c',title1(2,:)),strcat('c',title1(3,:)),strcat('c',title1(4,:)),strcat('c',title1(5,:)));
xlabel('Estimated Volatility','FontSize',14);
ylabel('Implied Volatility','FontSize',14)  
saveas(gcf,'c_compare.png');


%%%%%%%% 30 set for smile %%%%%%%%%
volatility_smile=volatility_implied(range,:);
volatility_smile_p=volatility_implied_p(range,:);

%%%%%%%% plot smile (put) %%%%%%%%%
figure(2);
plot(K,volatility_smile_p(28,:));
hold on;
scatter(K,volatility_smile_p(28,:));
legend('Put');
title('Volatility Smile for Put Option','FontSize',16);
xlabel('Strike Price','FontSize',14);
ylabel('Implied Volatility (Put Option)','FontSize',14)
saveas(gcf,'smile_put.png');

%%%%%%%% plot smile (call) %%%%%%%%%
figure(3);
plot(K,volatility_smile(28,:));
hold on;
scatter(K,volatility_smile(28,:));
legend('Call');
title('Volatility Smile for Call Option','FontSize',16);
xlabel('Strike Price','FontSize',14);
ylabel('Implied Volatility (Call Option)','FontSize',14)
saveas(gcf,'smile_call.png');

figure(4);
plot(K,volatility_smile_p(28,:));
hold on;
scatter(K,volatility_smile_p(28,:));
hold on;
plot(K,volatility_smile(28,:));
hold on;
scatter(K,volatility_smile(28,:));
legend('Put','','Call','');
title('Volatility Smile for Call/Put Option','FontSize',16);
xlabel('Strike Price','FontSize',14);
ylabel('Implied Volatility','FontSize',14);
saveas(gcf,'smile_both.png');

subplot(2,1,1);
plot(K,volatility_smile(28,:));
hold on;
scatter(K,volatility_smile(28,:));
legend('Call');
title('Volatility Smile for Call/Put Option','FontSize',16);
ylabel('Implied Volatility (Call)','FontSize',14)
%%%%%%% plot smile (put) %%%%%%%%%
subplot(2,1,2);
plot(K,volatility_smile_p(28,:));
hold on;
scatter(K,volatility_smile_p(28,:));
legend('Put');
xlabel('Strike Price','FontSize',14);
ylabel('Implied Volatility (Put)','FontSize',14)
saveas(gcf,'smile_cp.png');
