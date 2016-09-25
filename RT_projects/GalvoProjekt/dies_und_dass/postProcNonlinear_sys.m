% Postprocessing PID_self1.mdl
%

t=simoutTime.signals.values;

f1=figure(1);

subplot(4,1,1)
plot(t,sigU.signals.values,'g')
hold on
plot(t,sigY.signals.values,'r')
legend('in u(t)','out y(t)');
hold off
xlabel('time [s]')
ylabel('out')
grid on

subplot(4,1,2)
plot(t,sigU1.signals.values,'g')
hold on
plot(t,2*sigY.signals.values,'b')
plot(t,sigY1.signals.values,'r')
legend('in u(t)','out y(t)');
hold off
xlabel('time [s]')
ylabel('out')
grid on

subplot(4,1,3)
plot(t,torque.signals.values,'b')
legend('Torque (input to powerstage)');
xlabel('time [s]')
ylabel('out')
grid on
%title('Single-Sided Amplitude Spectrum of y(t)')

subplot(414)
plot(t,out_open.signals.values,'g')
%hold on
%plot(t,outW.signals.values,'r')
legend('PT2 out_open (x)');
%hold off
xlabel('time [s]')
ylabel('out open loop')
grid on

Ts=0.00001;
sys1=tf(1,[1e-3 80e-3 1]);
sys1d=c2d(sys1,Ts);