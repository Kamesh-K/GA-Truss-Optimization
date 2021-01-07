clc;
clear all;
global E
global FS
global Rho
global YS
global Allowable_displacement
global Coordinates
global ElementCon
global NumberElement
global NumberNode
global Fg
global U_glob

E = 6900;
FS = 1.5;
Rho = 2.77e-5;
YS = 172;
Allowable_displacement = 50.8;
Coordinates = [0 0; 9144 0;18288 0; 18288 9144; 9144 9144;0 9144];
ElementCon = [1 2; 2 3; 3 4; 4 5; 5 6;2 5; 2 6; 1 5; 3 5; 2 4];
NumberNode = size(Coordinates,1);
NumberElement = size(ElementCon,1);
Kg = zeros(2*NumberNode);
A = 3.14*ones(1,NumberElement);
 
ForceBC = input('Enter the total number of nodes on which force acts\n');
    Fg = zeros(2*NumberNode,1);
    for i = 1:ForceBC
        fprintf('Enter the Node number on which force %d acts\n',i);
        NodeFBC = input('');
        Fnode = input('Enter the x, y component of force in pounds on the node in [Fx;Fy] format\n');
        Fg((NodeFBC*2)-1:(NodeFBC*2),1) = Fg((NodeFBC*2)-1:(NodeFBC*2),1) + Fnode;
    end
U_glob = ones(2*NumberNode,1);
DisplacementBC = input('Enter the total number of nodes on which displacement constraints are applied\n');
for i = 1:DisplacementBC
    NodeDBC = input('Enter the Node ID  = ');
    U_glob(2*NodeDBC-1:2*NodeDBC) = 0;
end

b = find(U_glob == 0);
Fg(b,:) = [];

Fitness = @ObjectiveFunction;
Constraint = @ConstraintFunction;
nvars = 10;
LB= 0.1*A;
UB = 2*A;
% opts=gaoptimset('PopulationSize',20,'Generations',200,'StallGenLimit',200,'SelectionFcn', @selectionroulette,'CrossoverFcn',@crossovertwopoint,'Display', 'off','PlotFcns', {@gaplotbestf @gaplotbestindiv});
opts = optimoptions(@ga,'PlotFcn',{@gaplotbestf,@gaplotbestindiv});
disp('Working on optimizing');
[x,fval] = ga(Fitness,nvars,[],[],[],[],LB,UB,Constraint,opts)