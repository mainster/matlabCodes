%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% loopgain of opAmp driven oscillator 14-04-2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear G*
syms R1 R2 Rs L C real
syms Z1 Gs1 jw
%jw=sym(1i*w);

%% Inverting amp, A=R2/R1 in series with Rs+L+C, V(C) feedback to opamp in R1
%
if 0
   Z1 = Rs+jw*L;
   Z2 = ol.par2(1/(jw*C),R1);
   G0a = -R2/R1*Z2/(Z1+Z2);

   G0ac = collect(G0a,jw);
   pretty(G0ac)
   G0ajw = subs(G0ac,{'R1','R2','Rs','L','C'},{10e3,10e3,0,100e-6,1e-9});
   pretty(G0ajw)
   [na,da] = numden(G0ajw)
   G0a = tf(double(coeffs(na)),double(coeffs(da)))

   Ga = feedback(G0a,1)

   if ishandle(h)
      if ~(get(h,'name')=='Linear System Analyzer'); 
         clear h;
         h=ltiview(ol.optlti,G0a)
      else
         ltiview('clear',h)
         ltiview('current',G0a,h)
      end
   else
      h=ltiview(ol.optlti,G0a)
   end
end
%%
% XL || XC
%
syms L C w kp
L_=10e-6;
C_=100e-9;
R_=10e3;

Pp=p*L/(1+p^2*L*C);
Pp = ol.par3(R,jw*L,1/(jw*C))
pretty(simplify (Pp,'steps',250))
Ps = sym2tf(subs(Pp,{'R','L','C','p'},{R_,L_,C_,'s'}))

G0p = kp*Pp;

p12=solve(G0p==1,kp)
p12e=solve(subs(G0p,{'R','L','C'},{R_,L_,C_})==1,kp)

assume([L,C]>0);
p12= simplify (p12,'steps',250)
p12e= simplify (p12e,'steps',250)
   
if ishandle(h)
   if ~(get(h,'name')=='Linear System Analyzer'); 
      clear h;
      h=ltiview(ol.optlti,Ps)
   else
      ltiview('clear',h)
      ltiview('current',Ps,h)
   end
else
   h=ltiview(ol.optlti,Ps)
end


