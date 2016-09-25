%function wave_equation
%**********************************************************************
%*
%* Loesung der eindimensionalen Wellengleichung
%*
%*   (d/dt)^2 u(x,t) = c^2 (d/dx)^2 u(x,t)
%*
%* auf dem Intervall [0,L] mit einem expliziten Verfahren 2. Ordung
%* fuer den Spezialfall c=1, L=1 und die Anfangs- und Randbedingungen
%*
%*        u(x,0) = f(x)
%*   d/dt u(x,0) = g(x)
%*
%*   u(0,t) = u(L,t) = 0
%*
%* (Die Anzahl der raeumlichen Teilintervalle ist mit n=100 fixiert.)
%*
%* Eingabe
%*
%*   tmax...Integration von t=0 bis t=tmax
%*   dtpr...Zeitintervall zwischen Ausgaben in File
%*
%* Ausgabe
%*
%**********************************************************************/
 
clc
 
n = 100;
c = 1.0;        % mein a
e = 2.718281828459;
 
tmax = 0.0;
dtpr = 0.0;
 
dx = 1.0/n;     % mein h
dt = dx/c;      % mein k
 
alpha   = c * dt/dx;
alpha2  = alpha * alpha;
itmax   = (tmax/dt + 0.5);
itpr    = (dtpr/dt + 0.5);
 
x=zeros(size(2:n)); 
u=zeros(size(2:n)); 

for j=2:n
    x(j) = j * dx;
    % Anfangsbedingung u(x,0) = f(x);
    u(j) = e^(-100*(x(j)-0.5)*(x(j)-0.5));
end;
 
x(n+1)    = 1.0;
u(n+1)    = 0.0;
 
uold = zeros(size(2:n));
 
for j=2:n
                                                                % Anfangsbe
                                                                % dingung
                                                                % d/dt
                                                                % u(x,0) =
                                                                % g(x)
    uold(j)=(1.0-alpha2)*u(j)+0.5*alpha2*(u(j+1)+u(j-1))-dt * (-200*c*(x(j)-0.5)*e^(-100.0*(x(j)-0.5)*(x(j)-0.5)));
end;
 
uold(n+1)=0.0;
 
t       = 0.0;
 
for it=2:n+1
   %ausgabe x[j],t,u[j]
   plot(x(it),u(it))
   hold on
end;
%%
%erg = input('Taste druecken');
hold off

f3=figure(2);
clf(f3)
plot3(0,0,0)
hold all
%%
for it=2:n % 2:itmax+1
   unew = zeros(size(2:n));
    for j=2:n
        unew(j)=2.0*(1-alpha2)*u(j)+alpha2*(u(j+1)+u(j-1))-uold(j);
    end;
    unew(1) = 0.0;
 
    t   = it * dt;
 
    for j=1:n%n+1
        uold(j) = u(j);
        u(j)    = unew(j);
    end;
    if mod(it,itpr) == 0 
        for j=1:n+1
           %Ausgabe x[j],t,u[j]
           plot3(x(j),t,u(j),'.')
           
        end        
    end        
end;