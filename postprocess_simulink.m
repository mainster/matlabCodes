f10 = figure(10);
set(f10, 'Name', 'simoutGMSKmod');
subplot(3,1,1);
plot(simoutTime.signals.values,simoutOhne.signals.values)
title('Verlauf Re(GMSKmod)');
grid('on');

subplot(3,1,2);
plot(simoutTime.signals.values,simoutPid.signals.values)
title('Verlauf Im(GMSKmod)');
