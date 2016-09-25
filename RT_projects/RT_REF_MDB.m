% RT Reference, Control sys tools
%
oldLines=findall(0,'type','line');    % Inhalte der letzten plots löschen, figure handle behalten
delete(oldLines);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Entweder
[num0,den0]=linmod('simplify');     % get num and den 
g00=tf(num0, den0);                 % create tf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% oder
[A,b,c,d]=linmod('simplify');       % get ss-model
[num1,den1]=ss2tf(A,b,c,d);
g01=tf(num1, den1);                 % create tf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% oder
[E,f,g,h]=linmod('simplify');       % get ss-model
[num2,den2]=ss2tf(E,f,g,h)          % convert to den and num
g02=tf(num2, den2);                 % create tf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% oder  Zero Pole Gain

g00
g01
g02

open('simplify.slx');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ueb. Blatt 2, A2






