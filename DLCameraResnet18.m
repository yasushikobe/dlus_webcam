classdef DLCameraResnet18 < DLCameraBase
    methods
        function obj = DLCameraResnet18
            obj.netName = "resnet18";
            obj.layerName = "res5b_relu";            
        end
    end
end

