classdef EventWithHandle < event.EventData
    %DETECTEDTARGETEVENTDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Handle
    end
    
    methods
        function this = EventWithHandle(handle)
            this.Handle = handle;
        end
    end
    
end

