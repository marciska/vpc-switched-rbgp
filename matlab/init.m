%% init.m
% *Summary:* Defines parameters necessary for the unity simulation
%
% -----------
%
% Editor:
%   OMAINSKA Marco - Doctoral Student, Cybernetics
%       <marcoomainska@g.ecc.u-tokyo.ac.jp>
% Supervisor:
%   YAMAUCHI Junya - Assistant Professor
%       <junya_yamauchi@ipc.i.u-tokyo.ac.jp>
%
% Property of: Fujita-Yamauchi Lab, University of Tokyo, 2021
% e-mail: marcoomainska@g.ecc.u-tokyo.ac.jp
% Website: https://www.scl.ipc.i.u-tokyo.ac.jp
% January 2022
%
% ------------- BEGIN CODE -------------

% Note:
% It is assumed that you have already started the ROS Docker container, and
% that MATLAB can already send & receive ROS messages
% rosinit('docker-ros',11311,'NodeHost','192.168.255.6')

%% Parameters

% vpc gains
Ke = 17*eye(6); % estimation gain
Kc = 10*eye(6); % control gain

% desired pose
gd = mergepose(rotx(45),[0 3 0]);
% gd = mergepose(eye(3),[0 3 0]);

% initial conditions
pwo_init = [-2 0 0];
gwo_init = mergepose(eye(3),pwo_init);
gwc_init = mergepose(rotx(-45),[-2 -3 3]);
gco_init = mergepose(rotx(45),[0 2 0]);
% gwo_init = mergepose(eye(3),pwo_init);
% gwc_init = mergepose(eye(3),[-2 -2 0]);
% gco_init = mergepose(eye(3),[0 3 0]);

% focal length
lambda = 20;

% feature points
fp = [   0,  0,  0.5;
       0.5,  0,    0;
       0,    0, -0.5;
      -0.5,  0,    0];

% ROS message frequency [Hz]
ros_freq = 50;

% set switching constant (old algorithm)
T = 0; %0.05;
