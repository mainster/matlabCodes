function [bitdauer, bitrate, stopbit]=FSK_Bitdauer_schaetzen(fs, momentanfreq, mittelwert_momentanfreq, shift, bitrate, stopbit);
%% Sch�tzen der Bitdauer und Bitrate �ber die H�ufigkeit der Flankenabst�nde der Momentanfrequenz
%% Absch�tzen ob 1 oder 2 Stopbit, ebenfalls �ber die H�ufigkeit, keine sichere Sch�tzung.
%% Pr�fen auf H�ufigkeiten im Bereich der Bitl�nge von 1.5 Bit. Sichere Aussage �ber 1.5 Stopbit.


%% Bestimmen der zeitlichen Abst�nde der Nulldurchg�nge(mittelwert_momentanfreq)
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

%% Sch�tzen der Bitdauer
max_dist = max(flanken_abstaende);
min_dist = min(flanken_abstaende);
hist_laenge = round((max_dist-min_dist)/3);
%%hist(delta_t,50)
[N,X] = hist(flanken_abstaende,hist_laenge);                      
[anzahl index]=max(N);

%% Pr�fen ob eine H�ufigkeit von von delta_t Werten auch bei einer kleiner
%% Zeit(der halben Symboldauer) vorhanden ist
anzahl_ok=anzahl;
index_ok=index;
verhaeltnis_ok=1;
if bitrate==0
    index_2 = index;
    while index_2 > 1                                                      % Pr�fen auf H�ufigkeiten vor dem Maximalwert
        [anzahl_2 index_2]=max(N(1:index_2-1));                       % Maxima bei kleineren Zeiten bestimmen
        verhaeltnis=X(index)/X(index_2);
        if (anzahl_2 >= (0.25*anzahl)) &  abs(verhaeltnis-round(verhaeltnis))<0.1
            anzahl_ok=anzahl_2;
            index_ok=index_2;
            verhaeltnis_ok=round(verhaeltnis);
        end                                                         % es gibt zwar kleinere Symboll�ngen, jedoch nicht gen�gend oft
    end                                                             % keine H�ufigkeiten von kleineren Symboll�ngen vorhanden
    %% Werte bestimmen die im Intervall der Bitdauer liegen
    if index>1                                          
        werte_1=(flanken_abstaende>=(X(index)-((X(2)-X(1))/2)));              % Der Vektor X beinhaltet nicht die Grenzen des Histogramms sondern den Mittelwert der Intervalle
        werte_2=(flanken_abstaende<=(X(index)+((X(2)-X(1))/2)));              %... deshalb muss zu diesen Mittelwerten noch die H�lfte eines Intervall addiert bzw. subtrahiert werden    
        werte_im_intervall=(werte_1 & werte_2).*flanken_abstaende;
        clear werte_1 werte_2
    else
        werte_im_intervall=(flanken_abstaende<=(X(index)+((X(2)-X(1))/2))).*flanken_abstaende;        %% Grenze bestimmen durch Addition des halben Intervalls, da Index=1 gibt es keine kleineren Werte mehr, 
    end                                                                           % ...es gen�gt nach den Werten zu suchen, die kleiner als die Grenze des ersten Intervalls sind.
    
    %% Mittelwert aus allen delta_t Werten die im Intervall der Symboldauer liegen bilden,  um die Bitdauer zusch�tzen.
    bitdauer=mean(nonzeros(werte_im_intervall))/fs/verhaeltnis_ok;   
    bitrate=(1/bitdauer);                          
    clear werte_im_intervall index;
else bitdauer=1/bitrate;
end

if stopbit==0                                                   % Stopbitl�nge wurde nicht angegeben und muss bestimmt werden.
    stopbit='1 oder 2';                                         % Wenn Stopbit nicht bekannt wird zun�chst angenommen das es 1 oder zwei Stopbits sind.
    % Pr�fen auf 1.5 Stopbit
    t_15_bit=1.5*bitdauer;                                      % L�nge von 1.5 Bit berechnen
    if t_15_bit<=X(end)+((X(2)-X(1))/2)                         % Pr�fen ob es dieser Bereich im Histogramm liegt
        %% Intervall bestimmen in dem t_15_bit liegt
    	index_nonzero=find(X>t_15_bit);         
    	index_15_bit=index_nonzero(1);
    	if (t_15_bit >= X(index_15_bit)-((X(2)-X(1))/2)) & (t_15_bit <= X(index_15_bit)+((X(2)-X(1))/2))
            index_15_bit;
    	else index_15_bit=index_15_bit-1;
    	end
    	%% Werte bestimmen die im Intervall von 1.5 Bit liegen
    	werte_1=(flanken_abstaende>=(X(index_15_bit)-((X(2)-X(1))/2)));              % Der Vektor X beinhaltet nicht die Grenzen des Histogramms sondern den Mittelwert der Intervalle
    	werte_2=(flanken_abstaende<=(X(index_15_bit)+((X(2)-X(1))/2)));              %... deshalb muss zu diesen Mittelwerten noch die H�lfte eines Intervall addiert bzw. subtrahiert werden    
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
   