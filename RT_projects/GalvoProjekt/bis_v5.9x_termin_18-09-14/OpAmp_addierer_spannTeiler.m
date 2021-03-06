% Auslegung einer Addierer- Schaltung mit unterschiedlichen @@@MDB
% Spannungsteilern in den Additionspfaden...
% R10 ist ersatzwiderstand aus den beiden massewiderständen der
% spannungsteiler
%         ____
% Ue1 ---|_R4_|--+---(OpAmp In+)
%                |
%         ____   |
% Ue2 ---|_R9_|--+
%                |
%               ---
%               | | R10
%               | |
%               ---
%                |
%               _|_
%
%
% ________________________________________________________________________
%
% Bsp.: 
%   Vref = 2.5V 
%   Voff = 0...3V (z.B. DAC) mit dieser Spannung soll Vref zwischen 
%   Vref = 2.3V ... 2.7V eingestellt werden.
%       --> dVoff = 0.4V
%       --> VrefMin = 2.3V
%
%     (R3 || R10 || R9)
%   ---------------------- * Vref = VrefMin   -->   0.92 * Vref@2.5V = 2.3V
%   (R3 || R10 || R9) + R4
%
%
%     (R10 || R3 || R4)
%   ---------------------- * Voff = dVoff     -->   2/15 * Voff@3V = 0.4V
%   (R10 || R3 || R4) + R9
%
% ________________________________________________________________________
%
clear all;
par=@(x,y) (x.*y)./(x+y);
par3=@(x,y,z) (x.^(-1)+y.^(-1)+z.^(-1)).^(-1);
syms R1 R2 R3 R4 R5 Vpos Vbias;
% Vpos=5;
% Vbias = 1.25;
% R3=10;
% R4=10;
% R5=10;
% 
% Vplus=par(R4,R5)/(par(R4,R5)+R3)*Vbias + par(R3,R5)/(par(R3,R5)+R4)*Vpos

eq=par(R2, R3)/(par(R2, R3)+R4)*Vbias + par(R4,R3)/(par(R4,R3)+R2)*Vpos;
EQ=subs(eq,{'Vbias','Vpos','R4'},{1.25,10,10})

S=solve(EQ==2.5/3, par(R2,R3)==R4)
% V+ != 2.5V @ Vpos=+10V
% V+ != 0V @ Vpos=-10V

R4=2.2
eval(S.R2)
eval(S.R3)

return

clear all;
par=@(x,y) (x.*y)./(x+y);
par3=@(x,y,z) (x.^(-1)+y.^(-1)+z.^(-1)).^(-1);
syms R4 R9 R10 Uref Uoff Udac;

R9=10e3;

vrefFac=par(R10, R9)/(par(R10, R9)+R4); % == 21/25
voffFac=par(R4, R10)/(par(R4, R10)+R9); % == 2/15

%pretty(vrefFac);
%pretty(voffFac);

S=solve(vrefFac==0.5*(0.92), voffFac==0.5*(2/15));
sn=fieldnames(S);

ind=find(cellfun(@isnumeric, {R4,R9,R10}));
switch ind
    case 1 
        str=sprintf('R4 = %i:',R4);
    case 2 
        str=sprintf('R9 = %i:',R9);
    case 3
        str=sprintf('R10 = %i:',R10);
end


for k=1:length(sn)
    str=[str sprintf(':%s = %.0f',sn{k},eval(S.(sn{k})))];
end

strsplit(str,':')

sol=solve(vrefFac==21/25);



return