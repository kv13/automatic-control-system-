function [ x1 ] = simple_position_v4( )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%   The input setpoint is in Volts and can vary from 0 to 10 Volts because the position pot is refered to GND
setpos=5;
V_7805=5.36;
Vref_arduino=5.12;

a=arduino('/dev/ttyACM1');
Wn=9;
T=0.518;
z=1;
Kt=0.0037;
K0=0.25;
Km=245.38;
K1=(Wn^2*T*36)/(K0*Km);
K2=(2*Wn*T*z-1)/(Km*Kt);
% OUTPUT ZERO CONTROL SIGNAL TO STOP MOTOR  %
analogWrite(a,6,0);
analogWrite(a,9,0);


positionData = [];
velocityData = [];
eData = [];
timeData = [];
udata=[];
setposdata=[];

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
    

%setpos=5+2*sin(10*t);


velocity=analogRead(a,3);
position=analogRead(a,5);

x1=3*Vref_arduino*position/1024;

x2=2*(2*velocity*Vref_arduino/1024- V_7805);

 e= setpos-x1;
 u=K1*e-K2*x2;   
 if(u>255)
     u=255;
 end
 
 if(u<-255)
     u=-255;
 end


if(e<0.2)
    u=0;
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
    udata=[udata u];
    setposdata=[setposdata setpos];




end

 disp(['End of control Loop. Press enter to see diagramms']);
 pause();
 
% OUTPUT ZERO CONTROL SIGNAL TO STOP MOTOR  %
analogWrite(a,6,0);
analogWrite(a,9,0);

figure 
plot(timeData,positionData);
hold on
plot(timeData,setposdata);
plot(timeData,udata);
legend('position','setposition','input signal');
hold off;

figure
plot(timeData,positionData);
hold on
plot(timeData,setposdata);
title('position')
legend('position','epithimiti thesi');
hold off

figure 
plot(timeData,udata);
title('sima elegxou');


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
