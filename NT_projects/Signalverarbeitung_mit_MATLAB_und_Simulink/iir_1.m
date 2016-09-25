% Programm iir_1.m, in dem die Entwicklung von IIR-Filtern
% über analog Prototypfilter und Discretisierung am Beispiel 
% von Tiefpassfiltern untersucht wird

% -------- Spezifikation
f_3dB = 1000;      % Durchlassfrequenz
ku = 2;            % Überabtastungsfaktor
nord = 6;          % Ordnung des Filters
fs = ku*2*f_3dB;   % Abtastfrequenz

% -------- Entwicklung der Filter
a = zeros(nord, nord, 5); % Zustandsmatrizen für die 
                          % Beschreibung der Filter
b = zeros(nord,1,5);    c = zeros(1,nord,5);
d = zeros(1,1,5);

% Bessel Filter
[z,p,k] = besselap(nord);   % Prototypfilter
[A,B,C,D] = zp2ss(z,p,k);   % Null- Polstellen Transformation in
                            % Zustandsmodell 
[a(:,:,1),b(:,:,1),c(:,:,1),d(:,:,1)]=...
    lp2lp(A,B,C,D,2*pi*f_3dB);

% Butterworth Filter
[z,p,k] = buttap(nord);   % Prototypfilter
[A,B,C,D] = zp2ss(z,p,k);
[a(:,:,2),b(:,:,2),c(:,:,2),d(:,:,2)]=...
    lp2lp(A,B,C,D,2*pi*f_3dB);

% Tschebyschev Typ I Filter
Rp = 0.1;    % Welligkeit im Durchlassbereich
[z,p,k] = cheb1ap(nord, Rp);   % Prototypfilter
[A,B,C,D] = zp2ss(z,p,k);
[a(:,:,3),b(:,:,3),c(:,:,3),d(:,:,3)]=lp2lp(A,B,C,D,2*pi*f_3dB);

% Tschebyschev Typ II Filter
Rs = 60;    % Welligkeit im Sperrbereich
[z,p,k] = cheb2ap(nord, Rs);   % Prototypfilter
[A,B,C,D] = zp2ss(z,p,k);
[a(:,:,4),b(:,:,4),c(:,:,4),d(:,:,4)]=lp2lp(A,B,C,D,2*pi*f_3dB);

% Elliptisches Filter
[z,p,k] = ellipap(nord, Rp, Rs);   % Prototypfilter
[A,B,C,D] = zp2ss(z,p,k);
[a(:,:,5),b(:,:,5),c(:,:,5),d(:,:,5)]=lp2lp(A,B,C,D,2*pi*f_3dB);

% -------- Frequenzgänge der Analogfilter
f = logspace(log10(floor(f_3dB/10)),...
             log10(ceil(f_3dB*10)), 1000); % Frequenzbereich
w = f*2*pi;       nf = length(f);

H = zeros(nf,5);
for k = 1:5,
    [zaehler,nenner]=ss2tf(a(:,:,k),b(:,:,k),c(:,:,k),d(:,:,k));
    H(:,k) = freqs(zaehler, nenner, w).';
end;

figure(1),   clf;
semilogx(f, 20*log10(abs(H)));
title(['Amplitudengaenge der analogen Filter (Ordnung = ',...
        num2str(nord),'; f\_3dB = ',num2str(f_3dB),' Hz)']);
xlabel('Hz');    grid;
La = axis;    axis([La(1:2), -100, 10]);

% -------- Diskretisierung über das Impulsinvarinz-Verfahren
zaehler = zeros(5, nord+1, 2); % Speicher für die Koeffizienten
nenner  = zeros(5, nord+1, 2); % der diskreten Filter

nf = 1000;
H = zeros(nf,5);
Gr = H;

for k = 1:5,
    [bz,az]=ss2tf(a(:,:,k),b(:,:,k),c(:,:,k),d(:,:,k));
    [zaehler(k,:,1), nenner(k,:,1)] = impinvar(bz, az, fs); 
                        % Diskretisierung
    H(:,k) = freqz(zaehler(k,:,1), nenner(k,:,1), nf, 'whole');
    Gr(:,k) = grpdelay(zaehler(k,:,1), nenner(k,:,1), nf, 'whole'); 
end;

figure(2),   clf;
subplot(211);
plot((0:nf-1)*fs/nf, 20*log10(abs(H)));
title(['Amplitudengaenge der digitalen IIR-Filter ',...
        'mit Impulsinvarianz-Verfahren (Ordnung = ',...
        num2str(nord),'; f\_3dB = ',num2str(f_3dB),' Hz)']);
xlabel('Hz');    grid;
La = axis;    axis([La(1:2), -50, 20]);

subplot(212);
plot((0:nf-1)*fs/nf, Gr/fs);
xlabel('Hz');    grid;
title('Gruppenlaufzeit');
ylabel('Sekunden');

% -------- Diskretisierung über die Bilineare-Transformation
nf = 1000;
H = zeros(nf,5);
Gr = H;
for k = 1:5,
    [az,bz,cz,dz]=bilinear(a(:,:,k),b(:,:,k),c(:,:,k),...
        d(:,:,k),fs,f_3dB); % Diskretisierung
    [zaehler(k,:,2),nenner(k,:,2)] = ss2tf(az, bz, cz, dz);
    H(:,k) = freqz(zaehler(k,:,2),nenner(k,:,2), nf, 'whole');
    Gr(:,k) = grpdelay(zaehler(k,:,2),nenner(k,:,2), nf, 'whole'); 
end;

figure(3),   clf;
subplot(211);
plot((0:nf-1)*fs/nf, 20*log10(abs(H)));
title(['Amplitudengaenge der digitalen IIR-Filter ',...
        'mit Bilineare-Transformation (Ordnung = ',...
        num2str(nord),'; f\_3dB = ',num2str(f_3dB),' Hz)']);
xlabel('Hz');    grid;
La = axis;    axis([La(1:2), -100, 20]);

subplot(212);
plot((0:nf-1)*fs/nf, Gr/fs);
xlabel('Hz');    grid;
title('Gruppenlaufzeit');
ylabel('Sekunden');




