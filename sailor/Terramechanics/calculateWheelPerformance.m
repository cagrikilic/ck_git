        function [H,R,D,T,z] = calculateWheelPerformance(TS,slip,keq,n,c,...
                phi,K,c1,c2,Fz,r,b,theta2,guess)
            TS.slip = slip;
            TS.k_1 = keq;
            TS.n = n;
            TS.c = c;
            TS.phi = phi;
            TS.K = K;
            TS.c_1 = c1;
            TS.c_2 = c2;
            TS.W = Fz;
            TS.r = r;
            TS.b = b;
            TS.theta_2 = theta2;

            radius = r;
            width = b;
            
            % Calculate the entrance angle (assuming an exit angle)
            options = optimset('Jacobian','off','Display','on');
            f = @(theta_c) TS.errorFunction(theta_c);
            theta_c = fsolve(f,guess,options);
            TS.theta_1 = theta_c;
            TS.theta_m = (TS.c_1+TS.c_2*TS.slip)*TS.theta_1;
            TS.z_0 = (1-cos(TS.theta_1))*TS.r;

            % Calculate the total thrust
            H = integral(@(theta)(TS.getTau(theta).*cos(theta)),...
                TS.theta_2,TS.theta_1);
            H = H.*radius.*width;

            % Calculate the total motion resistance
            R = integral(@(theta)(TS.getSigma(theta).*sin(theta)),...
                TS.theta_2,TS.theta_1);
            R = R.*radius.*width;
            
            % Calculate the total drawbar pull
            D = H-R;
            
            % Calculate the total torque
            T = integral(@(theta)(TS.getTau(theta)),TS.theta_2,TS.theta_1);
            T = T.*(radius^2*width);
            
            %Calculate the maximum sinkage
            z = (1-cos(TS.theta_1)).*radius;
        end