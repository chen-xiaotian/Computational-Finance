
prn=zeros(222,3);
f=dir('*.prn');% get the file list

c2925=importdata(f(1).name);
c3025=importdata(f(2).name);
c3125=importdata(f(3).name);
c3225=importdata(f(4).name);
c3325=importdata(f(5).name);
p2925=importdata(f(6).name);
p3025=importdata(f(7).name);
p3125=importdata(f(8).name);
p3225=importdata(f(9).name);
p3325=importdata(f(10).name);
% f=dir('*.prn');
% c\p 2925 
K=2925;
[call_2925,diff_c2925,v_c2925] = BLS_callprice(c2925,K);
[put_2925,diff_p2925,v_p2925] = BLS_putprice(p2925,K);

% c\p 3025 
K=3025;
[call_3025,diff_c3025,v_c3025] = BLS_callprice(c3025,K);
[put_3025,diff_p3025,v_p3025] = BLS_putprice(p3025,K);
% c\p 3125 
K=3125;
[call_3125,diff_c3125,v_c3125] = BLS_callprice(c3125,K);
[put_3125,diff_p3125,v_p3125] = BLS_putprice(p3125,K);
% c\p 3225 
K=3225;
[call_3225,diff_c3225,v_c3225] = BLS_callprice(c3225,K);
[put_3225,diff_p3225,v_p3225] = BLS_putprice(p3225,K);

% c\p 3325 
K=3325;
[call_3325,diff_c3325,v_c3325] = BLS_callprice(c3325,K);
[put_3325,diff_p3325,v_p3325] = BLS_putprice(p3325,K);

% 2925
figure(1);
subplot(2,1,1);
plot(57:222,call_2925);
hold on;
plot(c2925(:,2));
title('Estimated price by BS Model vs True Option Price (2925)','FontSize',16)
legend('Estimated call price','True option price')
xlabel('Time','FontSize',14);
ylabel('Call Option Price','FontSize',14)

subplot(2,1,2);
plot(57:222,put_2925);
hold on;
plot(p2925(:,2));
legend('Estimated put price','True option price')
xlabel('Time','FontSize',14);
ylabel('Put Option Price','FontSize',14)

% 3025
figure(2);
subplot(2,1,1);
plot(57:222,call_3025);
hold on;
plot(c3025(:,2));
title('Estimated price by BS Model vs True Option Price (3025)','FontSize',16)
legend('Estimated call price','True option price')
xlabel('Time','FontSize',14);
ylabel('Call Option Price','FontSize',14)

subplot(2,1,2);
plot(57:222,put_3025);
hold on;
plot(p3025(:,2));
legend('Estimated put price','True option price')
xlabel('Time','FontSize',14);
ylabel('Put Option Price','FontSize',14)

% 3125
figure(3);
subplot(2,1,1);
plot(57:222,call_3125);
hold on;
plot(c3125(:,2));
title('Estimated price by BS Model vs True Option Price (3125)','FontSize',16)
legend('Estimated call price','True option price')
xlabel('Time','FontSize',14);
ylabel('Call Option Price','FontSize',14)

subplot(2,1,2);
plot(57:222,put_3125);
hold on;
plot(p3125(:,2));
legend('Estimated put price','True option price')
xlabel('Time','FontSize',14);
ylabel('Put Option Price','FontSize',14)

% 3225
figure(4);
subplot(2,1,1);
plot(57:222,call_3225);
hold on;
plot(c3225(:,2));
title('Estimated price by BS Model vs True Option Price (3225)','FontSize',16)
legend('Estimated call price','True option price')
xlabel('Time','FontSize',14);
ylabel('Call Option Price','FontSize',14)

subplot(2,1,2);
plot(57:222,put_3225);
hold on;
plot(p3225(:,2));
legend('Estimated put price','True option price')
xlabel('Time','FontSize',14);
ylabel('Put Option Price','FontSize',14)

% 3325
figure(5);
subplot(2,1,1);
plot(57:222,call_3325);
hold on;
plot(c3325(:,2));
title('Estimated price by BS Model vs True Option Price (3325)','FontSize',16)
legend('Estimated call price','True option price')
xlabel('Time','FontSize',14);
ylabel('Call Option Price','FontSize',14)

subplot(2,1,2);
plot(57:222,put_3325);
hold on;
plot(p3325(:,2));
legend('Estimated put price','True option price')
xlabel('Time','FontSize',14);
ylabel('Put Option Price','FontSize',14)

figure(6)
plot(diff_c2925);
hold on;
plot(diff_p2925);
title('Systematic Error(2925)','FontSize',16)
legend('c2925','p2925')
xlabel('Time','FontSize',14);
ylabel('Difference','FontSize',14)
figure(7)
plot(diff_c3025);
hold on;
plot(diff_p3025);
title('Systematic Error(3025)','FontSize',16)
legend('c3025','p3025')
xlabel('Time','FontSize',14);
ylabel('Difference','FontSize',14)
figure(8)
plot(diff_c3125);
hold on;
plot(diff_p3125);
title('Systematic Error(3125)','FontSize',16)
legend('c3125','p3125')
xlabel('Time','FontSize',14);
ylabel('Difference','FontSize',14)
figure(9)
plot(diff_c3225);
hold on;
plot(diff_p3225);
title('Systematic Error(3225)','FontSize',16)
legend('p3225','c3225')
xlabel('Time','FontSize',14);
ylabel('Difference','FontSize',14)
figure(10)
plot(diff_c3325);
hold on;
plot(diff_p3325);
title('Systematic Error(3225)','FontSize',16)
legend('c3325','p3325')
xlabel('Time','FontSize',14);
ylabel('Systematic Error','FontSize',14)
ylabel('Difference','FontSize',14)