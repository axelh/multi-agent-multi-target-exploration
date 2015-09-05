%   Created by Axel Hackbarth, UC Berkeley VDL / TU-Harburg MuM

classdef MovingObject < SimulationObject & Plottable
    %MOVINGOBJECT This class represents a moving object in its most general form
    %   Detailed explanation goes here
    
    properties
        LastTimeMoved = 0       % [s]
        Mass = 1                % [kg]
        SystemMatrix
        State                   % [m] and [m/s]
        StateArchive
        InputMatrix
        Noise                   % std deviation in [m] or [m/s]
        Input = [0;0]               % [m/s²]
        StateBounds = [zeros(2);-1,1;-1,1] % [lower ; upper] %[m/s]
        InputBounds = 1 %*[-1,1;-1,1]    % [lower ; upper]  [m/s²]
        BounceOffWalls = true
        StopAtWalls = true
        Region
    end % properties
    
    properties (Dependent = true)
        Position
        Velocity
        MaxVelocity
        NoiseCovariance
    end
    
    events
        changedState
        moved
    end
    
    
    methods
        function this = MovingObject(varargin) % constructor
            this = this@SimulationObject(varargin{:});
            if ~isempty(this.Environment)
                this.StateBounds(1:2,1:2) = this.Region.Bounds;
%                 this.StateBounds(3:4,1:2) = this.MaxVelocity;
                if isempty(this.State)
                    this.randomState;
                end
                dTime = this.Environment.TimeStepDuration;
                if isempty(this.SystemMatrix)
                    this.SystemMatrix = [eye(2),dTime*eye(2);zeros(2),eye(2)];
                end
                if isempty(this.InputMatrix)
                    this.InputMatrix = [ dTime^2/2*eye(2);eye(2)]./this.Mass;
                    this.InputMatrix = [-dTime^2/2*eye(2);eye(2)]./this.Mass;
                end
                % this makes the objects move on move event from
                % environment
                addlistener(this.Environment,'moveInTime',...
                    @(src,evdata)this.move);
                addlistener(this.Environment,'updatePlots',...
                    @(src,evdata)this.updatePlot);
            end
        end  % constructor
        
        function state = move(this, state, input, noise)
            if ~exist('state','var'), state = this.State; end
            if ~exist('input','var'), input = this.Input; end
            if ~exist('noise','var'), noise = this.Noise .* randn(size(this.State)); end
            state = this.SystemMatrix * state ...
                  + this.InputMatrix  * input ...
                  + noise;
            if nargout == 0
                this.StateArchive = this.State;
                this.State = state;
                notify(this,'moved');
            end
        end % move
        
        function state = randomState(this)
            statespan = this.StateBounds(:,2) - this.StateBounds(:,1);
            state = this.StateBounds(:,1) ...
                  + statespan .* rand(size(statespan));
            if nargout == 0, this.State = state; end
        end % randomState
        
        function reverse(this)
            this.State(3:4) = - this.State(3:4);
        end % function
        
        function state = predict(this, time)
            if ~exist('time','var'), time = 1; end
            state = this.State;
            input = this.Input;
            for i=1:time/this.Environment.TimeStepDuration
                state = this.move(state,input);
                input = 0* input;
            end
        end
        
    end % methods
    
    methods % set and get methods
        function set.State(this, state)
            % check for bouncing off at walls
            if this.BounceOffWalls || this.StopAtWalls
                if this.BounceOffWalls && (state(1) < this.StateBounds(1,1)...
                                        || state(1) > this.StateBounds(1,2))
                    state(3) = -state(3);
                elseif this.BounceOffWalls && (state(2) < this.StateBounds(2,1)...
                                        || state(2) > this.StateBounds(2,2))
                    state(4) = -state(4);
                end
                % check for stop at walls
                this.State(1:2,:) = max(this.StateBounds(1:2,1),...
                        min(this.StateBounds(1:2,2),state(1:2)));
            end
            
            % check for max velocity
            this.State(3:4,:) = max(this.StateBounds(3:4,1),...
                         min(this.StateBounds(3:4,2),state(3:4)));
            % check for normed velocity
            factor = norm(this.State(3:4))/max(this.StateBounds(3:4,2));
            if factor > 1
                this.State(3:4,:) = this.State(3:4,:) ./ factor;
            end
            notify(this,'changedState');
        end % function
        
        function set.MaxVelocity(this,mvel)
            this.StateBounds(3:4,:) = mvel*[-1 1];
        end
        function mvel = get.MaxVelocity(this)
            mvel = this.StateBounds(3:4,2);
        end
        
        function set.Input(this,input)
            if size(this.InputBounds) == [2,2]
            this.Input = max(this.InputBounds(:,1),...
                         min(this.InputBounds(:,2),input));
            elseif size(this.InputBounds) == [1,1]
                this.Input = input / max(1,norm(input)/this.InputBounds);
            else
                this.Input = input;
            end
        end
        
        function pos = get.Position(this)
            pos = this.State(1:2);
        end
        function set.Position(this,pos)
            this.State(1:2) = pos;
        end
        
        function vel = get.Velocity(this)
            vel = this.State(3:4);
        end
        function       set.Velocity(this,vel)
            this.State(3:4) = vel;
        end
        
        function noisecovar = get.NoiseCovariance(this)
            noisecovar = diag( this.Noise.^2 .* ones(size(this.State)));
        end
        
        function region = get.Region(this)
            if isempty(this.Region)
                region = this.Environment.Region;
            else
                region = this.Region;
            end
        end
    end % set and get methods
    
    methods % plot methods
        function registerPlot(this)
            hold on
            x = this.Position;
            this.PlotHandle{end+1} = ...
                plot(x(1),x(2),this.PlotStyle);
            hold off
        end
        
        function updatePlot(this)
            x = this.Position;
            for i=1:length(this.PlotHandle)
                set(this.PlotHandle{i},'XData',x(1),'YData',x(2));
            end
        end
    end % methods
    
end % classdef