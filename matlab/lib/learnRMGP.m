function [X,Y,hyp,sn] = learnRMGP(gdata,Vdata,M,kernel,sn,idx,varargin)
%%LEARNRMGP returns a fully-trained rigid-motion GP model on given data. 
%
% Detailed Explanation:
%   none
%
% -----------
%
% Inputs:
%   - gdata: pose data [size 4x4xN]
%   - Vdata: body velocity data [size Nx6]
%   - M: amount of data to reduce to [scalar]
%   - kernel: kernel function [function handler]
%   - sn: noise standard deviation [scalar]
%
% Outputs:
%   - X: GP input data [size Mx6]
%   - Y: GP output data [size Mx6]
%   - hyp: GP kernel hyperparameters [size depends on kernel]
%
% Example commands:
%   [X,Y,hyp] = learnRMGP(gdata,Vdata,30,@covSEard,1e-2)
%
%
% Editor:
%   OMAINSKA Marco - Doctoral Student, Cybernetics
%       <marcoomainska@g.ecc.u-tokyo.ac.jp>
% Property of: Fujita-Yamauchi Lab, The University of Tokyo, 2022
% Website: https://www.scl.ipc.i.u-tokyo.ac.jp

%------------- BEGIN CODE --------------

% GP dataset
X = gdata;
Y = Vdata;

% reduce dataset
if nargin < 6
    idx = sort(randperm(size(X,1),M));
end
X = X(idx,:);
Y = Y(idx,:);

% add noise to dataset
Y = Y + (sn.^2)'.*randn(M,6);

% calculate GP hyperparameters
[hyp, sn] = optimize_hyp(X,Y,kernel,'sn0',sn.*ones(6,1),varargin{:});

% print outputs for easy copy&paste
disp('Copy & Paste into GP block:')
disp(['X:   ' mat2str(X)])
disp(['Y:   ' mat2str(Y)])
disp(['hyp: ' mat2str(hyp)])

%-------------- END CODE ---------------
end

