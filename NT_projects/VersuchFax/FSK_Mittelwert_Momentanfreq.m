function [mittelwert_momentanfreq]=FSK_Mittelwert_Momentanfreq(momentanfreq, fs);
%% Bestimmen des Offsets der Momentanfrequenz, da Schätzung der Trägerfrequenz nicht immer genau ist.

%%Bestimmen des Mittelwertes der Momentanfrequenz im Bereich von 0.2 bis 0.5 sec des 
h=round(0.2*length(momentanfreq));                                          	% Zeit, ab der die Werte der Momentanfrequenz gemittelt werden
m=round(0.5*length(momentanfreq));

schwelle=(max(momentanfreq(h:m))+min(momentanfreq(h:m)))/2;
pegelwerte_plus=nonzeros((momentanfreq(h:m)>schwelle).*momentanfreq(h:m));
pegelwerte_minus=nonzeros((momentanfreq(h:m)<schwelle).*momentanfreq(h:m));

mittelwert_momentanfreq=(mean(pegelwerte_plus)+mean(pegelwerte_minus))/2;
clear m h pegelwerte_minus pegelwerte_plus;
