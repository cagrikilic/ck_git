        % Get the normal stress along the front of the wheel for a given
        % angle
        function sigma_1 = getSigma1(TS,theta)
            z = (cos(theta)-cos(TS.theta_1))*TS.r;
            sigma_1 = TS.k_1.*(z./TS.b).^TS.n; % k_1 is k_eq here
        end