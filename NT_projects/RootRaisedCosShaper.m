% Root Raised-Cosine Filter / Pulsform
%
% t:    timevector
% Ts:   Symbol time
% r:    Role- off faktor
% dom:  Domain, Time or Frequency
%
function [res] = RootRaisedCosShaper(x,Ts,r,dom)
    jump=@(xx) (0.5*sign(xx)+0.5);
    
    if dom=='time'
        fs=1/Ts;
        fn=fs;
%        sig=@(x) 2*fn*sinc(2*pi*fn*x).*cos(2*pi*r*fn*x)./(1-(4*r*fn*x).^1);
        sig=@(x) ( 4*r/(pi*sqrt(Ts))* (cos((1+r)*pi*x/Ts)+Ts./(4*r*x).*sin((1-r)*pi*x/Ts))./(1-(4*r*x/Ts).^2) ) 
        res = sig(x);
    else
        res=-1;
        
    end
    if dom=='freq'
        fs=1/Ts;
        fn=fs/2  % Nyquist frequency --> fn=fs/2 (half the symbol frequency)

%         Hrc= @(x) (cos(pi/4*(abs(x)-(1-r)*fn)/(r*fn))).^2 .* (jump(x+(1+r)*fn)-jump(x-(1+r)*fn));
%         Hrc2= @(x) -( ((cos(pi/4*(abs(x)-(1-r)*fn)/(r*fn))).^2 -1).* (jump(x+(1-r)*fn)-jump(x-(1-r)*fn)));

        res= 0;
    end

end