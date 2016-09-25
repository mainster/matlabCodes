function [YFULL, Y, Y_bb, FS] = fsk_darstellung()
% #########################################################################
% #     Script um Wavedatei zu laden und darzustellen                     #
% #########################################################################
% # Anwendung:                                                            #
% # ----------                                                            #
% # Gibt von einer Wave-Datei folgende Darstellungen des                  #
% # komplexen Basisbandes aus:                                            #
% #      - Realteil                                                       #
% #      - Imagin�rteil                                                   #
% #      - Betrag                                                         #
% #      - Phase                                                          #
% #########################################################################

% Kleine Anpassungen, 20.06.2014 MDB

% Einlesen der Wav-Datei:
% -----------------------

%[wav_filename wav_path] = uigetfile('*.wav', 'Auswahl der wav-Datei');
%wav_filename='DIS_sml.wav';
wav_filename='DIS.wav';
wav_path='/media/data/CODES/matlab_workspace/VersuchFax/';
[Y,FS,NBITS,OPTS]=wavread([wav_path wav_filename]);

% Filter-Koeffizienten des mit dem FDA-Tool entworfenen Tiefpasses
% ----------------------------------------------------------------
%[coeff_filename coeff_path]=uigetfile('*.mat', 'Auswahl der Filterkoeffizientendatei (Hausarbeit)');
coeff_filename='filterCoeff.mat';
coeff_path='/media/data/CODES/matlab_workspace/VersuchFax/';
var_name_of_coeff='Num';
% Die Variable 'Num' sollte sich nun in der .mat-Datei befinden, wenn
% diese so belassen wurde gem�� Anweisung in den Versuchsunterlagen.

YFULL=Y;

Y=Y(50:1000);

% L�nge der FFT die gerechnet werden soll
% ---------------------------------------
% entsprechend der m�glichen L�ngen in Cool Edit
% 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 65536
NFFT=4096;


% Fensterfunktion die verwendet werden soll
% -----------------------------------------
% F�r die die noch kein DSV, TK etc. geh�rt haben: Die Fensterfunktion
% dient dazu das die R�nder bei der verwendeten L�nge der FFT ausge-
% blendet werden, M�gliche Fensterfunktionen:
% BARTLETT, BARTHANNWIN, BLACKMAN, BLACKMANHARRIS, BOHMANWIN, 
% CHEBWIN, GAUSSWIN, HAMMING, HANN = Hanning, KAISER, NUTTALLWIN, 
% PARZENWIN, RECTWIN, TRIANG, TUKEYWIN
Window_Funktion=hann(NFFT);

% �berlappung bei der FFT
% -----------------------
% OVERLAP=0             % keine �berlappung
% OVERLAP=NFFT-1;       % "Totale �berlappung"
% OVERLAP=NFFT/2;       % �berlapp bis zur halben L�nge der FFT
OVERLAP=NFFT/2;


% Mittenfrequenz (Carrier-Frequenz) der 2-FSK in [Hz]
% ---------------------------------------------------
f0=1750; 


% 1. Bildung komplexes Basisbandsignal
% ------------------------------------
y_length=length(Y);                             % L�nge der Wave-Datei ermitteln
Y_misch=Y.*exp(-j*2*pi*f0/FS*(1:length(Y))');   % Spektrum um die Mittenfrequenz
                                                % nach unten verschieben
load([coeff_path coeff_filename],var_name_of_coeff);     % Filterkoeffizienten f�r den
                                                % Tiefpass zur Bildung des komplexen
                                                % Basisbandsignal laden
Y_bb=filter(eval(var_name_of_coeff),1,Y_misch); % Bildung komplexes Basisbandsignal

% 2. Zeitskala bilden
% -------------------
t=(1:y_length)*1/FS';
tt=(1:(y_length-1))*1/FS'; % nur bis y_length-1 f�r Momentanfreq. wg. Ableitung



% ***************************************************************
% *                     Diagramm Nr 1.                          *
% *                     ==============                          *
% * zeigt:                                                      *
% *  - Realteil des komplexen Basisbandsignals                  *
% *  - Imagin�rteil des komplexen Basisbandsignals              *
% *  - Betrag des komplexen Basisbandsignals                    *
% *  - Phase des komplexen Basisbandsignals                     *
% ***************************************************************
figure(1);          clf;
set(1, 'Position',[10 10 900 650]);
subplot(3,2,[1 2]), plot(t, Y);
title('Bandpasssignal');     grid;
xlabel('t in [s]');
ylabel('')

subplot(323), plot(t, real(Y_bb));
title('Realteil des komplexen Basisbandsignals');     grid;
xlabel('t in [s]');
ylabel('')

subplot(324), plot(t, imag(Y_bb));
title('Imaginärteil des komplexen Basisbandsignals');     grid;
xlabel('t in [s]');
ylabel('')


subplot(325), plot(t, abs(Y_bb));
title('Betrag des komplexen Basisbandsignals');     grid;
xlabel('t in [s]');
ylabel('')


subplot(326), plot(t, angle(Y_bb));
title('Phase des komplexen Basisbandsignals');     grid;
xlabel('t in [s]');
ylabel('[rad]')




% ***************************************************************
% *                     Diagramm Nr 2.                          *
% *                     ==============                          *
% * zeigt:                                                      *
% *  - Spektrale Leistungsdichte des urspr�nglichen Signals     *
% *  - Spektrale Leistungsdichte des urspr�nglichen Signals     *
% *    verschoben um die Mittenfrequenz (1750Hz) der 2-FSK      *
% *  - Spektrale Leistungsdichte des komplexen Basisbands       *
% *    ( = verschobenes Signal tiepassgefiltert)                *
% ***************************************************************
figure(2);          clf;
set(2, 'Position',[10 10 900 650]);
[l f] = psd(Y,NFFT,FS,Window_Funktion,OVERLAP);
% Frequenzen symmetrisch um Null
f = [-flipud(f(2:end)); f];
l = [flipud(l(2:end)); l];
subplot(311)
plot(f,10*log10(l)), axis tight;
line([f0 f0], [-70 -20],'color','red','Line','--')
title('Spektrale Leistungsdichte des Bandpasssignals');     grid on;
xlabel('f in [Hz]');
ylabel('[dB]')


[l f] = psd(Y_misch,NFFT,FS,Window_Funktion,OVERLAP);
f = f-FS/2;
l= fftshift(l);
subplot(312), plot(f,10*log10(l)) , axis tight
title('Spektrale Leistungsdichte des um die Mittenfrequenz (1750Hz) verschobenen Signals');     grid on;
xlabel('f in [Hz]');
ylabel('[dB]');

[l f] = psd(Y_bb,NFFT,FS,Window_Funktion,OVERLAP);
f = f-FS/2;
l= fftshift(l);
subplot(313), plot(f,10*log10(l)), axis tight;
title('Spektrale Leistungsdichte des komplexen Basisbandsignals (= verschobenes Signal tiefpassgefiltert)');     grid on ;
xlabel('Frequenz f in [Hz]');
ylabel('[dB]');

