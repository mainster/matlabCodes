% postprocessing GSM_sim.mdl
%

lp = [0:1:length(simoutGMSKmod.signals.values)-1];
fc = 1;  % Carier frequence 


% Plot Re() Im() angle()
f10 = figure(10);
set(f10, 'Name', 'simoutGMSKmod');
subplot(3,1,1);
plot(simoutTime.signals.values,real(simoutGMSKmod.signals.values))
title('Verlauf Re(GMSKmod)');
grid('on');

subplot(3,1,2);
plot(simoutTime.signals.values,imag(simoutGMSKmod.signals.values))
title('Verlauf Im(GMSKmod)');

subplot(3,1,3);
plot(simoutTime.signals.values,angle(simoutGMSKmod.signals.values).*(180/pi))
title('Verlauf arg(GMSKmod)');

f13 = figure(13);
set(f13, 'Name', 'simoutGMSKmod Signal');
inphase=cos(angle(simoutGMSKmod.signals.values));
quadratur=sin(angle(simoutGMSKmod.signals.values));
%plot(simoutTime.signals.values,real(simoutGMSKmod.signals.values)+imag(simoutGMSKmod.signals.values))
%plot(simoutTime.signals.values,abs(simoutGMSKmod.signals.values))
modSig=sin(2*pi*fc*simoutTime.signals.values).*inphase+cos(2*pi*fc*simoutTime.signals.values).*quadratur;
plot(simoutTime.signals.values,modSig)
title('Verlauf m(t)=cos(2*pi*fc*t)*I(t)+sin(2*pi*fc*t)*Q(t)');

f11 = figure(11);
set(f11, 'Name', 'simoutMSKmod');
subplot(3,1,1);
plot(simoutTime.signals.values,real(simoutMSKmod.signals.values))
title('Verlauf Re(MSKmod)');

subplot(3,1,2);
plot(simoutTime.signals.values,imag(simoutMSKmod.signals.values))
title('Verlauf Im(MSKmod)');
subplot(3,1,3);
plot(simoutTime.signals.values,angle(simoutMSKmod.signals.values).*(180/pi))
title('Verlauf arg(MSKmod)');

f122 = figure(122);
set(f11, 'Name', 'simoutGMSKmod Hüll');
plot(simoutTime.signals.values,abs((modSig)))
title('Hüllkurve modSig');


f12 = figure(12);
set(f11, 'Name', 'simoutBPSKmod');
plot(simoutTime.signals.values,real(simoutBPSKmod.signals.values))
title('Verlauf Re(BPSKmod)');

subplot(3,1,2);
plot(simoutTime.signals.values,imag(simoutBPSKmod.signals.values))
title('Verlauf Im(BPSKmod)');
subplot(3,1,3);
plot(simoutTime.signals.values,angle(simoutBPSKmod.signals.values).*(180/pi))
title('Verlauf arg(BPSKmod)');