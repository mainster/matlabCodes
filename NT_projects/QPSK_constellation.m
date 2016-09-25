% QPSK or M-PSK simulation
% Gray coded 4-PSK
% Tupel: (ai,bi)=( cos(pi/4*(2i-1)), sin(pi/4*(2i-1)) )
% 
% Summe:
% s = sum( ((k:M) + 2) )  
% s entspricht der Summe von k bis m über k+2

clear all;
clear hidden;
clc;
%delete(findall(0,'Type','figure'));

fc=20;  % carrier frequency
M=4;

s=[1:M];
ak=[zeros(2,M)]

s(1)=0;   % s0=00 (z.B.)
s(2)=1;   % s1=01
s(3)=2;   % s2=11 (gray)
s(4)=3;   % s3=10
% usw.....

for n=1:M
    s(n)=n-1;
    ak([1:2],n)=[cos(pi/M*(2*s(n)-1)) sin(pi/M*(2*s(n)-1))];
end

% Find open figure handles from last run
delete(findall(0,'type','line'));

handles = findall(0,'type','figure');
fig1 = findobj(handles,'type','figure','Name','fig1'); % Find open figure handle
fig2 = findobj(handles,'type','figure','Name','fig2'); % Find open figure handle
fig2b = findobj(handles,'type','figure','Name','fig2b'); % Find open figure handle
figBandpass = findobj(handles,'type','figure','Name','figBandpass'); % Find open figure handle
figSpec = findobj(handles,'type','figure','Name',''); % Find open figure handle

if isempty(fig1)
    fig1=figure('Name','fig1');
end
if isempty(fig2)
    fig2=figure('Name','fig2');
end
if isempty(fig2b)
    fig2b=figure('Name','fig2b');
end
if isempty(figBandpass)
    figBandpass=figure('Name','figBandpass');
end

figure(fig1);
%subplot(2,1,1);
plot(ak(1,[1:M]),ak(2,[1:M]),'o','MarkerFaceColor','r')
grid('on');
axis([-1.5 1.5 -1.5 1.5]);

% text(a0(1),a0(2),'  00','HorizontalAlignment','left','FontSize',20);
% text(a1(1),a1(2),'  01','HorizontalAlignment','left','FontSize',20);
% text(a2(1),a2(2),'11  ','HorizontalAlignment','right','FontSize',20);
% text(a3(1),a3(2),'10  ','HorizontalAlignment','right','FontSize',20);

time=[-1:0.0001:4];
syms Ts A dk

Ts=1;
% symbol=zeros(M,4)
% symbol([1:4],1)=[0 0 0 0];
% symbol([1:4],2)=[1 1 1 1];
% symbol([1:4],3)=[2 2 2 2];
% symbol([1:4],4)=[3 3 3 3];

%symbol
% Komplexes Basisband - symbols ist ein Vektor [0:M1] mit dem "gemappden" symbolen 
%fig2 = findobj('type','figure','Name','plot2') % Find open figure handle

figure(fig2);
st=[1:size(time,2)];

zbbMx=[[1:4],st];
It=[[1:4],st];
Qt=[[1:4],st];
bbA=[[1:4],st];
bbB=[[1:4],st];
hull=[[1:4],st];

for n=1:M
    zbbMx(n,st)=zbb(time,M,1,n,1);
    It(n,st)=real(zbbMx(n,st));
    Qt(n,st)=imag(zbbMx(n,st));
    bbA(n,st)=real(zbbMx(n,st).*exp(i*2*pi*fc*time));

    bbB(n,st)=It(n,st).*cos(2*pi*fc*time) - Qt(n,st).*sin(pi*fc*time);

%    for k=1:4
    figure(fig2);    
    subplot(M,2,2*n-1);
    plot(time,It(n,st),'g')
    hold on 
    plot(time,Qt(n,st),'r')
%    plot(time,hull(n,st),'r')    
    grid('minor');
    hold off 
    subplot(M,2,2*n);
    plot(time,bbA(n,st),'b')
    grid('minor');
end

    hull(n,st)=abs(bbA(n,st));
    figure(fig2b);
    subplot(2,1,1);
    plot(time,hull(n,st),'b')
    grid('minor');
    subplot(2,1,2);
    plot(time,bbB(n,st),'b')
%     
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % ------ FFT-Analyse der modulierten Bitfolgen
% 
% % FFT-Parameter festlegen
% L = length(bbA(n,st))
% %Ts = simoutTime.signals.values(2)-simoutTime.signals.values(1);
% Fs = 1/Ts;
% window = blackman(L);
% NFFT = 2^nextpow2(L);
% f = Fs/2*linspace(-1,1,NFFT);
% 
% bbAT=transpose(bbA(1,st));
% 
% % GMSK-Signal
% Y_spec = fft(bbAT.*window,NFFT)/L;
% Y_spec = Y_spec/max(abs(Y_spec)); % Normierung
% Y_spec_dB = 10*log10(abs([Y_spec(end/2:end);Y_spec(1:end/2-1)]).^2);
% 
% % zweiseitiges Spektrum plotten
% if isempty(figSpec)
%     figSpec=figure('Name','figSpec');
% end
% figure(figSpec);
% set(figSpec, 'Name', 'Leistungsdichtespektrum ');
% plot(f,Y_spec_dB, 'r') ;
% % hold on;
% % plot(f,Y_Msk_dB, 'r') ;
% % plot(f,Y_Gmsk_dB, 'b'); 
% % hold off;
% legend('G-MSK');
% title('normiertes Leistungsdichtespektrum \phi(f)');
% xlabel('Frequenz / Hz');
% ylabel('Leistung / dB');
% grid('on');
% ylim([-90;1]);
% set(gca,'XTickLabel',{'-4/Ts','-3/Ts','-2/Ts','-1/Ts', '0', '1/Ts','2/Ts','3/Ts','4/Ts'});
% xlim([-(Ts/10),(Ts/10)]);

%     figure(fig2b);    
%     subplot(M,2,2*n-1);
%     plot(time,It(n,st),'g')
%     hold on 
%     plot(time,Qt(n,st),'r')
%     grid('minor');
%     hold off 
%     subplot(M,2,2*n);
%     plot(time,bbB(n,st),'b')
%     grid('minor');    

    
    %   end


      
    figure(figBandpass);
    hold on 
    plot(time,bbA(1,st),'b')
    plot(time,bbA(2,st),'r')
    plot(time,bbA(3,st),'g')
    plot(time,bbA(4,st),'y')
%     plot(time,bbA(5,st),'b')
%     plot(time,bbA(6,st),'r')
%     plot(time,bbA(7,st),'g')
%     plot(time,bbA(8,st),'y')
    grid('on');
    grid('minor');
    

