function snr_psd_stochastik ()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stochastik Klausur SS2012 Aufgabe 5
% awgn() power spectral density
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   clear nfhs nam M fhs choice
%   global fhs nam nam M fhs choice;
   global fs Bs fr Br 
%% Rectangular power density
   fs=4e3; Bs=2e3;   % payload signal
   fr=5e3; Br=8e3;   % noise signal

   evalin('base', 'global fhs nam M fhs choice f1')
   fhs = localfunctions;
   nam = cellfun(@func2str, fhs,'UniformOutput',false)

   M = [num2cell( 1:length(nam) ); nam']

   fprintf('Select function: \n')
   fprintf('[%i] %s\n', M{:})
   
    choice = input(sprintf('Selection: '));
%   choice = 1;
   
   eval(M{2,choice})
   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Stochastik Klausur SS2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function SS2012 ()
   syms t T w w0 T0 real
   assumeAlso([T,T0,t]> 0);
   
   %% invoke variables inside a (private) function
   bfc_ = struct2cell( getappdata(0,'basefunctions') );
   na_ = fieldnames( getappdata(0,'basefunctions') );
   
   for k=1:length(na_)
      eval([na_{k} '=' char(bfc_{k}) ';']);
   end
   clear *_;
   
   %% Time domain system impulse response 
   g = @(t,T) 2* rect((t-T)/(2*T)) - rect((t-5/2*T)/T);
%    g_ = dotExpansion(g);
   
   %% x vector as function of onknown time constant T
%    tt = @(T) linspace(0,5/T,500);
   tt = @(T) 0:T/100:5*T;
   
   %% Impulse response as function T
   gT = @(T) g(tt(T),T);
   
   %% select a value for T
   T0=1e-3;
   
   %% Spawn a double_t evaluated gy vector 
   gy = gT(T0);
   
   %% Plot impulse response
   f1=figure(1);
   delete(findall(f1,'type','line'));
   plot(tt(T0), gy, 'o-'); 
   
   tt_=tt(T0);
   axis([0, tt_(end), -1.5, 3]);
   
   %% Laplace transform
   syms s 
   
   G = @(s,T) laplace(g(t,T0),t,s)
   G(s,T)
   Gw = @(w,T) G(1i*w,T) 
   
   
   return
   
   
   
   %%
   syms fg real 
   syms A2(w,T) 
   global f1

   Af = @(w,T) 4*T/(w*T)*(sin(w*T)-sin(w*T/2));
   A2(w,T) = 4*T/(w*T)*(sin(w*T)-sin(w*T/2));

   Af = dotExpansion(Af);
   wwlog = logspace(-1,2,1000);
   
   f1=figure(1);
   setappdata(f1,'xvect',wwlog);
   
   plot(wwlog,Af(wwlog,1))
   ax=gca;
   set(ax, 'XScale','log','YScale','lin');

   % Create slider
   sld = uicontrol(  'Style', 'slider','Min',1,'Max',max(wwlog),...
                     'Value',max(wwlog)/2, 'Position', [400 20 120 20],... 
                     'Callback', @slidhandler); 

   jButton = findjobj(sld);
   jButton.MouseWheelMovedCallback = @slidhandler;%(sld,0);

   % Add a text uicontrol to label the slider.
   txt = uicontrol(  'Style','text','Position',[400 45 120 20],...
                     'String','Vertical Exaggeration');
   
             
% return
% 
%    SNR1 = @(fg) 2*sqrt( (2-fg*pi/180*atan(5/fg)+fg*pi/180*atan(3/fg)) / (8-fg*pi/180*atan(9/fg)+fg*pi/180*atan(1/fg)) );
%    SNR2 = str2func( ['@(fg)' regexprep(char(SNR1(fg)),{'*','/','\^','atan'},{'.*','./','.^','atand'})] );
% 
%    fggs = [.5 1:10];
%    fgg = 0 :.1: 10;
% 
%    plot(fgg, SNR2(fgg)); hold all;
%    plot(fggs, SNR2(fggs),'o');
end

   function slidhandler(source, callbackdata)
      whos source
      source
      wwlog = getappdata(gcf,'xvect'); 
      ax = gca;
      val = max(wwlog) + 1 - source.Value
      % For R2014a and earlier:
      % val = 51 - get(source,'Value');
      [0 val]
%       xlim(ax,[0 val]);
   end  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% timeAvg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function timeAvg ()
   % clear all
   %% Define Parameters

   % sampling frequency (Hz)
   fs=100e6;

   % length of time-domain signal
   L=30e3;

   % desired power specral density (dBm/Hz)
   Pd=-100;

   % number of FFT points
   nfft=2^nextpow2(L);

   % frequency plotting vector
   f=fs/2*[-1:2/nfft:1-2/nfft];

   % create
   s=wgn(L,3,Pd+10*log10(fs),1,[],'dBm','complex');

   %% Analysis

   % analyze spectrum
   N=nfft/2+1:nfft;
   S=fftshift(fft(s,nfft));
   S=abs(S)/sqrt(L*fs);

   % time-average for spectrum
   Navg=4e2;
   b(1:Navg)=1/Navg;
   Sa=filtfilt(b,1,S);

   % convert to dBm/Hz
   S=20*log10(S)+30;
   Sa=20*log10(Sa)+30;

   %% Plot
   figure(1)
   clf
   plot(f(N)/1e6,S(N))
   hold on
   plot(f(N)/1e6,Sa(N),'r')
   xlabel('Frequency (MHz)')
   ylabel('Power Density (dBm/Hz)')
   title(['Power Spectral Density'])
   legend('Noise Spectrum','Time-Averaged Spectrum')
   axis([10e-4 fs/2/1e6 -120 -60])
   grid on
   hold off

   return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% characteristicFunc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function characteristicFunc ()
   syms w a sx2 t real

   clear Phi Phir
   % Leistungsdichte Phir(w) des Rauschsignals r(t)
   Phir = @(w) 2./(w.^2+5);

   % Standarddarstellung der Leistungsdichte (Stöckle, Stochastik Skript S.142)
   Phi = @(w,a,sx2) sx2*(2.*a)./(w.^2+a.^2);
   pretty(Phir(w))
   pretty(Phi(w,a,sx2))

   f1=figure(1); clf;
   SUB=210;

   subplot(SUB+1);
   ezplot(Phir(w)); hold all;
   ezplot(Phi(w,2,0.5)); hold off;

   legend({['$$' latex(Phir(w)) '$$']; ['$$' latex(Phi(w,a,sx2)),...
            '$$ mit a=2, sx=.5']},'FontSize',16,'Orientation','Horizontal');

   %%

   sol=solve(Phi(w,a,sx2)==Phir(w),sx2)

   if iscell(sol)
      sol{:}
   else
      if isstruct(sol)
         nam=fieldnames(sol);
         sol.(nam{1})
      end
   end
   return

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% rectDensity1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rectDensity1 ()
   
   syms f t w T reals;
   delete(findall(0,'Type','line'))
   global Pss Prr Pxx ff
   evalin('base', 'global Pss Prr Pxx ff')
   V=1;

   Bu=5e3-3e3;    % PSD bandwidth of signal
   Br=9e3-1e3;    % PSD bandwidth of noise
   nper = 20;

   %% Rectangular power density
   Pss = @(f) V.*rect((f-4e3)/Bu);
   Prr = @(f) V/4.*rect((f-5e3)/Br);
   Pxx = @(f) V.*rect((2*pi*f)/Bu);
   ff  = linspace(-10e3, 10e3,1e3);
   
   f1=figure(1);
   SUB=310;
   clear l;

   %% Plot both density functions in freq. domain
   su(1) = subplot(SUB+1);
   ezplot(Pss(f), [0,10e3]); hold all;
   ezplot(Prr(f), [0,10e3]); hold off;
   ylim([-.1 1.1]*V);
   title('Power spectral density');
   l(1)=legend('$\phi_{ss}$','$\phi_{rr}$');
   xl=xlabel('Frequency / kHz');
   xl.Position=[9500 -.2580 -1];

   XTL=get(su(1),'XTickLabel');
   xtd = linspace(str2double(XTL{1}), str2double(XTL{end}), length(XTL))' * 1e-3;
   set(su(1),'XTickLabel',cellstr(num2str(xtd)));

   %% Apply inverse fourier transformation to get correlation sequence
   pss = @(t) simplify(ifourier(Pss(f),f,t),'steps',50);
   prr = @(t) simplify(ifourier(Prr(f),f,t),'steps',50);
   pxx = @(t) simplify(ifourier(Pxx(f),f,t),'steps',50);

   tt = lin(-nper/Bu, nper/Bu, 2500);
   tt(tt==0) = 1e-25;

   if ~exist('pssy','var') 
      pssy=[];
      prry=[];
      pxxy=[];
   end

   if length(pssy) ~= length(tt) || true
      pssy = eval( subs(pss(t),'t','tt') );
      prry = eval( subs(prr(t),'t','tt') );
      pxxy = eval( subs(pxx(t),'t','tt') );
   end

   pssyRe = real(pssy);
   prryRe = real(prry);
   pxxyRe = real(pxxy);


   %% Plot both correlation sequences
   subplot(SUB+2);
   plot(tt, pssyRe); hold all;
   plot(tt, prryRe); 
   plot(tt, pxxy); 
   plot(tt, pxxyRe); hold off;
   title('Auto correlation');
   l(2)=legend('$\varphi_{ss}$','$\varphi_{rr}$',...
                     '$\varphi_{xx}$','$\varphi_{xx}\mathrm{R}$');
   xlim([-nper/Bu, nper/Bu]);

   %%
   set(l(1:end),'Interpreter','latex','FontSize',16,'FontWeight','Normal');


   % plot(tt,psss(tt)); 
   return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% f to w
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function next () 
global setWrap getWrap reim vname par2 par3 ol csigma rect tri lin;
global fs Bs fr Br pi2
syms f t w T reals;

delete(findall(0,'Type','Axes'));


   Phis = @(f,V) V.*rect((f-fs)/Bs);
   Phir = @(f,V) V/4.*rect((f-fr)/Br);
   Phisw = @(w,V) V.*rect((w-2*pi*fs)/(2*pi*Bs));
   Phirw = @(w,V) V/4.*rect((w-2*pi*fr)/(2*pi*Br));
   ff  = linspace(0, 10e3,1e3);
   ffpm  = linspace(-10e3, 10e3,1e3);
 
   fprintf('bandpower(Phis(ff,1)) = %gdB\n',...
      10*log10(bandpower(eval(subs(Phis(f,1),'f','ff')))))
   fprintf('bandpower(Phir(ffpm,1)) = %gdB\n',...
      10*log10(bandpower(eval(subs(Phir(f,1),'f','ffpm')))))
   fprintf('bandpower(Phisw(ff*2*pi,1)) = %gdB\n',...
      10*log10(bandpower(eval(subs(Phisw(f*2*pi,1),'f','ff')))))
   fprintf('bandpower(Phirw(ffpm*2*pi,1)) = %gdB\n',...
      10*log10(bandpower(eval(subs(Phirw(f*2*pi,1),'f','ffpm')))))
   %%
   f1=figure(1);
   SUB=210;
   subplot(SUB+1)
   ax(1) = gca;
   ezplot(Phis(f,1),[0,10e3]); hold all;
   ezplot(Phisw(f,1),[0,10e3]); 
   ezplot(Phir(f,1),[0,10e3]); 
   ezplot(Phirw(f,1),[0,10e3]); hold off; 
   xlabel('Frequency / Hz');
   l(1)=legend('$\phi_{s}(f)$','$\phi_{r}(f)$','$\phi_{sw}(f)$','$\phi_{rw}(f)$');

   set(l(1:end),'Interpreter','latex','FontSize',16,'FontWeight','Normal');
   ylim([-.1,1.1]*1);
   title('PSD''s Payload (s) | Noise (r)')

   subplot(SUB+2)
   ezplot(Phisw(w,1),[0,2*pi*10e3]); hold all;
   ezplot(Phirw(w,1),[0,2*pi*10e3]); hold off;
   xlabel('$$\omega / rad$$','Interpreter','latex');
   l(1)=legend('$\phi_{sw}(w)$','$\phi_{rw}(w)$');

   set(l(1:end),'Interpreter','latex','FontSize',16,'FontWeight','Normal');
   ylim([-.1,1.1]*1);
   title('PSD''s Payload (s) | Noise (r)')
%% Plot both density functions in freq. domain
%   su(1) = subplot(SUB+1);
   FMAX=10e3;
   
   f2=figure(2);
   delete(findall(f2,'Type','Line'));

   SUB=210;
   subplot(SUB+1);
   ax(1) = gca;
   ezplot(Phis(f,1),[0,FMAX]); hold all;
   ezplot(Phir(f,1),[0,FMAX]); hold off;
   
   xlabel('Frequency / Hz');
   set(l(1:end),'Interpreter','latex','FontSize',16,'FontWeight','Normal');
	l(1)=legend('$\phi_{s}(f)$','$\phi_{r}(f)$');

   ylim([-.1,1.1]*1);
   xlim([0,FMAX]);
   title(' ');
%%
   
%    ax(2)= axes('Position',ax(1).Position,...
%                'XAxisLocation','top',...
%                'YAxisLocation','left',...
%                'Color','none');
   subplot(SUB+2);

   ezplot(1.05*Phisw(f,1),[0,FMAX]*pi2); hold all;
   ezplot(1.05*Phirw(f,1),[0,FMAX]*pi2); hold off;
   xlabel('Frequency / rad/s'); hold all;
   l(2)=legend('$\phi_{sw}(f)$','$\phi_{rw}(f)$');
	title(' ');

%%
   set(l(1:end),'Interpreter','latex','FontSize',16,'FontWeight','Normal');
   ylim([-.1,1.1]*1);

   
   %%
%    ax(2).Position=ax(2).Position - [ax(2).Position(3:4)*2 0 0]   
end


