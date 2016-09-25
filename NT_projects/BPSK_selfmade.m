% MPSK self made
%
jump=@(x) (0.5*sign(x)+0.5);
g1=@(t,t0,t1) jump(t-t0)-jump(t-t1);    % Rechteck von t0 bis t1
g=@(t) g1(t,0,1);                       % Rechteck von t=0 bis t=1

% Uni->Bipolar convertet Bitstream
dk=[1 1 -1 -1 1 1 1 -1 1 1 1 1 -1 -1 1 -1 -1 -1 -1 1 1 -1 -1 -1 1 1 ];
dk=[1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 ];

Fsam = 1000;                   % Sampling frequency, timevector ticks/s
Tsam = 1/Fsam;                 % Sample time
L=Fsam*10;                     % Length of Signal is 100samples * 10sec
t=(0:L-1)*Tsam;
Ts=Tsam*Fsam;                  % Symboltime = 1sec.

fc=100;       % carrier

length(t)

A=1;        % Amplitude Basisband


% Check RC- and RRC impulse reponse
p1=figure(1);
plot([-5:0.01:5],RaisedCosShaper([-5:0.01:5],Ts,0.5,'time'),'r')
grid on;
hold on;
plot([-5:0.01:5],RootRaisedCosShaper([-5:0.01:5],Ts,0.5,'time'),'g')
hold off
sc_rc=zbbBPSK(t,Ts,dk,A,'rcos',0.5);
sc_rect=zbbBPSK(t,Ts,dk,A,'rect',0);

s_rc=real(sc_rc.*exp(i*2*pi*fc*t));
s_rect=real(sc_rect.*exp(i*2*pi*fc*t));
s_rc=s_rc.'
s_rect=s_rect.'


p2=figure(2);
subplot(2,1,1)
plot(t,sc_rc,'r')
grid on
subplot(2,1,2)
plot(t,sc_rect,'b')
grid on
% 
p3=figure(3);
subplot(2,1,1)
plot(t,s_rc,'r')
grid on;
subplot(2,1,2)
plot(t,s_rect,'b')
grid on


% 
% for l=1:length(s_rc)
%     if s_rc(l)==Inf  | s_rect(l)==NaN
%         s_rc(l)=s_rc(l+1);
%     end
%     if s_rc(l)==-Inf | s_rect(l)==-NaN
%         s_rc(l)=s_rc(l+1);
%     end
% end
% 
% for l=1:length(s_rect)
%     if s_rect(l)=='NaN' 
%         s_rect(l)=1;
%     end
%     if s_rect(l)==Inf 
%         s_rect(l)=1;
%     end
%     if s_rect(l)==-Inf | s_rect(l)==-NaN
%         s_rect(l)=1;
%     end
% end

NFFT = 2^nextpow2(L/10); % Next power of 2 from length of y
S_RC = fft(s_rc,NFFT)/(0.1*L);
f = Fsam/2*linspace(0,1,NFFT/2+1);

p2=figure(5);
% Plot single-sided amplitude spectrum.
plot(f,2*abs(S_RC(1:NFFT/2+1))) 
grid on;
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

% s_rc
% S_RC = fft(s_rc,NFFT)/L
% S_RC = S_RC/max(abs(S_RC)); % Normierung
% S_RC_dB = 10*log10(abs([S_RC(end/2:end);S_RC(1:end/2-1)]).^2);
% 
% 
% 
% S_RECT = fft(s_rect.*window,NFFT)/L;
% S_RECT = S_RECT/max(abs(S_RECT)); % Normierung
% S_RECT_dB = 10*log10(abs([S_RECT(end/2:end);S_RECT(1:end/2-1)]).^2);
% 
% 
% 
% fftFig=figure(5);
% % Plot single-sided amplitude spectrum.
% plot(f,S_RECT_dB) 
% hold on
% plot(f,S_RC_dB,'r') 
% hold off
% title('normiertes Leistungsdichtespektrum \phi(f)');
% xlabel('Frequenz / Hz');
% ylabel('Leistung / dB');
% grid('on');
% ylim([-90;1]);
% set(gca,'XTickLabel',{'-4/Ts','-3/Ts','-2/Ts','-1/Ts', '0', '1/Ts','2/Ts','3/Ts','4/Ts'});
% xlim([-(0.1*Fs),(0.1*Fs)])
