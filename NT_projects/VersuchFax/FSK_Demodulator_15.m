function [bits, t_bitende, bits_nach_letztem_SB, momentanfreq_invertieren]=fsk_demodulator_15(bitdauer, mittelwert_momentanfreq, t, momentanfreq , fs, bits_nach_letztem_SB, erster_aufruf, sync_angabe)
%%
%%  Ersten Stop-Startbitwechsel bestimmen.
%%  Erkennung ob Bits invertiert gesendet, d.h. '1' entspricht hohe Freq. und '0'= tiefe Freq. vertauscht 
%%  Bits vor erstem Stopbit auswerten, dann die nächsten 4 Symbole, 
%%  immer nach 4 Symbolen auf den Stop-Startbitwechsel synchronisieren.
%%  Start- und Stopbit als je 1 Bit ausgeben.
%%

n=0;                                                    % Zähler Bitvektor
if erster_aufruf==1
    %% Bestimmen des ersten Stop-Startbit-Wechsels
    symboldauer=7.5*bitdauer;
    loops=fix((t(end))/symboldauer);                    % Berechnen wie viele Symbole in dem audio sample enthalten sind
    if loops >=21                                       % Maximale Anzahl von Symbolen festlegen die auf addiert werden
        loops=21;
    end
      
    h=1;
    t_flanken=(t(1):symboldauer:loops*symboldauer);     % Berechnen der Zeitabstände von Symbollänge zu Symbollänge
    index_flanken=fix(t_flanken*fs)+1;                  % Bestimmen der Indizies der Zeitpunkte
    index_abstand=diff(index_flanken);                  % Abtsände zwischen den Indizies berechnen
    werte=zeros(max(index_abstand)+1,1);                % Vektor für die Abtastwerte die addiert werden sollen
       
    while h<loops                                       % Abtastwerte von maximal 20 Symbolen aufaddieren
        werte(1:index_abstand(h)+1)=werte(1:index_abstand(h)+1)+momentanfreq(index_flanken(h):index_flanken(h+1));
        h=h+1;
    end
     
    clear h loops;
        
    flanken_stopbit=diff(werte(1:end-1))*(fs/(2*pi));       % letzten Wert weglassen da nicht bei jedem Symbolvorhanden (Schlupf)
    [v_min index_15_SSB_min]=min(flanken_stopbit);                  % da Flanke von '1' auf '0' wechselt, muss das Minimum gesucht werden
    [v_max index_15_SSB_max]=max(flanken_stopbit);                  % wenn invertiert gesendet wird muss das Maximum bestimmt werden!
    if abs(v_min)>abs(v_max)                                % größeren Wert bestimmen
        index_15_SSB=index_15_SSB_min;                      % Minimum weist auf nichtinvertierte Bits hin
        momentanfreq_invertieren=0;
    else index_15_SSB=index_15_SSB_max;                     % Maximum weist auf invertierte Bits hin
        momentanfreq=momentanfreq*-1;                       % Momentanfrequenz mit -1 multiplizieren
        momentanfreq_invertieren=1;                         % künftige momentanfrequenzen invertieren
    end
    clear v_min index_15_SSB_min v_max index_15_SSB_max;
    t_erstes_15_SSB=t(index_15_SSB);
    clear v flanken_stopbit werte index_abstand index_SSB t_flanken index_flanken index_15_SSB;
    
    %% Anzahl Bits vor erstem Stopbit bestimmen und Zeitpunkt des ersten Bits ausrechnen
    anzahl_bits_vor_SB=fix((t_erstes_15_SSB-1.5*bitdauer)/bitdauer);
    if anzahl_bits_vor_SB<0															% Keine Bits vor dem Stopbit und 1.Stopbit nicht vollständig empfangen.
       t_bitende=t_erstes_15_SSB;													% Demodulation ab dem ersten Stop-Startbit-Wechsel
       momentane_bitdauer=bitdauer;													% zu demodulierende Bitdauer gleich 1*Bitdauer
    elseif anzahl_bits_vor_SB==0														% Keine Bits vor dem Stopbit!
       t_bitende=t_erstes_15_SSB-1.5*bitdauer;									% Das Stopbit ist zu demodulieren
       momentane_bitdauer=1.5*bitdauer;		       							% zu demodulierende Bitdauer gleich 1.5*Bitdauer
    else t_bitende=t_erstes_15_SSB-1.5*bitdauer-anzahl_bits_vor_SB*bitdauer;	% es sind Bits vor dem 1. Stopbit. Zeitpunkt des ersten Bits berechnen
    momentane_bitdauer=bitdauer;   													% zu demodulierende Bitdauer gleich 1*Bitdauer 
    end

%    if anzahl_bits_vor_SB>0           									         % Prüfen ob Bits vorm ersten Stopbit sind
 %       momentane_bitdauer=bitdauer;                                    % 
  %  else momentane_bitdauer=1.5*bitdauer;                               % Wenn nicht muss mit der Bitdauer von 1.5 Bit begonnen werden.
   % end
    while t_bitende < t_erstes_15_SSB                                   % While Schleife, solange bis die ersten Bits und das erste Stopbit ausgewertet sind.
        n=n+1;                                                          % Bitzähler um eins erhöhen.
        start_index=fix(t_bitende*fs)+1;                                % Index vom ersten Bit berechnen
        t_bitende_neu=t_bitende+momentane_bitdauer;                               % Zeitpunkt vom Bitende ausrechnen, bei letzten Durchlauf ist t_bitende=t_anfang_stopbit
        index_bitende=fix(t_bitende_neu*fs)+1;                          % Index vom Bitende ausrechnen
        auswert_vektor=(momentanfreq((start_index+(round(((index_bitende-start_index)/3)/2))):(round((index_bitende-start_index)/3)):index_bitende));      % Auswertvektor, 3-4 Abtastwerte pro Bit
        if sum(auswert_vektor>mittelwert_momentanfreq)>=fix(length(auswert_vektor)/2)+1       % Wenn ein Wert mehr als die Hälfte der Werte über 0 sind
            bits(n)=1;                                                  % ... hat das Bit den Wert '1'
        else bits(n)=0;                                                 % ansonsten den Wert '0'    
        end
        if n==anzahl_bits_vor_SB
            momentane_bitdauer=1.5*bitdauer;
        end
            t_bitende=t_bitende_neu;
    end 
    momentane_bitdauer=bitdauer;
    sync=round(sync_angabe/7); 														% Zähler für Synchronisation
else t_bitende=0;
    sync=0;																					% Demodulator wird mit beim ersten Stop-Startbit-Wechsel des neuen Teilstückes synchronisiert.
    if bits_nach_letztem_SB==6	
        momentane_bitdauer=1.5*bitdauer;
    else momentane_bitdauer=bitdauer;
    end
end

%% Bits nach dem ersten bis zum letzten Stopbit auswerten
k=bits_nach_letztem_SB;                                             % Zähler der Bits zwischen Stopbits
while t_bitende < t(end)-momentane_bitdauer
    n=n+1;                                                          % Bitzähler um eins erhöhen.
    if k==7
        k=0;
        sync=sync-1;
        if sync>0    
            t_bitende;                                         % Bitende bleibt wie berechnet, keine Synchronisation
        else                                                   % Bitende synchronisieren auf die Flanke des Stop-Startbits
            start=(1+fix(t_bitende*fs)-(1+fix(bitdauer/2*fs)));
            if start<1
                start=1;
            end
            werte_1=(t(start:(1+fix(t_bitende*fs)+(fix(bitdauer/2*fs))))'.*(momentanfreq(start:((1+fix(t_bitende*fs))+(fix(bitdauer/2*fs))))>=mittelwert_momentanfreq));     % Werte bestimmen die 1/2 Bit vor und nach dem berechneten t_bitende liegen
            werte_1=nonzeros(werte_1);
            if length(werte_1)==0
                sync=0;
            else t_bitende=werte_1(end);                    % da Stop-Startbit-Wechsel von 1 auf 0, ist der letzte Wert der letzte Zeitpunkt des Stopbits
                sync=round(sync_angabe/7);                    
            end            
            clear werte_1;
        end
    end
    k=k+1;
    start_index=fix(t_bitende*fs)+1;                                % Index vom ersten Bit berechnen
    t_bitende_neu=t_bitende+momentane_bitdauer;                               % Zeitpunkt vom Bitende ausrechnen, bei letzten Durchlauf ist t_bitende=t_anfang_stopbit
    index_bitende=fix(t_bitende_neu*fs)+1;                          % Index vom Bitende ausrechnen
    auswert_vektor=(momentanfreq((start_index+(round(((index_bitende-start_index)/3)/2))):(round((index_bitende-start_index)/3)):index_bitende));      % Auswertvektor, 3-4 Abtastwerte pro Bit
    if sum(auswert_vektor>mittelwert_momentanfreq)>=fix(length(auswert_vektor)/2)+1       % Wenn ein Wert mehr als die Hälfte der Werte über 0 sind
        bits(n)=1;                                                  % ... hat das Bit den Wert '1'
    else bits(n)=0;                                                 % ansonsten den Wert '0'    
    end
    if k==6
        momentane_bitdauer=bitdauer*1.5;                % momentane Bitdauer= 1.5 Bit
    else momentane_bitdauer=bitdauer;                   % momentane Bitdauer= 1Bit
    end
    t_bitende=t_bitende_neu;
end 
bits_nach_letztem_SB=k;                                 % Bits nach letztem Stopbit
clear k n momentane_bitdauer sync t_erstes_15_SSB auswert_vektor;