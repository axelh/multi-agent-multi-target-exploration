%   Created by Axel Hackbarth, UC Berkeley VDL / TU-Harburg MuM

classdef Sensor < SimulationObject & Plottable
    %SENSOR Most general form of a sensor
    %   Detailed explanation goes here
    
    properties
        Agent
        CameraPicture
        CameraTime
        GridSize  = [20;20]      % [discretization steps]
        DiscretizationError = .5 % std deviation on ground [m]
        LensError = .3/10        % std dev on ground [m] / distance [m]
        FieldOfView = 10*[-1,1;-1,1] % on ground [m]
        VarianceMap
        DetectedTargets
        PlotStyle = '-b'
    end
    
    properties (Dependent = true)
    end
    
    events
        DetectedTarget
        NewMeasurement
    end
    
    
    methods (Access = public)
        function this = Sensor(varargin)
            this = this@SimulationObject(varargin{:});
            
            this.VarianceMap = this.createVarianceMap;
            
            if ~isempty(this.Environment)
                notify(this.Environment,'addedSensor',EventWithHandle(this));
                addlistener(this.Environment,'useSensors',...
                    @(src,evdata)this.useSensor);
                addlistener(this.Environment,'updatePlots',...
                    @(src,evdata)this.updatePlot);
                for regobs = [this.Environment.RegionEstimators{:}]
                    addlistener(this,'NewMeasurement',...
                        @(src,evdata)regobs.placeSensorFootprint(src,evdata));
                end
            end
        end
    end
    
    
    methods (Access = private) 
        function useSensor(this)
            notify(this,'NewMeasurement');
            this.checkForTargets;
        end
        
        function checkForTargets(this)
            this.DetectedTargets = [];
            for k = 1:length(this.Environment.Targets)
                target = this.Environment.Targets{k};
                if this.inFieldOfView(target.Position)
                    this.DetectedTargets{end+1} = target;
                    tpos = target.Position;
                    variance = [1;1] * this.getSensorVariance(tpos);
                    tpos = tpos + randn(2,1) .* sqrt(variance);
                    notify(this,'DetectedTarget',...
                        DetectedTargetData(target,tpos,variance));
                end
            end
        end
        
        function varmap = createVarianceMap(this)
            FoV = this.FieldOfView;
            sx = linspace(FoV(1,1),FoV(1,2),this.GridSize(1));
            sy = linspace(FoV(2,1),FoV(2,2),this.GridSize(2));
            [SX,SY] = meshgrid(sx,sy);
            
            varmap = this.DiscretizationError.^2 + this.LensError^2 * (SX.^2 + SY.^2);
%             1./(this.GaussianAmp * ...
%                 fspecial('gaussian',this.GaussianSize,this.GaussianSigma));
        end
        
        function var = getSensorVariance(this,position)
            FoV = this.FieldOfView + this.Agent.Position * [1 1];
            varmap = this.VarianceMap;
            sx = linspace(FoV(1,1),FoV(1,2),size(varmap,1));
            sy = linspace(FoV(2,1),FoV(2,2),size(varmap,2));
            [SX,SY] = meshgrid(sx,sy);
            var = interp2(SX,SY,varmap,position(1),position(2));
        end
        
        function inside = inFieldOfView(this, position)
            %inFieldOfView reports if a point / position is in the field of
            %view
            % position is a cartesian coordinate position
            % inside is a boolean returning if position is inside FOV or
            % not
            FoV = this.FieldOfView + this.Agent.Position * [1 1];
            distanceFromBounds = FoV - position * [1 1];
            inside = all(all([-1 1;-1 1] .* distanceFromBounds > 0));
        end
        
    end
        
    
    methods % plot methods
        function registerPlot(this)
            f = this.FieldOfView;
            x = this.Agent.Position * ones(1,5) + ...
                [f(:,1) [f(1,1);f(2,2)] f(:,2) [f(1,2);f(2,1)] f(:,1)];
            hold on
            this.PlotHandle{end+1} = ...
                plot(x(1,:),x(2,:),this.PlotStyle);
            hold off
        end
        
        function updatePlot(this)
            f = this.FieldOfView;
            x = this.Agent.Position * ones(1,5) + ...
                [f(:,1) [f(1,1);f(2,2)] f(:,2) [f(1,2);f(2,1)] f(:,1)];
            for i=1:length(this.PlotHandle)
                set(this.PlotHandle{i},'XData',x(1,:),'YData',x(2,:));
            end
        end
    end % plot methods
end % classdef
