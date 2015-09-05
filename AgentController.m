%   Created by Axel Hackbarth, UC Berkeley VDL / TU-Harburg MuM

classdef AgentController < SimulationObject & Plottable
    %TARGETCONTROLLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Agent
        Waypoint = [0;0]
        CostMap
        CostFigure
        CostGraphicsHandle
        BaseMap                     % is a region map that defines no-fly zones and zones to better avoid
        TargetAttraction = 4          % low: ignore / high: follow targets
        RegionExploration = 1      % low: ignore / high: consider map exploration
        AgentRepulsion = 1          % low: ignore / high: avoid agent collisions
        WaypointRepulsion = 3
        StateDeviation = 3   % low: global / high: local waypoint selection
        BaseMultiplier = 3   % low: global / high: local waypoint selection
        PredictTime = 5             % time horizon that is predicted for control
    end
    properties % for PD & gradient controller
        FeedbackGain = 0.4      % gain for defining sensor input by waypoint distance
        VelocityGain = 2        % gain for derivative feedback
        CostGradientGain = 2000  % gain for defining sensor input by local cost gradient
    end
    properties % for plotting
        PlotStyle = 'bo'
        Visualize  = false % leave empty for environment visualize setting
    end
    properties (Dependent = true)
        X
        Y
    end
    
    methods % set and get
        function x = get.X(this)
            x = this.Agent.Region.X;
        end
        function y = get.Y(this)
            y = this.Agent.Region.Y;
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
        function this = AgentController(varargin)
            this = this@SimulationObject(varargin{:});
            if ~isempty(this.Environment)
                this.BaseMap = this.createBaseMap;
                addlistener(this.Environment,'controlObjects',...
                    @(src,evdata)this.control);
                addlistener(this.Environment,'updatePlots',...
                    @(src,evdata)this.updatePlot);
            end
        end
        
        function control(this)
            this.computeCostMap;
            this.defineAgentInput;
        end
    end
    
    methods (Access = private)
        function baseMap = createBaseMap(this,X,Y)
            % is a region map that defines no-fly zones and zones to better
            % avoid
            if ~exist('X','var') || ~exist('Y','var')
                X = this.X;
                Y = this.Y;
            end
            center = this.Agent.Region.Center;
            baseMap = ((X-center(1)).^2 + (Y-center(2)).^2);
            baseMap = 1*baseMap / max(max(baseMap));
            if nargout == 0
                this.BaseMap = baseMap;
            end
        end
        
        %the input for the corresponding agent is generated
        function defineAgentInput(this)
            agent = this.Agent;
            % simple PD controller
            agent.Input = ...
                this.FeedbackGain * (this.Waypoint - agent.Position ...
                    - this.VelocityGain * agent.Velocity ...
                    - this.CostGradientGain * this.computeLocalGradient);
        end
        
        function computeCostMap(this,X,Y)
            if ~exist('X','var') || ~exist('Y','var')
                X = this.X;
                Y = this.Y;
            end
            
            DiscoveryMap = this.Agent.Region.RegionEstimator.DiscoveryMap;
%             DiscoveryMap = -this.Agent.Region.RegionEstimator.VarianceMap;
            
            Cost = this.BaseMultiplier      *this.BaseMap ...
                 + this.RegionExploration   *DiscoveryMap' ...
                 - this.TargetAttraction    *this.getTargetAttractionMap(X,Y) ...
                 + this.AgentRepulsion      *this.getAgentRepulsionMap(X,Y) ...
                 + this.WaypointRepulsion   *this.getWaypointRepulsionMap(X,Y) ...
                 + this.StateDeviation      *this.getStateDeviationMap(X,Y);
            
            % find minimum of cost map
            [minCost,idx1] = min(Cost);
            [minCost,idx2] = min(minCost);
            idx1=idx1(idx2);
            this.Waypoint = [X(idx1,idx2);Y(idx1,idx2)];
            this.CostMap = Cost;
        end
        
        function grad = computeLocalGradient(this)
            grad = [0;0];
            gradX = 0; gradY = 0;
            areaofinfluence = this.Agent.MaxVelocity...
                             *this.Environment.TimeStepDuration; % meters in both directions
            agent = this.Agent;
            convert2grid = @(x)this.Agent.Region.convert2GridPosition(x);
            pos = agent.predict(this.PredictTime);
            pos = pos(1:2);
            if ~this.Agent.Region.outOfRegion(pos)
            gridposbounds = [convert2grid(pos - areaofinfluence),...
                             convert2grid(pos + areaofinfluence)];
            
            cost = this.CostMap(gridposbounds(2,1):gridposbounds(2,2),...
                                gridposbounds(1,1):gridposbounds(1,2));
            if ~any(size(cost)==[1 1])
                [gradX,gradY] = gradient(cost,...
                                    this.Agent.Region.GridStep(1),...
                                    this.Agent.Region.GridStep(2));
            end
            grad = [mean(mean(gradX));
                    mean(mean(gradY))];
            end
        end
        
        % calculate target attraction by gaussian maps
        function tMap = getTargetAttractionMap(this,X,Y)
            if ~exist('X','var') || ~exist('Y','var')
                X = this.X;
                Y = this.Y;
            end                
            tMap = 0;
            for i=1:length(this.Environment.TargetEstimators)
                targetobs = this.Environment.TargetEstimators{i};
                pos = targetobs.predict(this.PredictTime);
                sigma = 10*targetobs.Sigma;
                amp = sqrt(targetobs.Gain);
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
                if agent.ID ~= this.Agent.ID
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
        function registerPlot(this)
            x = [10*this.Agent.Input + this.Agent.Position,this.Waypoint];
            hold on
            this.PlotHandle{end+1} = ...
                plot(x(1,:),x(2,:),this.PlotStyle);
            hold off
        end
        
        function updatePlot(this)
            % P L O T $$$$$$
            this.showCostMap;
            
            x = [10*this.Agent.Input + this.Agent.Position,this.Waypoint];
            for i=1:length(this.PlotHandle)
                set(this.PlotHandle{i},'XData',x(1,:),'YData',x(2,:));
            end
        end
        
        function showCostMap(this)
            if this.Visualize
            if isempty(this.CostFigure)
                this.CostFigure = figure;
                set(gcf,'Name',['AgentController ',num2str(this.ID),' Cost Map']);
                setFigurePosition(2,2,4)
%                 set(gcf,'WindowStyle','docked')
                this.CostGraphicsHandle = mesh(this.Agent.Region.X,...   % for 3D-plot
                                                 this.Agent.Region.Y,...
                                                 this.CostMap);
                xlabel('x in [m]');
                ylabel('y in [m]');
                zlabel('cost');
%                 view(0,90)
%                 axis square
                axis tight
                zlim('auto')
                
            else
                set(this.CostGraphicsHandle,'ZData',this.CostMap);  % for 3D-plot
            end
            end
        end
    end
end
