% Experiment (m_fscanf.m) zum Befehl fscanf

%-------- Datei für den Frequenzgang
fid = fopen('freqg1.dat','rt');

%-------- Lesen des Kopfs
Kopf = '';
for k = 1:4
   word = fscanf(fid, '%s',1);
   Kopf = [Kopf,' ',word];
end;
H = [];
while 1
   [Ht, count] = fscanf(fid,' %f %f %f %f ', 4);
   H = [H;Ht'];
   if feof(fid), break, end,
end;   
   
fclose(fid);



