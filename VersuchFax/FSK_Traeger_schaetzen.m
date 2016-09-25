function[carrier_frequency, shift]=FSK_Traeger_schaetzen(data,fs,carrier_frequency,shift)
%% Trägerfrequenz und Frequenzshift bestimmen
%%  

points=round(fs/10);                                        % delta_f of PSD=10 Hz
[spec f]=psd(data,points,fs,points);                   		% PSD des samples
clear points;
if carrier_frequency~=0 & shift==0                           % Nur der Träger ist bekannt der Shift muss noch bestimmt werden.
    index_traeger=find(f==carrier_frequency);               % Index der Trägerfrequenz bestimmen.
    [max_value_a index_a]=max(spec(1:index_traeger));        % Untere Sendefrequenz bestimmen.
    [max_value_b index_b]=max(spec(index_traeger:end));      % obere Sendefrequenz bestimmen.
    index_b=index_b+index_traeger;                          % Die MAX Funktion beginnt bei eins zuzählen.
    shift=(f(index_b)-f(index_a))/2;                          % Shift berechnen.
    
else                                                        % Träger muss bestimmt werden.
    [max_value max_index]=max(spec(1:end));  	            % Maximum in den PSD-Werten suchen.
    [next_max_a next_index_a]=max(spec((max_index+3):end)); % Nächstes Maximum nach oben hin suchen.
    next_index_a=next_index_a+max_index;				    % Indizes müssen addiert werden, da die Funktion max wieder bei 1 beginnt zuzählen.
    [next_max_b next_index_b]=max(spec(1:(max_index-3)));   % Nächstes Maximum nach unten hin suchen.		  
    if next_max_a<next_max_b	                            % Es kann nur ein Nebenmaxima der zweiten Sendefrequenz geben
       max_index_2=next_index_b;                            % Das größere der beiden Nebenmaxima wird als Sendefrequenz angenommen
    else max_index_2=next_index_a;                          %
    end
    clear spec max_value next_index_a next_max_a next_index_b next_max_b;
    if shift==0                                             % Shift muss bestimmt werden.
        shift=abs(f(max_index_2)-f(max_index))/2;
    end
    if max_index_2<max_index
        carrier_frequency=shift+f(max_index_2);
    else carrier_frequency=shift+f(max_index);
    end
    clear f max_index max_index_2;
end

