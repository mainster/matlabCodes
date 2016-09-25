%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Thermal management 
% CREE
% Thermal Management of Cree ®  XLamp ®  LEDs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T_j:      junction temp
% T_sp:     solderpoint temp 
% T_pcb:    pcb temp
% T_tim:    Thermal interface material temp (Wärmeleitpaste)
% T_hs:     Heat sink temp
% T_a:      Ambient temp
% N:        N LEDs per PCB
% P:        thermal power dissipation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

syms T_j T_sp T_pcb T_tim T_hs T_a n P

T_a = 25;
n = 2;
P = 1;                  % 1W verlustleistung
If = 0.35;
P_in = If*(2.6+3.9+3.7)  % If=350mA, Vf_rd=2.6V, Vf_gn=3.9V, Vf_bl=3.7V
P = P_in*0.60;          % 60% Verlustleistung ( Seite 6)
R_j_sp = 3.5;           % CREE XLamp XM-L: 3.5°C/W
R_hs_a = 10;
R_tim_hs = 2;           % thermischer widerstand thermalInterfaceMaterial - hs
R_sp_pcb = 2;

A=(5e-3)^2;
k=2.5;
l=1.6e-3;
%------------------------
R_pcb_tim = l/(k*A);    % Thermischer widerstand der PCB 
                        % FR-4: k = 3 W/(m*K) [wiki]
                        % FR-4: k = 2 W/(m*K) [cree]  
                        % --> k = 2.5 W/(m*K)
                        % A: Flächennormale zur Wärmequelle
                        % l: Layer height, eg 1.6mm

T_hs = solve(R_hs_a == (T_hs-T_a)/P, T_hs);
T_tim = solve(R_tim_hs == (T_tim-T_hs)/P, T_tim);
T_pcb = solve(R_pcb_tim == (T_pcb-T_tim)/P, T_pcb);
T_sp = solve(R_sp_pcb == (T_sp-T_pcb)/(P*n), T_sp);
T_j = solve(R_j_sp == (T_j-T_sp)/(P*n), T_j);

fprintf('\n%s\nP_in \t=\t%.2gW\n', ds, P_in)
fprintf('P \t\t=\t%.2gW\n', P)
fprintf('If \t\t=\t%.2gA\n', If)
fprintf('A \t\t=\t%.2gmm^2 (fläche PCB auf hs)\n', A*1e6)
fprintf('T_a \t=\t%3.f°C\n', T_a)
fprintf('T_hs \t=\t%3.f°C\n', eval(T_hs))
fprintf('T_tim \t=\t%3.f°C\n', eval(T_tim))
fprintf('T_pcb \t=\t%3.f°C\n', eval(T_pcb))
fprintf('T_sp \t=\t%3.f°C\n', eval(T_sp))
fprintf('T_j \t=\t%3.f°C\n', eval(T_j))




