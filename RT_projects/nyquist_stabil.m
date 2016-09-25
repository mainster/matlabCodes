% Nyquist kriterium, stabilität und pole
% Loop gain / Kreisverstärkung
%
delete(findall(0,'type','line'))
% 
% a=1;b=2;c=3;
% [num den]=linmod('symbolic_test');
% 
% sys1=tf(num,den);
% sys1
% 
% nyquist(sys1)

Kp=1; K=0.2; T1=1; T2=4;

%block1='nyquist_stab_mod/Subsystem'
block1='nyquist_stab_mod/Sum'
[cm,dm,mm,info]=loopmargin('nyquist_stab_mod',{block1},1)

[num den]=linmod('nyquist_stab_mod');
sys1=tf(num,den);
sys1p=tf2sym(sys1);

syms p s
factor(5/(5*p^3 + 10*p^2 + 5*p + 1))


