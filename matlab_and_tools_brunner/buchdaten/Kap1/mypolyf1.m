% Programm (mypolyf1.m) zur Untersuchung des Befehls polyfit

%------- Ideale Funktion
x = -10:0.1:10;
n = length(x);

u = [-6, -2, 3, 4.5, 7];      % Maximas
y = zeros(1,n);
randn('seed', 537019);

for k = 1:5
   y = y + randn(1,1)./(1 + 5*(x-u(k)).^2);  
end;

figure(1);     clf;
subplot(211), plot(x,y);
title('Ideale Funktion');
xlabel('x'),       grid;

%------- Verrauschte Meﬂdaten
noise = 0.2;
y = y + randn(1,n)*noise;

%------- Approximation
N = 25;
c = polyfit(x,y,N);
yapp = polyval(c,x);

subplot(212), plot(x,y,x,yapp);
title(['Polynomiale Approximation (Grad = ',num2str(N),')']);
xlabel('x');       grid;