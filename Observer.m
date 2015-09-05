classdef Observer < handle
    %CONTROLLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        TargetSystemMatrix;
        TargetStateEstimate;
        Sensors;
        Targets;
        Gain = 1;
    end
    
    methods
        function obs = Observer(varargin)
            optargin = size(varargin,2);
            if optargin > 1 && mod(optargin,2)==0
                for i=nargin-optargin+1 : 2 : optargin-1
                    obs.(varargin{i}) = varargin{i+1};
                end
            end
            
            if isempty(obs.Sensors)
                obs.Sensors = Sensor;
            end
            if isempty(obs.Targets)
                obs.Targets = Target;
            end
            
            for i=1:length(obs.Targets)
                obs.TargetSystemMatrix{i} = obs.Targets(i).SystemMatrixA;
            end
        end
        
        function estimate = calcTargetStateEstimate(obj,...
                        sensorTargetMeasurementZ)
%             for i = 1:
            obj.TargetStateEstimate = obj.GainL * ...
                (obj.TargetSystemMatrix * sensorTargetMeasurementZ ...
                 - obj.TargetStateEstimate );
            estimate = obj.TargetStateEstimate;
        end
    end
end

