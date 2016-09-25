% Programm fir_fenster3 zum Vergleich zweier FIR-Tiefpassfilter
% entwickelt mit Fenster-Verfahren:
% FIR-Filter mit default Hamming-Fenster und mit Kaiser-Fenster

% --------- FIR-Filter mit Hamming- und Kaiser-Fenster
% entwickelt
nord = 56;  % Ordnung des Filters (Hamming-Fenster)
fr = 0.4;   % Relative Bandbreite (zur Nyquist-Frequenz)  

b = fir1(nord,fr);                 % Default-Fenster

% Kaiser Fenster
ck = kaiserord([fr, 1.45*fr], [1,0], [0.01, 1e-4], 2, 'cell');
%bk = fir1(ck{:});   % mit Kaiser-Fenster
      % ck{1}=nord; ck{2} = fr; ck{3}='low'; 
      % ck{4}=kaiser(nord+1, beta); ck{5}='noscale'
bk = fir1(ck{1}, fr, ck{3:5});      
nk = length(bk)-1;   % Ordnung des Filters mit Kaiser-Fenster

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
legend('Hamming', 'Kaiser',1);
ylabel('dB');
title(['Amplitudengaenge (Ordnung-Default = ',...
  num2str(nord),';']); 

subplot(222),
nd = fix(length(w)/2);

plot(w(1:nd),20*log10([abs(H(1:nd)),abs(Hk(1:nd))]));
La = axis;   axis([La(1:2), -0.05, 0.025]);
xlabel('f/fs');   grid;
legend('Hamming', 'Kaiser',3);
ylabel('dB');
title(['Ordnung-Kaiser = ',num2str(nk),...
        ');   Amplitudengaenge (Ausschnitt)']);

subplot(224),
nd = fix(length(w)/2);

plot(w(1:nd),20*log10([abs(H(1:nd)),abs(Hk(1:nd))]));
La = axis;   axis([La(1:2), -10, 1]);
xlabel('f/fs');   grid;
legend('Hamming', 'Kaiser',3);
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
legend('Hamming', 'Kaiser',1);
ylabel('Grad');
title(['Phasengaenge (Ordnung-Default = ',...
  num2str(nord),'; Ordnung-Kaiser = ',num2str(nk),')']); 

subplot(212),
plot(wg/(2*pi), [Gr, Grk]);
xlabel('f/fs');   grid;
legend('Hamming', 'Kaiser',1);
ylabel('Abtastintervalle');
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

% -------- Verschlechterung der Eigenschaften bei begrenzter Auflösung
% für das kaiser-Filter
nbit = 16;   % Anzahl Bit für die Implementierung in Fest-Komma-Format

% Quantisierung der Koeffizienten
ber = 2^(nbit-1);
bkq = fix(bk*ber)/ber;

[Hkq,w] = freqz(bkq, 1, nf, 1);

figure(4),   clf;
subplot(121),
plot(w, 20*log10([abs(Hk),abs(Hkq)]));
La = axis;   axis([La(1:2), -100, 10]);
xlabel('f/fs');   grid;
legend('Kaiser', 'Kaiser-Quant.',1);
ylabel('dB');
title(['Amplitudengaenge nbit = ',num2str(nbit),'; (Ordnung = ',...
  num2str(nord),')']); 

subplot(222),
nd = fix(length(w)/2);

plot(w(1:nd),20*log10([abs(Hk(1:nd)),abs(Hkq(1:nd))]));
La = axis;   axis([La(1:2), -0.05, 0.025]);
xlabel('f/fs');   grid;
legend('Kaiser', 'Kaiser-Quant.',3);
ylabel('dB');
title(['Amplitudengaenge (Ausschnitt)']);

subplot(224),
nd = fix(length(w)/2);

plot(w(1:nd),20*log10([abs(Hk(1:nd)),abs(Hkq(1:nd))]));
La = axis;   axis([La(1:2), -10, 1]);
xlabel('f/fs');   grid;
legend('Kaiser', 'Kaiser-Quant',3);
ylabel('dB');
title(['Amplitudengaenge (Ausschnitt)']);

% --------Darstellung des Kaiser- und Hamming-Fensters
hamming_b = hamming(nord+1);
wvtool(ck{4}, hamming_b);



