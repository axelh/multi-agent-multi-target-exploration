%   Created by Axel Hackbarth, UC Berkeley VDL / TU-Harburg MuM

classdef GlobalCostFunction < SimulationObject
    %TARGETCONTROLLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Region
        CostMap
        CostHistory = []
        TargetAttraction = 2          % low: ignore / high: follow targets
        RegionExploration = 1      % low: ignore / high: consider map exploration
        AgentRepulsion = 1          % low: ignore / high: avoid agent collisions
        WaypointRepulsion = 3
        StateDeviation = 3   % low: global / high: local waypoint selection
        PredictTime = 5             % time horizon that is predicted for control
    end
    properties % for plotting
        CostFigure
        CostGraphicsHandle
        CostHistoryFigure
        CostHistoryGraphicsHandle
        Visualize
    end
    properties (Dependent = true)
        X
        Y
    end
    
    methods % set and get
        function reg = get.Region(this)
            if isempty(this.Region)
                reg = this.Environment.Region;
            else
                reg = this.Region;
            end
        end
        
        function x = get.X(this)
            x = this.Region.X;
        end
        function y = get.Y(this)
            y = this.Region.Y;
        end
        function vis = get.Visualize(this)
            if isempty(this.Visualize)
                vis = this.Environment.Visualize;
            else
                vis = this.Visualize;
            end
        end
    end % set and get
    
    methods (Access = public)
        function this = GlobalCostFunction(varargin)
            this = this@SimulationObject(varargin{:});
            if ~isempty(this.Environment)
                addlistener(this.Environment,'updatePlots',...
                    @(src,evdata)this.updatePlot);
            end
        end
    end
    
    methods (Access = private)
        function computeCostMap(this,X,Y)
            if ~exist('X','var') || ~exist('Y','var')
                X = this.X;
                Y = this.Y;
            end
            
            DiscoveryMap = this.Region.RegionEstimator.DiscoveryMap;
            
%             Cost = this.BaseMap ...
            Cost =      + this.RegionExploration   *DiscoveryMap' ...
                 - this.TargetAttraction    *this.getTargetAttractionMap(X,Y);
%                  + this.AgentRepulsion      *this.getAgentRepulsionMap(X,Y) ...
%                  + this.WaypointRepulsion   *this.getWaypointRepulsionMap(X,Y) ...
%                  + this.StateDeviation      *this.getStateDeviationMap(X,Y);
            
            % find minimum of cost map
            [minCost,idx1] = min(Cost);
            [minCost,idx2] = min(minCost);
            idx1=idx1(idx2);
            
            % calc mean of cost
            this.CostHistory(end+1) = mean(mean(Cost));
%             this.Waypoint = [X(idx1,idx2);Y(idx1,idx2)];
            this.CostMap = Cost;
        end
               
        % calculate target attraction by gaussian maps
        function tMap = getTargetAttractionMap(this,X,Y)
            if ~exist('X','var') || ~exist('Y','var')
                X = this.X;
                Y = this.Y;
            end                
            tMap = 0;
            for i=1:length(this.Environment.TargetEstimators)
                targetest = this.Environment.TargetEstimators{i};
                pos = targetest.predict(this.PredictTime);
                sigma = 10*targetest.Sigma;
                amp = sqrt(targetest.Gain);
                tMap = tMap + gaussian2d(X,Y,pos(1),pos(2),sigma(1),sigma(2),amp);
            end
        end
        
        % calculate agent repulsion by 1/dx maps
        function aMap = getAgentRepulsionMap(this,X,Y)
            if ~exist('X','var') || ~exist('Y','var')
                X = this.X;
                Y = this.Y;
            end                
            aMap = 0;
            for i=1:length(this.Environment.Agents)
                agent = this.Environment.Agents{i};
                    for j=1:length(agent.Sensors)
                        pos = agent.predict(this.PredictTime);
                        sigma = 0.5*(agent.Sensors{j}.FieldOfView(:,2) - agent.Sensors{j}.FieldOfView(:,1));
                        amp = 10;
                        % 1/x map
                        aMap = aMap + amp*min(10,(((pos(1) - X)/sigma(1)).^2 + ((pos(2)- Y)/sigma(2)).^2).^(-1));
                        % gaussian map
%                         aMap = aMap + gaussian2d(X,Y,pos(1),pos(2),sigma(1),sigma(2),amp);
                    end
            end
        end
        
        % calculate planned agent's waypoint repulsion
        function wMap = getWaypointRepulsionMap(this,X,Y)
        % this part here introduces an order of execution - the first
        % who decides to move to a specific waypoint increases the cost
        % for all other agents who decide later
            if ~exist('X','var') || ~exist('Y','var')
                X = this.X;
                Y = this.Y;
            end                
            wMap = 0;
            for i=1:length(this.Environment.Agents)
                agent = this.Environment.Agents{i};
                if agent.ID ~= this.Agent.ID
                    for j=1:length(agent.Sensors)
                        pos = agent.AgentController.Waypoint;
                        sigma = 0.5*(agent.Sensors{j}.FieldOfView(:,2) - agent.Sensors{j}.FieldOfView(:,1));
                        amp = 3;
                        % gaussian map
                        wMap = wMap + gaussian2d(X,Y,pos(1),pos(2),sigma(1),sigma(2),amp);
                    end
                end
            end
        end
        
        % get agent state deviation cost
        function dMap = getStateDeviationMap(this,X,Y)
            % the further away the
            % waypoint from the predicted next timestep position, the
            % higher the cost to get there
            % this actually is a decision between local and global waypoint
            % finding
            if ~exist('X','var') || ~exist('Y','var')
                X = this.X;
                Y = this.Y;
            end
            state = this.Agent.predict(this.PredictTime);
            maxvel = this.Agent.MaxVelocity;
            dMap = 1e-2*((X - state(1)).^2 + (Y - state(2)).^2)...
                    / (maxvel(1)^2 +maxvel(2)^2) ;
        end
    end
    
    methods (Access = public) % plot functions
        function updatePlot(this)
            % P L O T $$$$$$
                this.computeCostMap;
                this.showCostMap;
                this.showCostHistory;
        end
        
        function showCostMap(this)
            if this.Visualize
            if isempty(this.CostFigure)
                this.CostFigure = figure;
                set(this.CostFigure,'Name',['Global Cost Function Map']);
                setFigurePosition(2,2,1)
%                 set(gcf,'WindowStyle','docked')
                this.CostGraphicsHandle = mesh(this.Region.X,...   % for 3D-plot
                                               this.Region.Y,...
                                               this.CostMap);
                xlabel('x in [m]');
                ylabel('y in [m]');
                zlabel('cost');
%                 view(0,90)
%                 axis square
                axis tight
                zlim('auto')
                hold on
%                 this.Agent.registerPlot;
                hold off
            else
                set(this.CostGraphicsHandle,'ZData',this.CostMap);  % for 3D-plot
            end
%                 set(this.CostFigure,'Name',...
%                     ['Global Cost Function Map = ',...
%                     num2str(mean(mean(this.CostMap)))]);
            end
        end
        function showCostHistory(this)
            if this.Visualize
            if isempty(this.CostHistoryFigure)
                this.CostHistoryFigure = figure;
                set(this.CostHistoryFigure,'Name',['Global Cost History']);
                setFigurePosition(2,2,3)
%                 set(gcf,'WindowStyle','docked')
                this.CostHistoryGraphicsHandle = plot(this.CostHistory);
                xlabel('t in [s]');
                ylabel('cost');
            else
                set(this.CostHistoryGraphicsHandle,'YData',this.CostHistory);  % for 3D-plot
            end
            end
        end
    end
end
