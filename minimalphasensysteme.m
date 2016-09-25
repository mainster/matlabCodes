%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Minimalphasige Systeme 15-01-2016        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Jede reele ratinale tf G(s) kann in einen minimalphasigen Anteil Gm und 
% einen Allpass Ga zerlegt werden.
% Es gilt dann G = Gm*Ga mit der allgemeinen Forderung an allpässe 
% |Ga| = 1 sowie d/dw(Ga(w)) < 0 für alle w in IR 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear s p G ds; 
syms w w0 wc f real; syms p s x

warning('off', 'Control:ltiobject:TFComplex');
ds.a = '----------------------------------------------------------';
ds.b = strrep(ds.a,'-','-');
ds.c = strrep(ds.a,'-','-');

%% positive (komplexe) ns
syms q; assume(real(q) > 0)

%% negative (komplexe) ns und pole)
syms z1 n1 n2; assume(real([z1 n1 n2]) > 0)

%% DC gain
syms k0 real

%%
p=tf('p');

q = -1 + 1.5*1i;
qp = 4 + 0*1i;
z1 = -1 + 2*1i;
n1 = -2 + 3*1i;
n2 = -2 + 1i;
k0 = 1;

%% G(s) = R(s)*(s-q) erweitern mit (s + conj(q))/(s + conj(q))
% G(s) = Gm(s)*Ga(s)
%R = zpk([z1, conj(z1)], [-n1, conj(-n1), -n2, conj(-n2)], k0);
%R.Name = 'R(s)';
PREF='\n\n%s\n  ';

%% TF mit sämtlichen singularitäten in der lhe
Rlhs = @(s) k0 * (s+z1)*(s+conj(z1))/( (s+n1)*(s+conj(n1))*(s+n2)*(s+conj(n2)) );
fprintf([PREF 'Rlhs(s): tf mit sämtlichen singularitäten in der lhe\n%s\n'],ds.b,ds.c)
pretty(Rlhs(s))

%% G(s) = R(s)*(s-q)
G.rat = @(s) Rlhs(s) * (s-qp); % (s - conj(q))/(s - conj(q));
G.sim = @(s) sym(collect(G.rat(s),'s'));
fprintf([PREF 'G(s) = R(s) * (s-q):\n%s\n'],ds.b,ds.b)
pretty(collect(G.rat(s),'s'))
fprintf([PREF 'simplify( G(s) ):\n%s\n'],ds.b,ds.b)
pretty(G.sim(s))

%% Convert 2 lti sys
tmp = str2func(['@(s)' char(G.sim(s))]);
G.tf = tmp(p); 
G.tf.Name = 'R(s)*(s-q)*H(s)';
%%


Gm.rat = Rlhs;
if ~exist('hv', 'var') || ~ishandle(hv)
   hv = ltiview(ol.optlti, G.tf); %, 'r--');
else
  ltiview('current', G.tf,hv); %,'r--', hv);
end


%%
return

%%
clear s; 
syms w w0 wc f real; syms p

optlti = {'bode';'nyquist';'pzmap';'step';'impulse'};

G1 = zpk( +1, [-2 -3], 1, 'Name','G1 pos. NS');
G2 = zpk( [], [-2 -3], 1, 'Name','G2 keine NS');
G3 = zpk( -1, [-2 -3], 1, 'Name','G3 neg. NS');
%%
new=0;
tic
if ~exist('hv', 'var')
   new=1;
else
   if ~ishandle(hv)
      new=1;
   end
end

if new
	hv = ltiview(optlti, G1, G2, G3,'r--');
else
%   ltiview('clear', hv);
   ltiview('current', G1, G2, G3,'r--', hv);
end

vs = get(get(hv,'UserData'));

axs = findall(get(hv,'Children'),'type','axes');

for k=1:length(axs)
   if ~isempty(strfind(axs(k).Title.String, 'Bode'))
      axb = axs(k+1);
   end
end
%%
axes(axb);

legb = legend('show');


% legend({
%    '\fontsize{10} \fontname{Palatino} This is G1',...
%    '\fontsize{15} \fontname{Helvetica} This id G2',...
%    '\fontsize{12} \fontname{Comic Sans MS} This is G3'}, 'Interpreter','tex');
%    
   
return
