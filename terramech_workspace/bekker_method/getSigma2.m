        % Get the normal stress along the back of the wheel for a given
        % angle
        function sigma_2 = getSigma2(TS,theta)
            z = (cos(TS.theta_1-((theta-TS.theta_2)/...
                (TS.theta_m-TS.theta_2))*(TS.theta_1-TS.theta_m))...
                -cos(TS.theta_1))*TS.r;
            sigma_2 = TS.k_1.*(z./TS.b).^TS.n; % k_1 is k_eq here
        end