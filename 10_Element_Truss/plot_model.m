function plot_model(A)
    figure()
    global Coordinates
    global ElementCon
    global NumberElement
    width = round(8*(((A-mean(A))/(max(A)-min(A)))))+ 4;
    hold on
    for i =1:size(ElementCon)
        line = Coordinates(ElementCon(i,:),:);
        plot(line(:,1),line(:,2),'r','LineWidth',width(i))
    end
    for i = 1:NumberElement
        plot(Coordinates(:,1),Coordinates(:,2),'b*')
    end
end