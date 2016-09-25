% Programm co_1.m zur Konditionierung eines CO-Mess-Signals
% mit Hilfe einer asymmetrischen MRA-Filterbank

clear

% ------- Laden des Signals
load('cs2');   % Signal cs2
ncs2 = length(cs2);

%----------------------------------------------------
figure(1),   clf;
subplot(211), plot(0:ncs2-1, cs2);
title('Mess-Signal');
La = axis; axis([La(1), ncs2-1, La(3:4)]);
xlabel('Sekunden/6'); grid;

% ------- Zerlegung in 6 Stufen
N = 6;
wave_name = 'db4';
[C,L] = wavedec(cs2, N, wave_name);  % Koeffizienten der Zerlegung

a1 = wrcoef('a',C,L, wave_name ,1);  % Approximationskomponente
a2 = wrcoef('a',C,L, wave_name ,2);  
a3 = wrcoef('a',C,L, wave_name ,3);  
a4 = wrcoef('a',C,L, wave_name ,4);  
a5 = wrcoef('a',C,L, wave_name ,5);  
a6 = wrcoef('a',C,L, wave_name ,6);  

d1 = wrcoef('d',C,L, wave_name ,1);  % Detailskomponenten
d2 = wrcoef('d',C,L, wave_name ,2);
d3 = wrcoef('d',C,L, wave_name ,3);
d4 = wrcoef('d',C,L, wave_name ,4);
d5 = wrcoef('d',C,L, wave_name ,5);
d6 = wrcoef('d',C,L, wave_name ,6);

%----------------------------------------------------
figure(2),   clf;
subplot(421), plot(cs2);
La = axis; axis([La(1), ncs2-1, min(cs2), max(cs2)]);
title('Signal');    grid;

subplot(422), plot(a6);
La = axis; axis([La(1), ncs2-1, La(3:4)]);
ylabel('a6');    grid;

subplot(423), plot(d6);
La = axis; axis([La(1), ncs2-1, La(3:4)]);
ylabel('d6');    grid;

subplot(425), plot(d5);
La = axis; axis([La(1), ncs2-1, La(3:4)]);
ylabel('d5');    grid;

subplot(427), plot(d4);
La = axis; axis([La(1), ncs2-1, La(3:4)]);
ylabel('d4');    grid;

subplot(424), plot(d3);
La = axis; axis([La(1), ncs2-1, La(3:4)]);
ylabel('d3');    grid;

subplot(426), plot(d2);
La = axis; axis([La(1), ncs2-1, La(3:4)]);
ylabel('d2');    grid;

subplot(428), plot(d1);
La = axis; axis([La(1), ncs2-1, La(3:4)]);
ylabel('d1');    grid;

% --------- Approximationskomponenten
figure(3),   clf;
subplot(421), plot(cs2);
La = axis; axis([La(1), ncs2-1, min(cs2), max(cs2)]);
title('Signal');    grid;

subplot(423), plot(a1);
La = axis; axis([La(1), ncs2-1, La(3:4)]);
ylabel('a1');    grid;

subplot(425), plot(a2);
La = axis; axis([La(1), ncs2-1, La(3:4)]);
ylabel('a2');    grid;

subplot(427), plot(a3);
La = axis; axis([La(1), ncs2-1, La(3:4)]);
ylabel('a3');    grid;

subplot(424), plot(a4);
La = axis; axis([La(1), ncs2-1, La(3:4)]);
ylabel('a4');    grid;

subplot(426), plot(a5);
La = axis; axis([La(1), ncs2-1, La(3:4)]);
ylabel('a5');    grid;

subplot(428), plot(a6);
La = axis; axis([La(1), ncs2-1, La(3:4)]);
ylabel('a6');    grid;

% -------- Berechnung der Korrelationskoeffizienten zwischen
% den Komponenten
rcoef_sa = corrcoef([cs2,a1,a2,a3,a4,a5,a6]);
rcoef_sd = corrcoef([cs2,d1,d2,d3,d4,d5,d6]);

% -------- Rekonstruktion füŸr die Entfernung 
% der Rauschanteile
% Ermittlung der Koeffizienten
% ca1 = appcoef(C,L,wave_name,1); % Koeff. der Approximation
% ca2 = appcoef(C,L,wave_name,2);
% ca3 = appcoef(C,L,wave_name,3);
% ca4 = appcoef(C,L,wave_name,4);
% ca5 = appcoef(C,L,wave_name,5);
ca6 = appcoef(C,L,wave_name,6);
[cd1, cd2, cd3, cd4, cd5, cd6] = detcoef(C,L,[1,2,3,4,5,6]); % Koeff. der Details

% ---------------------------------
figure(3);   clf;
subplot(411), plot(0:length(cs2)-1,cs2); 
title('Ursprüngliches Signal');
La = axis;   axis([La(1),length(cs2)-1, La(3:4)]);
grid;

subplot(423), plot(0:length(cd1)-1,cd1); 
ylabel('cd1');
pos = get(gca,'Position');  set(gca,'Position',[pos(1:2), pos(3)*1.9, pos(4)]);
La = axis;   axis([La(1),length(cd1)-1, La(3:4)]);
grid;

subplot(425), plot(0:length(cd2)-1,cd2); 
ylabel('cd2');
pos = get(gca,'Position');  set(gca,'Position',[pos(1:2), pos(3)*1.5, pos(4)]);
La = axis;   axis([La(1),length(cd2)-1, La(3:4)]);
grid;

subplot(427), plot(0:length(cd6)-1,cd6); 
ylabel('cd6');
La = axis;   axis([La(1),length(cd6)-1, La(3:4)]);
grid;

subplot(428), plot(0:length(ca6)-1,ca6); 
ylabel('ca6');
La = axis;   axis([La(1),length(ca6)-1, La(3:4)]);
grid;

% --------- UnterdrüŸckung des Rauschens und der Artefakten
% Begrenzung der Details cd6
schwelle = 1.0;
k = find(cd6 > schwelle | cd6 < -schwelle);
cd6(k) = sign(cd6(k))*schwelle; 

% Rekonstruktion mit ca6 und cd6
cd1 = zeros(length(cd1),1);  cd2 = zeros(length(cd2),1);
cd3 = zeros(length(cd3),1);  cd4 = zeros(length(cd4),1);
cd5 = zeros(length(cd5),1);

sr = waverec([ca6;cd6;cd5;cd4;cd3;cd2;cd1],L,wave_name); 

figure(4);    clf;
subplot(211), plot(0:length(cs2)-1,cs2);
title('Ursprüngliches Signal');
%xlabel('Sekunden/6');   
grid;

subplot(212), plot(0:length(sr)-1,sr);
title(['Das aus ca6 und begrenztem cd6 (Schwelle = ',...
        num2str(schwelle),') synthetisierte Signal']);
xlabel('Sekunden/6');   grid;

% --------- UnterdrŸckung des Rauschens und der Artefakten über
% die Funktionen ddencmp und wdencmp

% Bestimmung der Parameter füŸr die signifikanten Werte der Koeffizienten
[thr, sorh, keepapp] = ddencmp('den', 'wv', cs2);

% Rekonstruktion mit diesen Koeffizienten
sr1 = wdencmp('gbl',C,L,wave_name,N,thr,sorh,keepapp);

figure(5);    clf;
subplot(211), plot(0:length(cs2)-1,cs2);
title('Ursprüngliches Signal');
%xlabel('Sekunden/6');   
grid;

subplot(212), plot(0:length(sr1)-1,sr1);
title(['Das über die Funktionen ddencmp und wdencmp synthetisierte Signal ']);
xlabel('Sekunden/6');   grid;


