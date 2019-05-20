B=[0function [Y] = simulation(A,B,C,D)
%UNTITLED Summary of this function goes here
t=0:0.1:10;
r=5*ones(size(t));
Xo=[2,0];
sys=ss(A,B,C,D);
[Y,Tsim,X]=lsim(sys,r,t,Xo);
plot(Tsim,Y);
end

