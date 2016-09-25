% Programm nyquist_filt1.m in dem die Zerlegung eines 
% Nyquist-Filters in Polyphasenteilfilter gezeigt wird

L = 4;      % Interpolationsfaktor
nord = 32;  % Ordnung des Filters

% --------- Nyquist-Filter
h = firnyquist(nord,L,.2);

% --------- Zerlegung in Teilfilter
p = firpolyphase(h,L);

% --------- Darstellung der Teilfiltern
figure(1);   clf;
subplot(3,1,1), stem(0:length(h)-1, h);
title('Nyquist-Filter mit nord = 32, L = 4 und roll-off 0.2');

subplot(3,2,3), stem(0:length(p(1,:))-1, p(1,:))
title('Polyphase-Teilfilter 1');

subplot(3,2,4), stem(0:length(p(2,:))-1, p(2,:))
title('Polyphase-Teilfilter 2');

subplot(3,2,5), stem(0:length(p(3,:))-1, p(3,:))
title('Polyphase-Teilfilter 3');

subplot(3,2,6), stem(0:length(p(4,:))-1, p(4,:))
title('Polyphase-Teilfilter 4');
