%% 初期化
clear;

%% モデルの選択（１つだけ有効化する）
%net = DLCameraAlexnet;     %calc_score line 66で落ちる
net = DLCameraGooglenet;
%net = DLCameraMobilenetv2;
%net = DLCameraResnet18;
%net = DLCameraResnet101;
%net = DLCameraSqueezenet;

%% モデルの初期化
net.initialize;

%% 実行
net.run;
