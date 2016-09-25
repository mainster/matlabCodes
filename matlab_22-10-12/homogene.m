function la = ewe( d,o )
% homogene berechnet die eigenwerte der homogenen Lösung der Schwingungsgleichung
la(1)=-d*o+sqrt(d^2-1)*o;
la(2)=-d*o-sqrt(d^2-1)*o;

% Plot der homogenen Lösungen
t=0:0.01:(10*o);
y1=real(exp(la(1)*t));
y2=imag(exp(la(2)*t));
plot(t,y1,'r',t,y2,'b',t,y1+y2,'k','LineWidth',2 );


end

