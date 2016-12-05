function [bitdauer, bitrate, stopbit]=FSK_Bitdauer_schaetzen(fs, momentanfreq, mittelwert_momentanfreq, shift, bitrate, stopbit);
%% Schätzen der Bitdauer und Bitrate über die Häufigkeit der Flankenabstände der Momentanfrequenz
%% Abschätzen ob 1 oder 2 Stopbit, ebenfalls über die Häufigkeit, keine sichere Schätzung.
%% Prüfen auf Häufigkeiten im Bereich der Bitlänge von 1.5 Bit. Sichere Aussage über 1.5 Stopbit.


%% Bestimmen der zeitlichen Abstände der Nulldurchgänge(mittelwert_momentanfreq)
i=1;
k=1;
mf = momentanfreq - mittelwert_momentanfreq;
len = length(mf);
nulldurchgang = zeros(1,length(mf));
while i < len
    while (mf(i)*mf(i+1) > 0) & (i < len-1)
        i=i+1;
    end
    nulldurchgang(k) = i - mf(i)/(mf(i+1) - mf(i)); % lin. Interp.
    k=k+1;
    i=i+1;
end
nulldurchgang = nulldurchgang(1:k-2);
flanken_abstaende = diff(nulldurchgang);

%% Schätzen der Bitdauer
max_dist = max(flanken_abstaende);
min_dist = min(flanken_abstaende);
hist_laenge = round((max_dist-min_dist)/3);
%%hist(delta_t,50)
[N,X] = hist(flanken_abstaende,hist_laenge);                      
[anzahl index]=max(N);

%% Prüfen ob eine Häufigkeit von von delta_t Werten auch bei einer kleiner
%% Zeit(der halben Symboldauer) vorhanden ist
anzahl_ok=anzahl;
index_ok=index;
verhaeltnis_ok=1;
if bitrate==0
    index_2 = index;
    while index_2 > 1                                                      % Prüfen auf Häufigkeiten vor dem Maximalwert
        [anzahl_2 index_2]=max(N(1:index_2-1));                       % Maxima bei kleineren Zeiten bestimmen
        verhaeltnis=X(index)/X(index_2);
        if (anzahl_2 >= (0.25*anzahl)) &  abs(verhaeltnis-round(verhaeltnis))<0.1
            anzahl_ok=anzahl_2;
            index_ok=index_2;
            verhaeltnis_ok=round(verhaeltnis);
        end                                                         % es gibt zwar kleinere Symbollängen, jedoch nicht genügend oft
    end                                                             % keine Häufigkeiten von kleineren Symbollängen vorhanden
    %% Werte bestimmen die im Intervall der Bitdauer liegen
    if index>1                                          
        werte_1=(flanken_abstaende>=(X(index)-((X(2)-X(1))/2)));              % Der Vektor X beinhaltet nicht die Grenzen des Histogramms sondern den Mittelwert der Intervalle
        werte_2=(flanken_abstaende<=(X(index)+((X(2)-X(1))/2)));              %... deshalb muss zu diesen Mittelwerten noch die Hälfte eines Intervall addiert bzw. subtrahiert werden    
        werte_im_intervall=(werte_1 & werte_2).*flanken_abstaende;
        clear werte_1 werte_2
    else
        werte_im_intervall=(flanken_abstaende<=(X(index)+((X(2)-X(1))/2))).*flanken_abstaende;        %% Grenze bestimmen durch Addition des halben Intervalls, da Index=1 gibt es keine kleineren Werte mehr, 
    end                                                                           % ...es genügt nach den Werten zu suchen, die kleiner als die Grenze des ersten Intervalls sind.
    
    %% Mittelwert aus allen delta_t Werten die im Intervall der Symboldauer liegen bilden,  um die Bitdauer zuschätzen.
    bitdauer=mean(nonzeros(werte_im_intervall))/fs/verhaeltnis_ok;   
    bitrate=(1/bitdauer);                          
    clear werte_im_intervall index;
else bitdauer=1/bitrate;
end

if stopbit==0                                                   % Stopbitlänge wurde nicht angegeben und muss bestimmt werden.
    stopbit='1 oder 2';                                         % Wenn Stopbit nicht bekannt wird zunächst angenommen das es 1 oder zwei Stopbits sind.
    % Prüfen auf 1.5 Stopbit
    t_15_bit=1.5*bitdauer;                                      % Länge von 1.5 Bit berechnen
    if t_15_bit<=X(end)+((X(2)-X(1))/2)                         % Prüfen ob es dieser Bereich im Histogramm liegt
        %% Intervall bestimmen in dem t_15_bit liegt
    	index_nonzero=find(X>t_15_bit);         
    	index_15_bit=index_nonzero(1);
    	if (t_15_bit >= X(index_15_bit)-((X(2)-X(1))/2)) & (t_15_bit <= X(index_15_bit)+((X(2)-X(1))/2))
            index_15_bit;
    	else index_15_bit=index_15_bit-1;
    	end
    	%% Werte bestimmen die im Intervall von 1.5 Bit liegen
    	werte_1=(flanken_abstaende>=(X(index_15_bit)-((X(2)-X(1))/2)));              % Der Vektor X beinhaltet nicht die Grenzen des Histogramms sondern den Mittelwert der Intervalle
    	werte_2=(flanken_abstaende<=(X(index_15_bit)+((X(2)-X(1))/2)));              %... deshalb muss zu diesen Mittelwerten noch die Hälfte eines Intervall addiert bzw. subtrahiert werden    
    	werte_im_intervall_15=nonzeros((werte_1 & werte_2).*delta_t);
    	clear werte_1 werte_2
    	if length(werte_im_intervall_15) >0
    	   intervall_mittel_15=mean(werte_im_intervall_15);
    	   if ((intervall_mittel_15/bitdauer)>=1.3) & ((intervall_mittel_15/bitdauer)<=1.7) & (N(index_15_bit)>=3 | N(index_15_bit-1)>=3)
    	      stopbit=1.5;
    	   end
    	end
       clear index_15_bit t_15_bit;
   end
end
clear X N flanken_abstaende;
   