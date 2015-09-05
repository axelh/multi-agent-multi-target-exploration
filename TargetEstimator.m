%   Created by Axel Hackbarth, UC Berkeley VDL / TU-Harburg MuM

classdef TargetEstimator < MovingObject & Plottable
% classdef TargetEstimator < Target % MovingObject & Plottable
    %TARGETEstimator Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Covariance = 1e6*eye(4)
        TargetID
        Target
        OutputMatrix = [eye(2),zeros(2)]
        PlotStyle = 'g.'
    end
    properties (Dependent = true)
        Sigma
        Gain
    end
    
    methods % property set and get methods
        function gain = get.Gain(this)
%             gain = norm(this.Sigma);
            gain = norm(sqrt(diag(this.Covariance)));
        end
        
        function sigma = get.Sigma(this)
            sigma = sqrt(diag(this.Covariance));
            sigma = sigma(1:2);
        end
    end
    
    methods
        function this = TargetEstimator(varargin)
%             this = this@Target('PlotStyle','g.',varargin{:});
            this = this@MovingObject(varargin{:});
            this.State(3:4) = [0;0];
        end
        
        % moves observed target position and estimates covariance
        function varargout = move(this,varargin)
            % if output arguments are given, the function will not save the
            % state and covariance in the object, but just calculate it
            if nargout == 0
%                 move@Target(this,varargin{:});
                move@MovingObject(this,varargin{:});
                this.predictCovariance;
            else
%                 varargout = {move@Target(this,varargin{:})};
                varargout = {move@MovingObject(this,varargin{:})};
                varargout{end+1} = this.predictCovariance;
            end
        end
        
        function update(this,position,sigma)
            residual = position - this.OutputMatrix * this.State;
            covarresidual = this.OutputMatrix * this.Covariance * this.OutputMatrix' ...
                + diag(sigma.^2);
            K = this.Covariance * this.OutputMatrix' / covarresidual;
            this.State = this.State + K * residual;
            this.Covariance = (eye(size(this.Covariance)) ...
                - K * this.OutputMatrix) * this.Covariance;
        end
    end
    
    methods (Access = private)    
        function cov = predictCovariance(this)
            cov = this.SystemMatrix ...
                * this.Covariance ...
                * this.SystemMatrix' ...
                + this.NoiseCovariance;
            if nargout == 0
                this.Covariance = cov;
            end
        end
    end
    
    methods % plot methods
        function registerPlot(this)
            x = [(this.Position  * [1,1,1,1,1]) ...
              + [0,1,0,-1,0;
                 0,0,-1,0,1] ...
             .* (this.Sigma * [1,1,1,1,1])];
%               + [1,1,-1,-1,1;
%                  1,-1,-1,1,1] ...
            hold on
            this.PlotHandle{end+1} = ...
                plot(x(1,:),x(2,:),this.PlotStyle);
            hold off
        end
        
        function updatePlot(this)
            x = [(this.Position  * [1,1,1,1,1]) ...
              + [0,1,0,-1,0;
                 0,0,-1,0,1] ...
             .* (this.Sigma * [1,1,1,1,1])];
            for i=1:length(this.PlotHandle)
                set(this.PlotHandle{i},'XData',x(1,:),'YData',x(2,:));
            end
        end
    end % plot methods
end
