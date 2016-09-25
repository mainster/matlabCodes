% Klausurvorbereitung Stochastik Dez-2015
%
% clearvars('-except',INITIALVARS{:});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%return

hf = findall(0,'type','figure');
plottype = 'plot';
NPTS = 100;

if ~isempty(hf)
   origNum = [hf.Number];
   oldpos = cell2mat({hf.Position}');
end

%delete(findall(0,'type','line'));

close all;
colordef('black')    %reset(groot); run start;

if ~isempty(hf)
   for k=1:length(hf)
      fi(k)=figure(k);
      fi(k).Position=oldpos(k,:);
   end
else
   fi(1)=figure(1);
end

SUBS=210;
s1=subplot(SUBS+1); hold all;
s2=subplot(SUBS+2); hold all;
   
syms b real
alpha=[1 2 3 4 5];

for k=1:length(alpha)
   x1.f  =@(t) exp(alpha(k).*t);
   deriv = subs(diff(x1.f(t),t),'t','0').*t + solve( subs(diff(x1.f(t),t).*t,'t','0')+b==1, b);
   x1.df0 =str2func(['@(t)' char(deriv)]);
   X1(k)=x1;
end
%%


subplot(s1); hold all;
for k=1:length(alpha)
   ezplot(X1(k).f(t)); 
end
ylim([0,5]); xlim auto 
hold off;


subplot(s2); hold all;
for k=1:length(alpha)
   ezplot(X1(k).df0(t)); 
end
ylim([0,5]); xlim auto
hold off;



return

tmp={'f','df0'};

if ~strcmpi(plottype,'ezplot')
   tt=zeros(NPTS,2);
   for m=1:2
      val=zeros(1,length(X1));
      for k=1:length(X1)
         val(k)=solve(X1(k).(tmp{m})(t)==5,t);
      end
      tt(:,m)=linspace(0,ceil(10*max(val))/10,NPTS);
   end
end
%%

for k=1:length(alpha)
   if strcmpi(plottype,'ezplot')
      subplot(s1); 
      ezplot(X1(k).f(t)); 
      subplot(s2); 
      ezplot(X1(k).df0(t)); 
   else
      plot(s1, tt(1),X1(k).f(tt(1,:))); 
      plot(s2, tt(2),X1(k).df0(tt(2,:))); 
   end
end
hold off;

return 









return

if exist('f(1)','var')
   clf(f(1))
end
clear Xr X1 X2

T=2;
t1=2;

xr=@(t) rect(t);
Tr=@(w) fourier(xr(t),t,w);
Xr=@(w) Tr(w);

ww=linspace(-35,35,500); 
f(1)=figure(1);

plot(ww,double(subs(Xr,w,ww))); hold all
disp('plot 1')
drawnow 

x1=@(t) rect((t-t1)/T);
T1=@(w) real(fourier(x1(t),t,w));
X1=@(w) T1(w);

plot(ww,double(subs(X1,w,ww))); 
disp('plot 2')
drawnow 

xlim([min(ww),max(ww)])
xlabel('\omega','FontSize',18,'FontWeight','bold');
plot( -10*pi:pi:10*pi,zeros(1,length(-10*pi:pi:10*pi)),'x')

%%
legend('Xr(w)','X1(w)','pi')

f2 = figure(2);

ix1=@(t) ifourier(2*sin(2*pi*f)/(2*pi*f),f,t)

T=1;
ixr=@(t) ifourier(T*sin(T*pi*f)/(T*pi*f),f,t)

ezplot(ixr(t),[-5,15])