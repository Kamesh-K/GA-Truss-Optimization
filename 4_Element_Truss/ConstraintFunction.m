function [stress_diff, strain_diff] = ConstraintFunction(A)
    E = 70*10^9;
    rho = 10;
    t = 100;
    Node = [0 0 0;0 -1 1;0 1 1;1 0 1;0 0 1];
    ElementCon = [1 4 ; 2 4 ; 3 4 ; 5 4];
    numnode = 5;
    numelem = 4;
    kg = zeros(3*numnode);

    for i = 1:numelem
     n1 = ElementCon(i,1);
     n2 = ElementCon(i,2);
     x1 = Node(n1,1);
     y1 = Node(n1,2);
     z1 = Node(n1,3);
     x2 = Node(n2,1);
     y2 = Node(n2,2);
     z2 = Node(n2,3);
     Length = sqrt((x2-x1)^2+(y2-y1)^2+(z2-z1)^2);
     l = (x2-x1)/Length;
     m = (y2-y1)/Length;
     n = (z2-z1)/Length;
     K_element = (E*A(i)/Length)*[l^2 l*m l*n -l^2 -l*m -l*n;
                               l*m m^2 m*n -l*m -m^2 -m*n;
                               l*n m*n n^2 -l*n -m*n -n^2;
                               -l^2 -l*m -l*n l^2 l*m l*n;
                               -l*m -m^2 -m*n l*m m^2 m*n;
                               -l*n -m*n -n^2 l*n m*n n^2];
    x1 = 3*n1-2; x2 = 3*n1-1; x3 = 3*n1';
    x4 = 3*n2-2; x5 = 3*n2-1; x6 = 3*n2;
    kg(x1:x3,x1:x3) = kg(x1:x3,x1:x3) + K_element(1:3,1:3);
    kg(x1:x3,x4:x6) = kg(x1:x3,x4:x6) + K_element(1:3,4:6);
    kg(x4:x6,x1:x3) = kg(x4:x6,x1:x3) + K_element(4:6,1:3);
    kg(x4:x6,x4:x6) = kg(x4:x6,x4:x6) + K_element(4:6,4:6);

    end
    Global_Stiffness_Matrix = kg(1:15,1:15);
    k = kg(10:12,10:12);
    f = [0;0;-10000];
    m = f;
    u = mldivide(k,m);
    Ug = [0;0;0;0;0;0;0;0;0;u(1);u(2);u(3);0;0;0];
    Fg = (kg*Ug);
    F1 = Fg(1,1)*0.707+Fg(3,1)*0.707;
    F2 = Fg(4,1)*0.707+Fg(5,1)*0.707;
    F3 = Fg(7,1)*0.707+Fg(8,1)*-0.707;
    F4 = Fg(13,1)*1;
    sigma_max = 6000*10^4;
    stress_diff = max([(-F1)/A(1),(-F2)/A(2),(-F3)/A(3),(-F4)/A(4)])-sigma_max;
    strain_diff = abs(u(3))-0.0075;
end