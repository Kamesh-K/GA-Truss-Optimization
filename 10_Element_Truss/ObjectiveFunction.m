function [val]= ObjectiveFunction(A)
    global Rho
    global Coordinates
    global ElementCon
    global NumberElement
    global NumberNode
    total_volume = 0;
    for i = 1:NumberElement
        element = Coordinates(ElementCon(i,:),:); 
        length = norm(element(1,:)-element(2,:));
        volume = length*A(i);
        total_volume = total_volume + volume;
    end
    weight = total_volume * Rho;
    val = weight;
end
