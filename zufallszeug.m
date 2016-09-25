%function zufallszeug ()
%%  Zufallsprozesse, zufallsvariablen
%   Skript Uet S.22 
% if 0
%     clear all; close all; startup;
%     %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     rectsym = @(t,T) (heaviside(t+T)-heaviside(t-T));
%     rect = @(t,T1,T2) (heaviside(t+T1)-heaviside(t+T2));
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     t1 = linspace(0,5,200); 
% 
%     T1 = -1; T2 = -2;
%     fx_x = @(x,T1,T2) (1-exp(-2.*x)).*rect(x,T1,T2)
% 
% 
%     f1 = figure(1);   clf;    SUB = 210;
%     subplot(SUB+1);
%     plot(t1,(1-exp(-2.*t1)),'x-');  grid on; hold all;
%     plot(t1,rect(t1,T1,T2),'-x'); hold all;
%     subplot(SUB+2);
%     plot(t1,fx_x(t1,T1,T2),'-x'); grid on; hold all;
%     %%
%     I1 = integral(@(x)fx_x(x,T1,T2), 0, inf)
%     %%
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TU- Darmstadt pdf:    Signale/Zufallsprozesse
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bsp.: Zufallsprozess mit sinusförmigen Musterfunktionen und
% zufälliger phase
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clear all;

delete(findall(0,'type','line'));

if 0
    isOpen = matlabpool('size') > 0;
    c = parcluster

    if ~isOpen
        matlabpool open 12
    end
end

w0 = 2*pi;
rect = @(x,X1,X2) (heaviside(x+X1)-heaviside(x+X2));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% xmuster = @(x,phi) sin(w0*x+phi);           % Musterfunktion
% xm = @(x,phi)xmuster(x,phi);                  % Prozessfunktion
xm = @(x,phi) sin(w0*x+phi);           % Musterfunktion
NEXP = 1500;                                  % n experiments

phiv = 2/pi*rand(1, NEXP);                     % Zufallsvariable
%phiv = 2/pi*normrnd(0,1,1, NEXP);                     % Zufallsvariable normalverteilt

fp_p = @(phi) 2/pi*( (0<= phi) & (phi<= pi/2) );   % Dichte? fkt im Interval [0,pi/2]
tt = linspace(0,1.2,50);                              % auf dem Zeitinterval

for k = 1:NEXP
    xmv(:,k) = xm(tt,phiv(k));
end

syms t p;
mx1 = int(sin(eval(w0*t+phiv(1)))*2/pi, p ,0 ,pi/2);    % Erwartungswert, Moment 1. Ordnung
mx1 = int(sin(w0*t+p)*2/pi, p ,0 ,pi/2);    % Erwartungswert, Moment 1. Ordnung
mx1 = str2func(['@(t)' char(mx1)]);

%%% Musterlösung %%%%%%%%%%%%%%%%%% 
in = @(t)2*sqrt(2)/pi*sin(w0*t+pi/4);

%ezplot(in,0,4); grid on;hold all;
%ezplot(mx1,0,4); grid on;

f1 = figure(1);
% plot(tt,xmv); grid on;
% 
% return
SUB = 220;
for k = 1:1
    subplot(SUB+k);
    plot(tt, xmv); 
    grid on;
    xlim([tt(1), tt(end)]);
end    

t1 = 1;                           % Scharmittel berechnen zum Zeitpunkt t1
ord = find(tt >= t1, 1,'first');    % Wegen auflösung den index anpassen --> ord~t1

mx1n = feval(mx1,tt);     % in matlab integriert
inn = feval(in,tt);     % in matlab integriert
plot(tt, inn,'Color','green','LineWidth',3); grid on; hold all;
plot(tt, mx1n,'b--'); 


%%
amp = xmv(ord,:);
scharMean = mean(amp);
disp(['scharMeanmittel bei ' num2str(tt(ord)) 's: ' num2str(scharMean)]);
plot(tt(ord), scharMean,'x','MarkerSize',15,'LineWidth',2); 
line([tt(ord) tt(ord)],[-1,1],'Color','red')
line([(1-0.1)*tt(ord) (1+0.1)*tt(ord)],[scharMean scharMean],'Color','red')

%%
subplot(SUB+2);

plot(tt, inn,'Color','green','LineWidth',3); grid on; hold all;
plot(tt, mx1n,'b--'); 
xlim([tt(1), tt(end)]);
legend('E\{x(t)\} musterloesung','matlab - berechnet')

line([tt(ord) tt(ord)],[-1,1],'Color','red')
line([(1-0.1)*tt(ord) (1+0.1)*tt(ord)],[scharMean scharMean],'Color','red')
disp('')

subplot(SUB+3);
plot(amp);
line([0 NEXP],[1 1]*scharMean,'Color','red','Linestyle','--');
legend( ['Amplituden des Prozesses, t=' num2str(tt(ord)) 's'],...
        ['Scharmittel bei t=' num2str(tt(ord)) 's: ' num2str(scharMean)] );
xlabel('Experiment n');
grid on;
ylim([-1,1]);

dist = distMagn(amp,length(amp),'all');     % Verteilung berechnen

subplot(SUB+4);
plot(dist,'x','LineWidth',1);
% line([0 NEXP],[1 1]*scharMean,'Color','red','Linestyle','--');
legend(sprintf('Amplituden Verteilung \nzum Zeitpunkt t=%.4gs', tt(ord))); 
xlabel('Amplitude');
grid on;



return

% phi = [0:.01:1];
% f2 = figure(2); clf;
% ezplot(@(x) xm(x,phi(1)),[0,2*pi])
% hold all; grid on;

%%
% y = evrnd(0,3,100,1);
% cdfplot(y)
% hold on
% x = -20:0.1:10;
% f = evcdf(x,0,3);
% plot(x,f,'m')
% legend('Empirical','Theoretical','Location','NW')
% 
% 
% 
% yg = wgn(100,1,0);
% end