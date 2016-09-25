%% Formelsammlung Nachrichtentechnik I
% Author:		Manuel Del Basso \n
% Erstellt:		31-01-2015
%

%
%% Pulsformung
%
% RC Filter 
% $$e^{\pi i} + 1 = 0$$
%
% a := 2: id(a + 2)
% clear all;
delete(findall(0,'Type','Line'));
delete(findall(0,'Type','Text'));
syms f t r fn reals
sigma = @(x) heaviside(x);
rect = @(x) sigma(x+0.5)-sigma(x-0.5);

fsym = 1e3;
fnyq = fsym/2;
r_rc = [.25, 1, .75, 1];
tsym = 1/fsym;

hrc=@(t,fn,r) 2*fn*sin(2*pi*fn*t)./(2*pi*fn*t).*cos(2*pi*r*fn*t)./(1-(4*r*fn*t).^2);
hrrc=@(t,fn,r)sqrt(hrc(t,fn,r));

Hrc1 = @(f,fn,r) (cos(pi/4*(abs(f)-(1-r)*fn)/(r*fn))).^2 .* (jump(f+(1+r)*fn)-jump(f-(1+r)*fn));
Hrc2 = @(f,fn,r) -( ((cos(pi/4*(abs(f)-(1-r)*fn)/(r*fn))).^2 -1).* (jump(f+(1-r)*fn)-jump(f-(1-r)*fn)));
Hrc = @(f,fn,r) Hrc1(f,fn,r)+Hrc2(f,fn,r);

di=[1 1 -1 1 -1 -1 1];
leadingZeros = 3;
ditt=upsample([zeros(1, leadingZeros-1), di, 0],100);
% ditt=[ditt(2:end) 0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RC Pulsformer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1=figure(1); 
SUB=[8,1,0];
XAX = [-leadingZeros,length(di)]*tsym;
hold all;

YL = [	limit(min(di)*hrc(t, fnyq, r_rc(1)),t,0),...		% min
		limit(max(di)*hrc(t, fnyq, r_rc(1)),t,0)];					% max
YL = round(12*eval(YL))/10;								% 20% drauf und runden	
Tsym = @(x) [[x x], YL];

tt=linspace(XAX(1),XAX(2),length(ditt));
sp = zeros(1,3);
spdi=subplot(SUB(1),SUB(2),[1, 2]);
stem(tt, ditt,'.','LineWidth',2);
ylim([-1,1]*2)
xlim(XAX);


%--------------------------------
% for m=1:2
% m=1;
sp = [	subplot(SUB(1),SUB(2),[3:5]),...
		subplot(SUB(1),SUB(2),[3:5]+3) ];
subplot(sp(1)); hold all;
subplot(sp(2)); hold all;

for k=0:length(di)-1
	subplot(sp(1));
	ln(1) = ezplot(di(k+1)*hrc(t-k*tsym, fnyq, r_rc( 1 )), XAX); 
	nTsym = Tsym(k*tsym);
	line(nTsym(1,1:2),nTsym(1,3:4), 'Color', 'black', 'LineStyle', '--')

	subplot(sp(2));
	ln(2) = ezplot(di(k+1)*hrc(t-k*tsym, fnyq, r_rc( 2 )), XAX); 
	nTsym = Tsym(k*tsym);
	line(nTsym(1,1:2),nTsym(1,3:4), 'Color', 'black', 'LineStyle', '--')

	set(ln(:),'LineWidth',2);
end

set(sp(:),'YLim',YL,'NextPlot','replace');
delete(cell2mat(get(sp,'Title')));
set([sp spdi],'XTickLabel',{strcat(num2str([-2:8]'), repmat('Ts',11,1))});

subplot(sp(1));
tx(1)=text(-2.5e-3, 500, sprintf('r=%g',r_rc(1)),...
	'FontSize',16,'BackgroundColor','white',...
	'HorizontalAlignment','center', 'EdgeColor','red','LineWidth',2);
subplot(sp(2));
tx(2)=text(-2.5e-3, 500, sprintf('r=%g',r_rc(2)),...
	'FontSize',16,'BackgroundColor','white',...
	'HorizontalAlignment','center', 'EdgeColor','red','LineWidth',2);
subplot(spdi);
tx(3)=text(2e-3, 1.8, sprintf('Raised Cosine Pulsformung'),...
	'FontSize',16,'BackgroundColor','white',...
	'HorizontalAlignment','center', 'EdgeColor','red','LineWidth',2);
% end
%%
f99=figure(99);
ezplot(Hrc(f,fnyq,r_rc(1)),[-1,1]*2*fnyq)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RRC Pulsformer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f2=figure(2); 
SUB=[8,1,0];
XAX = [-leadingZeros,length(di)]*tsym;
hold all;

YL = [	limit(min(di)*hrrc(t, fnyq, r_rc(1)),t,0),...		% min
		limit(max(di)*hrrc(t, fnyq, r_rc(1)),t,0)];					% max
YL = round(12*eval(YL))/10;								% 20% drauf und runden	
Tsym = @(x) [[x x], YL];

tt=linspace(XAX(1),XAX(2),length(ditt));
sp = zeros(1,3);
spdi=subplot(SUB(1),SUB(2),[1, 2]);
stem(tt, ditt,'.','LineWidth',2);
ylim([-1,1]*2)
xlim(XAX);


%--------------------------------
% for m=1:2
m=1;
	sp = [	subplot(SUB(1),SUB(2),[3:5]),...
			subplot(SUB(1),SUB(2),[3:5]+3) ];
	subplot(sp(1)); hold all;
	subplot(sp(2)); hold all;
	
	for k=0:length(di)-1
		subplot(sp(1));
		ln(1) = ezplot(di(k+1)*hrrc(t-k*tsym, fnyq, r_rc( 1 )), XAX); 
		nTsym = Tsym(k*tsym);
		line(nTsym(1,1:2),nTsym(1,3:4), 'Color', 'black', 'LineStyle', '--')

		subplot(sp(2));
		ln(2) = ezplot(di(k+1)*hrrc(t-k*tsym, fnyq, r_rc( 2 )), XAX); 
		nTsym = Tsym(k*tsym);
		line(nTsym(1,1:2),nTsym(1,3:4), 'Color', 'black', 'LineStyle', '--')

		set(ln(:),'LineWidth',2);
	end
	
	set(sp(:),'YLim',YL,'NextPlot','replace');
	delete(cell2mat(get(sp,'Title')));
	set([sp spdi],'XTickLabel',{strcat(num2str([-2:8]'), repmat('Ts',11,1))});

	subplot(sp(1));
	tx(1)=text(-2.5e-3, 500, sprintf('r=%g',r_rc(1)),...
		'FontSize',16,'BackgroundColor','white',...
		'HorizontalAlignment','center', 'EdgeColor','red','LineWidth',2);
	subplot(sp(2));
	tx(2)=text(-2.5e-3, 500, sprintf('r=%g',r_rc(2)),...
		'FontSize',16,'BackgroundColor','white',...
		'HorizontalAlignment','center', 'EdgeColor','red','LineWidth',2);
	subplot(spdi);
	tx(3)=text(2e-3, 1.8, sprintf('Root Raised Cosine Pulsformung'),...
		'FontSize',16,'BackgroundColor','white',...
		'HorizontalAlignment','center', 'EdgeColor','red','LineWidth',2);
	% end
	
return
%%
hh = hrc(t,10,.5)
res=evalin(symengine, 'numeric::solve(hh==0,t=-3..3)')
hold all;
plot(res,zeros(1,length(res)),'o')
hold off;

%%
% 
% $$e^{\pi i} + 1 = 0$$
% 

syms w wn r real
Hrc=@(w,wn,r) piecewise([(1-r)<=abs(w)/wn<=(1+r),1],[abs(w)/wn<=(1-r),1])


