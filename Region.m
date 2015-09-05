%   Created by Axel Hackbarth, UC Berkeley VDL / TU-Harburg MuM

classdef Region < SimulationObject
    %REGION This class represents a region in its most general form
    %   The region includes all maps and information about the actual state
    
    properties
        Bounds = [0 130; 0 100] % in meters
        GridStep = [2;2]         % in meters / gridstep
        RegionEstimator
    end
    properties (Dependent = true)
        Center
        Size
        GridSize
        ScaleFactor
        x
        y
        X
        Y
    end
    properties (Access = public)
        VectorMapFigure
        Visualize = false
    end
    
    methods % set and get methods
        function size = get.Size(this)
            size = this.Bounds(:,2) - this.Bounds(:,1);
        end
        function set.Size(this,size)
            this.Bounds(:,2) = this.Bounds(:,1) + size;
        end
        function center = get.Center(this)
            center = (this.Bounds(:,1) + this.Bounds(:,2)) /2;
        end
        function set.Center(this, center)
            this.Bounds = this.Bounds + (center - this.Center)*[1 1];
        end
        function gridsize = get.GridSize(this)
            gridsize = floor(this.Size ./ this.GridStep + 1);
        end
        
        function x = get.x(this)
%             x = this.Bounds(1,1):this.GridStep(1):this.Bounds(1,2);
            x = linspace(this.Bounds(1,1), this.Bounds(1,2), ...
                         this.GridSize(1));
        end
        function y = get.y(this)
%             y = this.Bounds(2,1):this.GridStep(2):this.Bounds(2,2);
            y = linspace(this.Bounds(2,1), this.Bounds(2,2), ...
                         this.GridSize(2));
        end
        
        function x = get.X(this)
            [x,y] = meshgrid(this.x,this.y);
        end
        function y = get.Y(this)
            [x,y] = meshgrid(this.x,this.y);
        end
        
        function vis = get.Visualize(this)
            if isempty(this.Visualize)
                vis = this.Environment.Visualize;
            else
                vis = this.Visualize;
            end
        end
        
        function scale = get.ScaleFactor(this)
            scale = norm(this.Size)/280;
        end
    end
    
    methods (Access = public)
        function this = Region(varargin)
            this = this@SimulationObject(varargin{:});
            if ~isempty(this.Environment)
                addlistener(this.Environment,'updatePlots',...
                    @(src,evdata)this.updatePlot);
            end
        end
        
        function newTimeStep(this)
        % every simulationobject has to have this function
        end
        
        function gpos = convert2GridPosition(this,x,y)
            if nargin == 3
                x = [x;y];
            end
            gridstep = this.GridStep;
            bounds = this.Bounds;
            g1 = bounds(1,1):gridstep(1):bounds(1,2);
            g2 = bounds(2,1):gridstep(2):bounds(2,2);
            gpos = [interp1(g1,1:length(g1),x(1,:),'nearest','extrap');
                    interp1(g2,1:length(g2),x(2,:),'nearest','extrap')];
        end
        
        function updatePlot(this)
        % displays a vector based map of the area
            % set figures and their positions
            if this.Visualize
            if isempty(this.VectorMapFigure)
                this.VectorMapFigure = figure('Name',['Region ',num2str(this.ID),' Mission Map']);
                setFigurePosition('topleft')
                plot(this.getPlottableBox,'g')
                xlabel('x in [m]');
                ylabel('y in [m]');
                axis equal
                axis tight
                hold on
                for i=1:length(this.Environment.Agents)
                    this.Environment.Agents{i}.registerPlot;
                end
                for i=1:length(this.Environment.Targets)
                    this.Environment.Targets{i}.registerPlot;
                end
                for i=1:length(this.Environment.TargetEstimators)
                    this.Environment.TargetEstimators{i}.registerPlot;
                end
                hold off
            end
            end
        end
        
        function randPos = randomPosition(this)
        % returns a random position inside region boundaries
            randPos = rand(2,1) .* this.Size + this.Bounds(:,1);
        end
        
        function plotBox = getPlottableBox(this)
        % returns imaginary coordinates for plotting the region boundary
            plotBox = makePlottableBox(this.Center',this.Size');
        end
        
        function [outside,distanceXY] = outOfRegion(this,position)
            outside = any(abs(position - this.Center) > this.Size/2);
            if nargout >= 2
            distanceXY = ((position - this.Center) >  this.Size/2).*...
                         ((position - this.Center) -  this.Size/2) + ...
                         ((position - this.Center) <  - this.Size/2).*...
                         ((position - this.Center) +  this.Size/2);
            end
        end
        
    end
    
end % classdef

% function newPos = checkSize(pos,objSize)
%     newPos = pos;
%     if pos(1) > objSize(1), newPos(1) = objSize(1); end
%     if pos(2) > objSize(2), newPos(2) = objSize(2); end
%     if pos(1) < 1, newPos(1) = 1; end
%     if pos(2) < 1, newPos(2) = 1; end
% end
