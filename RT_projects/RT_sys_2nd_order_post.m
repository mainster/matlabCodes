% Postprocessing RT_sys_2nd_order.mdl
%

a=0.1;
b=5;

t=simoutTime.signals.values;

f1=figure(1);

subplot(2,1,1)
plot(t,simout_y.signals.values,'g')
hold on
%plot(t,outW.signals.values,'r')
legend('y(t)');
hold off
xlabel('time [s]')
ylabel('out')
grid on