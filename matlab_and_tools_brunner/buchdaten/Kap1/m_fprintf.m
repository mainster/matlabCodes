% Experiment (m_fprintf.m) zum Befehl fprintf

%-------- System 2.Ordnung
b = 1;
a = [1, 0.7, 1];

%-------- Frequenzgang
[H,w] = freqs(b,a);

nr = 1:length(w);
freq_gang = [nr; w'/(2*pi); abs(H'); angle(H')*180/pi];


%-------- Datei mit dem Frequenzgang
fid = fopen('freqg1.dat','w');
fprintf(fid, '     Nr.     Frequenz       Betrag        Phase  \n');
fprintf(fid,' %5.0f %16.8f %11.5f %11.2f \n',freq_gang);
fclose(fid);



