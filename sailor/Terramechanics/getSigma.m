        % Get the normal stress at any angle on the wheel
        function sigma = getSigma(TS,theta)
            sigma = zeros(length(theta),1);
            for i=1:length(theta) 
                %sigma(i) = getSigma1(TS,theta(i));
                if(theta(i)>=TS.theta_m && theta(i)<=TS.theta_1)
                    sigma(i) = getSigma1(TS,theta(i));
                elseif(theta(i)>=TS.theta_2 && theta(i)<TS.theta_m)
                    sigma(i) = getSigma2(TS,theta(i));
                else
                    sigma(i) = 0;
                end
            end
            sigma = sigma';
        end