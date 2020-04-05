classdef DLCameraSqueezenet < DLCameraBase
    methods
        function obj = DLCameraSqueezenet
            obj.netName = "squeezenet";
            obj.layerName = "relu_conv10";            
        end
    end
    
    methods (Access = protected)
        function [scores, classIds, classActivationMap] = calc_score(~, imageActivations)
            scores = squeeze(mean(imageActivations,[1 2]));
            [~,classIds] = maxk(scores,3);
            classActivationMap = imageActivations(:,:,classIds(1));
            scores = exp(scores)/sum(exp(scores));     
        end
    end
end
