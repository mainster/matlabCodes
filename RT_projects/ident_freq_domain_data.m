%__________________________________________________________________________
%
% -------------------------------
% Systemidentifikation mit ident
% -------------------------------
%
% 1.)   AC- analyse eines RLC- Netzwerk in LTSpice R=1k, L=12mH, C=15uF 
% 2.)   Frequenzgang aus plot exportieren und zwar als 
%       komplexe Frequenzfunktion und NICHT phase/betrag
% 3.)   textfile mit importdata in matlab workspace laden
% 4.)   aus re und im eine komplexe frequenzfunktion cpx erstellen
% 5.)   ident GUI starten und Import data -> Freq. Domain data
% 6.)   Freq. Function (Complex) auswählen, cpx bei Freq. Func. eintragen
% 7.)   Frequency vektor eintragen und Unit auf Hz umstellen
% 8.)   Sampling interval auf 0
%
%__________________________________________________________________________

%spiceOut=importdata('RT_projects/GalvoProjekt/spice_exports/OpAmp_LT1028_biased_currentsource_RC.txt',',',1);
%spiceOut=importdata('RT_projects/GalvoProjekt/spice_exports/OpAmp_LT1028_biased_currentsource_RCL.txt',',',1);
spiceOut=importdata('RT_projects/GalvoProjekt/spice_exports/OpAmp_LT1028_biased_currentsource_RCL2.txt',',',1);
freq=spiceOut.data(:,1);
re=spiceOut.data(:,2);
im=spiceOut.data(:,3);

cpx=re+1j*im;       % <------- import this as complex freq. function

f1=figure(1);
subplot(211);
semilogx(freq, 20*log10(abs(cpx)))
grid on;
subplot(212);
semilogx(freq, unwrap(angle(cpx)))
grid on;

ident



