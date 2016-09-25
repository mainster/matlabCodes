% Use MatLab to convert from state space to transfer function (symbolic)
% 
% This script requires the MatLab's symbolic toolbox
% 
% % Start by clearing everything
clear all
clc
% Declare all symbolic variables
% 
syms a3 a2 a1 s b1 b2 b3
% Define state space system
% 
A=[0 1 0; 0 0 1; -a3 -a2 -a1];
B=[0; 0; 1;];
C=[b3 b2 b1];
D=0;
% Find State Transition Matrix transition matrix
% 
Phi=inv(s*eye(3)-A)
%  
% Phi =
%  
% [ (s^2 + a1*s + a2)/(s^3 + a1*s^2 + a2*s + a3),     (a1 + s)/(s^3 + a1*s^2 + a2*s + a3),   1/(s^3 + a1*s^2 + a2*s + a3)]
% [               -a3/(s^3 + a1*s^2 + a2*s + a3), (s*(a1 + s))/(s^3 + a1*s^2 + a2*s + a3),   s/(s^3 + a1*s^2 + a2*s + a3)]
% [           -(a3*s)/(s^3 + a1*s^2 + a2*s + a3), -(a3 + a2*s)/(s^3 + a1*s^2 + a2*s + a3), s^2/(s^3 + a1*s^2 + a2*s + a3)]
%  
% Find transfer function
% 
H=C*Phi*B+D
%  
% H =
%  
% b1/(s^3 + a1*s^2 + a2*s + a3) + (b0*s)/(s^3 + a1*s^2 + a2*s + a3)
%  
% %Display
pretty(simple(H))
%  
%         b1 + b0 s 
%   ---------------------- 
%    3       2 
%   s  + a1 s  + a2 s + a3