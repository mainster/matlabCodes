%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Inverted Pendulum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% http://ctms.engin.umich.edu/CTMS/index.php?example=InvertedPendulum&section=SystemModeling


M = 0.5;
m = 0.2;
b = 0.1;
I = 0.006;
g = 9.8;
l = 0.3;
q = (M+m)*(I+m*l^2)-(m*l)^2;
s = tf('s');

P_cart = (((I+m*l^2)/q)*s^2 - (m*g*l/q))/(s^4 + (b*(I + m*l^2))*s^3/q - ((M + m)*m*g*l)*s^2/q - b*m*g*l*s/q);

P_pend = (m*l*s/q)/(s^3 + (b*(I + m*l^2))*s^2/q - ((M + m)*m*g*l)*s/q - b*m*g*l/q);

sys_tf = [P_cart ; P_pend];

inputs = {'u'};
outputs = {'x'; 'phi'};

set(sys_tf,'InputName',inputs)
set(sys_tf,'OutputName',outputs)

sys_tf


M = .5;
m = 0.2;
b = 0.1;
I = 0.006;
g = 9.8;
l = 0.3;

p = I*(M+m)+M*m*l^2; %denominator for the A and B matrices

A = [0      1              0           0;
     0 -(I+m*l^2)*b/p  (m^2*g*l^2)/p   0;
     0      0              0           1;
     0 -(m*l*b)/p       m*g*l*(M+m)/p  0];
B = [     0;
     (I+m*l^2)/p;
          0;
        m*l/p];
C = [1 0 0 0;
     0 0 1 0];
D = [0;
     0];

states = {'x' 'x_dot' 'phi' 'phi_dot'};
inputs = {'u'};
outputs = {'x'; 'phi'};

sys_ss = ss(A,B,C,D,'statename',states,'inputname',inputs,'outputname',outputs)


sys_tf2 = tf(sys_ss);

step(sys_tf-sys_ss)

pole(sys_tf)
eig(sys_ss)

return


M = 0.5;
m = 0.2;
b = 0.1;
I = 0.006;
g = 9.8;
l = 0.3;
q = (M+m)*(I+m*l^2)-(m*l)^2;
s = tf('s');

P_cart = (((I+m*l^2)/q)*s^2 - (m*g*l/q))/(s^4 + (b*(I + m*l^2))*s^3/q - ((M + m)*m*g*l)*s^2/q - b*m*g*l*s/q);

P_pend = (m*l*s/q)/(s^3 + (b*(I + m*l^2))*s^2/q - ((M + m)*m*g*l)*s/q - b*m*g*l/q);

sys_tf = [P_cart ; P_pend];

inputs = {'u'};
outputs = {'x'; 'phi'};

set(sys_tf,'InputName',inputs)
set(sys_tf,'OutputName',outputs)

% [num, den] = tfdata(sys_tf)
% 
% sys_ss = tf2ss({num(1,:); num(2,:)}, {den(1,:); den(2,:)});
% 
% SIMO1 = tf({num(1,:); num(2,:)}, den, 'u', u_, 'y', y_); 
states = {'x' 'x_dot' 'phi' 'phi_dot'};
inputs = {'u'};
outputs = {'x'; 'phi'};


syms M m b I g l q

q = -b*(I+m*l^2)/( I*(M+m)+M*m*I^2 );

A = [0      1               0           0;
     0   -b*(I+m*l^2)/q   m^2*g*l^2/q   0;
     0      0               0           1;
     0   -m*l*b/q       m*g*l*(M+m)/q   0];

B = [0; (I+m*l^2)/q;  0;  m*l/q];

C = [1 0 0 0; 
     0 0 1 0];

D = 0;

pretty(A)
pretty(B)
%pretty(C)


M = 0.5;
m = 0.2;
b = 0.1;
I = 0.006;
g = 9.8;
l = 0.3;
%q = (M+m)*(I+m*l^2)-(m*l)^2;
%s = tf('s');



sys_ss = ss( eval(A), eval(B), C, D,...
    'statename',states,'inputname',inputs,'outputname',outputs);

sys_tf
sys_ss

pole(sys_tf)
eig(sys_ss)
return
step(sys_tf)
% After substiting the above approximations into our nonlinear governing
% equations, we arrive at the two linearized equations of motion

% Create plant G.
G = sys_tf(2)
% Create controller C.
%C = tf(1,[1 2]);
% Launch the GUI.
sisotool(G)







