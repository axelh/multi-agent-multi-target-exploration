%   Created by Axel Hackbarth, UC Berkeley VDL / TU-Harburg MuM

classdef Environment < SimulationObject
    %Environment This class contains one region, targets and Agents
    %   Detailed explanation goes here
    
    properties
        Regions = {}
        CommHandler
        RegionEstimators ={}
        Agents = {}
        Targets = {}
        TargetEstimators = {}
        TargetEstimatorCoordinator
        
        CurrentTimeStep = 0
        SimulationIsRunning = false
        TimeStepDuration = 1 % seconds per timestep
        EndTime = 100        % seconds simulation time
        nextID = 1
        IDTable
        Visualize = true
    end
    properties (Dependent = true)
        Region
        RegionEstimator
        CurrentTime
    end
    
    events % for simulation progress
        moveInTime
        useSensors
        controlObjects
        updatePlots
        startSimulation
        stopSimulation
    end
    events % for simulation changes
        addedTarget
        deletedTarget
        addedAgent
        deletedAgent
        addedSensor
        deletedSensor
    end
    
    methods % set and get
        function time = get.CurrentTime(this)
            time = this.CurrentTimeStep * this.TimeStepDuration;
        end
        
        function region = get.Region(this)
            region = this.Regions{1};
        end
        function set.Region(this,region)
            this.Regions{1} = region;
        end
        function regionEstimator = get.RegionEstimator(this)
            regionEstimator = this.RegionEstimators{1};
        end
    end
    
    methods % initialization / change methods
        function this = Environment(varargin)
        %Environment constructor for simulation environment
        % Environment includes and creates all objects that are needed to 
        % run a simulation.
        % 
        % All class properties can be initialized by parameter / value
        % pairs individually: 
        % this = Environment('propertyName',propertyValue)'
            this.ID = 0;
            
            % create and define region
            this.addRegion;
            
            optargin = size(varargin,2);
            if optargin > 1 && mod(optargin,2)==0
                for i=nargin-optargin+1 : 2 : optargin-1
                    this.(varargin{i}) = varargin{i+1};
                end
            end
            
            % create and define region Estimator
            this.addRegionEstimator;
            
            % create targetEstimatorcoodrinator
            this.TargetEstimatorCoordinator = TargetEstimatorCoordinator('Environment',this); %#ok<PROP,CPROP>
            
            % create listeners for start and stop simulation
            addlistener(this,'startSimulation',@(src,evdata)this.runSimulation);
            addlistener(this,'stopSimulation',@(src,evdata)this.abortSimulation);
        end % constructor
        
        function ID = getNewID(this,object)
            ID = this.nextID;
            this.nextID = this.nextID + 1;
            if exist('object','var')
                this.IDTable{ID} = object;
            end
        end
        
        function region = addRegion(this,varargin)
            region = Region('Environment',this,...
                                  varargin{:}); %#ok<CPROP,PROP>
            this.Regions{end+1} = region;
        end
        
        function regionEstimator = addRegionEstimator(this,varargin)
            regionEstimator = RegionEstimator('Environment',this,...
                                          'Region',this.Regions{length(this.RegionEstimators)+1},...
                                          varargin{:}); %#ok<CPROP,PROP>
            this.RegionEstimators{end+1} = regionEstimator;
        end
        
        function agent = addAgent(this,varargin)
            agent = Agent('Environment',this,...
                            'LastTimeMoved',this.CurrentTimeStep,...
                            varargin{:});
            scale = agent.Region.ScaleFactor;
            agent.Noise = 0;
            agent.MaxVelocity = scale*[1;1];
            agent.InputBounds = scale*.5 * agent.InputBounds;
            agent.BounceOffWalls = false;
            % set sensor scaling factor
            agent.addSensor;
            for sensor=[agent.Sensors{:}]
                sensor.DiscretizationError = scale*sensor.DiscretizationError;
                sensor.FieldOfView = scale*sensor.FieldOfView;
            end
            this.Agents{end+1} = agent;
            
            notify(agent,'addedAgent')
            notify(this,'addedAgent',EventWithHandle(agent))
            
            %register plots
            figobjects = [this.RegionEstimators];
            for figobject = [figobjects{:}]
                if ~isempty(figobject.MapFigure)
                    figure(figobject.MapFigure);
                    agent.registerPlot;
                    agent.AgentController.registerPlot;
                end
            end
        end
        
        % deletes agent by ID nr, otherwise last agent in list
        function agent = deleteAgent(this,ID)
            for i = 1:length(this.Agents)
                if exist('ID','var') && this.Agents{i}.ID == ID
                    break
                end
            end
            agent = this.Agents{i};
            this.Agents = this.Agents([1:i-1,i+1:end]);
            notify(this,'deletedAgent');
        end
        
        function target = addTarget(this,varargin)
            target = Target('Environment',this,...
                            'LastTimeMoved',this.CurrentTimeStep,...
                            varargin{:});
            scale = target.Region.ScaleFactor;
            
            dt = this.TimeStepDuration;
            target.Noise = scale*0.01*[0;0;1;1].*[dt^2/2;dt^2/2;dt;dt];
            target.MaxVelocity = scale*target.MaxVelocity;
            target.InputBounds = scale*target.InputBounds;
            target.randomState;
            
            this.Targets{end+1} = target;
            notify(this,'addedTarget',EventWithHandle(target));
            
            %register plots
            figobjects = [this.RegionEstimators];
            for figobject = [figobjects{:}]
                if ~isempty(figobject.MapFigure)
                    figure(figobject.MapFigure);
                    target.registerPlot;
                end
            end
        end
        % deletes target by ID nr, otherwise last target in list
        function target = deleteTarget(this,ID)
            for i = 1:length(this.Targets)
                if exist('ID','var') && this.Targets{i}.ID == ID
                    break
                end
            end
            target = this.Targets{i};
            this.Targets = this.Targets([1:i-1,i+1:end]);
            notify(this,'deletedTarget');
        end
    end
    
    methods % simulation methods
        function runSimulation(this, pauseTime)
            %runSimulation starts the simulation
            this.SimulationIsRunning = true;
            disp(['Started simulation at time step k=',int2str(this.CurrentTimeStep)]);
            disp(['Started simulation at simulation time t=',int2str(this.CurrentTime),' seconds']);
            tic
            while this.SimulationIsRunning && (this.CurrentTime < this.EndTime)
                this.CurrentTimeStep = this.CurrentTimeStep + 1;
                this.newTimeStep;
                if exist('pauseTime','var')
                    pause(pauseTime);
                end
            end
            disp(['Stopped simulation at time step k=',int2str(this.CurrentTimeStep)]);
            disp(['Stopped simulation at simulation time t=',int2str(this.CurrentTime),' seconds']);
            disp(['Simulation computational duration was ',num2str(toc),' seconds']);
        end
        
        function abortSimulation(this)
            this.SimulationIsRunning = false;
        end
        
        function newTimeStep(this)
        % every simulationobject has to have this function
            
            % ###### M O V E   O B J E C T S ############
            % this moves agents, targets and targetEstimators
            % regionEstimator is also processed
            % sensors might also include a move function and listener
            notify(this,'moveInTime');
            
            % ###### U S E   S E N S O R S ############
            notify(this,'useSensors');
            
            % ###### C O N T R O L   O B J E C T S ############
            notify(this,'controlObjects');
            
            % ###### U P D A T E   P L O T S ############
            if this.Visualize
                notify(this,'updatePlots');
            end
        end
    end
end
