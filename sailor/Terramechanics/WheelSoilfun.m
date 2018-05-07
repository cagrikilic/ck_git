        function TS = WheelSoilfun(i,keq,n,c,phi,K,c1,c2,Fz,r,b,theta2)
            TS.phi_degree = phi;    % angle of internal shearing resistance
            TS.phi = 0;
            TS.c = c;               % cohesion, Pa
            TS.K = K;               % shear deformation modulus, m
            
            TS.k_1 = keq;           % pressure sinkage modulus 1
            TS.k_2 = 0;             % pressure sinkage modulus 2
            TS.n = n;               % exponent of sinkage to width ratio
            
            TS.gamma = 0.048;       % density, N/m^3 (doesn't matter)
            
            % Wheel properties
            TS.r = r;               % radius, m
            TS.b = b;               % width, m
            TS.W = Fz;              % vertical axle load, N
            
            % Coefficients for the relative position of max. radial stress
            TS.c_1 = c1;
            TS.c_2 = c2;
            
            TS.slip = i;            % slip
            
            TS.theta_1 = 0.1;
            TS.theta_2 = theta2*pi/180;    % assume no t
            TS.theta_m = 0;
            
            TS.z_0 = 0;
            TS.slip = i;
            TS.phi = TS.phi_degree*pi/180;
            
        end