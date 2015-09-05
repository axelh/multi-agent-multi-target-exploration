classdef FigureHandler < SimulationObject
    %FIGUREHANDLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        FigureHandle
        PlotHandles
    end
    
    methods
        function this = FigureHandler(varargin)
            this = this@SimulationObject('FigureHandle',figure);
        end
        
        function disp(this)
            figure(this.FigureHandle)
            disp@SimulationObject(this)
        end
        
        function newTimeStep(this)
        % every simulationobject has to have this function
            
        end
        
        function setFigure(this)
            figure(this.FigureHandle)
        end
        
        function setPosition(this,varargin)
            setFigurePosition(varargin);
        end
        
        function drawPlot(this, plot)
            
        end
    end
    
end

