function [bits, t_bitende]=FSK_Demodulator(bitdauer, mittelwert_momentanfreq, t, momentanfreq , fs, erster_aufruf, sync_angabe);
%%  
%% Beim erstes aufruf des Demodulators eine Flanke in den ersten 7 Bits suchen zum synchronisieren
%% Berechnen wieviel Bit noch vor der Sync_Flanke sein kÖnnten und diese auswerten.
%% Ab der Sync_Flanke werden bis zu nächsten Synchronisation die Bits ausgewerten.
%% Start und Stopbits werden demoduliert und ausgeben.
%%  
%% Bei allen weiteren aufrufen ist der erste Abtastwert das Ende eines Bits, evtl. Flanke
%% Also wird ab diesem Wert demoduliert.


if erster_aufruf==1
    %% Bestimmen der ersten Flanke
    erste_flanken=abs(diff(momentanfreq(1:round(7*bitdauer*fs))))*(fs/(2*pi));	% Flanken der ersten 7 Bits Bestimmen, man müsste dann mindestens eine Flanke(Stop-Startbitwechsel) finden.
    [v index_sync_flanke]=max(erste_flanken);                  						% Flanke zum synchronisien bestimen wird
    clear v erste_flanken;
    t_sync_flanke=t(index_sync_flanke);                         						% Zeitpunkt der sync. Flanke, nicht die erste Flanke bzw. erstes Bit
    clear index_sync_flanke;
    t_erstes_bit=t_sync_flanke-bitdauer*fix(t_sync_flanke/bitdauer);      			% Erstes Bit des Samples
    clear t_sync_flanke;
else
    t_erstes_bit=0;																					% Ab dem zweiten Aufruf kann mit dem ersten Wert demoduliert werden.
end

%% Auswerten aller Bits ab der ersten Flanke, nach 'sync_angabe'-Bits mit der nächsten Flanke synchronisieren
t_bitende=t_erstes_bit;                                     % Anfang des ersten Bits wird als Ende des vorhergehenden Bits gesetzt
n=0;                                                        % Bitzähler
sync=sync_angabe;                                           % sync-Zähler mit gewünschtem Wert setzten        
while t_bitende < t(end)-bitdauer                           % While Schleife, bis alle ganzen Symbole ausgewertet sind
    if sync>0                                               % Wenn sync = 0, auf nächste Flanke synchronisieren
        sync=sync-1;                                        % Bitende bleibt wie berechnet, keine Synchronisation
    else                                                    % Bitende synchronisieren auf die nächste Flanke
        flanke=t((round(t_bitende*fs)-round(bitdauer/2*fs)):(round(t_bitende*fs)+round(bitdauer/2*fs)))'.*(momentanfreq((round(t_bitende*fs)-round(bitdauer/2*fs)):(round(t_bitende*fs)+round(bitdauer/2*fs)))>=mittelwert_momentanfreq);     % Werte bestimmen die 1/2 Bit vor und nach dem berechneten t_bitende über dem Mittelwert der Momentanfreq liegen
        z=find(flanke);                                     % Indizes alle Werte~=0
        if sum(flanke)==0 | length(z)==length(flanke)       % Wenn nur nullen oder nur die Zeitpunkte der Abtastfrequenz in 'flanke' stehen gibt es keinen Bitwechsel.
            t_bitende;                                      % keine Flanke gefunden, weiter demodulieren und es wird bei nächsten Bit nach einer Flanke gesucht.
        else t_flanke=nonzeros(flanke);                     % Nullen entfernen  
            if flanke(1)==0                                 % Bitwechsel von '0' auf '1' 
                t_bitende=t_flanke(1);                      % Bitende ist Zeitpunkt des Flankenwechsels
            else                                            % Bitwechsel von '1' auf '0'
                t_bitende=t_flanke(end);                    % Bitende ist Zeitpunkt des Flankenwechsels
            end
            clear t_flanke 
            sync=sync_angabe-1;                             % Flanke wurde erkannt und Demodulator neu synchronisieret. Sync-Zähler neu setzten.
        end
        clear flanke z
     end
     n=n+1;                                                          % Bitzähler um eins erhöhen
     start_index=fix(t_bitende*fs)+1;                                % Index vom Bitanfang
     t_bitende_neu=t_bitende+bitdauer;                               % Zeitpunkt vom Bitende ausrechnen              
     index_bitende=fix(t_bitende_neu*fs)+1;                          % Index vom Bitende ausrechnen
     auswert_vektor=(momentanfreq((start_index+round(((index_bitende-start_index)/3)/2)):(round((index_bitende-start_index)/3)):index_bitende));      % Auswertvektor, 3-4 Abtastwerte pro Bit
     if sum(auswert_vektor>mittelwert_momentanfreq)>=fix(length(auswert_vektor)/2)+1       % Wenn ein Wert mehr als die Hälfte der Werte über 0 sind
         bits(n)=1;                                                  % ... hat das Bit den Wert '1'
     else bits(n)=0;                                                 % ansonsten den Wert '0'    
     end
     t_bitende=t_bitende_neu;                                        % Bitende = Bitanfang nächstes Bit
end