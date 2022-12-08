function bestfis=beh(fis,data)
% Variables
p0=GettingFuzzyParameters(fis);
Problem.CostFunction=@(x) FuzzyCost(x,fis,data);
Problem.nVar=numel(p0);
alpha=1;
VarMin = -10;         % Decision Variables Lower Bound
VarMax = 10;          % Decision Variables Upper Bound
Problem.VarMin=-(10^alpha);
Problem.VarMax=10^alpha;
%------------------------------------------------------
% SHS Parameters
Params.MaxIt = 60;     % Maximum Number of Iterations
% Population Size
Params.nPop = 4;
Params.DamageRate = 0.2;                      % Damage Rate
Params.nbeeeater = round(Params.DamageRate*Params.nPop);    % Number of Remained beeeaters
Params.nNew = Params.nPop-Params.nbeeeater;                 % Number of New beeeaters
Params.mu = linspace(1, 0, Params.nPop);             % Mutation Rates
Params.pMutation = 0.1;                       % Mutation Probability
Params.MUtwo = 1-Params.mu;                          % Fight Mutation
Params.PeakPower = 0.8;                       % BeeEater Peack power Rate
Params.AdjustPower = 0.03*(VarMax-VarMin);    % BeeEater Adjustment Power Rate
Params.PYR= -0.2;                              % Pitch Yaw Roll Rate
% Starting BEH Algorithm
results=Runbeh(Problem,Params);
% Getting the Results
p=results.BestSol.Position.*p0;
bestfis=FuzzyParameters(fis,p);
end
%------------------------------------------------------
function results=Runbeh(Problem,Params)
disp('Starting BEH Algorithm Training');
% Cost Function
CostFunction=Problem.CostFunction;  
% Number of Decision Variables
nVar=Problem.nVar;   
% Size of Decision Variables Matrixv
VarSize=[1 nVar]; 
% Lower Bound of Variables
VarMin=Problem.VarMin;    
% Upper Bound of Variables
VarMax=Problem.VarMax;      
% Some Change
if isscalar(VarMin) && isscalar(VarMax)
dmax = (VarMax-VarMin)*sqrt(nVar);
else
dmax = norm(VarMax-VarMin);
end;
%--------------------------------------------
% SHS Algorithm Parameters
MaxIt=Params.MaxIt;
nPop=Params.nPop; 
DamageRate=Params.DamageRate;                   
nbeeeater=Params.nbeeeater;    
nNew=Params.nNew;                
mu=Params.mu;       
pMutation=Params.pMutation;                       
MUtwo=Params.MUtwo;                          
PeakPower=Params.PeakPower;                   
AdjustPower=Params.AdjustPower;    
PYR=Params.PYR;                           


%------------------------------------------------------
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
% Iteration 
disp(['In Iteration No ' num2str(it) ': BeeEater Optimizer Best Cost = ' num2str(BestCost(it))]);
end;

%------------------------------------------------
disp('BEH Algorithm Came To End');
% Store Res
results.BestSol=BestSol;
results.BestCost=BestCost;
% Plot BEH Training Stages
% set(gcf, 'Position',  [600, 300, 500, 400])
fonts=12;
plot(BestCost,'-g',...
'LineWidth',2);
title('BEH Algorithm Training','FontSize', fonts);
set(gca,'Color','k');
ax = gca; 
ax.FontSize = fonts; 
xlabel('BEH Iteration Number','FontSize',fonts,...
'FontWeight','bold','Color','k');
ylabel('BEH Best Cost Result','FontSize',fonts,...
'FontWeight','bold','Color','k');
end


