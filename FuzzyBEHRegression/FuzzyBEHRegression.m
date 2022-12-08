%% BEH Regression
%% Start
clc;
clear;
warning('off');
% Data Loading
data=JustLoad();
% Generate Fuzzy Model
ClusNum=3; % Number of Clusters in FCM
fis=GenerateFuzzy(data,ClusNum);

%% Tarining BEH Algorithm
BEHFis=beh(fis,data); 

figure;
plotfis(fis);
figure;
plotfis(BEHFis);

figure;
plotmf(fis,'input',4);
figure;
ax = gca; 
ax.FontSize = 12; 
plotmf(BEHFis,'input',4);
ax = gca; 
ax.FontSize = 12; 

%--------------------------------------------------------
%% Plot Fuzzy BEH Results (Train - Test)
% Train Output Extraction
TrTar=data.TrainTargets;
TrainOutputs=evalfis(data.TrainInputs,BEHFis);
% Test Output Extraction
TsTar=data.TestTargets;
TestOutputs=evalfis(data.TestInputs,BEHFis);
% Train calc
Errors=data.TrainTargets-TrainOutputs;
MSE=mean(Errors.^2);RMSE=sqrt(MSE);  
error_mean=mean(Errors);error_std=std(Errors);
% Test calc
Errors1=data.TestTargets-TestOutputs;
MSE1=mean(Errors1.^2);RMSE1=sqrt(MSE1);  
error_mean1=mean(Errors1);error_std1=std(Errors1);
% Train
figure('units','normalized','outerposition',[0 0 1 1])
subplot(3,2,1);
plot(data.TrainTargets,'b','linewidth',2);hold on;
plot(TrainOutputs,'r','linewidth',2);legend('Target','Output');
title('BEH Training Part');xlabel('Sample Index');grid on;
% Test
subplot(3,2,2);
plot(data.TestTargets,'b');hold on;
plot(TestOutputs,'r');legend('BEH Target','BEH Output');
title('BEH Testing Part');xlabel('Sample Index');grid on;
% Train
subplot(3,2,3);
plot(Errors,'k');legend('BEH Training Error');
title(['Train MSE =     ' num2str(MSE) '  ,     Train RMSE =     ' num2str(RMSE)]);grid on;
% Test
subplot(3,2,4);
plot(Errors1,'k');legend('BEH Testing Error');
title(['Test MSE =     ' num2str(MSE1) '  ,    Test RMSE =     ' num2str(RMSE1)]);grid on;
% Train
subplot(3,2,5);
h=histfit(Errors, 50);h(1).FaceColor = [.8 .3 0.3];
title(['Train Error Mean =   ' num2str(error_mean) '  ,   Train Error STD =   ' num2str(error_std)]);
% Test
subplot(3,2,6);
h=histfit(Errors1, 50);h(1).FaceColor = [.8 .3 0.3];
title(['Test Error Mean =   ' num2str(error_mean1) '  ,   Test Error STD =    ' num2str(error_std1)]);
%-----------------------------------------------------------
%% Plot Just Fuzzy Results (Train - Test)
% Train Output Extraction
fTrainOutputs=evalfis(data.TrainInputs,fis);
% Test Output Extraction
fTestOutputs=evalfis(data.TestInputs,fis);
% Train calc
fErrors=data.TrainTargets-fTrainOutputs;
fMSE=mean(fErrors.^2);fRMSE=sqrt(fMSE);  
ferror_mean=mean(fErrors);ferror_std=std(fErrors);
% Test calc
fErrors1=data.TestTargets-fTestOutputs;
fMSE1=mean(fErrors1.^2);fRMSE1=sqrt(fMSE1);  
ferror_mean1=mean(fErrors1);ferror_std1=std(fErrors1);
% Train
figure('units','normalized','outerposition',[0 0 1 1])
subplot(3,2,1);
plot(data.TrainTargets,'b','linewidth',2);hold on;
plot(fTrainOutputs,'g','linewidth',2);legend('Target','Output');
title('Fuzzy Training Part');xlabel('Sample Index');grid on;
% Test
subplot(3,2,2);
plot(data.TestTargets,'b');hold on;
plot(fTestOutputs,'g');legend('Target','Output');
title('Fuzzy Testing Part');xlabel('Sample Index');grid on;
% Train
subplot(3,2,3);
plot(fErrors,'k');legend('Fuzzy Training Error');
title(['Train MSE =     ' num2str(fMSE) '   ,    Test RMSE =     ' num2str(fRMSE)]);grid on;
% Test
subplot(3,2,4);
plot(fErrors1,'k');legend('Fuzzy Testing Error');
title(['Train MSE =     ' num2str(fMSE1) '   ,    Test RMSE =     ' num2str(fRMSE1)]);grid on;
% Train
subplot(3,2,5);
h=histfit(fErrors, 50);h(1).FaceColor = [.1 .8 0.6];
title(['Train Error Mean =    ' num2str(ferror_mean) '   ,   Train Error STD =    ' num2str(ferror_std)]);
% Test
subplot(3,2,6);
h=histfit(fErrors1, 50);h(1).FaceColor = [.1 .8 0.6];
title(['Test Error Mean =    ' num2str(ferror_mean1) '   ,   Test Error STD =    ' num2str(ferror_std1)]);
%---------------------------------------------------------------
%% Regression Plots
figure('units','normalized','outerposition',[0 0 1 1])
subplot(2,2,1)
[population2,gof] = fit(TrTar,TrainOutputs,'poly3');
plot(TrTar,TrainOutputs,'o',...
'LineWidth',1,...
'MarkerSize',6,...
'MarkerEdgeColor','g',...
'MarkerFaceColor',[0.9,0.9,0.1]);
title(['BEH Train - R =  ' num2str(1-gof.rmse)]);
xlabel('Train Target');
ylabel('Train Output');   
hold on
plot(population2,'g-','predobs');
xlabel('Train Target');
ylabel('Train Output');   
hold off
subplot(2,2,2)
[population2,gof] = fit(TsTar, TestOutputs,'poly3');
plot(TsTar, TestOutputs,'o',...
'LineWidth',1,...
'MarkerSize',6,...
'MarkerEdgeColor','g',...
'MarkerFaceColor',[0.9,0.9,0.1]);
title(['BEH Test - R =  ' num2str(1-gof.rmse)]);
xlabel('Test Target');
ylabel('Test Output');    
hold on
plot(population2,'g-','predobs');
xlabel('Test Target');
ylabel('Test Output');
hold off
subplot(2,2,3)
[population2,gof] = fit(TrTar,fTrainOutputs,'poly3');
plot(TrTar,fTrainOutputs,'o',...
'LineWidth',1,...
'MarkerSize',6,...
'MarkerEdgeColor','b',...
'MarkerFaceColor',[0.3,0.9,0.9]);
title(['Fuzzy Train - R =  ' num2str(1-gof.rmse)]);
xlabel('Train Target');
ylabel('Train Output');   
hold on
plot(population2,'m-','predobs');
xlabel('Train Target');
ylabel('Train Output');   
hold off
subplot(2,2,4)
[population2,gof] = fit(TsTar, fTestOutputs,'poly3');
plot(TsTar, fTestOutputs,'o',...
'LineWidth',1,...
'MarkerSize',6,...
'MarkerEdgeColor','b',...
'MarkerFaceColor',[0.3,0.9,0.9]);
title(['Fuzzy Test - R =  ' num2str(1-gof.rmse)]);
xlabel('Test Target');
ylabel('Test Output');    
hold on
plot(population2,'m-','predobs');
xlabel('Test Target');
ylabel('Test Output');
hold off
% _____________________________ 
%% Normalized Errors BEH
% Train
trr1=rescale(TrainOutputs);
trr2=rescale(TrTar);
trmse=mse(trr1,trr2);
Traincorrcoef = corrcoef(trr1,trr2);
% Test
tsr1=rescale(TestOutputs);
tsr2=rescale(TsTar);
tsmse=mse(tsr1,tsr2);
Testcorrcoef = corrcoef(tsr1,tsr2);
% 
fprintf('BEH Normalized Train "MSE" =  %0.4f.\n',trmse)
fprintf('BEH Normalized Test "MSE" =  %0.4f.\n',tsmse)
fprintf('BEH Normalized Train "RMSE" =  %0.4f.\n',sqrt(trmse))
fprintf('BEH Normalized Test "RMSE" =  %0.4f.\n',sqrt(tsmse))
fprintf('BEH Normalized Train "Train Error Mean" =  %0.4f.\n',mean(trmse))
fprintf('BEH Normalized Train "Test Error STD" =  %0.4f.\n',mean(tsmse))
fprintf('BEH Normalized Train "Test Error Mean" =  %0.4f.\n',std(trmse))
fprintf('BEH Normalized Test "Test Error STD" =  %0.4f.\n',std(tsmse))
fprintf('BEH Train Correlation Coefficient Is =  %0.4f.\n',Traincorrcoef)
fprintf('BEH Test Correlation Coefficient Is =  %0.4f.\n',Testcorrcoef)
%-----------------------------------------------------------------------
%% Normalized Errors Fuzzy
% Train
trr1=rescale(fTrainOutputs);
trr2=rescale(TrTar);
trmse=mse(trr1,trr2);
Traincorrcoef = corrcoef(trr1,trr2);
% Test
tsr1=rescale(fTestOutputs);
tsr2=rescale(TsTar);
tsmse=mse(tsr1,tsr2);
Testcorrcoef = corrcoef(tsr1,tsr2);
% 
fprintf('Fuzzy Normalized Train "MSE" =  %0.4f.\n',trmse)
fprintf('Fuzzy Normalized Test "MSE" =  %0.4f.\n',tsmse)
fprintf('Fuzzy Normalized Train "RMSE" =  %0.4f.\n',sqrt(trmse))
fprintf('Fuzzy Normalized Test "RMSE" =  %0.4f.\n',sqrt(tsmse))
fprintf('Fuzzy Normalized Train "Train Error Mean" =  %0.4f.\n',mean(trmse))
fprintf('Fuzzy Normalized Train "Test Error STD" =  %0.4f.\n',mean(tsmse))
fprintf('Fuzzy Normalized Train "Test Error Mean" =  %0.4f.\n',std(trmse))
fprintf('Fuzzy Normalized Test "Test Error STD" =  %0.4f.\n',std(tsmse))
fprintf('Fuzzy Train Correlation Coefficient Is =  %0.4f.\n',Traincorrcoef)
fprintf('Fuzzy Test Correlation Coefficient Is =  %0.4f.\n',Testcorrcoef)
