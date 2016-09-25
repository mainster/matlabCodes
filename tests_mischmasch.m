%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% dirac - Darstellung fourier(sin(...))         22-06-2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clear all; close all; startup
syms t f w T0 f0 w0 real;
assumeAlso([T0 f0 w0] > 0);
w0=10*pi;
w1=11*pi;

fprintf('\n%s\n\tfourier(sin(w0*t),t,2*pi*f)\n%s\n',ds,ds)
pretty(fourier(sin(w0*t),t,2*pi*f))
fprintf('\n%s\n',ds)
f1  = eval(imag(fourier(sin(w0*t),t,2*pi*f)));
f1c = eval(fourier(sin(w0*t),t,2*pi*f));
f2  = eval(imag(fourier(cos(w1*t),t,2*pi*f)));
f2c = eval(fourier(cos(w1*t),t,2*pi*f));

f1cc=f1c;
f2cc=f2c;

if ~isempty(imag(f1))
   f1=str2func(['@(f)' strrep(char(f1), '*(-i)','')]);
else
   f1=str2func(['@(f)' char(f1)]);
end

if ~isempty(imag(f2))
   f2=str2func(['@(f)' strrep(char(f2), '*(-i)','')]);
else 
   f2=str2func(['@(f)' char(f2)]);
end

f1c=str2func(['@(f)' char(f1c)]);
f2c=str2func(['@(f)' char(f2c)]);


ff=[-10:0.1:10];
f1y = str2num(strrep(num2str(f1(ff)), 'Inf','1/2'));
f2y = str2num(strrep(num2str(f2(ff)), 'Inf', '1/2'));

f1cy = str2num(strrep(num2str(f1c(ff)), 'Inf', '1'));
f1cy = str2num(strrep(num2str(f1cy), 'Infi', '1i'));
f2cy = str2num(strrep(num2str(f2c(ff)), 'Inf', '1'));
f2cy = str2num(strrep(num2str(f2cy), 'Infi', '1i'));
% return

%% PLOTS
fig1=figure(1);
delete(findall(0,'type','line'));
SUB=220;
%%
subplot(SUB+1);
s(1)=stem(ff,real(f1cy)); hold all;
le(1)=legend(sprintf('Re{ fourier(sin(%g*t)) }',w0));

subplot(SUB+2);
s(2)=stem(ff,imag(f1cy)); hold off;
le(2)=legend(sprintf('Im{ fourier(sin(%g*t)) }',w0));


%%
subplot(SUB+3);
s(3)=stem(ff,real(f2cy)); hold all;
le(3)=legend(['{\fontsize{16pt}\bf\Re} { fourier(cos(' num2str(w1) '*t)) }']);
%%
subplot(SUB+4);
s(4)=stem(ff,imag(f2cy)); hold off;
buff=strrep([  '\fontsize{16pt}\bf\Im\{',...
               ' {\fontsize{10pt}\rm ',...
               ' fourier(cos(%g*t))} \}'],'\','\\');

le(4)=legend(sprintf(buff,w1));

for k=1:length(le)
   set(le(k), 'interpreter','tex')
end

%%
laplace(sin(w0*t),t,s)
laplace(cos(w0*t),t,s)
return;
%%
ff=linspace(-10,10,200);
f2y=str2num(strrep(num2str(f2c(ff)), 'Inf','1'));
f2y=str2num(strrep(num2str(f2c(ff)), 'Infi','1i'));
find(f2y)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% psd nach Welch        16-06-2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms t f w T0 f0 w0 real;
assumeAlso([T0 f0 w0] > 0);
fi1=figure(1);
delete(findall(0,'type','line'))
SUB=310;

ls=@linspace;
%%
T0=0.1;
tau=ls(-2*T0, 2*T0,320);

%%
a=[0.25 0.35 0.5];
a=[-1:.1:1];
a=0.49
clear f1

for k=1:length(a)
   f1(:,k)= a(k).*(tri((tau+T0)/(T0/4)) + tri((tau-T0)/(T0/4)))+tri(tau/(T0/4)); 
end
%%
rng3=[-1 1]*2*T0;

subplot(SUB+1);
plot(tau,f1); 
% xlim([-.1,1.1]);
% line([-3*T0:T0:3*T0]'*[1 1],[-0.2 1],'color','r','linestyle','--'); 
% hold off;

% n = 0:319;
% x = cos(pi/4*n)+randn(size(n));
segmentLength = 100;
nfft = 640;
subplot(SUB+2);
%%
for k=1:length(a)
   pxx(:,k) = pwelch(f1(:,k),segmentLength,[],nfft);
end
%plot(10*log10(pxx));
plot(10*log10(pxx));
xlabel('Radians/sample'); ylabel('dB');

return

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% psd        16-06-2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fs = 32e3;   
t = 0:1/Fs:2.96;
x = cos(2*pi*t*1.24e3)+ cos(2*pi*t*10e3)+ randn(size(t));
x = 0.1+cos(2*pi*t*1.24e3)+ cos(2*pi*t*10e3)+ 10*randn(size(t));
nfft = 2^nextpow2(length(x));
Pxx = abs(fft(x,nfft)).^2/length(x)/Fs;

% Create a double-sided spectrum
Hpsd = dspdata.psd(Pxx,'Fs',Fs,'SpectrumType','twosided');
%pwelch
plot(Hpsd)

return
%%
% Create a single-sided spectrum
Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',Fs);  
plot(Hpsd); 


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Logar        14-06-2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
h = stem([1 2 3],[0.1 0.5 10],'linestyle','none');
hb = get(h,'Baseline');
set(hb,'Visible','off')
set(gca,'yscal','log')


