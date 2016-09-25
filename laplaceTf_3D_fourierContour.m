%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    Um den Zusammenhang zwischen Laplace und Fourier Transformatin 
%%    zu verdeutlichen, ist eine Visualisierung wie bei H. Strohrmann 
%%    im Skript bisher die Beste Lösung...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

syms s

%% Tf mit einem komplexen Polpaar in der LHE
%
G = @(s) 1/((s+1+1i*2)* (s+1-1i*2));

%% Bei der Überführung vom Laplace in den Spektralbereich muss zunächst geprüft
% werden, ob das Fourier-Integral existiert! 
% Bei der Berechnung der Laplace-Transformierten muss der Konvergenzbereich 
% der Transformation eingehalten werden. 
% Für die Überführung von Laplace nach Fourier muss sichergestellt werden, dass
% die imaginäre Achse s=j*w innerhalb des Konvergenzbereichs der Laplace-
% Transformation liegt.
% 
% In diesen Fällen gillt G(i*w) = G(s)|s=i*w
%

%% Die Laplacetransformierte in einem Raum
% Um eine Funktion im Raum zu plotten, sind mind. zwei freie Variablen Variablen
% Notwendig. Da die Laplace Variable s als komplexes Element betrachtet werden
% muss (komplexe Pole bzw. negative Radikanten) biehtet es sich an, s 
% entsprechend x,y aufzuteilen:
%
% s = real(s) + i*imag(s)
%
% Da man ohnehin Betrag und Phase einer komplexwertigen Funktion getrennt
% zeichnen muss, gilt folgende Abbildung für G:
%
% G(s) |--> |A(Re(s),Im(s))|     also G(s) geht über in ihre Betragsfunktion
%                                wobei das komplexe Argument s, nach der Berechn.
%                                Vorschrift x=real(s), y=imag(s) in einen
%                                2-Tupel zerlegt wird. 
%%
clear x y; syms x y real
hh = str2func(['@(x,y)',char( evalc('disp(abs(G(x+y)))') )]);

A = @(x,y) 1/(abs(x + y + 1 - 2i)*abs(x + y + 1 + 2i));
A = dotExpansion(A);

[xx,yy] = meshgrid(linspace(-10,10,80)); 

mesh(xx,yy,A(xx,yy))

%%
%% http://www.seas.upenn.edu/~ese216/handouts/Chpt14_3DPlotTransferFunction.pdf

>> [X,Y]=meshgrid(-10:0.5:10);
>> F2=(X.^2+Y.^2)./(sqrt((X.^2-Y.^2+2*X+5).^2+(2*X.*Y+2*Y).^2)+eps);
>> mesh(X,Y,F2) 










