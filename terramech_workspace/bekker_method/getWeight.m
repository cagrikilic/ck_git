        % Get the weight for a given entrance angle
        function Wcheck = getWeight(TS,theta_c)
            radius = TS.r;
            width = TS.b;
            TS.theta_1 = theta_c;
            TS.theta_m = (TS.c_1+TS.c_2*TS.slip)*theta_c;
            
            % TEST
            %Wcheck = 2*integral(@(theta)(TS.getSigma(theta).*cos(theta)+TS.getTau(theta).*sin(theta)),0,TS.theta_1).*radius.*width;
            % END TEST

            Wcheck = integral(@(theta)(TS.getSigma(theta).*cos(theta)),...
                TS.theta_2,TS.theta_1);
            Wcheck = Wcheck + integral(@(theta)(TS.getTau(theta).*...
                sin(theta)),TS.theta_2,TS.theta_1);
            Wcheck = Wcheck.*radius.*width;
        end