classdef DLCameraAlexnet < DLCameraBase
    methods
        function obj = DLCameraAlexnet
            obj.netName = "alexnet";
            obj.layerName = "conv5";            
        end
    end
end

