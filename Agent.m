%   Created by Axel Hackbarth, UC Berkeley VDL / TU-Harburg MuM

classdef Agent < MovingObject
    %Agent Most general form of a Agent
    %   Detailed explanation goes here
    
    properties
        Sensors
        PlotStyle = 'bx'
        AgentController
    end
    
    events
        addedAgent
        deletedAgent
        addedSensor
        deletedSensor
    end
    
    methods (Access = public)
        function this = Agent(varargin)
            this = this@MovingObject(varargin{:});
%             this.addSensor;
            %this.initializeSensors();
            this.AgentController = ...
                 AgentController('Environment',this.Environment,...
                                 'Agent',this); %#ok<PROP,CPROP>
        end
        
        function sensor = addSensor(this,varargin)
            sensor = Sensor('Environment',this.Environment,...
                            'Agent',this,...
                            varargin{:});
            this.Sensors{end+1} = sensor;
            notify(this,'addedSensor');
            notify(this.Environment,'addedSensor',EventWithHandle(sensor));
            
            %register plots
            figobjects = [this.Environment.RegionEstimators];
            for figobject = [figobjects{:}]
                if ~isempty(figobject.MapFigure)
                    figure(figobject.MapFigure);
                    sensor.registerPlot;
                end
            end
        end
        
        % deletes sensor by ID nr, otherwise last added sensor
        function sensor = deleteSensor(this,ID)
            for i = 1:length(this.Sensors)
                if this.Sensors{i}.ID == ID
                    break
                end
            end
            sensor = this.Sensors{i};
            this.Sensors = this.Sensors([1:i-1,i+1:end]);
            notify(this,'deletedSensor');
            notify(this.Environment,'deletedSensor',EventWithHandle(sensor));
        end
    end
end % classdef
