function plot_model(A)
    figure()
    Node = [0 0 0;0 -1 1;0 1 1;1 0 1;0 0 1];
    ElementCon = [1 4 ; 2 4 ; 3 4 ; 5 4];
    width = round(8*((A/max(A))))+8;
    hold on
    for i = 1:size(Node)
        plot3(Node(:,1),Node(:,2),Node(:,3),'b*')
    end
    for i =1:size(ElementCon)
        line = Node(ElementCon(i,:),:) 
        plot3(line(:,1),line(:,2),line(:,3),'r','LineWidth',width(i))
    end
end