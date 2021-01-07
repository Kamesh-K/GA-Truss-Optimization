function [val]= ObjectiveFunction(A)
    rho = 10000;
    Node = [0 0 0;0 -1 1;0 1 1;1 0 1;0 0 1];
    ElementCon = [1 4 ; 2 4 ; 3 4 ; 5 4];
    total_volume = 0;
    for i = 1:size(ElementCon)
        element = Node(ElementCon(i,:),:); 
        length = norm(element(1,:)-element(2,:));
        volume = length*A(i);
        total_volume = total_volume + volume;
    end
    weight = total_volume * rho;
    val = weight;
end
