function predictPart = getStateTransition(prevPart, dT, u)
thetas = prevPart(:,3);
w = u(2);
v = u(1);
l = length(prevPart);
% Generate velocity samples
sd1 = 0.3;
sd2 = 1.5;
sd3 = 0.02;
vh = v + (sd1)^2*randn(l,1);
wh = w + (sd2)^2*randn(l,1);
gamma = (sd3)^2*randn(l,1);
% Add a small number to prevent div/0 error
wh(abs(wh)<1e-19) = 1e-19;
% differential motion model
predictPart(:,1) = prevPart(:,1) - (vh./wh).*sin(thetas) + (vh./wh).*sin(thetas + wh*dT);
predictPart(:,2) = prevPart(:,2) + (vh./wh).*cos(thetas) - (vh./wh).*cos(thetas + wh*dT);
predictPart(:,3) = prevPart(:,3) + wh*dT + gamma*dT;
predictPart(:,4) = (- (vh./wh).*sin(thetas) + (vh./wh).*sin(thetas + wh*dT))/dT;
predictPart(:,5) = ( (vh./wh).*cos(thetas) - (vh./wh).*cos(thetas + wh*dT))/dT;
predictPart(:,6) = wh + gamma;
end