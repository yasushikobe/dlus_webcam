classdef DLCameraResnet101 < DLCameraBase
    methods
        function obj = DLCameraResnet101
            obj.netName = "resnet101";
            obj.layerName = "res5c_branch2c";            
        end
    end
end

