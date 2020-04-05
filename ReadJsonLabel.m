classdef ReadJsonLabel < handle
    % クラス名を詳細したjson ファイルの読み込み 
    
    properties
        japaneseLabels
        fileName
    end
    
    methods
        function obj = ReadJsonLabel(fileName)
            % インスタンス作成
            obj.fileName = fileName;
            fileID = fopen('label.json');
            textJson = fread(fileID,'*char')';
            fclose(fileID);
            japaneseLabels = jsondecode(textJson);
            obj.japaneseLabels = japaneseLabels;
        end
        
        function outputArg = getJpName(obj,num)
            % 日本語名を返す
            outputArg = obj.japaneseLabels(num).ja;
        end
        
        function outputArg = getEnName(obj,num)
            % 日本語名を返す
            outputArg = obj.japaneseLabels(num).en;
        end
    end
end
