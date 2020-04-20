time_series_realdata;

e = zscore(e(4:size(e, 1)));
CORP_PROFIT = zscore(imresize(CORP_PROFIT, size(e), 'bicubic'));
INCOME = zscore(imresize(INCOME, size(e), 'bicubic'));
OIL = zscore(imresize(OIL, size(e), 'bicubic'));
PMI = zscore(imresize(PMI, size(e), 'bicubic'));
POPULATION = zscore(imresize(POPULATION, size(e), 'bicubic'));
UNEMPLOYED = zscore(imresize(UNEMPLOYED, size(e), 'bicubic'));

variables = [CORP_PROFIT INCOME OIL PMI POPULATION UNEMPLOYED];
names = {'CORP\_PROFIT'; 'INCOME'; 'OIL'; 'PMI'; 'POPULATION'; 'UNEMPLOYED'};

tau = 1.3;

cvx_begin quiet
variable w(6)
    minimize(square_pos(norm(e - variables * w)) + tau * norm(w, 1));
cvx_end

%w = w / norm(w, 1);

figure;
hold on;
plot(variables * w);
plot(e);
title('Weighted variables plotted against residual');
legend('Weighted variables', 'Residual');
xlabel('n');

figure;
bar(w);
set(gca, 'XTickLabel', names);
rotateXLabels(gca(), 45);
title('Variable weights');
xlabel('Variable');
ylabel('Weight');
