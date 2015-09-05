classdef Plottable < handle
    %PLOTTABLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        PlotHandle
        PlotInFigure
    end
    properties (Abstract = true)
        PlotStyle
    end
    
    methods (Abstract = true)
        registerPlot(this)
        updatePlot(this)
    end
end

