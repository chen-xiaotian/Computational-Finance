x=randperm(30,3)

stock1 = Return(1:758,x(1));
stock2 = Return(1:758,x(2));
stock3 = Return(1:758,x(3));

rows=length(stock1);


stock1 = (stock1- mean(stock1))/ std(stock1);
stock2 = (stock2- mean(stock2))/ std(stock2);
stock3 = (stock3- mean(stock3))/ std(stock3);


return1 = zeros(rows/2,1);
return2 = zeros(rows/2,1);
return3 = zeros(rows/2,1);
returnT1 = zeros(rows/2,1);
returnT2 = zeros(rows/2,1);
returnT3 = zeros(rows/2,1);
% 1st half-train
for i = 1:rows/2
    return1(i) = stock1(i) - stock1(1);
    return2(i) = stock2(i) - stock2(1);
    return3(i) = stock3(i) - stock3(1);
end

% 2nd half-test
for i = 1:rows/2
    returnT1(i) = stock1(rows/2+i) - stock1(rows/2+1);
    returnT2(i) = stock2(rows/2+i) - stock2(rows/2+1);
    returnT3(i) = stock3(rows/2+i) - stock3(rows/2+1);
end


% 1. non-mispricing naiveMV model---------------------------
% train mean
trainRe1 = mean(return1(1:rows/2));
trainRe2 = mean(return2(1:rows/2));
trainRe3 = mean(return3(1:rows/2));
% testset mean
testRe1 = mean(returnT1(1:rows/2));
testRe2 = mean(returnT2(1:rows/2));
testRe3 = mean(returnT3(1:rows/2));
re = [return1 return2 return3];
reT = [returnT1 returnT2 returnT3];
trainRet = re(1:rows/2,:);
testRet = reT(1:rows/2,:);

% train covariance, number of assets, expected returns
nonM_ECov = cov(trainRet);
NPts = 10;
nonM_ERet = [trainRe1 trainRe2 trainRe3]';

% naiveMV model wiht non-mispricing values
[nonM_PRisk, nonM_PRoR, nonM_PWts] = NaiveMV(nonM_ERet, nonM_ECov, NPts);
nonM_efficientRet = zeros(rows/2,NPts);
nonM_efficientRetAverage = zeros(rows/2,1);
efficientRet = zeros(rows/2,NPts);
efficientRetAverage = zeros(rows/2,1);
efficientRet1 = zeros(rows/2,NPts);
efficientRetAverage1 = zeros(rows/2,1);

% 2. create mispricing values------------------------------
Nrand = randperm(rows/2,50);
Nsize = size(Nrand);
for j = 1:Nsize
    return1(Nrand(j)) = 0;
    return2(Nrand(j)) = 0;
    return3(Nrand(j)) = 0;
end

% returns
misRe = [return1 return2 return3];
trainRe1 = mean(return1(1:rows/2));
trainRe2 = mean(return2(1:rows/2));
trainRe3 = mean(return3(1:rows/2));
trainRet = misRe(1:rows/2,:);
% for i = 1:3
%     trainRet(:,i) = trainRet(:,i) - mean(trainRet(:,i));
%     trainRet(:,i) = trainRet(:,i) / std(trainRet(:,i));
% end
ECov = cov(trainRet);
ERet = [trainRe1 trainRe2 trainRe3]';
% naiveMV model with mispricing values
[PRisk, PRoR, PWts] = NaiveMV(ERet, ECov, NPts);

% 3. Mac model -------------------------------
riskFree = 0.03;
sharpeMV = zeros(1, NPts);
for i = 1:NPts
    efficientRet = testRet * PWts';
end
for i=1:NPts
    sharpeMV(i) = (std(efficientRet(:,i))/(mean(efficientRet(:,i)) - riskFree))^2;
end
sharpeEfficientAverage = mean(sharpeMV);
% ERet1 = ERet - mean(ERet);
% ERet1 = ERet1 / std(ERet1);
ECov1 = ERet * ERet' * sharpeEfficientAverage + var(ERet).*eye(3);
[PRisk1, PRoR1, PWts1] = NaiveMV(ERet, ECov1, NPts);
for i = 1:NPts
    nonM_efficientRet = testRet * nonM_PWts';
    efficientRet1 = testRet * PWts1';    
end
for i = 1:rows/2
    nonM_efficientRetAverage(i,1) = mean(nonM_efficientRet(i,:));
    efficientRetAverage(i,1) = mean(efficientRet(i,:));
    efficientRetAverage1(i,1) = mean(efficientRet1(i,:));
end
testRetAvg = zeros(rows/2,1);
for i = 1:rows/2
    testRetAvg(i) = mean(testRet(i,:));
end
figure;
box on;
hold on;
grid on;
plot(efficientRetAverage,'LineWidth',0.5);
plot(efficientRetAverage1,'LineWidth',0.5);
plot(testRetAvg,'LineWidth',0.5);
legend("NaiveMV","MP Portfolio","True values",'Location','northwest');
title("Return of NaiveMV and MP Portfolio",'FontSize',16);
xlabel("Time",'FontSize',16);
ylabel("Returns",'FontSize',16);

figure;
box on;
hold on;
grid on;
plot(cumsum(efficientRetAverage),'LineWidth',0.5);
plot(cumsum(efficientRetAverage1),'LineWidth',0.5);
plot(cumsum(testRetAvg),'LineWidth',0.5);
legend("NaiveMV","MP Portfolio","True values",'Location','northwest');
title("Cumulative Return of NaiveMV and MP Portfolio",'FontSize',16);
xlabel("Time",'FontSize',16);
ylabel("Cumulative Returns",'FontSize',16);


% error
MVerror = zeros(379,1);
Macerror = zeros(379,1);
for i = 1:379
    MVerror(i) = efficientRetAverage(i) - testRetAvg(i);
    Macerror(i) = efficientRetAverage1(i) - testRetAvg(i);
end
figure;
boxplot([MVerror,Macerror],'Notch','on','Labels',{'Mean-variance model','MacKinlay & Pastor model'});
title("Prediction deviation of two models",'FontSize',16);
ylabel("Error",'FontSize',16);

% sharpe ratio
sharpeMV = zeros(1, NPts);
sharpeMac = zeros(1,NPts);
for i=1:NPts
    sharpeMV(i) = (mean(efficientRet(:,i)) - riskFree)/std(efficientRet(:,i));
    sharpeMac(i) = (mean(efficientRet1(:,i)) - riskFree)/std(efficientRet1(:,i));
end
sharpeMVAverage = mean(sharpeMV);
sharpeMacAverage = mean(sharpeMac);
sharpe_N = sharpe(testRetAvg)

colormap = autumn(NPts);
colormap2 = winter(NPts);
figure;
hold on;
grid on;
plot([1 NPts],[sharpeMVAverage sharpeMVAverage],'LineWidth',2,'Color',[0 0.7 0.2]);
plot([1 NPts],[sharpeMacAverage sharpeMacAverage],'LineWidth',2,'Color',[0 0.1 0.7]);
sharpeMV = fliplr(sharpeMV);
sharpeMac = fliplr(sharpeMac);
for i=1:NPts
    plot(i, sharpeMV(i), '.r', 'MarkerSize', 30, 'Color', colormap(i,:));
    plot(i, sharpeMac(i), 'ob', 'MarkerSize', 15, 'Color', colormap2(i,:));
end
sharpeMV = fliplr(sharpeMV);
sharpeMac = fliplr(sharpeMac);
xlabel('Portfolio', 'FontSize', 18);
ylabel('Ratio', 'FontSize', 18);
title(strcat('Sharpe Ratio - Risk Free:', int2str(riskFree*100) ,'%' ), 'FontSize', 18);
legend('Mean-variance Avg.', 'MacKinlay & Pastor model Avg.', 'Mean-variance model','MacKinlay & Pastor model');