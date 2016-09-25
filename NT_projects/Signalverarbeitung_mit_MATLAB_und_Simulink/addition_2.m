% Programm addition_21.m in dem eine Addition 
% in Festkomma-Format mit Skalierung und Verschiebung
% fŸr hšchste Genauigkeit codiert wird (16 Bit).

clear
% -------- Erster Operand
% Vorfeld Berechnungen
nbb = 12;   % signed
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

% on-line Berechnungen
Vb = 117.5643;     % Vbmin <= Vb < Vbmax
Qb = round((Vb-Bb)/Sb);

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

% on-line Berechnungen
Vc = -69.1715;     % Vcmin <= Vc < Vcmax
Qc = round((Vc-Bc)/Sc);

Vqc = Sc*Qc + Bc;

% -------- Parameter der Addition Vqb+Vqc
% fŸr hšchste Genauigkeit
% off-line Berechnungen
nba = 16;
Ba = Bb + Bc;

Vamax = Vbmax + Vcmax;
Vamin = Vbmin + Vcmin;
Sa = (Vamax - Vamin)/(2^nba);

Eamax = log2(Sa);   Eamin = log2(Sa/2);
Famin = Sa/(2^round(Eamax));   Famax = Sa/(2^round(Eamin));
if(Famax >= 2)
    Fa = Famin;
    Ea = round(Eamax);
else
    Fa = Famax;
    Ea = round(Eamin);
end;
Sa = Fa*(2^(Ea));
% on-line Berechnungen
Qa = round((Fb/Fa)*(2^(Eb-Ea))*Qb + (Fc/Fa)*(2^(Ec-Ea))*Qc);

% quantisierte Summe
Vqa = Sa*Qa + Ba

%-----------------------------------
Va = Vb + Vc    % Korrekte Summe
Vb
Vqb
Vc
Vqc
Fehler = Va - Vqa
Skalierung = Sa

