function la = ewe( d,o )
% EWE berechnet die eigenwerte der homogenen Lösung der Schwingungsgleichung
la(1)=-d*o+sqrt(d^2-1)*o;
la(2)=-d*o-sqrt(d^2-1)*o;

% Plot der homogenen Lösungen
t=0:0.01:(10*o);
y1=real(exp(la(1)*t));
y2=imag(exp(la(2)*t));
plot(t,y1,'r',t,y2,'b',t,y1+y2,'k','LineWidth',2 );

%Harmonische Anregung, inhomogene DGL
om=2
A=1/(sqrt(o^2-om^2)^2+4*d^2*o^2*om^2);
phi=atan((2*d*om*o)/(o^2-om^2));
ys=A*cos(om*t-phi);

plot(t,ys,'r',t,y1+y2+ys,'k','LineWidth',2 );

end

