function [] = fsk_formatierung()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Funktion zum Formatieren des Demodulationsergebnisses
% 1. es wird geprüft, ob invertiert werden muss
% 2. Transparenz-Bits werden entfernt
% 3. alles bis zum ersten Auftreten eines Flags wird abgeschnitten
% 4. es wird Byte-weise umgebrochen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Einlesen der Bits:
% -----------------------
[bit_filename bit_path] = uigetfile('*.txt', 'Auswahl des Demodulationsergebnisses');
stamm = strtok(bit_filename,'.');
transp_filename = [stamm '.transp.txt'];
byte_filename = [stamm '.byte.txt'];

B=textread([bit_path bit_filename],'%c');  
C=B.';  %% transponieren

%% auf Flag überprüfen und ggf. invertieren
invertiert = findstr(C,'10000001');
n_invertiert = findstr(C,'01111110');
if(length(invertiert) > length(n_invertiert))
    for i=1:length(C)
        if(C(i) == '0')
            C(i) = '1';
        else
            C(i) = '0';
        end
    end
end

%% Transparenzbits löschen
pos = findstr(C,'0111110');
B=C;
B(pos+6)='T';  %% B enthält jetzt die Transparenzbits mit T markiert

D=strrep(B,'T','');  %% D ist ohne Transparenzbits

%% zur Inspektion auch dieses schreiben
fid=fopen([bit_path transp_filename],'w');
fprintf(fid,'Vom Demodulator gelieferter (und ggf. invertierter) Datenstrom:\n');
fprintf(fid,'%c',C);
fprintf(fid,'\nMarkierte (T) Transparenz-Bits:\n');
fprintf(fid,'%c',B);
fprintf(fid,'\nDatenstrom ohne Transparenz-Bits:\n');
fprintf(fid,'%c',D);
fclose(fid);
clear fid;

%% Suchen nach dem ersten flag;
pos = findstr(D,'01111110');
E=D(pos(1):end); %% abschneiden;

%% am Ende auch abschneiden
faktor=floor(length(E)/8);
E=E(1:8*faktor);

%% Byteweise ausgeben
F=reshape(E,8,faktor); %% arrangiert spaltenweise
F=F.';
dlmwrite([bit_path byte_filename],F,'');


