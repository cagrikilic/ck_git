clear all
clc
r=0.1;%radius (m)
b=0.1;%width(m)
k=0.05;%shear deformation modulus
sampling=0.05;%20hz
j1=0;
for jj=1:1000
for j=1:0.05:30

V=0.1+0.001*rand;%m/sec Linear velocity
if V<0
    V=V*(-1);
end
w=V/r+0.1*rand;%angular velocity
if w<0
    w=w*(-1);
end

theta1=(20+0.5*rand)*pi/180;%the angle from the vertical at which the wheel first makes contact
if theta1<0
    theta1=theta1*(-1);
end
W=200+0.01*rand; %kg vertical load
if W<0
    W=W*(-1);
end

T=0.04+0.1*rand;% Torque= (moment of inertia)(angular acceleration)

if T<0
    T=T*(-1);
end
if V<(r*w)
i=1-(V/(r*w));
    if i<-1
        i=-1;
        w=0;
    elseif i>1
        i=1;
        V=0;

    end
% disp ('driving')
elseif V>(r*w)
i=((r*w)/V)-1;
    if i<-1
        i=-1;
        w=0;
    elseif i>1
        i=1;
        V=0;

    end
% disp ('breaking')
end
if i > 0.6
    disp('Classical Terramechanics may fail after i>0.6')
end

A=1-exp((-r/k)*((theta1/2)+(1-i)*(-sin(theta1)+sin(theta1/2))));


K1=A*(theta1^2*W*r+4*T*sin(theta1)-8*T*sin(theta1/2));
K2=4*T*(cos(theta1)-2*cos(theta1/2)+1);
K4=theta1*r^2*b*(cos(theta1)-2*cos(theta1/2)+2*A*cos(theta1/2)+2*A+1);

j1=j1+1;
r1(j1)=K2/K4;
r2(j1)=-K1/K4;
end
R1=[r1]';
R2=[r2];
R2=vertcat(ones(1,length(R2)),R2)';
A=inv(R2'*R2)*R2'*R1;
A2=inv(R2'*R2+0.0001*eye(size(R2'*R2)))*R2'*R1;
cohA(jj)=A(1,1)/1000;
Phi(jj)=atan(A(2,1))*180/pi;

cohA2(jj)=A2(1,1);
Phi2(jj)=atan(A2(2,1));
end
time=1:1:1000;
figure
plot(time,cohA)
figure
plot(time,Phi)