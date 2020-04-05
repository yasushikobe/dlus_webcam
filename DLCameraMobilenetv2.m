classdef DLCameraMobilenetv2 < DLCameraBase
    methods
        function obj = DLCameraMobilenetv2
            obj.netName = "mobilenetv2";
            obj.layerName = "out_relu";            
        end
    end
end
