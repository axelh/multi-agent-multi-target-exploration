%   Created by Axel Hackbarth, UC Berkeley VDL / TU-Harburg MuM

classdef RegionEstimator < SimulationObject
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Region
        BlurRate = 30          % in m/s
        DarkeningRate = 1.005
%         DarkeningRate = 0.95
        MapFigure
        Visualize
        VarianceMap = 1e10
%         VarianceMap = 1e3
    end
    properties (Access = private)
        MapGraphicsHandle
        AgentGraphicsHandle
    end
    properties (Dependent = true)
        DiscoveryMap;
    end
    
    methods % set and get
        function vis = get.Visualize(this)
            if isempty(this.Visualize)
                vis = this.Environment.Visualize;
            else
                vis = this.Visualize;
            end
        end
        function dmap = get.DiscoveryMap(this)
            dmap = 1./this.VarianceMap;
%             dmap = -this.VarianceMap;
        end
        function set.DiscoveryMap(this,dmap)
            this.VarianceMap = 1./dmap;
%             this.VarianceMap = -dmap;
        end
    end
    
    methods(Access = public)
        function this = RegionEstimator(varargin)
        % constructor
            % copy any parameter / value pair to object properties
            this = this@SimulationObject(varargin{:});
            
            if ~isempty(this.Environment)
                addlistener(this.Environment,'moveInTime',...
                    @(src,evdata)this.newTimeStep);
                addlistener(this.Environment,'updatePlots',...
                    @(src,evdata)this.updatePlot);
                if isempty(this.DiscoveryMap)
                    this.DiscoveryMap = zeros(this.Region.GridSize');
                end
                if ~isempty(this.Region)
                    this.Region.RegionEstimator = this;
                end
                for agent = [this.Environment.Agents{:}]
                    for sensor = [agent.Sensors{:}]
                        addlistener(sensor,'NewMeasurement',...
                            @(src,evdata)this.placeSensorFootprint(src,evdata));
                    end
                end
            end
        end
        
        function placeSensorFootprint(this,sensor,evdata)
        %placeSensorFootprint places a new sensor footprint to region map
            sensorbounds = sensor.FieldOfView + sensor.Agent.Position * [1 1];
            sx = linspace(sensorbounds(1,1),sensorbounds(1,2),size(sensor.VarianceMap,1));
            sy = linspace(sensorbounds(2,1),sensorbounds(2,2),size(sensor.VarianceMap,2));
            [SX,SY] = meshgrid(sx,sy);
            SZ = (sensor.VarianceMap);
            
            RX = this.Region.X;
            RY = this.Region.Y;
            
            RZ = interp2(SX,SY,SZ,RX,RY,'linear',1e10);
            
%             this.DiscoveryMap = min(this.DiscoveryMap + RZ', 1);
%             this.VarianceMap = 1./(1./this.VarianceMap + 1./RZ');
            this.VarianceMap = this.VarianceMap .* ...
                (1 - this.VarianceMap./(this.VarianceMap + RZ'));
        end
        
        function newTimeStep(this)
        % every simulationobject has to have this function
            this.blurMap;
            this.darkenMap;
        end
        
        function updatePlot(this)
            if this.Visualize
            if isempty(this.MapFigure)
                this.MapFigure = figure;
                set(gcf,'Name',['RegionEstimator ',num2str(this.ID),' Mission Map']);
                setFigurePosition('topright');
%                 set(gcf,'WindowStyle','docked')
               
                this.MapGraphicsHandle = imagesc(this.Region.x,...
                                                 this.Region.y,...
                                                 this.DiscoveryMap');%,[0,1]);
                xlabel('x in [m]');
                ylabel('y in [m]');
                colormap(hot);
                set(gca,'YDir','normal');
                axis equal
                axis tight
                % plot agents into map
%                 hold on
%                 this.AgentGraphicsHandle = plot(xpos,ypos,'bo');
                for i=1:length(this.Environment.Agents)
                    this.Environment.Agents{i}.registerPlot;
                    this.Environment.Agents{i}.AgentController.registerPlot;
                    for j=1:length(this.Environment.Agents{i}.Sensors)
                        this.Environment.Agents{i}.Sensors{j}.registerPlot;
                    end
                end
                for i=1:length(this.Environment.Targets)
                    this.Environment.Targets{i}.registerPlot;
                end
                for i=1:length(this.Environment.TargetEstimators)
                    this.Environment.TargetEstimators{i}.registerPlot;
                end
%                 hold off
                
            else
                set(this.MapGraphicsHandle,'CData',this.DiscoveryMap');
%                 set(this.AgentGraphicsHandle,'XData',xpos,'YData',ypos);
                drawnow;
            end
            end
        end
    end
    
    
    methods(Access = private)
        function blurred = blurMap(this)
        % blur map
            timestep = this.Environment.TimeStepDuration;
            gridstep = norm(this.Region.GridStep);
            sigma = this.BlurRate * timestep/gridstep;
            imageFilter = fspecial('gaussian',max(3,ceil(6*sigma)), sigma);
            blurred = imfilter(this.DiscoveryMap,imageFilter,'replicate');
            if nargout == 0
                this.DiscoveryMap = blurred;
            end
        end
        
        function darkened = darkenMap(this)
        % make map darker
            timestep = this.Environment.TimeStepDuration;
            darkened = this.DiscoveryMap / this.DarkeningRate / timestep;
            if nargout == 0
                this.DiscoveryMap = darkened;
            end
        end
    end
end

