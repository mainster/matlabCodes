%% V_tune Bereich:
Aref=2.5;
REFA=[1.25 2.048 2.5 3 3.3];
%REFA=2.5
R409=27e3; R413=3910; R417=1220;
tune=[0:0.05:1];

Vtune=REFA*tune;
syms x reals;

inP= @(x) (Aref/R413+x./R409).*par3(R409, R413, R417);

plot(Vtune, inP(Vtune))
ylim([0.5,0.7])

return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%	transducer_dimensionierung		%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% levelconv_transducer_digital_offset_v1.5.asc

par3 = @(x,y,z)(x^(-1)+y^(-1)+z^(-1))^(-1);

if 0
	%syms Vinp		% voltage on noninverting input 
	syms R1 R3		% input Resisors for Vinm Vinp
	syms Vbias		% reference generator Vbias=Aref/2 
	syms Vdac		% bias manipulation DAC signal 
	syms R10		% inp->gnd
	syms Ra1 Ra2	% Feedback devider 


	Vinp =@(Vbias, Vdac, R1, R3, R10) (Vbias/R1+Vdac/R3) * par3(R1, R3, R10);
	eVinp =@(Vbias) Vinp(1.25, Vdac,10e3, 10e3, 500e3);

	Vdiff_out =@(Ra2, Ra1, Vdac) Ra2/Ra1 * eVinp(Vdac);
	eVdiff_out =@(Vdac) Vdiff_out(1.1, 1, Vdac);

	Vpwr_ctrl =@(Rb2, Rb1, Vdac) Rb2/Rb1 * (eVdiff_out(Vdac) - Vbias);
	eVpwr_ctrl =@(Vdac) Vpwr_ctrl(24e3, 12e3, Vdac);

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	f1=figure(1); clf;
	ezplot(eVinp(Vdac),[0,3]); hold all; 
	ezplot(eVdiff_out(Vdac),[0,3]); 
	ezplot(eVpwr_ctrl(Vdac),[0,3]); 
	hold off
	l1=legend('Vin_p','Vdiff','Vpwr_ctrl');
	set(l1,'Interpreter','none');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%	Dimensionierung LTC6360		%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear Vpos Va Vinm Rf Rg Rb Rf_by_g 
syms Vpos Va Vinm Rf Rg Rb Rf_by_g

Rf_by_g = @(Vpos, Va) solve(Vpos==(Vpos-Vinm)*(1+Rf_by_g)+Va, Rf_by_g);

% Vorgabe:	PosDemod 
%			Vpos=+10V --> Va=4V 
%			Vpos=-10V --> Va=0 

Vinm = eval( solve(Rf_by_g(10, 4)==Rf_by_g(-10, 0), Vinm) )
RfgFact = symfun( eval(Rf_by_g(Vpos,Va)), [Vpos, Va] )

RfgFact(10,4)

%%
clear Vpos Va Vinm Rf Rg Rb Rf_by_g Vref 
syms Vpos Va Vinm Rf Rg Rb Rf_by_g Vref 
Vamin=0; Vamax=3;
dVpos=20;

% Vref = Vinm;

gain = Rf/Rg;
Vpos = @(Va, Vref, Rf, Rg) (Va-Vref)*(1/gain-1)+Va

S=solve(Vpos(3, Vref, Rf, Rf*gain)==10, Rf)







