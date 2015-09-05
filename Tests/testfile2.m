gauss=@(x,b,c)exp(-(x-b).^2./2./c^2);

xx=linspace(0,10,10000);

x=gauss(xx,4,5)-1;
y=gauss(xx,2,1)+5;
w=ones(size(xx))';

N = length(x);

%m = [mean(x); mean(y)]; %wrong! forgot weights!
mx = x*w;
my = y*w;
m = [mx;my];

var = zeros(2,2);

for k = 1:N
    var = var + w(k)*([x(k);y(k)] - m)*([x(k) y(k)] - m');
end

log2pie= log(2*pi*exp(1));
tic
H = log2pie + 0.5*log(det(var));
toc
% tic
% H = log(sqrt((2*pi*exp(1))^2*det(var)));
% toc

% H
% var
% m
