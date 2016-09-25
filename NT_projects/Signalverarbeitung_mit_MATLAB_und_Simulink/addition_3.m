% Programm addition_3.m in dem eine Addition 
% in Festkomma-Format codiet wird (F = 1, B = 0, 16-Bit)

clear
% -------- Erster Operand
% Vorfeld Berechnungen
nbb = 12;   % signed
Vbmax = 126.89;      Vbmin = -7.675;
Vbmax_abs = max(abs([Vbmax, Vbmin]));

Sb = 2*Vbmax_abs/(2^nbb);    
Eb = round(log2(Sb));   
Sb = 2^Eb;
% on-line Berechnungen
Vb = 117.5643;     % Vbmin <= Vb < Vbmax
Qb = round(Vb/Sb);

Vqb = Sb*Qb;

% -------- Zweiter Operand
% off-line Berechnungen
nbc = 16;   % signed
Vcmax = 10.526;      Vcmin = -178.176;
Vcmax_abs = max(abs([Vcmax, Vcmin]));

Sc = 2*Vcmax_abs/(2^nbc);   
Ec = round(log2(Sc));   
Sc = 2^Ec;
% on-line Berechnungen
Vc = -69.1715;     % Vcmin <= Vc < Vcmax
Qc = round(Vc/Sc);
Vqc = Sc*Qc;

% -------- Parameter der Addition Vqb+Vqc
% fŸr hšchste Genauigkeit
% Vorfeld Berechnungen
nba = 16;
Vamax = Vbmax + Vcmax;
Vamin = Vbmin + Vcmin;
Vamax_abs = max(abs([Vamax, Vamin]));
Sa = 2*Vamax_abs/(2^nba); 
Ea = floor(log2(Sa));   
Sa = 2^Ea;

% on-line Berechnungen
Qa = round((2^(Eb-Ea))*Qb + (2^(Ec-Ea))*Qc);
Vqa = Sa*Qa

%-----------------------------------
Va = Vb + Vc    % Korrekte Summe
Fehler = Va - Vqa
Skalierung = Sa

