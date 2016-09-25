%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% stochastik_zusammenhange.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if false
   clear all; close all; startup_R2015a
end

syms t T T0 w w0 f f0 real;

%% Nutzsignal u(t)
Pu=@(f,Ku,fu,Bu) Ku*rect((f-fu)/Bu);

%% Störsignal r(t)
Pr=@(f,Kr,fr,Br) Kr*rect((f-fr)/Br);

%% parameter
% fu:    delay/shift 
Ku=1;    fu=4; Bu=2;
Kr=1/4;  fr=5; Br=8;
fmax=10e3;

ff=lin(-fmax, fmax, 25e3);
fff=lin(-fmax*2, fmax*2, 20e3);

bandpower( eval(subs(Pu(f,Ku,fu,Bu),'f','ff')))
bandpower( eval(subs(Pr(f,Kr,fr,Br),'f','ff')))

bandpower( eval(subs(Pu(f,Ku,fu,Bu),'f','fff')))
bandpower( eval(subs(Pr(f,Kr,fr,Br),'f','fff')))

