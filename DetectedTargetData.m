classdef DetectedTargetData < event.EventData
    %DETECTEDTARGETEVENTDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        TargetHandle
        MeasuredPosition
        Variance
    end
    
    methods
        function this = DetectedTargetData(target,pos,var)
            this.TargetHandle = target;
            this.MeasuredPosition = pos;
            this.Variance = var;
        end
    end
    
end

