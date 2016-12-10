% #########################################################################
% #                    FSK-Demodulator-v2004.07.26                        #
% #                    ===========================                        #
% # Der FSK-Demodulator entstand im Rahmen einer Studienarbeit von        #
% # Manuel Klein - 2003. Erweiterungen bzw. Vereinfachungen fuer den      #
% # Laborversuch wurden 2004 im Rahmen der Studienarbeit von Rüdiger      #
% # Hoffmann durchgeführt.                                                #
% #                                                                       #
% # Anwendung:                                                            #
% #     - Auswerten von 2-FSK-Signale                                     #
% #     - Stopbitlänge 1, 1.5 oder 2                                      #
% #     - Code: ITA2   (Baudot-Code)                                      #
% #########################################################################
function [] = fsk_demod()

% #########################################################################
% #                            Parameter                                  #
% #########################################################################
% Eingabe der Parameter des 2-FSK-Signals
% ---------------------------------------
% Hier können die Parameter wie Trägerfrequenz, Shift, Symbolfrequenz und die
% Anzahl der Stopbits angegeben werden. Sind diese Werte nicht bekannt, so
% werden sie vom Demodulator selbst bestimmt. Es sind dann die entsprechenden 
% Default-Werte einzutragen!
carrier_frequency=1750;     %% default: 0
shift=100;                   %% default: 0
bitrate=0;                %% default: 0

anzahl_stopbits=1;          %% default: 0
% Synchronisation des Demodulators (für Faxversuch uninteressanter Parameter)
% ---------------------------------------------------------------------------
% Nach wieviel demodulierten Bits soll sich der Demodulator auf die nächste
% Flanke synchronisieren ? z.B. sync=20 => Synchronisation nach 20 Bits bei
% 1 und 2 Stopbits. Bei 1.5 Stopbit erfolgt die Synchronisation beim Stop-
% Startbit-Wechsel.Mit sync=20, synchronisiert sich der Demodulator dann bei
% jedem 3. Stop-Startbit-Wechsel. Ist die Schätzung der Bitdauer zu ungenau,
% sollte die Synchronisation häufiger erfolgen. Default: sync=20;
sync_angabe=16;


% Quelldatei im wav-Format (Windows PCM):
% ---------------------------------------
[wav_filename wav_path] = uigetfile('*.wav', 'Auswahl der wav-Datei');
datei = [wav_path wav_filename];
stamm = strtok(wav_filename,'.');

% Ausgabedatei für die demodulierten Bits (ASCII):
% ------------------------------------------------
bit_ausgabe=[wav_path stamm '.bits.txt'];




% #########################################################################
% #             Programmroutinen des FSK-Demodulators                     #
% #########################################################################

% 1. Dauerbetrieb
%  ---------------
%  A) 2 sec. einlesen und Parameter bestimmen
%  B) Diese 2 sec. demodulieren
%  C) In Dauerbetieb schalten, d.h. Schleife: Daten einlesen -> demodulieren
%     Demodulierte Bits werden in eine Datei (var:'bit_ausgabe') gespeichert.

% 2. Abtastwerte lesen
% ------------------
[siz]=wavread(datei,'size');                % Bestimmen der Länge des Samples
[data,fs]=wavread(datei,[1 2]);		        % y=sampled data, sample frequency, 
if siz(1)>2*fs                              % Wenn sample größer als 2 Sekunden ist, wird es in Stücken demoduliert.
    [data,fs]=wavread(datei,[1 (2*fs)]);	% y=sampled data, sample frequency, 2sec = 2*sample frequency
else [data,fs]=wavread(datei);              % ganzes sample einlesen
end

%% carrier frequency and shift 
if carrier_frequency==0 | shift==0
   [carrier_frequency, shift]=FSK_Traeger_schaetzen(data,fs,carrier_frequency,shift)
end

% 3. Bandpaß-Tiefpaß Transformation des eingelesenen Samples
% ----------------------------------------------------------
% -> abmischen bzw. runtermischen ins komplexe Basisband
data_abgemischt=data.*exp(-j*2*pi*carrier_frequency/fs*(1:length(data))');
clear data;

% -> Filterung des heruntergemischten Signals mit Tiefpass
%    = Komplexes Basisbandsignal
% Zi : Anfangebedingungen für den Filter
% Zf : Endwerte des Filters, dienen als Anfangsbedingungen, 
%      wenn das nächstemal ein neues Stück vom Sample Transformiert wird
[zaehler_BP_TP, nenner_BP_TP] = cheby1(6,0.5,carrier_frequency/fs); 
Zi_BP_TP=zeros(1,6);							            % Beim ersten Durchgang gib es keine Anfangsbedingungen
[aequi_tp, Zf_BP_TP] = filter(zaehler_BP_TP, nenner_BP_TP, data_abgemischt, Zi_BP_TP);
Zi_BP_TP=Zf_BP_TP;								            % Endzustand ist neuer Anfangszustand für die nächste Filterung
clear data_abgemischt data Zf_BP_TP;

%% Rauschen am Anfang beseitigen mit billiger Pegelschwelle
%% Lesitung in den ersten 10% des Signals schaetzen
huellkurve = abs(aequi_tp(1:fix(0.1*length(aequi_tp))));    % Berechnen der Hüllkurve
leistung_anfang = mean(huellkurve);                         % Mittlere Leistung
index = find(huellkurve > 0.5*leistung_anfang);             % Index bestimmen, bei dem die Hüllkurve das 
                                                            % erste mal die Mittlere Leistung überschreitet.
%% "Rauschen" abschneiden:                                              
aequi_tp = aequi_tp(index(1):end);                          % Werte weglassen, die vor dem Index liegen, bei
                                                            % dem das Signal das erstemal die Mittlere Leistung erreicht.
clear huellkurve leistung_anfang index;

% 4. Phase des äquivalenten Tiefpaßsignals
% ----------------------------------------
phase_tp_unwrap=unwrap(angle(aequi_tp));                    % unwrap um Phasensprunge durch arctan zu vermeiden		
clear aequi_tp

% 5. Momentanfrequenz bestimmen, d.h. ableiten der Phase nach der Zeit
% --------------------------------------------------------------------
momentanfreq=diff(phase_tp_unwrap)*(fs/(2*pi));
clear phase_tp_unwrap;

% 6. Zeitskala bilden
% -------------------
t=0:1/fs:1/fs*(length(momentanfreq)-1);

% 7. Filtern der Momentanfrequenz mit B=4*shift
% ---------------------------------------------
linienabst=2*shift;
[zaehler_mf, nenner_mf] = cheby1(6,0.5,2*linienabst/(0.5*fs));      % Grenzfrequenz ist bezogen auf fs/2
Zi_mf=zeros(1,6);
[momentanfreq, Zf_mf] = filter(zaehler_mf, nenner_mf, momentanfreq, Zi_mf);
Zi_mf=Zf_mf;
clear Zf_mf;

% 8. Bestimmen des Mittelwertes der Momentanfreqenz
% -------------------------------------------------
clear mittelwert_momentanfreq										% Löschen der Variablen, da bei zweimaligem
                                                                    % Aufruf Probleme auftreten, da Variable
                                                                    % und Funktion den gleichen Namen haben
[mittelwert_momentanfreq]=FSK_Mittelwert_Momentanfreq(momentanfreq, fs);

% 9. Bitdauer, Bitrate abschätzen und auf 1.5 Stopbit prüfen
% ----------------------------------------------------------
if bitrate==0 | anzahl_stopbits==0
   [bitdauer, bitrate, anzahl_stopbits]=FSK_Bitdauer_schaetzen(fs, momentanfreq, mittelwert_momentanfreq, shift, bitrate, anzahl_stopbits);
else bitdauer=1/bitrate;
end

% 9a. Ausgabe der Parameter der Demodulation; jetzt sind sie alle bestimmt
%-------------------------------------------------------------------------
param_ausgabe=sprintf('\nDemodulation von %s', datei);
disp(param_ausgabe); clear param_ausgabe;
param_ausgabe=sprintf('Ausgabe der demodulierten Daten nach %s', bit_ausgabe);
disp(param_ausgabe); clear param_ausgabe;
param_ausgabe=sprintf('\nMittenfrequenz=%dHz\nShift=%dHz\nSymbolfrequenz=%dHz\n',carrier_frequency,shift,bitrate);
disp(param_ausgabe); clear param_ausgabe;

% 10. Unterabtastung
% ------------------
% Berechnen der Unterabtastung
fs_gewuenscht=9*bitrate;                                            % Pro Bit sollen nur noch 9 Abtastwerte vorhanden sein.
faktor_UA=round(fs/fs_gewuenscht);                                  % Faktor der Unterabtastung, muss ganzahlig sein.
clear fs_gewuenscht                                     
fs_UA=fs/faktor_UA;                                                 % Bestimmen der neuen Sample Frequency

%% Reduzieren der Datenmenge (Dezimierung)
momentanfreq=momentanfreq(1:faktor_UA:end);                         % Werte der Momentanfrequenz reduzieren
t=t(1:faktor_UA:end);                                               % Neu Zeitachse bestimmen

% 11. Momentanfrequenz demodulieren.
% ----------------------------------
% Der Vektor 'bits' enthält die demodulierten Daten mit Stop- und Startbits.
if anzahl_stopbits==1.5
    [bits, t_bitende, bits_nach_letztem_SB,momentanfreq_invertieren]=fsk_demodulator_15(bitdauer, mittelwert_momentanfreq, t, momentanfreq , fs_UA, 0, 1, sync_angabe);
else [bits, t_bitende]=FSK_Demodulator(bitdauer,mittelwert_momentanfreq, t, momentanfreq, fs_UA, 1, sync_angabe);
    momentanfreq_invertieren=0;                                     % Invertierung wird nur bei 1.5 Stopbits
                                                                    % erkannt und wird deshalb bei 1 oder 2
                                                                    % Stopbit auf 0 gesetzt.
end

%% Rest bestimmen der nicht demoduliert werden konnte
index_rest=fix(t_bitende*fs_UA)+1;                
momentanfreq_rest=momentanfreq(index_rest:end);                     % Restlichen Werte bestimmen die bei
                                                                    % nächsten Stück mit verarbeitet werden müssen.

clear momentanfreq mittelwert_momentanfreq t_bitende index_rest;    % Variablen "aufräumen"

% 12. Bits in Datei speichern
% ---------------------------
fid=fopen(bit_ausgabe,'w');
fprintf(fid,'%1u',bits);
fclose(fid);
clear bits fid;

% 13. Schleife: neues Datenstück einlesen und auswerten.
% ------------------------------------------------------
%% Weitere Daten vorhanden ?
if siz(1)>2*fs
    h=2*fs;                                 % Ende letztes Samplestück
    while h<siz(1)
        if h>(siz(1)-2*fs)                  % Prüfen ob noch mehr als 2 Sekunden vom Sample übrig sind
            laenge_pakete=(siz(1)-h);       % restliche Werte demodulieren
        else laenge_pakete=2*fs;            % Samplestück von 2 Sekunden demodulieren
        end
        %% Daten einlesen
        [data,fs]=wavread(datei,[(h+1) (h+laenge_pakete)]);		% y=sampled data, sample frequency, 2sec = 2*sample frequency
    
        %% BP-TP-Transformation mit alten Filterwerten als Anfangsbedingung
        %% abmischen:
        data_abgemischt=data.*exp(-j*2*pi*carrier_frequency/fs*(1:length(data))');
	    clear data;
	 
     	%% filtern:
        [aequi_tp, Zf_BP_TP] = filter(zaehler_BP_TP, nenner_BP_TP, data_abgemischt, Zi_BP_TP);
        Zi_BP_TP=Zf_BP_TP;
    	clear data_abgemischt data Zf_BP_TP; 
	 
    	%% Phase des äquivalenten Tiefpaßsignals:
	    phase_tp_unwrap=unwrap(angle(aequi_tp));		
	    clear aequi_tp
    	 
    	% Momentanfrequenz bestimmen, ableiten der Phase nach der Zeit
        momentanfreq=diff(phase_tp_unwrap)*(fs/(2*pi));
 	    clear phase_tp_unwrap;
	 
	    %% Filtern der Momentanfrequenz mit B=4*shift
	    [momentanfreq, Zf_mf] = filter(zaehler_mf, nenner_mf, momentanfreq, Zi_mf);
        Zi_mf=Zf_mf;
        clear Zf_mf;
    
	    %% Bestimmen des Mittelwertes der Momentanfreqenz:
	    [mittelwert_momentanfreq]=FSK_Mittelwert_Momentanfreq(momentanfreq, fs);
     
        %% Unterabtastung:
        momentanfreq=momentanfreq(1:faktor_UA:end);

        %% Momentanfrequenz invertieren wenn erforderlich
        if momentanfreq_invertieren==1
            momentanfreq=momentanfreq*-1;
        end
        
        %% Altes Stück Momentanfrequenz (welches beim letztenmal nicht ausgewertet werden konnte) vor neues Stück hängen.
        momentanfreq_neu=[momentanfreq_rest;momentanfreq];
        t=0:1/fs_UA:(1/fs_UA)*(length(momentanfreq_neu)-1);
        momentanfreq=momentanfreq_neu;
        clear momentanfreq_neu;
    
        %% Demodulation:
        if anzahl_stopbits==1.5
            [bits, t_bitende, bits_nach_letztem_SB]=fsk_demodulator_15(bitdauer, mittelwert_momentanfreq, t, momentanfreq , fs_UA, bits_nach_letztem_SB, 0, sync_angabe);
        else [bits, t_bitende]=FSK_Demodulator(bitdauer,mittelwert_momentanfreq, t, momentanfreq, fs_UA, 0, sync_angabe);
        end
        
        index_rest=fix(t_bitende*fs_UA)+1;        
        momentanfreq_rest=momentanfreq(index_rest:end);                 % Restlichen Werte bestimmen die bei nächsten Stück mit verarbeitet werden müssen.
        
       	clear mittelwert_momentanfreq t_bitende index_rest;
    
        %% Bits in Datei speichern
        fid=fopen(bit_ausgabe,'a');
        fprintf(fid,'%1u',bits);
        fclose(fid);
        h=h+2*fs;
        clear bits fid;
    end
    clear h laenge_pakete;
end
clear siz t nenner* zaehler* Zi* fs* faktor_UA momentanfreq* bits_nach_letztem_SB sync_angabe;
disp('Demodulation beendet.');
