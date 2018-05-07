%Coulomb equation
tau_max=(c+sigma_max*tan(phi));
%c=cohesion
%phi=internal friction angle
%sigma=normal stress acting on the terrain region
%tau=terrain shear stress

% W=vertical load - applied to the wheel by vehicle suspension
% DP horizontal force -applied at the wheel by vehicle suspension
% T=torque -applied at the wheel rotation axis by an actuator. The wheel has
% omega= wheel angular velocity 
% V=the wheel center's linear velocity
% Theta1= the angle from the vertical at whichthe wheel first makes contact with the terrain
% Theta2= The angle from the vertical at which the wheel loses contact with the terrain
Theta_all=Theta1+Theta2;
%Theta_all= the entire angular wheel-terrain contact region
I=1-(V/(r*omega));
tau(Theta)=(c+sigma(theta)*tan(phi))*(1-exp((-r/k)*(Theta1-Theta-(1-I)*(sin(Theta1)-sin(Theta)))));
%Theta=WHAT IS THETA!!! HOW TO CALCULATE THETA! IT IS NOT Theta1+Theta2!
%sigma and tau are functions of Theta
%r=the wheel radius
%k=shear deformation modulus
%I= Wheel slip

%Normal stress at the wheel terrain interface 
sigma(z)=(k1+k2*b)*(z/b)^n;
%b=wheel width
%k1,k2 are constants of WHAT!!!
%n=sinkage 

% Expression for the normal stress as a function of the wheel angular 
%  location Theta is written by expressing the sinkage as a function of the
%  angular location Theta
z(Theta)=r*(cos(Theta)-cos(Theta1));

% Expressions for the normal stress distribution along the
% wheel-terrain interface

sigma1(Theta)=(k1+k2*b)*((r/b)^n)*(cos(Theta)-cos(Theta1))^n;
sigma2(Theta)=(k1+k2*b)*((r/b)^n)*(cos(Theta1-(Theta/Theta_max)*(Theta1-Theta_max))-cos(Theta1))^n;

% linear approximation
sigma1(Theta)=((Theta1-Theta)/(Theta1-Theta_max))*sigma_max;
sigma2(Theta)=(Theta/Theta_max)*sigma_max;

tau1(Theta)=((Theta1-Theta)/(Theta1-Theta_max))*tau_max;
tau2(Theta)=(Theta/Theta_max)*tau_max;

W=(r*b/((Theta_max)*(Theta_1-Theta_max)))*(sigma_max*(Theta_1*cos(Theta_max)-Theta_max*cos(Theta_1)-Theta_1+Theta_max)+tau_max*(Theta_1*sin(Theta_max)-Theta_max*sin(Theta_1)));
T=(1/2)*b*tau_max*Theta_1*r^2;
tau_max=(c+sigma_max*tan(phi))*(1-exp((-r/k)*(Theta1-Theta_max-(1-I)*(sin(Theta1)-sin(Theta_max)))));
sigma_max=(Theta1+Theta2)/2;

%% assume Theta_2=0;
C1=((4*T*sin(Theta_1)+W*(Theta_1^2)*r-8*T*sin(Theta_1/2))*tan(phi)+(4*T*cos(Theta_1)-8*T*cos(Theta_1/2)+4*T)/(1-A1));
C2=((2*r^2*w*Theta_1)*(cos(Theta_1)-2*cos(Theta_1/2)+1));
c=C1/C2;
A1=exp((-r/k)*((Theta_1/2)+(1-I)*(-sin(Theta_1)+sin(Theta_1/2))));
K1=(4*T*cos(Theta_1)-8*T*cos(Theta_1/2)+4*T)/(1-A1);
K2=(C2-(4*T*sin(Theta_1)+W*(Theta_1^2)*r-8*T*sin(Theta_1/2)))';

y=inv(K2'*K2)*K2'*K1


