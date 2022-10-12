function precision = precisionMeasure(y, ypred)
%%PRECISIONMEASURE calculates detection precision.
%
%
% FORMULA:
%
%   Precision = 1 - 1/T * ∫_0^T h(|y-ypred|)dt
%
%       with h(x) = 0 if x ==0 else 1
%
% If we discretize that formula, we obtain (M = T/dt):
%
%   Precision = 1 - 1/M * ∑h(|y-ypred|)
%
%       with h(x) = 0 if x ==0 else 1
%
% -----------
%
% Inputs:
%   - y: true value time series [vector, size M]
%   - y_pred: predicted value time series [vector, size M]
%
% Outputs:
%   - precision: precision measure [scalar]
%
% Example commands:
%   precision = precisionMeasure(randi(0:1, [100,1]),randi(0:1, [100,1]))
%
%
% Editor:
%   OMAINSKA Marco - Doctoral Student, Cybernetics
%       <marcoomainska@g.ecc.u-tokyo.ac.jp>
% Property of: Fujita-Yamauchi Lab, The University of Tokyo, 2022
% Website: https://www.scl.ipc.i.u-tokyo.ac.jp

%------------- BEGIN CODE --------------

M = length(y);
err = sum(min(abs(y-ypred),ones(M,1))) / M;
precision = 1 - err;

end

