% Auslegung einer Addierer- Schaltung mit unterschiedlichen @!@MDB
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
%           R10 | |
%               | |
%               ---
%                |
%               _|_
%
% ________________________________________________________________________
%
% Bsp.: 
% levelconv_transducer_endstufe_lochraster.asc
% levelconv_transducer_digital_offset_v1.6.asc  26-02-2015
%
%   Vref = 2.5V (auf Prototyp v1.2/3 kann Vref auf 
%				2.5V oder 2.5V/2 gejumpert werden)
%   Voff = 0...3V (z.B. DAC) mit dieser Spannung soll Vref zwischen 
%   kVref = 2.3V ... 2.7V eingestellt werden.
%       --> VrefMin = 2.3V  -->  VinpMin = 1.15V  
%       --> VrefMax = 2.7V  -->  VinpMax = 1.35V
%
% Maschengleichung für Vinp:
% ----------------------------
% Vinp = (Vref/R4 + Voff/R9) * (R4 || R9 || R10)
% Vref = R2/R1 * Vinp = A01 * Vinp
%
% LGS für VinpMin und VinpMax
% 
%___________________________________________________________
%
clear all;
par=@(x,y) (x.*y)./(x+y);
par3=@(x,y,z) (x.^(-1)+y.^(-1)+z.^(-1)).^(-1);
syms R4 R9 R10 Vpos Vbias Vdac;


%% Levelshifter DACx -> pwrCtrl
%  nochmal am 26-02-2015
% levelconv_transducer_digital_offset_v1.6.asc  26-02-2015
delete(findall(0,'Type','Line'));

Vinp =@(Vdac,Vref,R4,R9,R10) (Vref/R4+Vdac/R9)*par3(R4, R9, R10);

Vref=2.5;		% Set Vref, 2.5V or 1.25V
f1=figure(1);
ezplot(Vinp(Vdac, Vref, 1.45e3, 10e3, 1.4e3), 0,3)
hold all;
Vinp([0 1 3]', Vref, 1.45e3, 10e3, 1.4e3)
%% Aus VdacOffset = 0...3V soll Vout_dig_offset = 2.3V...2.7V folgen
%  
S=solve( Vinp(0, Vref, R4,R9,R10)==1.15,...
		 Vinp(3, Vref, R4,R9,R10)==1.35 )
S=solve( Vinp(0, Vref, R4,R9,R10)==1.15/2,...
		 Vinp(3, Vref, R4,R9,R10)==1.35/2 )	 
R9=20e3;
fprintf('\nSetze R9=%i...\n',R9)
fprintf('R9 = %i\nR4 = %i\nR10 = %i\n',...
	round(R9),round(eval(S.R4)),round(eval(S.R10)))

R4r = round(eval(S.R4)/10)*10;
R10r = round(eval(S.R10)/10)*10;
fprintf('\nAuf 10^1 gerundet...\n')
fprintf('R9 = %i\nR4 = %i\nR10 = %i\n', round(R9),R4r,R10r)

ezplot(Vinp(Vdac, Vref, R4r, R9, R10r), 0,3)
hold off;
legend('Vref(Voff)','Vref(Voff) round')
return 
%%
if 1
	eq=par(R2, R3)/(par(R2, R3)+R4)*Vref + par(R4,R3)/(par(R4,R3)+R2)*Vpos;
	EQ=subs(eq,{'Vref','Vpos','R4'},{1.25,10,10})

	S=solve(EQ==2.5/3, par(R2,R3)==R4)
	% V+ != 2.5V @ Vpos=+10V
	% V+ != 0V @ Vpos=-10V

	R4=10;
	fprintf('R2 = %i\n',round(eval(S.R2)))
	fprintf('R3 = %i\n',round(eval(S.R3)))
	fprintf('R4 = %i\n',R4)

% 	return
end;


clear all;
par=@(x,y) (x.*y)./(x+y);
par3=@(x,y,z) (x.^(-1)+y.^(-1)+z.^(-1)).^(-1);
syms R4 R9 R10 Uref Uoff Udac;

R9=10e3;

vrefFac=par(R10, R9)/(par(R10, R9)+R4) % == 21/25
voffFac=par(R4, R10)/(par(R4, R10)+R9) % == 2/15

%pretty(vrefFac);
%pretty(voffFac);

%S=solve(vrefFac==0.5*(0.92), voffFac==0.5*(2/15));
S=solve(vrefFac==0.5*( 21/25 ), voffFac==0.5*( 2/15 ));
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
% 
% 
% % Auslegung einer Addierer- Schaltung mit unterschiedlichen @!@MDB
% % Spannungsteilern in den Additionspfaden...
% % R10 ist ersatzwiderstand aus den beiden massewiderständen der
% % spannungsteiler
% %         ____
% % Ue1 ---|_R4_|--+---(OpAmp In+)
% %                |
% %         ____   |
% % Ue2 ---|_R9_|--+
% %                |
% %               ---
% %               | | R10
% %               | |
% %               ---
% %                |
% %               _|_
% %
% %
% % ________________________________________________________________________
% %
% % Bsp.: 
% % levelconv_transducer_endstufe_lochraster.asc
% %
% %   Vref = 2.5V 
% %   Voff = 0...3V (z.B. DAC) mit dieser Spannung soll Vref zwischen 
% %   Vref = 2.3V ... 2.7V eingestellt werden.
% %       --> dVoff = 0.4V
% %       --> VrefMin = 2.3V
% %
% %     (R3 || R10 || R9)
% %   ---------------------- * Vref = VrefMin   -->   0.92 * Vref@2.5V = 2.3V
% %   (R3 || R10 || R9) + R4
% %
% %
% %     (R10 || R3 || R4)
% %   ---------------------- * Voff = dVoff     -->   2/15 * Voff@3V = 0.4V
% %   (R10 || R3 || R4) + R9
% %
% % ________________________________________________________________________
% %
% clear all;
% par=@(x,y) (x.*y)./(x+y);
% par3=@(x,y,z) (x.^(-1)+y.^(-1)+z.^(-1)).^(-1);
% syms R1 R2 R3 R4 R5 Vpos Vbias;
% % Vpos=5;
% % Vbias = 1.25;
% % R3=10;
% % R4=10;
% % R5=10;
% % 
% % Vplus=par(R4,R5)/(par(R4,R5)+R3)*Vbias + par(R3,R5)/(par(R3,R5)+R4)*Vpos
% 
% eq=par(R2, R3)/(par(R2, R3)+R4)*Vbias + par(R4,R3)/(par(R4,R3)+R2)*Vpos;
% EQ=subs(eq,{'Vbias','Vpos','R4'},{1.25,10,10})
% 
% S=solve(EQ==2.5/3, par(R2,R3)==R4)
% % V+ != 2.5V @ Vpos=+10V
% % V+ != 0V @ Vpos=-10V
% 
% R4=2.2
% eval(S.R2)
% eval(S.R3)
% 
% return
% 
% clear all;
% par=@(x,y) (x.*y)./(x+y);
% par3=@(x,y,z) (x.^(-1)+y.^(-1)+z.^(-1)).^(-1);
% syms R4 R9 R10 Uref Uoff Udac;
% 
% R9=10e3;
% 
% vrefFac=par(R10, R9)/(par(R10, R9)+R4); % == 21/25
% voffFac=par(R4, R10)/(par(R4, R10)+R9); % == 2/15
% 
% %pretty(vrefFac);
% %pretty(voffFac);
% 
% S=solve(vrefFac==0.5*(0.92), voffFac==0.5*(2/15));
% sn=fieldnames(S);
% 
% ind=find(cellfun(@isnumeric, {R4,R9,R10}));
% switch ind
%     case 1 
%         str=sprintf('R4 = %i:',R4);
%     case 2 
%         str=sprintf('R9 = %i:',R9);
%     case 3
%         str=sprintf('R10 = %i:',R10);
% end
% 
% 
% for k=1:length(sn)
%     str=[str sprintf(':%s = %.0f',sn{k},eval(S.(sn{k})))];
% end
% 
% strsplit(str,':')
% 
% sol=solve(vrefFac==21/25);
% 
% 
% 
% return