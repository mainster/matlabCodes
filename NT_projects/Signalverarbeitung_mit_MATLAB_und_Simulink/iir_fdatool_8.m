% Programm iir_fdatool_8.m zur Berechnung der 
% Skalierungsfaktoren der Abschnitte des Bandpassfilters,
% das in die FDATool-Umgebung iir_fdatool8.fda entwickelt wurde 
%
% in Hq als Objekt ist das Filter enthalten
% Bandbreite 0,2 bis 0,4 (Nyquist-Bereich)
% Ordnung 8 ergibt vier Abschnitte

syms z

load('quant_filt');    % Für neue Filter muss man immer
% das Filter als Hq Objekt exportieren und danach 
% mit save('quant_filt.mat','Hq'); abspeichern

H1 = (Hq.ReferenceCoefficients{1}{1}(1) + ...
     Hq.ReferenceCoefficients{1}{1}(2)*z^(-1) + ...
     Hq.ReferenceCoefficients{1}{1}(3)*z^(-2))/(...
     Hq.ReferenceCoefficients{1}{2}(1) + ...
     Hq.ReferenceCoefficients{1}{2}(2)*z^(-1) + ...
     Hq.ReferenceCoefficients{1}{2}(3)*z^(-2));

H2 = (Hq.ReferenceCoefficients{2}{1}(1) + ...
     Hq.ReferenceCoefficients{2}{1}(2)*z^(-1) + ...
     Hq.ReferenceCoefficients{2}{1}(3)*z^(-2))/(...
     Hq.ReferenceCoefficients{2}{2}(1) + ...
     Hq.ReferenceCoefficients{2}{2}(2)*z^(-1) + ...
     Hq.ReferenceCoefficients{2}{2}(3)*z^(-2));
 
 H3 = (Hq.ReferenceCoefficients{3}{1}(1) + ...
     Hq.ReferenceCoefficients{3}{1}(2)*z^(-1) + ...
     Hq.ReferenceCoefficients{3}{1}(3)*z^(-2))/(...
     Hq.ReferenceCoefficients{3}{2}(1) + ...
     Hq.ReferenceCoefficients{3}{2}(2)*z^(-1) + ...
     Hq.ReferenceCoefficients{3}{2}(3)*z^(-2));
 
 H4 = (Hq.ReferenceCoefficients{4}{1}(1) + ...
     Hq.ReferenceCoefficients{4}{1}(2)*z^(-1) + ...
     Hq.ReferenceCoefficients{4}{1}(3)*z^(-2))/(...
     Hq.ReferenceCoefficients{4}{2}(1) + ...
     Hq.ReferenceCoefficients{4}{2}(2)*z^(-1) + ...
     Hq.ReferenceCoefficients{4}{2}(3)*z^(-2));
 
 % -------- Amplitudengänge
 fr = 0:0.001:0.5;
 zr = exp(j*2*pi*fr);
 
 H1r = abs(subs(H1, z, zr));
 H2r = abs(subs(H2, z, zr));
 H3r = abs(subs(H3, z, zr));
 H4r = abs(subs(H4, z, zr));

 
 figure(1);   clf;
 plot(fr, 20*log10(H1r)); hold on
 plot(fr, 20*log10(H2r));
 plot(fr, 20*log10(H3r),'r');
 plot(fr, 20*log10(H4r),'r'); 
 plot(fr, 20*log10(H1r)+20*log10(H2r)+20*log10(H3r)+20*log10(H4r),'k');
 hold off
 grid;
 title('Amplitudengaenge der Abschnitte und des Filters');
 xlabel('f/fs');

snorm = 1/max(H1r.*H2r.*H3r.*H4r)  % Skalierungsfaktor für 
% den Fall einer Skalierung am Eingang

% -------- Verteilte Skalierungsfaktoren
snormv = snorm^(1/4);
alpha = ((max(H1r)*max(H2r)*max(H3r)*max(H4r))^(1/4));

s1 = snormv*alpha/max(H1r)
s2 = snormv*alpha/max(H2r)
s3 = snormv*alpha/max(H3r)
s4 = snormv*alpha/max(H4r)

% snorm = s1*s2*s3*s4

% -------- nlm Noise-Loading-Method
figure(2);    clf;
nlm(Hq,1024,10);





 
 
 
 
 