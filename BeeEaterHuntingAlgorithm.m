%% Bee-Eater Hunting Algorithm (BEH)
% https://ieeexplore.ieee.org/abstract/document/9953726
% DOI: 10.1109/SCIoT56583.2022.9953726
% Please cite below:
% Mousavi, Seyed Muhammad Hossein. "Introducing Bee-Eater Hunting Strategy Algorithm 
% for IoT-Based Green House Monitoring and Analysis." 2022 Sixth International Conference
% on Smart Cities, Internet of Things and Applications (SCIoT). IEEE, 2022.
% -----------------------------------------------------------------------------------
clc;
clear;
close all;
warning ('off');
%-----------------------------------------
nVar = 10;                             % Number of Decision Variables
VarSize = [1 nVar];                    % Decision Variables Matrix Size
VarMin = -5;                           % Decision Variables Lower Bound
VarMax = 5;                            % Decision Variables Upper Bound
MaxIt = 200;                           % Maximum Number of Iterations
nPop = 10;                             % Number of bee-eaters 
DamageRate = 0.2;                      % Damage Rate
nbeeeater = round(DamageRate*nPop);    % Number of Remained beeeaters
nNew = nPop-nbeeeater;                 % Number of New beeeaters
mu = linspace(1, 0, nPop);             % Mutation Rates
pMutation = 0.1;                       % Mutation Probability
MUtwo = 1-mu;                          % Fight Mutation
PeakPower = 0.8;                       % BeeEater Peack power Rate
AdjustPower = 0.03*(VarMax-VarMin);    % BeeEater Adjustment Power Rate
PYR= -0.2;                             % Pitch Yaw Roll Rate
%----------------------------------------
%% Cost Functions
a=["@(x) Ackley(x)","@(x) Beale(x)","@(x) Booth(x)","@(x) Rastrigin(x)"];
siza=size(a);
siza=siza(1,2);
for fun = 1 : siza
c=str2num(a(1,fun));
CostFunction = c;        % Cost Function
%% Basics
% Empty bee-eater
beeeater.Position = []; 
beeeater.Cost = [];
% BeeEaters Array
pop = repmat(beeeater, nPop, 1);
% First bee-eaters
for i = 1:nPop
pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
pop(i).Cost = CostFunction(pop(i).Position);end;
% Sort 
[~, SortOrder] = sort([pop.Cost]);pop = pop(SortOrder);
% Best Solution
BestSol = pop(1);
% Best Costs Array
BestCost = zeros(MaxIt, 1);
%--------------------------------
%% BEH Body
for it = 1:MaxIt
newpop = pop;
for i = 1:nPop
for k = 1:nVar
if rand <= MUtwo(i)
TMP = mu;TMP(i) = 0;TMP = TMP/sum(TMP);
j = RouletteWheelS(TMP);
newpop(i).Position(k) = pop(i).Position(k)*PYR+PeakPower*(pop(j).Position(k)-pop(i).Position(k));
end;
% Mutation
if rand <= pMutation
newpop(i).Position(k) = newpop(i).Position(k)+PYR+AdjustPower*randn;
end;end;
% Apply Lower and Upper Bound Limits
newpop(i).Position = max(newpop(i).Position, VarMin);
newpop(i).Position = min(newpop(i).Position, VarMax);
newpop(i).Cost = CostFunction(newpop(i).Position);end;% Asses power
[~, SortOrder] = sort([newpop.Cost]);newpop = newpop(SortOrder);% Sort
pop = [pop(1:nbeeeater);newpop(1:nNew)];% Select 
[~, SortOrder] = sort([pop.Cost]);pop = pop(SortOrder);% Sort 
BestSol = pop(1);% Update 
BestCost(it) = BestSol.Cost;% Store 
% Iteration 
disp(['In Iteration No ' num2str(it) ': BeeEater Optimizer Best Cost = ' num2str(BestCost(it))]);
end;
%------------------------------
%% Plot ITR
plot(normalize(BestCost,'range'), 'LineWidth', 1);
legend('Ackley','Beale','Booth','Rastrigin');
hold on;
xlabel('ITR');
ylabel('BeeEater Optimizer Cost Value');
grid on;
end;
hold off;
