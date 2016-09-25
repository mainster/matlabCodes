Fs = 32e3;   
t = 0:1/Fs:2.96;
x = cos(2*pi*t*1.24e3)+ cos(2*pi*t*10e3)+ rednoise(max(size(t)));
nfft = 2^nextpow2(length(x));
Pxx = abs(fft(x,nfft)).^2/length(x)/Fs;

SUB=220;
% Create a single-sided spectrum
Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',Fs);  
figure(99)
subplot(SUB+1);
%%%%%%%%%%%% !!!!!!!!!!!! %%%%%%%%%%%%
% Hpsd ist ein dspdata objekt, hold all und ein zweites spektrum
% plotten funktioniert nicht
h1=plot(Hpsd);			
%% aber:
subplot(SUB+2);
%% NEEEEEEEEIN nicht 20*log
% Die PSD muss als Energiesignal interpretiert werden
% 10*log10( V^2/R ) == 10*log10( (V/sqrt(R))^2 )== 20*log10( V/sqrt(R) )
% Weil die psd aber schon ein X(f)^2 ist, muss mit 10*log10
% logarithmiert werden!!!!!!!!!!!!
%
% h2=plot(20*log10(Hpsd.Data)/2);
h2=plot(10*log10(Hpsd.Data)/2);

length(get(h1,'XData'))
length(get(h2,'XData'))
%%%%%%%%%%%% !!!!!!!!!!!! %%%%%%%%%%%%

% Create a double-sided spectrum
Hpsd = dspdata.psd(Pxx,'Fs',Fs,'SpectrumType','twosided');
subplot(SUB+3);
plot(Hpsd)




