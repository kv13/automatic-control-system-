function [ x1 ] = simple_position_v4( )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%   The input setpoint is in Volts and can vary from 0 to 10 Volts because the position pot is refered to GND
u=7;%to sima elegxou
l1=19.06; %proekupsan apo tis eksiswseis
l2=38.99;
setpos=5;
V_7805=5.36;
Vref_arduino=5.12;
a=arduino('/dev/ttyACM0');
Wn=3;
TM=0.518;
z=1;
KT=0.0037;
K0=0.25;
KM=245.38;
Kmu=1/36;
%K1=(Wn^2*T*36)/(K0*Km);
%K2=(2*Wn*T*z-1)/(Km*Kt);
% OUTPUT ZERO CONTROL SIGNAL TO STOP MOTOR  %
analogWrite(a,6,0);
analogWrite(a,9,0);
x1estold=0;%xrisimopoieite gia tin apothikeusi twn paliwn timwn
x2estold=0;%to idio
x1estnew=0;%se kathe epanalipsi oi kenourgies times
x2estnew=0;%omoios
x1estimation=[];
x2estimation=[];
positionData = [];
velocityData = [];
eData = [];
timeData = [];
timeflag=0;
t=0;

% CLOSE ALL PREVIOUS FIGURES FROM SCREEN

close all

% WAIT A KEY TO PROCEED
disp(['Connect cable from Arduino to Input Power Amplifier and then press enter to start controller']);
pause()


error=5;

%START CLOCK
tic
%while(error>0.5)
 
while(t<5)  
    
velocity=analogRead(a,3);
position=analogRead(a,5);

x1=3*Vref_arduino*position/1024;

x2=2*(2*velocity*Vref_arduino/1024- V_7805);
if(timeflag==0) %mono tin 1 fora tha mpei edw  giati thelw oi prwtes times na einai oi arxikes.
    x1estnew=x1estold;
    x2estnew=x2estold;
    C=clock; %ksekinaw ton times gia na vrw to dt
    timer1=C(5)*60+C(6);
else
    C=clock;
    timer2=C(5)*60+C(6); %stamatw ton timer gia na vrw to dt
    dt=timer2-timer1;
    x1estdot=l1*x1 -l1*x1estold+Kmu*K0/KT*x2estold;
    x2estdot=-x2estold/TM+KM*KT/TM*u+l2*x1-l2*x1estold;
    x1estnew=x1estold+x1estdot*dt;
    x2estnew=x2estold+x2estdot*dt;
    timer1=timer2;
    x1estold=x1estnew;
    x2estold=x2estnew;
    
end

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

    x1estimation=[x1estimation x1estnew];
    x2estimation=[x2estimation x2estnew];
    timeData = [timeData t];
    positionData = [positionData x1];
    velocityData = [velocityData x2];
    eData = [eData e];






timeflag=1;
end

 disp(['End of control Loop. Press enter to see diagramms']);
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



%    disp(['negative error ',num2str(789)]);

%   disp(['negative error ',num2str(e)]);
    
%   disp(['negative error ',num2str(e)]);


%end

%analogWrite(a,6,25); %  Start with small control signal

%while (digitalRead(a,2)== 0 )
% while (1 )   
%position=analogRead(a,5);
% disp(['position= ',num2str(position),digitalRead(a,2)]);

%disp(['position= ',num2str(position)]);
