%   Created by Axel Hackbarth, UC Berkeley VDL / TU-Harburg MuM

classdef Target < MovingObject
    %TARGET This class represents a target in its most general form
    %   Detailed explanation goes here
    
    properties
        Size = [3,3]
        PlotStyle = 'gx'
        TargetEstimator
    end
    
    events
        AddedTarget
        DeletedTarget
    end
    
    methods (Access = public)
        function this = Target(varargin)
            this = this@MovingObject(varargin{:});
        end
        
        function [position,map] = getMap(this)
            position = this.Position;
            map = ones(this.Size);
        end
    end
    
end % classdef
