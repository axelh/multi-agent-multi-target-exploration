% unregistered = imread('westconcordaerial.png');
% figure, imshow(unregistered)
% 
% % Aerial Photo
% % 
% % Read in the orthophoto.
% % 
% figure, imshow('westconcordorthophoto.png')
% % 
% % Orthophoto
% % 
% % Load control points that were previously picked.
% % 
% load westconcordpoints      
% % 
% % Create a transformation structure for a projective transformation.
% % 
% t_concord = cp2tform(input_points,base_points,'projective');
% % 
% % Get the width and height of the orthophoto and perform the transformation.
% % 
% info = imfinfo('westconcordorthophoto.png');
% 
% registered = imtransform(unregistered,t_concord,...
%     'XData',[1 info.Width], 'YData',[1 info.Height]);
% figure, imshow(registered)

gauss=@(x,b,c)exp(-(x-b).^2./2./c^2);

x=linspace(0,10,1000);
dx=x(2)-x(1);

y=gauss(x,2,0.2) + 0.2*gauss(x,6,3);
y=y./(sum((y(1:end-1)+y(2:end))./2.*diff(x))); 
y=y/max(y);
for i=2:length(x)
    Y(i)=(sum((y(1:i-1)+y(2:i))./2.*diff(x(1:i))));
end
figure(1)
plot(x,y)
figure(2)
plot(x,Y)

%% blur

% y=conv(y,y);
y= filter([1,1],[1],y);
figure(1)
hold on;plot(x,y,'r');hold off

%% entropy calculation
dx=1;
H1=-y*dx.*log2(y*dx);
y2=1-y;
H2=-y2*dx.*log2(y2*dx);

figure(3)
plot(x,H1,x,H2,x,H1+H2)


%% assignin test
a.test = 1;
assignin('caller','a.test',3)


%% struct test
names = {'fred' 'sam' 'al'};
for ind = 1:length(names)
  s.(names{ind}) = magic(length(names{ind}));
end


%% RegionObserver test
clear classes;
x=  RegionObserver;
x.DiscoveryMap = zeros(50);
x.showMap;
for i=1:100
xx = zeros(50);
xx(ceil(rand*50),ceil(rand*50))=0.8;
x.updateMap(xx);
x.showMap;
pause(0.1);
end

%% animation with drawnow and without refreshdata

c = -pi:.04:pi;
cx = cos(c);
cy = -sin(c);
figure('color','white');
axis off, axis equal
line(cx, cy, 'color', [.4 .4 .8],'LineWidth',3);
title('See Pythagoras run!','Color',[.6 0 0])
hold on
x = [-1 0 1 -1];
y =   [0 0 0 0];
ht = area(x,y,'facecolor',[.6 0 0]);
for j = 1:length(c)
    x(2) = cx(j);
    y(2) = cy(j);
    set(ht,'XData',x)
    set(ht,'YData',y)
    drawnow
end

%% animation with drawnow and with refreshdata
c = -pi:.04:pi;
cx = cos(c);
cy = -sin(c);
figure('color','white');
axis off, axis equal
line(cx, cy, 'color', [.4 .4 .8],'LineWidth',3);
title('See Pythagoras Run!','Color',[.6 0 0])
hold on
x = [-1 0 1 -1];
y =   [0 0 0 0];
ht = area(x,y,'facecolor',[.6 0 0])
set(ht,'XDataSource','x')
set(ht,'YDataSource','y')
for j = 1:length(c)
    x(2) = cx(j);
    y(2) = cy(j);
    refreshdata
    drawnow
end



%% pixelize image

img = env.RegionObserver.DiscoveryMap;
imgsize = size(img);
figure(3)
imagesc(1:imgsize(1),1:imgsize(2),img,[0 1]);
axis equal

for i=1:10
    pause(1)
img = imresize(img,0.5);
% img = imresize(img,2);
imagesc(1:imgsize(1),1:imgsize(2),img,[0 1]);
axis equal
end


%% RBF test

rbf=@(x,y,meanX,meanY,sigmaX,sigmaY)...
    a*exp(- ( (x - meanX)^2 / (2*c^2)));
rbf1=@(x,y)rbf(x,y,meanX,meanY,sigmaX,sigmaY);
A = 1;
x0 = 0; y0 = 0;
 
sigma_x = 1;
sigma_y = 2;
 
for theta = 0:pi/100:pi
a = cos(theta)^2/2/sigma_x^2 + sin(theta)^2/2/sigma_y^2;
b = -sin(2*theta)/4/sigma_x^2 + sin(2*theta)/4/sigma_y^2 ;
c = sin(theta)^2/2/sigma_x^2 + cos(theta)^2/2/sigma_y^2;
 
[X, Y] = meshgrid(-5:.1:5, -5:.1:5);
Z = A*exp( - (a*(X-x0).^2 + 2*b*(X-x0).*(Y-y0) + c*(Y-y0).^2)) ;
surf(X,Y,Z);shading interp;view(-36,36);axis equal;drawnow
end

