



return
f1 = figure(1);

for k=0:length(m1) 
   plot(m1(1,1:2)', m1(1,3:4)','o');
end
%%


clf




%return
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a=[1 -1 -1 -1 0 0];
b=[rand(1,1) 1 0 -1 1 -1];
ab=[a',b'];

fprintf('\n')
for k=1:length(ab)
   sol(k)=atan(ab(k,2)/ab(k,1));
   if sol(k)<0
      sol(k)=sol(k)+2*pi;
      fprintf('For a=%g and b=%g --> sol(k) += 2*pi\n', ab(k,1), ab(k,2))
   end
end
sol'
return

%return
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stochastik Vorbereitung - Erwartungswerte von Prozessen
% mit symmetrischer Dichtefunktion 09-02-2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Eigenschaften des Erwartungswert-Operators
%
% Def.: E{Y}=E{g(X)}=int(g(x)*fx(x),-inf,inf)
% Linearität ...
% Lin. Transformation:  E{Y}=E{a*X+b}=a*E{X}+b
% Symm. Dichtefunktion: fx(c-X)=fx(X-c --> E{X}=c
%
syms a b c real

xx=linspace(-5,5,500);
assumeAlso(c > 0);
a_=0; b_=1; c_=1;

fx=@(x,a,b,c) c*exp(-abs(x'*a+b));
f1=figure(1);

plot(xx,fx(xx,a_,b_,c_))

b = uicontrol('Parent',f1,'Style','slider','Position',[81,54,419,23],...
   'value',a_, 'min',0, 'max',1);
           
b.Callback = @(es,ed) fprintf([char(class(ed)) '\n'])
return 

fx=seq(xx, normpdf(xx,-c,1)+normpdf(xx,c,1),'pdf +-c'); 
plota(fx); hold all; 

fh1=@(x) (0.25*x*csigma(x))*rect(x/4);
dotExpansion('fh1');
fx2=@(x) fh1(x)+fh1(-x)
dotExpansion('fx2');

plota(fx2(xx+1))
plota(fx2(xx+1))
hold off;


return

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stochastik Vorbereitung 21-01-2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delete(findall(0,'type','line'));

clear Nx fc wc su2 fc_
syms Nx fc wc su2 fc_ real 
syms p
syms wlim w01 real

assumeAlso([wc fc]>0);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stochastik Vorbereitung 20-01-2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delete(findall(0,'type','line'));

clear Nx fc wc su2 fc_
syms Nx fc wc su2 fc_ real 
syms p
syms wlim w01 real

assumeAlso([wc fc]>0);

%%
s=tf('s');
G=1/(s+1);

f1=figure(1);
bp=bodeplot(G); %,ol.optb);
%%
Gp=@(p) 1/(p+1);
fc_= double( solve(abs(Gp(1i*2*pi*fc))==1/sqrt(2),fc) );

f2=figure(2);
SUBS = 220;

Ap=@(w,fc) abs(Gp(1i*w/(2*pi*fc)));
Ap = str2func(['@(w)' char(simplify(Ap(w,1/pi2),'steps',100))]) ;
%%
Ap2=dotExpansion(Ap);

ww=lin(.01,100,200)';
wwl=logspace(10*log10(.01), 10*log10(100),200)';
ff=lin(.01,100,200)';

%%
hold on;
subplot(SUBS+1);
plot(ww, Ap2(ww).^2);
plot(ww, Ap2(ww));
xlim([0, double(solve(limit(Ap2(wlim).^2,wlim,0)/10==Ap2(w01).^2,w01>0))]);

wwfine=lin(min(ww),max(ww)/10,250);
subplot(SUBS+2);
plot(wwfine, Ap2(wwfine).^2);
plot(wwfine, Ap2(wwfine));
legend('|G(i*w)|^2','|G(i*w)|')

%xlim([0, double(solve(limit(Ap2(wfine).^2,wfine,0)/10==Ap2(w01).^2,w01>0))]);
xlim([0,3])

subplot(2,2,[3 4]);
lp=loglog(wwl, Ap2(wwl).^2); xlim([1e-2 1e2]);
lp2=loglog(wwl, Ap2(wwl),'--'); xlim([1e-2 1e2]);
legend('|G(i*w)|^2','|G(i*w)|')
%set(lp,'linewidth',2)
hold off;
return


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FFT umfassendes beispiel
% http://www.gomatlab.de/fft-umfassendes-beispiel-t777.html
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Zeitbereich 
% ---------------------------------- 

fa = 8000; % Abtastfrequenz 
fn = fa/2; % Nyquistfrequenz 
N = 1024; % gewünschte FFT-Länge (N=2^x, sonst wird der DFT-Algorithmus verwendet!) 
df = fa/N; % Frequenzauflösung 
% Erzeugung eines Datensatzes mit N Abtastwerten 
% ---------------------------------------------- 
t = 0 : 1/fa : (N-1)/fa; % x-Vektor 
% Frequenzvorgabe in Hz als ganzzahlig Vielfaches der Frequenzauflösung der DFT/FFT: 
f1 = df*100; % bei fa = 8000 Hz und N = 1024 beträgt df = 7,8125 Hz und 
% f1 damit 781,25 Hz 
%%
f1 = 784; 
 f1 = df; 
 phase = pi/2; 

a1 = 1; % Amplitudenvorgabe 
y = a1*sin(2*pi*f1*t); % y-Vektor 
y = [y(1:N/2) zeros(1, N/2)]; 
% Graphische Darstellung 
% ---------------------- 
% max. Amplitude zur Skalierung der graphischen Darstellung feststellen: 
max_y = max(abs(y))*1.1; 
fig = figure(1); 
plot(y) 
axis([0 N -max_y max_y]) 
title('Datensatz') 
ylabel('Amplitude') 
xlabel('N Stützstellen') 
grid on 

% Frequenzbereich 
% ---------------------------------- 

% Berechnung der FFT 
% ------------------ 
H = fft(y, N); 
% Berechnung des Amplitudengangs aus dem komplexen Frequenzvektor H: 
amplH = abs(H); 
% Amplitudenskalierung (Normierung auf N) und verschieben der Elemente des 
% Amplitudenvektors, so dass die Darstellung des Amplitudengangs von -fn...0...fn 
% erfolgen kann: 
amplitudengang = fftshift(amplH/N); 
% Graphische Darstellung 
% ---------------------- 
% Frequenzvektoren (werden bei der graphischen Darstellung benötigt): 
x_fn = 0 : df : fn-df; 
x_fa = 0 : df : fa-df; 
% max. Amplitude zur Skalierung der graphischen Darstellung feststellen: 
%a = max([a1, a2, a3, a4, a5]); % wird später benötigt 
a = a1; 
fig = figure(fig.Number+1); 
stem(x_fa-fn, amplitudengang, 'b.-') 
axis([-fn fn 0 a/2*1.1]) 
title('Amplitudengang') 
ylabel('Amplitude') 
xlabel(['Auflösung: ',num2str(df),' Hz Frequenz in Hz']) 
grid on 

% Ausgabe in dB 
% ------------------ 
fig = figure(fig.Number+1); 
plot(x_fa-fn, 20*log10(amplitudengang)) 
%axis([-fn fn -100 20*log10(a/2)+3]) 
axis([-fn fn -100 3]) 
title('Amplitudengang') 
ylabel('Amplitude in dB') 
xlabel(['Auflösung: ',num2str(df),' Hz Frequenz in Hz']) 
grid on 

% Darstellung des interessierenden Frequenzbereichs des 
% Amplitudengangs (0...fn) und 
% daran angepasste Amplitudenskalierung (Normierung auf N/2): 
amplitudengang = [amplH(1)/N amplH(2:N/2)/(N/2)]; % DC-Bin auf N normieren! 
fig = figure(fig.Number+1); 
stem(x_fn, amplitudengang, 'b.-') 
axis([0 fn 0 a*1.1]) 
title('Amplitudengang') 
ylabel('Amplitude') 
xlabel(['Auflösung: ',num2str(df),' Hz Frequenz in Hz']) 
grid on 

% Ausgabe in dB 
% ------------------ 
fig = figure(fig.Number+1); 
plot(x_fn, 20*log10(amplitudengang)) 
axis([0 fn -100 20*log10(a)+3]) 
title('Amplitudengang') 
ylabel('Amplitude in dB') 
xlabel(['Auflösung: ',num2str(df),' Hz Frequenz in Hz']) 
grid on 


% Fensterfunktion 
% ---------------------- 

% Anhang an die bereits erfolgte Untersuchung 
% ------------------------------------------- 
win = hann(N)'; 
%y_win = y.*win; % Fensterung ohne Amplitudenkorrektur 
y_win = y.*win*N/sum(win); % Fensterung mit Amplitudenkorrektur 
max_y = max(abs(y_win))*1.1; 

fig = figure(fig.Number+1); 
plot(y_win) 
axis([0 N -max_y max_y]) 
title('Datensatz nach Fensterung mit Hann-Fenster') 
ylabel('Amplitude') 
xlabel('N Stützstellen') 
grid on 

% Berechnung der FFT 
% ------------------ 
H = fft(y_win, N); 
% Berechnung des Amplitudengangs aus dem komplexen Frequenzvektor H: 
amplH = abs(H); 
% Amplitudenskalierung (Normierung auf N) und verschieben der Elemente des 
% Amplitudenvektors, so dass die Darstellung des Amplitudengangs von -fn...0...fn 
% erfolgen kann: 
amplitudengang = fftshift(amplH/N); 

% Graphische Darstellung 
% ---------------------- 
fig = figure(fig.Number+1); 
stem(x_fa-fn, amplitudengang, 'b.-') 
axis([-fn fn 0 a/2*1.1]) 
title('Amplitudengang nach Fensterung') 
ylabel('Amplitude') 
xlabel(['Auflösung: ',num2str(df),' Hz Frequenz in Hz']) 
grid on 

% Ausgabe in dB 
% ------------------ 
fig = figure(fig.Number+1); 
plot(x_fa-fn, 20*log10(amplitudengang)) 
%axis([-fn fn -100 20*log10(a/2)+3]) 
axis([-fn fn -100 3]) 
title('Amplitudengang nach Fensterung') 
ylabel('Amplitude in dB') 
xlabel(['Auflösung: ',num2str(df),' Hz Frequenz in Hz']) 
grid on 
 
return

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Taylor sequence of natural exponental function exp(x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear f* x y
f1=@(x,T) exp(x/T);
f2=@(x,T) 1-exp(-x/T);
syms x0 x real 
T0=1;

f1a=sym(ones(1,5));
f2a=sym(ones(1,5));
for k=1:5
   for n=1:k; 
      f1a(k)=f2a(k)+( diff(f1(x0,T0),n)/prod(n) * (x-x0).^n ); 
      f2a(k)=f2a(k)+( diff(f2(x0,T0),n)/prod(n) * (x-x0).^n ); 
   end
   f1u{k} = dotExpansion( str2func(['@(x,x0)' char(f1a(k))]) );
   f2u{k} = dotExpansion( str2func(['@(x,x0)' char(f2a(k))]) );
end
%%
fig(1)=figure(1);
fig(2)=figure(2);
delete(findall(fig,'type','line'));

figure(fig(1)); ezplot(f1(x,1)); hold all;
figure(fig(2)); ezplot(f2(x,1)); hold all;

for k=1:5
   figure(fig(1));   ezplot(f1u{k}(x,0))
   figure(fig(2));   ezplot(f2u{k}(x,0))
end
%%
figure(fig(1)); axis([-1 1 0 2]*2);
figure(fig(2)); axis([-1 1 0 2]*2);
%figure(fig(1)); axis([xlim ylim]*2);
%%
fu'
%%
% 
% $$\frac{KMT}{(KBM*KMT + KFR*Rc + KFR*Rsh + KFR*Lc*p + JR*Rc*p + JR*Rsh*p + JR*Lc*p^2)}$$
% 


return


h=get_param(gcb,'Name')
ind=regexp(h,'[0-9]*\.?[0-9]*')

blocks='none';
CNT=str2num(h(ind(1)))+1


while ~isempty(blocks) 
  blocks = find_system(gcs,'Type','Block','Name',...
            [h(1:ind(1)-1) num2str(str2num(h(ind(1)))+CNT)])
CNT=CNT+1
end

nn=[h(1:ind(1)-1) num2str(str2num(h(ind(1)))-1)]
% set_param(gcb,'MNAME',nn);
% set_param(gcb,'Name',nn);


%%
% ------------------------------------------------------------------------
% ----- load numeric raw data
% ------------------------------------------------------------------------
resp=LTspice2Matlab(FILES{1});  
SIGNALS={'V(out_a)','I(out_a)','V(stim)','I(Rshunt)'};

ind=[];
for k=1:length(SIGNALS)
    ind{k} = find(~cellfun(@isempty, (strfind(resp.variable_name_list(1,:), SIGNALS{k}))));
end
clrpo=cellfun(@isempty, ind);
ind(clrpo)=[];
SIGNALS(clrpo)=[];

ind = cell2mat(ind);
if isempty(ind)
    SIGNALS
    error( 'Signals not found' )
else
    sig.V = [];
    sig.I = [];
    for k=1:length(ind)
        sig.(SIGNALS{k}(:,1)).(SIGNALS{k}(:,3:end-1)) = resp.variable_mat(ind(k),1:end);
    end
end
sig.t=resp.time_vect;

%p=stepoptions;

fn=fieldnames(sig.V);
OFFS=90;
for k=1:length(fn)
    sv(k)=figure(OFFS+k);
    plot(sig.t, sig.V.(fn{k}));
end
grid on;
legend(fn)

fn=fieldnames(sig.I);
OFFS = OFFS+k+1;
for k=1:length(fn)
    si(k)=figure(OFFS+k);
    plot(sig.t, sig.I.(fn{k}));
end
grid on;
legend(fn)
