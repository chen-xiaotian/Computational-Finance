% missing value
% error in: stocks(:, 14) = textscan('stock/14 PPB.csv', '%n');
T = readtable('stock/14 PPB.csv','TreatAsEmpty',{'.','NA','null'});
PPB = fillmissing(T,'previous');
PPB=table2array(PPB(:,6));
PPB=PPB(1:760);

% missing value
% error in: stocks(:, 14) = textscan('stock/14 PPB.csv', '%n');
T = readtable('stock/15 PRU.csv','TreatAsEmpty',{'.','NA','null'});
% fill missing value with the previous row
PRU = fillmissing(T,'previous');
% change type from table to array
PRU=table2array(PRU(:,6));
% exclude the last row (which was filled with row 760 automatically)
PRU=PRU(1:760);

% missing value
% error in: stocks(:, 14) = textscan('stock/14 PPB.csv', '%n');
T = readtable('stock/18 RMV.csv','TreatAsEmpty',{'.','NA','null'});
% fill missing value with the previous row
RMV = fillmissing(T,'previous');
% change type from table to array
RMV=table2array(RMV(:,6));
% exclude the last row (which was filled with row 760 automatically)
RMV=RMV(1:760);

% missing value
% error in: stocks(:, 14) = textscan('stock/14 PPB.csv', '%n');
T = readtable('stock/19 RR.csv','TreatAsEmpty',{'.','NA','null'});
% fill missing value with the previous row
RR = fillmissing(T,'previous');
% change type from table to array
RR=table2array(RR(:,6));
% exclude the last row (which was filled with row 760 automatically)
RR=RR(1:760);

% missing value
% error in: stocks(:, 14) = textscan('stock/14 PPB.csv', '%n');
T = readtable('stock/20 RTO.csv','TreatAsEmpty',{'.','NA','null'});
% fill missing value with the previous row
RTO = fillmissing(T,'previous');
% change type from table to array
RTO=table2array(RTO(:,6));
% exclude the last row (which was filled with row 760 automatically)
RTO=RR(1:760);

% missing value
% error in: stocks(:, 14) = textscan('stock/14 PPB.csv', '%n');
T = readtable('stock/21 SDR.csv','TreatAsEmpty',{'.','NA','null'});
% fill missing value with the previous row
SDR = fillmissing(T,'previous');
% change type from table to array
SDR=table2array(SDR(:,6));
% exclude the last row (which was filled with row 760 automatically)
SDR=SDR(1:760);

% missing value
% error in: stocks(:, 14) = textscan('stock/14 PPB.csv', '%n');
T = readtable('stock/22 SMIN.csv','TreatAsEmpty',{'.','NA','null'});
% fill missing value with the previous row
SMIN = fillmissing(T,'previous');
% change type from table to array
SMIN=table2array(SMIN(:,6));
% exclude the last row (which was filled with row 760 automatically)
SMIN=SMIN(1:760);

% missing value
% error in: stocks(:, 14) = textscan('stock/14 PPB.csv', '%n');
T = readtable('stock/23 SMT.csv','TreatAsEmpty',{'.','NA','null'});
% fill missing value with the previous row
SMT = fillmissing(T,'previous');
% change type from table to array
SMT=table2array(SMT(:,6));
% exclude the last row (which was filled with row 760 automatically)
SMT=SMT(1:760);

% missing value
% error in: stocks(:, 14) = textscan('stock/14 PPB.csv', '%n');
T = readtable('stock/25 SSE.csv','TreatAsEmpty',{'.','NA','null'});
% fill missing value with the previous row
SSE = fillmissing(T,'previous');
% change type from table to array
SSE=table2array(SSE(:,6));
% exclude the last row (which was filled with row 760 automatically)
SSE=SSE(1:760);


% missing value
% error in: stocks(:, 14) = textscan('stock/14 PPB.csv', '%n');
T = readtable('stock/26 STJ.csv','TreatAsEmpty',{'.','NA','null'});
% fill missing value with the previous row
STJ = fillmissing(T,'previous');
% change type from table to array
STJ=table2array(STJ(:,6));
% exclude the last row (which was filled with row 760 automatically)
STJ=STJ(1:760);

% missing value
% error in: stocks(:, 14) = textscan('stock/14 PPB.csv', '%n');
T = readtable('stock/27 TSCO.csv','TreatAsEmpty',{'.','NA','null'});
% fill missing value with the previous row
TSCO = fillmissing(T,'previous');
% change type from table to array
TSCO=table2array(TSCO(:,6));
% exclude the last row (which was filled with row 760 automatically)
TSCO=TSCO(1:760);
