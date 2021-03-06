classdef DLCameraBase < handle
    properties
        layerName
    end
    
    properties(Transient = true)
        netName
    end
    
    properties(Access = protected)
        japaneseLabels
        camera
        inputSize
        classes
        figureHandle
        net
    end
    
    methods
        function set.netName(obj, netName)
            obj.netName = netName;
            obj.net = eval(netName);
        end
        
        function set.layerName(obj, layerName)
            obj.layerName = layerName;
        end
        
        function initialize(obj, webcamNum)
            obj.japaneseLabels = ReadJsonLabel('label.json');
            if ~exist('webcamNum','var')
                webcamNum = 1;
            end            
            if ~exist('camera','var')
                obj.camera = webcam(webcamNum);
            end
            obj.inputSize = obj.net.Layers(1).InputSize(1:2);
            obj.classes = obj.net.Layers(end).Classes;
            obj.figureHandle = figure('Units','normalized','Position',[0.05 0.05 0.9 0.8],'Visible','on');
        end
        
        function run(obj)
            count = 0;
            while ishandle(obj.figureHandle)
                count = count + 1;
                elaps = obj.getTicToc(@obj.mainLoop);
                fprintf('%03d： 経過時間は %.4f 秒です\n',count,elaps)
            end
        end
    end
    
    methods (Access = protected)
        function mainLoop(obj)
            im = snapshot(obj.camera); %カメラ画像情報の取得
            imResized = imresize(im,[obj.inputSize(1), NaN]); % ネットワークごとに入力サイズが異なるので変更
            imageActivations = activations(obj.net,imResized,obj.layerName);    
            [scores, classIds, classActivationMap] = obj.calc_score(imageActivations);
            maxScores = scores(classIds);
            %labels = obj.classes(classIds);
            subplot(1, 2, 1)
            imshow(im)
            subplot(1, 2, 2)
            combinedImage = obj.getCombinedImage(im,classActivationMap);
            imshow(combinedImage);
            %title(string(labels) + ", " + string(maxScores));
            titleLabel1 = sprintf('%s : %.1f%%', obj.japaneseLabels.getJpName(classIds(1)), maxScores(1) * 100);
            title(titleLabel1);
            ax = gca;
            ax.TitleFontSizeMultiplier = 2;
            drawnow            
        end
        
        function elaps = getTicToc(~,func)
            tic
            func()
            elaps = toc;
        end
        
        function [scores, classIds, classActivationMap] = calc_score(obj, imageActivations)
            scores = squeeze(mean(imageActivations,[1 2]));
            fcWeights = obj.net.Layers(end-2).Weights;
            fcBias = obj.net.Layers(end-2).Bias;
            scores =  fcWeights*scores + fcBias;
            [~,classIds] = maxk(scores,3);
            weightVector = shiftdim(fcWeights(classIds(1),:),-1);
            classActivationMap = sum(imageActivations.*weightVector,3);
            scores = exp(scores)/sum(exp(scores));     
        end
    end
    
    methods (Access = private)
        function combinedImage = getCombinedImage(obj, im, activationMap)
            imSize = size(im);
            activationMap = imresize(activationMap,imSize(1:2));
            activationMap = obj.normalizeImage(activationMap);
            activationMap(activationMap<0.2) = 0;
            cmap = jet(255).*linspace(0,1,255)';
            activationMap = ind2rgb(uint8(activationMap*255),cmap)*255;

            combinedImage = double(rgb2gray(im))/2 + activationMap;
            combinedImage = obj.normalizeImage(combinedImage)*255;
            combinedImage = uint8(combinedImage); 
        end
        
        function N = normalizeImage(~, I)
            minimum = min(I(:));
            maximum = max(I(:));
            N = (I-minimum)/(maximum-minimum);
        end
    end
end
