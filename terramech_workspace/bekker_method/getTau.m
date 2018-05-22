        % Get the shear stress at any angle on the wheel
        function tau = getTau(TS,theta)
            tau = zeros(length(theta),1);
            for i=1:length(theta) 
                if(theta(i)>=TS.theta_2 && theta(i)<=TS.theta_1)
                    sigma = TS.getSigma(theta(i));
                    j = ((TS.theta_1-theta(i))-(1-TS.slip)*(sin(TS.theta_1)...
                        -sin(theta(i))))*TS.r;
                    tau(i) = (TS.c+sigma*tan(TS.phi))*(1-exp(-j/TS.K));
                else
                    tau(i) = 0;
                end
            end
            tau = tau';
        end