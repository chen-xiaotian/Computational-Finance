[Call,txt_c,raw_c] = xlsread('FTSEOptionsData.xlsx','Calls');
Call=fillmissing(Call,'nearest'); % get true call option price
[Put,txt_p,raw_p] = xlsread('FTSEOptionsData.xlsx','Puts');
Put=fillmissing(Put,'nearest'); % get true put option price
FTSE100= xlsread('FTSEOptionsData.xlsx','FTSE Index');
FTSE100=fillmissing(FTSE100,'nearest');
%rand= randperm(83,5); % pick 5 stocks, starts from the 2nd column (1st col is date)
rand=[15,54,60,52,36]; % for convenient, fix the random numbers
Calls=Call(:,rand+1); % call option price starts from the 2nd column
Puts=Put(:,rand+1);
stock=char(txt_c(1,rand+1)); % get attribute of the random picked stocks
index=str2num(stock(:,16:19)); % get stock code/number

Call_est=zeros(206,5); % estimated call option price
Put_est=zeros(206,5);
diff_call=zeros(206,5);
diff_put=zeros(206,5);
volatility_c=zeros(206,5);
volatility_p=zeros(206,5);

% matlab function
%Volatility_matlab = blsimpv(FTSE100,Strike,Rate,Time,Value);

%%%%%%%%%%%%%% plot for price comparison%%%%%%%%%%%%%%%

for i=1:5
    [Call_est(:,i),diff_call(:,i),volatility_c(:,i)] = BLS_callprice(FTSE100(:,2),Calls(:,i),index(i));
    [Put_est(:,i),diff_put(:,i),volatility_p(:,i)] = BLS_putprice(FTSE100(:,2),Puts(:,i),index(i));
    figure(i);
    subplot(2,1,1);
    plot(70:275,Call_est(:,i));
    hold on;
    plot(70:275,Calls(70:275,i));
    title1 = num2str(index(i));
    title(strcat('Estimated price by BS Model vs True Option Price: ',title1),'FontSize',16);
    legend('Estimated call price','True option price')
    xlabel('Time','FontSize',14);
    ylabel('Call Option Price','FontSize',14)

    subplot(2,1,2);
    plot(70:275,Put_est(:,i));
    hold on;
    plot(70:275,Puts(70:275,i));
    legend('Estimated put price','True option price')
    xlabel('Time','FontSize',14);
    ylabel('Put Option Price','FontSize',14)
    %saveas(gcf,strcat(title1,'.png'))
end

%%%%%%%%%%%%%% plot for systematic differences of call option price%%%%%%%%%%%%%%%
figure(12);
plot(70:275,diff_call(:,1));
hold on;
plot(70:275,diff_call(:,2));
hold on;
plot(70:275,diff_call(:,3));
hold on;
plot(70:275,diff_call(:,4));
hold on;
plot(70:275,diff_call(:,5));
legend(strcat('c',num2str(index(1))),strcat('c',num2str(index(2))),strcat('c',num2str(index(3))),strcat('c',num2str(index(4))),strcat('c',num2str(index(5))));
title('Systematic Difference (True Price - Estimated Call Price)','Fontsize',16);
xlabel('Time Window','FontSize',14);
ylabel('Difference','FontSize',14);
%saveas(gcf,'diff_c.png');
    
%%%%%%%%%%%%%% plot for systematic differences of put option price%%%%%%%%%%%%%%%
figure(13);
plot(70:275,diff_put(:,1));
hold on;
plot(70:275,diff_put(:,2));
hold on;
plot(70:275,diff_put(:,3));
hold on;
plot(70:275,diff_put(:,4));
hold on;
plot(70:275,diff_put(:,5));
legend(strcat('p',num2str(index(1))),strcat('p',num2str(index(2))),strcat('p',num2str(index(3))),strcat('p',num2str(index(4))),strcat('p',num2str(index(5))));
title('Systematic Difference (True Price - Estimated Put Price)','Fontsize',16);
xlabel('Time Window','FontSize',14);
ylabel('Difference','FontSize',14);
%saveas(gcf,'diff_p.png');

% calculate difference
avg_diff_c=mean(diff_call);
avg_diff_p=mean(diff_put);
    

    