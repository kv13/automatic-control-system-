function [outputArg1,outputArg2] = untitled2(inputArg1,inputArg2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

Kmu=1/36;
TM=0.518;
K0=0.25;
KT=0.0037;
KM=245.38
Wn=
z=
p=
K1=(Wn^2+2*z*Wn*p)*TM/(Kmu*K0*KM)
K2=(2*z*Wn+p)*TM-1;
K2=K2/(KM*KT);
K3=(Wn^2*p*TM)/(Kmu*K0*KM)
A=[0,Kmu*K0/KT,0;-KM*KT*K1/TM,(-1-KM*KT*K2)/TM,-KM*KT*K3/TM;1,0,0]
x0=[X1arx,0,-K1/K3*X1arx]