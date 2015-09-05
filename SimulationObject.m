%   Created by Axel Hackbarth, UC Berkeley VDL / TU-Harburg MuM

classdef SimulationObject < handle
    %SIMULATIONOBJECT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties 
        ID
        Environment
    end
    
    
    methods (Abstract)
%         newTimeStep
    end
    
    methods
        function this = SimulationObject(varargin)
            % copy any parameter / value pair to object properties
            optargin = length(varargin);
            if optargin > 1
                for i= 1 : optargin-1
                    if any(strcmp(varargin{i},properties(this)))
                        try
                            this.(varargin{i}) = varargin{i+1};
                        catch ME
                            ME.stack
                        end
                    end
                end
            end
            if ~isempty(this.Environment)
                this.addID;
            end
        end
        
        function set(this,varargin)
            % copy any parameter / value pair to object properties
            optargin = length(varargin);
            if optargin > 1
                for i= 1 : optargin-1
                    if any(strcmp(varargin{i},properties(this)))
                        try
                            this.(varargin{i}) = varargin{i+1};
                        catch ME
                            ME.stack
                        end
                    end
                end
            end
        end
        
        function ID = addID(this)
            ID = this.Environment.getNewID;
            this.ID = ID;
        end
    end
    
end

