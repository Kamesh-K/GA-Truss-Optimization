clear all
Fitness = @ObjectiveFunction;
Constraint = @ConstraintFunction;
nvars = 4;
LB= 0.5*10^-4*ones(1,nvars)
UB = 1.5*10^-4*ones(1,nvars)
[x,fval] = ga(Fitness,nvars,[],[],[],[],LB,UB,Constraint)
opts = optimoptions(@ga,'PlotFcn',{@gaplotbestf,@gaplotstopping});
[x,fval] = ga(Fitness,nvars,[],[],[],[],LB,UB,Constraint,opts)