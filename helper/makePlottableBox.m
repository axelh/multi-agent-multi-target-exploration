%   Created by Axel Hackbarth, UC Berkeley VDL / TU-Harburg MuM

function plotBox = makePlottableBox(center,size)
%makePlottableBox returns imaginary coordinates for plotting the box boundary
    corner1 = center - size/2;
    corner1 = corner1 * [1;1i];
    corner3 = center + size/2;
    corner3 = corner3 * [1;1i];
    corner2 = real(corner1) + 1i*imag(corner3);
    corner4 = real(corner3) + 1i*imag(corner1);
    plotBox = [corner1;corner2;corner3;corner4;corner1];
end

