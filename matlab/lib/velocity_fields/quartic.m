function dpwo = quartic(p, v, k, center, scale)
%%QUARTIC oscillator velocity field
%
% Editor:
%   OMAINSKA Marco - Doctoral Student, Cybernetics
%       <marcoomainska@g.ecc.u-tokyo.ac.jp>
% Property of: Fujita-Yamauchi Lab, The University of Tokyo, 2022
% Website: https://www.scl.ipc.i.u-tokyo.ac.jp

%------------- BEGIN CODE --------------
dpwo = zeros(1,3);

% default parameters
if nargin < 5
    scale = 1;
end
if nargin < 4
    center = zeros(1,3);
end
if nargin < 3
    k = 1;
end
if nargin < 2
    v = 1;
end

% scale & center position around velocity field center
p = (p(:)-center(:)) ./ scale;

% velocity field equations below
dpwo(1) = v * p(2);
dpwo(2) = v * k*(-p(1)^3 + p(1));

%------------- END CODE --------------
end
