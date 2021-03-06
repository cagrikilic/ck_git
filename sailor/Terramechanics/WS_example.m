phi = 34.74;       % angle of friction, degrees       
c = 139.28;        % cohesion         
K = 5.15e-4;     % shear modulus
k_eq = 2.54e5;     % pressure-sinkage modulus
n = 1.387;           % exponent of sinkage to width
theta_2 = 0;       % exit angle (assumed)
r = .13;            % wheel radius
b = .16;            % wheel width
W = 130;         % wheel weight
slip=0.5;
% Coefficients for determining the relative position of max. radial stress
c_1 = 0.43;
c_2 = 0.32;

% Create the WheelSoil object
test = WheelSoil(slip,k_eq,n,c,phi,K,c_1,c_2,W,r,b,theta_2);

guess = 0.4058;
[H,R,D,T,z] = test.calculateWheelPerformance(slip,k_eq,n,c,phi*pi/180,K,c_1,c_2,W,r,b,theta_2*pi/180,guess);