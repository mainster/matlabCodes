% Use MatLab to convert from state space to state space (symbolic)
% 
% This script requires the MatLab's symbolic toolbox
% 

clear all
clc

% Declare all symbolic variables
syms k1 k2 b m

% Define state space system
A=[0 1 0; -k2/m -b/m b/m; 0 1 -k1/b];
B=[0; 0; 1/m];
C=[1 0 0];
D=0;

% Define state transformation matrix and find its inverse
T=[1/2 0 1/2; -1 0 1; 0 1 0;];
Tinv=inv(T)

% Find new state space system
% 
% Ahat
Ahat = T*A*Tinv

% Bhat
Bhat = T*B

% Chat
Chat = C*Tinv

% Dhat
Dhat = D


%%%%%%% MIMO TOOLBOX from exchange

A = [1 2 3; -1 -2 -3; 1 0 0 ];
B = [1;2;3];
C = [1 1 1];
D = [0];
g=ss2sym(A,B,C,D);
pretty(g)