% Postprocessing PID_self1.mdl
%

t=simoutTime.signals.values;

f1=figure(1);

subplot(4,1,1)
plot(t,out.signals.values,'g')
hold on
plot(t,outW.signals.values,'r')
legend('PT2 out (x)','Command (w)');
hold off
xlabel('time [s]')
ylabel('out')
grid on

subplot(4,1,2)
plot(t,error.signals.values,'r')
legend('Error (e)');
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