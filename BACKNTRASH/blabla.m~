%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%bla bla
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% numCmdWavPlot.m

return
%%



ch1=audioread('wavefiles/0_57_43/waveout_nein_1.wav'); ch1=ch1(:,1);
ch2=audioread('wavefiles/0_57_43/waveout_nein_1.wav'); ch2=ch2(:,2);

xch1=xcorr(ch1);
xch2=xcorr(ch2);
f98=figure(98); clf;
SUB = 310;
subplot(SUB+1);
plot(xch1); hold all; grid on;
subplot(SUB+2);
plot(xch2); hold off;
subplot(SUB+3);
plot(ch2); hold off;

a1=audioread('wavefiles/0_57_43/waveout_nein_1.wav'); a1=a1(:,2);
a1m=payloadDetector(a1, '0db', 100, 0);


f99=figure(99); clf;
SUB = 210;
subplot(SUB+1);
plot(a1); hold all
plot(a1m); hold all
hold off;
grid on;
%xlim([0, 1000]);

return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% H.Schäfer:
% Audio- Signal erst Gleichrichten, Filtern
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f0=100; f1=255; f2=600; 
tt=[0:10e-6:10e-3];

s.d1=@(X) [diff(X,1) 0];
s.d2=@(X) [diff(X,2) 0 0];
s.d3=@(X) [diff(X,3) 0 0 0];

f3=figure(3); clf;
SUB=310;

x1=sin(2*pi*f0*tt)+sin(2*pi*f1*tt)+sin(2*pi*f2*tt);
x=x1;

subplot(SUB+1);
plot(normVect(x)); hold all
plot(normVect(s.d1(x)));
hold off;
grid on;
xlim([0, 1000]);

x=abs(x1);

subplot(SUB+2);
plot(normVect(x)); hold all
plot(normVect(s.d1(x)));
hold off;
grid on;
xlim([0, 1000]);

N = 10;  
Fc = 0.15;
B = fir1(N,Fc);
Hf1 = dsp.FIRFilter('Numerator',B);
%freqz(b,1,512)
x=step(Hf1, abs(x1));

subplot(SUB+3);
plot(normVect(x)); hold all
plot(normVect(s.d1(x)));
hold off;
grid on;
xlim([0, 1000]);











