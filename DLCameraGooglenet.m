classdef DLCameraGooglenet < DLCameraBase
    methods
        function obj = DLCameraGooglenet
            obj.netName = "googlenet";
            obj.layerName = "inception_5b-output";            
        end
    end
end
