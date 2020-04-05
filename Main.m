%% initialize
clear;

%% model selection
%net = DLCameraAlexnet;     %calc_score line 66 bug
net = DLCameraGooglenet;
%net = DLCameraMobilenetv2;
%net = DLCameraResnet18;
%net = DLCameraResnet101;
%net = DLCameraSqueezenet;

%% model initialization
% if you have multiple camera, check webcamlist and detect the correct number.
% wencamlist % 
net.initialize(1);

%% main run
net.run;
