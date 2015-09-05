% figure
x=env.RegionObserver.DiscoveryMap;

subplot(2,2,1)
imagesc(x)
subplot(2,2,2)
dx=imfilter(x,[-1,1],'replicate');
imagesc(abs(dx))
subplot(2,2,3)
dy=imfilter(x,[-1;1],'replicate');
imagesc(abs(dy))


marble=[60;30];
mA=marble;
amp=100;

subplot(2,2,1)
hold on
h1=plot(mA(1,:),mA(2,:),'wo');
hold off
subplot(2,2,2)
hold on
h2=plot(mA(1,:),mA(2,:),'wo');
hold off
subplot(2,2,3)
hold on
h3=plot(mA(1,:),mA(2,:),'wo');
hold off

for i=1:1000
    pause(0.1)
    mappos = round(marble);
    marble = marble - amp*[dx(mappos(2),mappos(1));dy(mappos(2),mappos(1))];
    mA(:,end+1)=marble;
    set(h1,'XData',mA(1,:),'YData',mA(2,:));
    set(h2,'XData',mA(1,:),'YData',mA(2,:));
    set(h3,'XData',mA(1,:),'YData',mA(2,:));
end
