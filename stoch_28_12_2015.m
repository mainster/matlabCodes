%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Stochastik 15-01-2016        SS14  A.3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gegeben ist Amplitudengang A(w) und die Bedingung, dass die tf G(s) 
% stabil sein minimalphasig sein soll...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear s; syms w w0 wc f real; syms p s

An = sqrt(25);
Ad = sqrt(w^4-6*w^2+25);
A = str2func(['@(w)' char(eval('An/Ad'))]);
% 
% % A(i*s)^2;
% Asq = str2func(['@(p)' char(A(1i*p).^2)]);
% 
% %%
% G1 = sym2tf((A(1i*p)).^2);
% G1.Name = 'A(i*s)^2';
% 
% f1 = figure(1);
% SUBS = 120;
% 
% subplot(SUBS+1);
% bodeplot(G1,ol.optb); hold all;
% legend('show');
% 
% subplot(SUBS+2);
% pzmap(G1)
% legend('show');
% 
% %%
% f2 = figure(2);
% SUBS=120;
% 
% A = dotExpansion(A);
% 
% sp(1) = subplot(SUBS+1);
% ezplot(A(w),[1e-1, 1e1]); hold all;
% ezplot(Asq(s),[1e-1, 1e1]); hold off;
% legend('A(w)','A(i*s)^2');
% ylim auto
% 
% sp(2) = subplot(SUBS+2);
% ezplot(A(w),[-1, 1]*1e1); hold all;
% ezplot(Asq(s),[-1, 1]*1e1); hold off;
% legend('A(w)','A(i*s)^2');
% ylim auto
% 
% %%
% 
% G5 = zpk(-3,[-2 -1],1,'Name','G1');
% G6 = zpk(+3,[-2 -1],1,'Name','G2');
% 
% if ~exist('hv','var')
%    hv = ltiview(ol.optlti,G5,G6)
% end
% 
% return 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Stochastik 28-12-2015        SS11  A.6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Die Zufallsvariable X hat die Dichtefunktion fx(x) mit a > 0 und c > 0.
% Berechnen Sie die Konstanten a und c so, dass die Varianz den Wert 1
% annimmt!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delete(findall(0,'type','line'));
clearvars('-except',INITIALVARS{:})
%%
clear x a c
syms x a c real
assumeAlso([a,c] > 0);
VAR = 1;

%%%%%
% Laut Aufgabe ist b=3
B = 3;

fx  = @(x,a,c) c.*exp(abs(x-B)./a);

fxl = @(x,a,c) c.*exp((x-B)./a);
fxr = @(x,a,c) c.*exp(-(x-B)./a);

%%
%int(fx(x,a,c),x,-inf,inf)
f1=figure(1);
xx=lin(0,2*B,100);

C   = solve( int(fxl(x,a,c),x,-inf,B) + int(fxr(x,a,c),x,B,inf) == 1, c)
mx  = int(x.*fxl(x,a,C),x,-inf,B) + int(x.*fxr(x,a,C),x,B,inf) 
sx2 = int(x.^2*fxl(x,a,C),x,-inf,B) + int(x.^2*fxr(x,a,C),x,B,inf) 
A  = solve(sx2 - mx.^2 == VAR, a)

if ~isnumeric(A)
    A = double(A);
end
if ~isnumeric(C)
    C = double(subs(C,'a',A));
end
%%
plot(xx,subs(fxl,{'x','a','c','B'},{xx,A,C,B})); hold all;
plot(xx,subs(fxr,{'x','a','c','B'},{xx,A,C,B})); 
plot(xx,subs(fx,{'x','a','c','B'},{xx,A,C,B})); 
legend(['fxl=' char(fxl(x,a,c))], ['fxr=' char(fxr(x,a,c))], char(fx(x,a,c)));
ylim([0, 2*C]);

hold off;
%%

mx_  = int(x.*fxl(x,A,C),x,-inf,B) + int(x.*fxr(x,A,C),x,B,inf); 
sx2_ = int(x.^2*fxl(x,A,C),x,-inf,B) + int(x.^2*fxr(x,A,C),x,B,inf); 





