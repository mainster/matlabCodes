%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                      SNR Berechnung 	
% http://de.mathworks.com/help/signal/ref/snr.html
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global rect;
global fs Bs fr Br pi2 wg p
syms fs Bs fr Br wg p

syms f t w T v reals;
f1=figure(1);
delete(findall(0,'Type','Line'));
delete(findall(0,'Type','Text'));
SUB=220;

ff = linspace(-10e3,10e3,10e3);  frng = [min(ff) max(ff)];
ffp = linspace(0,10e3,10e3); ffprng = [min(ffp) max(ffp)];
ffq = linspace(-3e3,10e3,10e3); ffqrng = [min(ffq) max(ffq)];

ww = linspace(-10e3*pi2,10e3*pi2,10e3); wwrng = [min(ww) max(ww)];
wwp = linspace(0,10e3*pi2,10e3); wwprng = [min(wwp) max(wwp)];

%% Rectangular power density
fs=4e3; Bs=2e3; fr=5e3; Br=8e3;
ws=pi2*fs; wBs=pi2*Bs; wr=pi2*fr; wBr=pi2*Br;
f1=1e3; f2=3e3; f3=5e3; f4=9e3;
w1=pi2*f1; w2=pi2*f2; w3=pi2*f3; w4=pi2*f4;

syms V real

Pss = @(f,V) V.*rect((f-fs)./Bs);
Prr = @(f,V) V./4.*rect((f-fr)./Br);
Psw = @(w,V) 1/pi2 * ( V.*rect((w-pi2.*fs)./(pi2.*Bs)) );
Prw = @(w,V) 1/pi2 * ( V./4.*rect((w-pi2.*fr)./(pi2.*Br)) );

%% Phis, Phir with Frequency in Herz
subplot(SUB+1)
ezplot(Pss(f,1),ffprng); hold all
ezplot(Prr(f,1),ffprng); hold off
ax(1) = gca;
ax(1).XTickLabel = cellstr(num2str([0:1:10]'));
ax(1).YLim=[-.1,1.1];
la(1) = xlabel('f / [kHz]','FontWeight','bold');
title('Spectral densitys | f')

%% Phis, Phir with Frequency in rad/s
subplot(SUB+3)
ezplot(Psw(w,1),wwprng); hold all
ezplot(Prw(w,1),wwprng); hold off
ax(2) = gca;
ax(2).XTickLabel = cellstr(num2str([0:10:60]'));
la(2) = xlabel('$$\bf\omega / [k \cdot rad/s]$$',...
               'Interpreter','latex', 'FontSize',15);
ax(2).YLim=[-.1,1.1];
title('Spectral densitys | \omega')

%%
pwrs_in = [eval(int(Pss(f,V), f, f2,f3)), eval(int(Psw(w,V), w, w2,w3)),...
           eval(int(Prr(f,V), f, f1,f4)), eval(int(Prw(w,V), w, w1,w4))];
fprintf('Powers Pss Psw Prr Prw: \n')   
disp(pwrs_in)

%% Apply 1st order HP filter G(s)
assumeAlso(wg > 0);
Gs = @(s,wg) (s./wg)./(s./wg + 1);
Gw = @(w,wg) Gs(i*w,wg);

% Gw = strrep( char(Gw_(w,wg)), '/','./');
% Gw = strrep( Gw, '*','.*');
% Gw = str2func(['@(w,wg)' Gw]);
% Gw(w,wg)

Pys = @(w,wg,V) abs(Gw(w,wg)).^2 .* Psw(w,V); 
Pyr = @(w,wg,V) abs(Gw(w,wg)).^2 .* Prw(w,V); 

wn=[w1 w2 w3 w4];

subplot(SUB+2); hold all;
for k=1:length(wn)
   ezplot(Pys(w,wn(k),1), wwprng); hold all;
   ezplot(Pyr(w,wn(k),1), wwprng); 
end
hold off;
ax(3) = gca;
ax(3).YLim=[-.05,.2];
la(3) = xlabel('$$\bf\omega / [k \cdot rad/s]$$',...
               'Interpreter','latex', 'FontSize',15);
title('Output spectral density - different cut-offs | \omega')

%% Overall output signal powers
% sy_s2 = @(wg) V/pi.*int(w.^2./(w.^2 + wg.^2),     w, w2, w3);
% sy_r2 = @(wg) V/(4*pi).*int(w.^2./(w.^2 + wg.^2), w, w1, w4);
sy_s2 = @(wg) int( Pys(w,wg,V), w, w2, w3);
sy_r2 = @(wg) int( Pyr(w,wg,V), w, w1, w4);

pretty(simplify(sy_s2(wg)))
pretty(simplify(sy_r2(wg)))
snrfun = @(wg) sqrt(sy_s2(wg)./sy_r2(wg));
snrfun = strrep(char(simplify(snrfun(wg),'steps',50)))
%%

snrfun2 = strrep( char(snrfun2_(wg)), '/','./');
snrfun2 = strrep( snrfun2, '*','.*');
snrfun2 = str2func(['@(wg)' snrfun2]);
snrfun2

wwsn = linspace(1,10e3*pi2,1000);
tic
sn(1,:) = double(subs(snrfun2,'wg',wwsn))';
toc
tic
sn(2,:) = double(subs(snrfun2,'wg',wwsn))';
toc

fprintf('snr(wg):=\n')
pretty(simplify(snrfun(wg),'steps',5))
simplify(snrfun(wg),'steps',5)
%%
subplot(SUB+4);
% ezplot(snrfun(wg),wwprng); hold all;
% ezplot(snrfun(wg),[0,100e3]); hold off;
plot(wwsn, sn); hold all;
hold off;
title('$$SNR_{Out}(\omega_g) ~~|~~ \omega$$','Interpreter','latex');

return

%%
Prr = @(f,V) V/4.*rect((f-fr)/Br);
subplot(SUB+1);
plot(ffq, Pss(ffq,1)); hold all;
subplot(SUB+3);
plot(ww, Psw(ww,1)); hold all;


%plot(ffq, Pss(ffq+fs,1)); hold off;
%%
% var_s_ = int( Pss(f,v),f,f2,f3);
% var_s = int( Pss(f+fs,v), f, -Bs/2, Bs/2);
% varMat = var(Pss(ff-fs,1));

%% (Pss+Prr) * abs( HP(w) )^2
% w=2*pi*f;
Gs = @(s,wg) (s./wg)./(s./wg+1);
Gw = @(w,wg) Gs(i*w,wg);
ga = @(w,wg) abs(Gw(w,wg)).^2;


subplot(SUB+2);
% plot(ffq, var_s(ffq,1)); hold all;
sy2_1 = @(wg) 1/pi2*int(ga(w,wg) * Psw(w,1),w,pi2*f2,pi2*f3)
sy2_1(wg)
simplify(sy2_1(wg),'Steps',15)
%%
return
% %%
% rng default
% Tpulse = 20e-3;
% Fs = 100e3;
% t = -1:1/Fs:1;
% x = rectpuls(t,Tpulse);
% y = 0.00001*randn(size(x));
% s = x + y;
% subplot(211);
% plot(s)
% subplot(212);
% plot(y)
% pulseSNR = snr(x,s-x)

