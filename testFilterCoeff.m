bb = 1/3*ones(1,3);
ww = -pi:(pi/200):pi;
H = freqz( bb, 1, ww );
subplot(2,1,1)
plot( ww, abs(H) )
%<-- Magnitude
subplot(2,1,2)
plot( ww, angle(H) )
%<-- Phase
xlabel('normalized freq')

