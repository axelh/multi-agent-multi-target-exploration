%   Created by Axel Hackbarth, UC Berkeley VDL / TU-Harburg MuM

classdef TargetEstimatorCoordinator < SimulationObject
    %TARGETEstimatorCOORDINATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function this = TargetEstimatorCoordinator(varargin)
            this = this@SimulationObject(varargin{:});
            this.addDetectedTargetListeners;
            addlistener(this.Environment,'addedSensor',...
                @(src,evdata)this.addDetectedTargetListener(src,evdata));
        end
              
        function addDetectedTargetListeners(this)
            for i=1:length(this.Environment.Agents)
                for j=1:length(this.Environment.Agents{i}.Sensors)
                    addlistener(this.Environment.Agents{i}.Sensors{j},...
                        'DetectedTarget',@(src,evdata)this.detectedTarget(src,evdata));
                end
            end
        end
        
        function addDetectedTargetListener(this,src,evdata)
            addlistener(evdata.Handle,'DetectedTarget',...
                @(src,evdata)this.detectedTarget(src,evdata));
        end
        
        function detectedTarget(this,src,evdata)
            % if target has been detected by sensor (event trigger), the
            % targetEstimator for the target is created or updated

            target = evdata.TargetHandle;
            
            if isempty(target.TargetEstimator)
                this.addTargetEstimator(target,evdata.MeasuredPosition,evdata.Variance);
            else
                target.TargetEstimator.update(...
                    evdata.MeasuredPosition,evdata.Variance);
            end
        end
        
        function targetEstimator = addTargetEstimator(this,target,position,variance)
            targetEstimator = TargetEstimator('Environment',this.Environment,...
                                            'Target',target,...
                                            'TargetID',target.ID);
            targetEstimator.Noise = target.Noise; %TODO find a solution for this workaround. target noise has to be estimated
            targetEstimator.StateBounds = target.StateBounds; %TODO find a solution for this workaround. target bounds have to be estimated
            targetEstimator.InputBounds = target.InputBounds; %TODO find a solution for this workaround. target bounds have to be estimated
            targetEstimator.Covariance(1:2,1:2) = diag(variance);
            targetEstimator.Position = position;
            targetEstimator.LastTimeMoved = this.Environment.CurrentTimeStep;
            this.Environment.TargetEstimators{end+1} = targetEstimator;
            target.TargetEstimator = targetEstimator;
            if this.Environment.Visualize
                disp(['A new target has been detected with ID ',...
                    num2str(target.ID)]);
            end
            %register plots
            figobjects = [this.Environment.RegionEstimators];
            for figobject = [figobjects{:}]
                if ~isempty(figobject.MapFigure)
                    figure(figobject.MapFigure);
                    targetEstimator.registerPlot;
                end
            end
        end
    end
end

