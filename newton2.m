%% ********** Newton-Verfahren zur bestimmung von Nullstellen ********* %%
function [x,iter]=newton2(fun,x0,tol,iter,options);
% Eingabeparameter sind :
% fun   -   Funktion(funktionhandle) oder Funktionsname(string) deren
%           Nullstelle bestimmt werden soll
% x0    -   ein Starpunkt nahe der gesuchten Nullstelle
% tol   -   Toleranzschranke f?r die Abbruchbedingung und
% iter  -   maximale Anzahl an Iterationen

%%**************** Ueberpruefung der Uebergabeparameter *******************
if nargin == 2;
    tol = eps;
    iter = 16;
    options='y';
elseif nargin == 3;
    iter = 16;
    options='y';
elseif nargin ==4 ;
    options='y';
elseif nargin < 2;
    disp('Zu wenige ?bergabeparameter');
    return
end
%**************************************************************************
  syms x;
  funab= diff(fun(x));  
  x   = x0;
  
  for k=1:iter
    if eval(funab)==0
        error('Abbruch: Ableitung Null!')
    end
    x = x-fun(x)/eval(funab);
    if options == 'y'
    text=sprintf('%2d. Iteration: x0= %d', k, x);
    disp(text);
    end
    if (abs(fun(x))<tol)
      disp(' Geforderte Genauigkeit erreicht!');
      disp(' Benoetigte Iterationen:');
      disp(k);
      break;
    end;
    if (k==iter)
      disp('Maximale Iterationsanzahl erreicht!');
    end;
  end;

% Ende der Funktion newton 