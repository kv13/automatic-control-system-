function [ x1 ] = simple_position_v4new()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%   The input setpoint is in Volts and can vary from 0 to 10 Volts because the position pot is refered to GND

V_7805=5.36;
Vref_arduino=5.12;
setpos=5;
a=arduino('/dev/ttyACM1');

% OUTPUT ZERO CONTROL SIGNAL TO STOP MOTOR  %
analogWrite(a,6,0);
analogWrite(a,9,0);
X1start=2;
Wn=6;
z=1;%to zeta apo to xaraktiristiko poluwnumo
p=10;
TM=0.518;
K0=0.25;
KT=0.0037;
KM=245.38;
Kmu=1/36;
K1=(Wn^2+2*z*Wn*p)*TM/(Kmu*K0*KM);
K2=(2*z*Wn+p)*TM-1;
K2=K2/(KM*KT);
K3=(Wn^2*p*TM)/(Kmu*K0*KM);
Zold=-K1/K3*X1start;%arxiki timi tou Z
positionData = [];
velocityData = [];
eData = [];
timeData = [];
udata=[];

t=0;
timeflag=0;
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
e= setpos-x1;
% error=abs(e);  
if timeflag==0 %stin 1h epanalipsi tha mpei edw 
    Znew=Zold;
    u=-K1*x1-K2*x2-K3*Znew; %upologizw thn timi tou simatos elegxou me tin arxiki timi tou Z.
    C=clock;
    timer1=C(5)*60+C(6); %ksekinaw na metraw gia na vrw to dt gia ton  upologismo tis epomenis timis tou Z
else
    C=clock;%twra vriskw tin epomeni xroniki stigmi
    timer2=C(5)*60+C(6); %metatrepw se sec 
    dt=timer2-timer1; %vriskw dt
    Zdot=x1-setpos; %vriskw paragogo
    Znew=Zold+dt*Zdot; %vriskw nea  timi 
    Zold=Znew; % thetw tin palia timi isi me tin kainourgia gia tin epomeni epanalipsi
    u=-K1*x1-K2*x2-K3*Znew; % vriskw elegkti
    timer1=timer2; % krataw tin twrini timi tou ws timer1 wste me ton timer2 na vrw tin nea timi stin epomeni epanalipsi 
end
 if(u>255)
     u=255;
 end
 
 if(u<-255)
     u=-255;
 end


if e<0.3 u=0;
end

if u>0
    analogWrite(a,6,0);
    analogWrite(a,9,min(round(u/2*255/ Vref_arduino) , 255));
    

else
    analogWrite(a,9,0);
    analogWrite(a,6,min(round(-u/2*255/ Vref_arduino) , 255)); 
end

timeflag=1;
t=toc;

    
    timeData = [timeData t];
    positionData = [positionData x1];
    velocityData = [velocityData x2];
    eData = [eData e];
    udata=[udata u];


end

 disp(['End of control Loop. Press enter to see diagramms']);
 pause();
 
% OUTPUT ZERO CONTROL SIGNAL TO STOP MOTOR  %
analogWrite(a,6,0);
analogWrite(a,9,0);


figure
plot(timeData,positionData);
hold on
plot(timeData,udata);
legend('postion','input signal u');
title('position')
hold off
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
