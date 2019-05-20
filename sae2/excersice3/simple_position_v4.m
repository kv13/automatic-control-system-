function [ x1 ] = simple_position_v4( )

%The input setpoint is in Volts and can vary from 0 to 10 Volts because the position pot is refered to GND
setpos=5;
timeflag=0;
wn=1;
p=12;
%dt=0.1;
V_7805=5.36;
Vref_arduino=5.12;
k0=0.25;
km=245.38;
Tm=0.518;
kt=0.0037;

k2=((2*wn+p)*Tm-1)/(km*kt);

k1=(36*Tm*(wn^2+2*wn*p))/(k0*km);

ki=wn^2*p*Tm*36/(k0*km);

a=arduino('/dev/ttyACM0');

% OUTPUT ZERO CONTROL SIGNAL TO STOP MOTOR  %
analogWrite(a,6,0);
analogWrite(a,9,0);
positionData = [];
velocityData = [];
eData = [];
timeData = [];
t=0;
close all

% WAIT A KEY TO PROCEED
disp(['Connect cable from Arduino to Input Power Amplifier and then press enter to start controller']);
pause()

zold=-k1/ki*setpos;
tic 
while(t<5)  
velocity=analogRead(a,3);
position=analogRead(a,5);

x1=3*Vref_arduino*position/1024;

x2=2*(2*velocity*Vref_arduino/1024- V_7805);

e=setpos-x1;
if timeflag==0
    dt=0;
else
    dt=toc(dtstart);
end
z=-e*dt+zold;
dtstart=tic;
u=-k1*x1-k2*x2-ki*z;

 if(u>255)
     u=255;
 end
 if(u<-255)
     u=-255;
 end
if u>0
    analogWrite(a,6,0);
    analogWrite(a,9,min(round(u/2*255/ Vref_arduino) , 255));
else
    analogWrite(a,9,0);
    analogWrite(a,6,min(round(-u/2*255/ Vref_arduino) , 255));
end
t=toc;   
    timeData = [timeData t];
    positionData = [positionData x1];
    velocityData = [velocityData x2];
    eData = [eData e];
    
    timeflag=1;
end

 disp(['End of control Loop. Press enter to see diagrams']);
 pause();
 
% OUTPUT ZERO CONTROL SIGNAL TO STOP MOTOR  %
analogWrite(a,6,0);
analogWrite(a,9,0);


figure
plot(timeData,positionData);
title('position')

figure
plot(timeData,velocityData);
title('velocity')

figure
plot(timeData,eData);
title('error')

disp('Disonnect cable from Arduino to Input Power Amplifier and then press enter to stop controller');
pause();