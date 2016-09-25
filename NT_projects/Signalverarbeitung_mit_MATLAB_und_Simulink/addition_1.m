% Programm addition_1.m in dem eine Addition 
% in Festkomma-Format mit Skalierung und Verschiebung
% codiet wird (für höchste Geschwindigkeit und 16 Bit)

clear
% -------- Erster Operand
% Vorfeld Berechnungen
nbb = 12;   % signed 12-Bit Worte
Vbmax = 126.89;      Vbmin = -7.675;

Sb = (Vbmax-Vbmin)/(2^nbb);    Bb = (Vbmax+Vbmin)/2;
Ebmax = log2(Sb);              Ebmin = log2(Sb/2);
Fbmin = Sb/(2^round(Ebmax));   Fbmax = Sb/(2^round(Ebmin));
if(Fbmax >= 2)
    Fb = Fbmin;
    Eb = round(Ebmax);
else
    Fb = Fbmax;
    Eb = round(Ebmin);
end;
Sb = Fb*(2^Eb);

% Beliebiger Wert für Vb
Vb = 117.5643;     % Vbmin <= Vb < Vbmax
% Entsprechendes Codewort
Qb = round((Vb-Bb)/Sb);
% Quantisierte Variable
Vqb = Sb*Qb + Bb;

% -------- Zweiter Operand
% Vorfeld Berechnungen
nbc = 16;   % signed
Vcmax = 10.526;      Vcmin = -178.176;

Sc = (Vcmax-Vcmin)/(2^nbc);    Bc = (Vcmax+Vcmin)/2;
Ecmax = log2(Sc);   Ecmin = log2(Sc/2);
Fcmin = Sc/(2^round(Ecmax));   Fcmax = Sc/(2^round(Ecmin));
if(Fcmax >= 2)
    Fc = Fcmin;
    Ec = round(Ecmax);
else
    Fc = Fcmax;
    Ec = round(Ecmin);
end;
Sc = Fc*(2^Ec);

% Beliebiger Wert für Vc
Vc = -69.1715;     % Vcmin <= Vc < Vcmax
% Entsprechendes Codewort
Qc = round((Vc-Bc)/Sc);
% Quantisierte Variable
Vqc = Sc*Qc + Bc;

% -------- Parameter der Addition Vqb+Vqc
% für höchste Geschwindigkeit
Ba = Bb + Bc;
Fa = Fc;          Ea = Ec;

Sa = Fa*(2^Ea);
Qa = round((Fb*Qb/Fa)*(2^(Eb-Ea)) + Qc);
Vqa = Sa*Qa + Ba

%-----------------------------------
Va = Vb + Vc    % Korrekte Summe
Vb
Vqb
Vc
Vqc
Fehler = Va - Vqa
Skalierung = Sa

