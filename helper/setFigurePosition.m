%   Created by Axel Hackbarth, UC Berkeley VDL / TU-Harburg MuM

function setFigurePosition(varargin)
%     if ishandle(varargin{1})
%         figurehandle = varargin{1};
%         pos = varargin(2:end);
%     else
        figurehandle = gcf;
        pos = varargin(1:end);
%     end
    
    if length(pos) ==1 && isnumeric(pos{1}) 
        % direct position input
        position = pos{1};
    elseif length(pos) == 3
        % subplot functionality
        [m,n,p] = pos{:};
        position = [ 1/n * mod(p-1,n) , ...
                     1/m * floor((p-1)/n) , ...
                     1/n , ...
                     1/m ];
         % compensate reverse order (from bottom to top) and make it behave
         % as subplot function
         position(2) = 1 - position(2) - position(4);
    elseif ischar(pos{1})
        % textual input
        switch pos{1}
            case 'left'
                position = [0,0,0.5,1];
            case 'right'
                position = [0.5,0,0.5,1];
            case 'top'
                position = [0,0.5,1,0.5];
            case 'bottom'
                position = [0,0,1,0.5];
            case 'bottomleft'
                position = [0,0,0.5,0.5];
            case 'bottomright'
                position = [0.5,0,0.5,0.5];
            case 'topright'
                position = [0.5,0.5,0.5,0.5];
            case 'topleft'
                position = [0,0.5,0.5,0.5];
        end
    end
    if exist('position','var')
        set(figurehandle,'Units','normalized','Position',position)
    end
end