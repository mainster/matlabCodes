 clear all;
clc;
close all
f=50;
 A=5;
Fs=f*100;
Ts=1/Fs;
t=0:Ts:10/f;
x=A*sin(2*pi*f*t);
x1=A*sin(2*pi*(f+50)*t);
x2=A*sin(2*pi*(f+250)*t);
x=x+x1+x2;

p1=figure(1);
subplot(411);
plot(x);grid on;

F=fft(x);

subplot(412);
plot(real(F)),grid on 
N=Fs/length(F);
baxis=(1:N:N*(length(x)/2-1));

subplot(413);
plot(baxis,real(F(1:length(F)/2)))

F2=zeros(length(F),1);
F2(10:11)=F(10:11);
xr=ifft(F2);
subplot(414);
plot(real(xr)),grid on