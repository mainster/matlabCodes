% Programm fir_fenster4 zum Vergleich zweier FIR-Bandpassfilter
% entwickelt mit Fenster-Verfahren:
% FIR-Filter mit default Hamming-Fenster und mit Kaiser-Fenster

clear
% --------- FIR-Filter mit Hamming- und Kaiser-Fenster
% entwickelt
nord = 66;  % Ordnung des Filters
fr = [0.4, 0.6];   % Relative Bandbreite (zur Nyquist-Frequenz)  

b = fir1(nord,fr);                 % Default-Fenster

% Kaiser Fenster
[nk,frk,beta,typ]=kaiserord([0.25,fr,0.75],[0,1,0],[1e-4,0.01,1e-4],2);
nk = nord;
bk = fir1(nk, fr, typ, kaiser(nk+1, beta),'noscale'); 

% -- Frequenzgänge Default-Fenster-Filter und Kaiser-Fenster-Filter
nf = 1024;
H = zeros(nf,1);   % Default-Fenster
Hk = zeros(nf,1);  % Kaiser-Filter

[H,w]  = freqz(b, 1, nf, 1);
[Hk,w] = freqz(bk, 1, nf, 1);

figure(1),   clf;
subplot(121),
plot(w, 20*log10([abs(H),abs(Hk)]));
La = axis;   axis([La(1:2), -100, 10]);
xlabel('f/fs');   grid;
legend('Default', 'Kaiser',1);
ylabel('dB');
title(['Amplitudengaenge (Ordnung-Default = ',...
  num2str(nord),';']); 

subplot(222),
nd = fix(nf*[0.9*fr(1), 1.1*fr(2)]);

plot(w(nd(1):nd(2)),20*log10([abs(H(nd(1):nd(2))),abs(Hk(nd(1):nd(2)))]));
La = axis;   axis([La(1:2), -0.05, 0.03]);
xlabel('f/fs');   grid;
legend('Default', 'Kaiser',3);
ylabel('dB');
title(['Ordnung-Kaiser = ',num2str(nk),...
        ');   Amplitudengaenge (Ausschnitt)']);

subplot(224),
nd = fix(nf*[0.9*fr(1), 1.1*fr(2)]);

plot(w(nd(1):nd(2)),20*log10([abs(H(nd(1):nd(2))),abs(Hk(nd(1):nd(2)))]));
La = axis;   axis([La(1:2), -10, 1]);
xlabel('f/fs');   grid;
legend('Default', 'Kaiser',3);
ylabel('dB');
title(['Amplitudengaenge (Ausschnitt)']);

% -- Gruppenlaufzeiten  Default-Fenster-Filter und Kaiser-Fenster-Filter
[Gr,wg] = grpdelay(b,1,nf);
[Grk,wg] = grpdelay(bk,1,nf);

figure(2),   clf;
subplot(211),
plot(w, unwrap([angle(H),angle(Hk)])*180/pi);
%La = axis;   axis([La(1:2), -100, 10]);
xlabel('f/fs');   grid;
legend('Default', 'Kaiser',1);
ylabel('Grad');
title(['Phasengaenge (Ordnung-Default = ',...
  num2str(nord),'; Ordnung-Kaiser = ',num2str(nk),')']); 

subplot(212),
plot(wg/(2*pi), [Gr, Grk]);
xlabel('f/fs');   grid;
legend('Default', 'Kaiser',1);
ylabel('Abtastintervale');
title(['Gruppenlaufzeiten ']);

% -------- Koeffizienten der Filter (Einhaitspulsantworten)
figure(3),    clf;
subplot(211), stem(0:nord, b);
title(['Koeffizienten des Filters entwickelt mit Hamming-Fenster',...
        ' (Ordnung = ',num2str(nord),')']);
xlabel('k');   grid,
La = axis; axis([La(1), nord, La(3:4)]);
subplot(212), stem(0:nk, bk);
title(['Koeffizienten des Filters entwickelt mit Kaiser-Fenster',...
        ' (Ordnung = ',num2str(nk),')']);
xlabel('k');   grid,
La = axis; axis([La(1), nk, La(3:4)]);



