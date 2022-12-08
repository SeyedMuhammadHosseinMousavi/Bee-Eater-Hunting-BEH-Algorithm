%% BeeEater Scattering

clc;
clear;
close all;
warning('off');
%% Variables
Gen= 50;                              % Number of Generations
for ooo=1:Gen
%-------------------------------------
nVar = 2;                              % Number of Decision Variables
VarSize = [1 nVar];                    % Decision Variables Matrix Size
VarMin = -3;                           % Decision Variables Lower Bound
VarMax = 3;                            % Decision Variables Upper Bound
MaxIt = 100;                           % Maximum Number of Iterations
nPop = 50;                             % Number of beeeaters 
DamageRate = 0.2;                      % Damage Rate
nbeeeater = round(DamageRate*nPop);    % Number of Remained beeeaters
nNew = nPop-nbeeeater;                 % Number of New beeeaters
mu = linspace(1, 0, nPop);             % Mutation Rates
pMutation = 0.1;                       % Mutation Probability
MUtwo = 1-mu;                          % Fight Mutation
PeakPower = 0.8;                       % BeeEater Peack power Rate
AdjustPower = 0.03*(VarMax-VarMin);    % BeeEater Adjustment Power Rate
PYR= -0.3;                              % Pitch Yaw Roll Rate
%----------------------------------------
%% Cost Functions
a=["@(x) Ackley(x)"];
siza=size(a);
siza=siza(1,2);
for fun = 1 : siza
c=str2num(a(1,fun));
CostFunction = c;        % Cost Function
%% Basics
% Empty beeeater
beeeater.Position = []; 
beeeater.Cost = [];
% BeeEaters Array
pop = repmat(beeeater, nPop, 1);
% First beeeaters
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
AllSol(it)=BestSol;
disp(['In Iteration No ' num2str(it) ': BeeEater Optimizer Best Cost = ' num2str(BestCost(it))]);
all=AllSol(it).Position;
allone=all(1,1);
alltwo=all(1,2);
meshone(it)=all(1,1);
meshtwo(it)=all(1,2);
aaa(it)=allone;
bbb(it)=alltwo;
end;
aaaa(ooo,:)=aaa;
bbbb(ooo,:)=bbb;
end;
plot(aaaa,bbbb,'ko','MarkerEdgeColor','y','MarkerFaceColor','b');
grid on;
end;


