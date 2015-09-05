%   Created by Axel Hackbarth, UC Berkeley VDL / TU-Harburg MuM

function Z = gaussian2d( X,Y,x0,y0, sigma_x, sigma_y, A, theta )
%GAUSSIAN2D Summary of this function goes here
%   Detailed explanation goes here
    if ~exist('theta','var')
        theta = 0;
    end
    a = cos(theta)^2/2/sigma_x^2 + sin(theta)^2/2/sigma_y^2;
    b = -sin(2*theta)/4/sigma_x^2 + sin(2*theta)/4/sigma_y^2 ;
    c = sin(theta)^2/2/sigma_x^2 + cos(theta)^2/2/sigma_y^2;

    Z = A*exp( - (a*(X-x0).^2 + 2*b*(X-x0).*(Y-y0) + c*(Y-y0).^2));


end

