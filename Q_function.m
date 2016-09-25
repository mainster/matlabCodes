% Q-function: y = qfunc(x) is one minus the cumulative
% distribution function of the standardized normal random
% variable
% Q=@(x) 1/sqrt(2*pi)*int(exp(-x^2/2),x,inf)
%% NT Klausur SS13 A ganz unten
clear all;
syms n x t real;

Q=@(x) 1/sqrt(2*pi)*int(exp(-t^2/2),x,inf);
Q2=@(x) 1/(sqrt(2*pi)*2.5)*int(exp(-t^2/5),x,inf);

fn_{1} = @(n) 1/sqrt(2*pi)*exp(-n^2/2)	% Dichtefunktion des Kanalrauschens
fn_{2} = @(n) 1/sqrt(2*pi)*exp(-n^2/5)	% Dichtefunktion des Kanalrauschens

for k=1:2
	s1 = 1								% Sendevektor für Bit "1"
	s2 = -1								% Sendevektor für Bit "0"
	fn=fn_{k};
	
	r1 =@(n) fn(n-s1);						% Empfangsvektor für Bit "1"
	r2 =@(n) fn(n-s2);						% Empfangsvektor für Bit "0"

	figure(k); SUB=210;
	subplot(SUB+1);
	ezplot(r1,[-1,1]*5);	hold all
	ezplot(r2,[-1,1]*5);	hold off
	line([1,1],[0, 0.5],'Color','red','LineStyle','--')
	legend('f_r(r|s1)','f_r(r|s2)','gamma')
	title(['fn(n)=' func2str(fn)],'Interpreter','none')

	subplot(SUB+2);
	tmp=strsplit(func2str(fn),'@(n)');
	fnTerm = sym(tmp{2});
	Fa = int(fnTerm);
	Qs = str2func(['@(n)' '.5-' char(Fa)])
	h1=ezplot(Qs,[-1,1]*5);	hold all
	h2=ezplot(Q(x),[-1,1]*5);	
	hold off
	set(h1,'Color','red','LineWidth',2)
	set(h2,'Color','blue','LineStyle','-.','LineWidth',2)
	legend('Qs=0.5-int(fn(n))','Q(n)')
	% Bestimmen Sie die Fehlerwahrscheinlichkeit der Übertragung,
	% wenn die Entscheidungsschwelle bei gamma=1 liegt und die
	% a-priori-Wahrscheinlickeit für das Bit "1" P("1")=0.1192 ist
	Ps1 = 0.1192;
	Ps2 = 1-Ps1;
	gamma = 1;

	% Entweder umständlich über Gaußverteilte Rauschfunktion
	% integrieren oder über Q-funktion

	if k==1
		Pe = Ps1*qfunc(gamma-1) + Ps2*qfunc(gamma+1)
		Pes = eval( Ps1*Q(gamma-1) + Ps2*Q(gamma+1) )
		
		fprintf(['Was wenn die Dichtefunktion nicht zufällig grade mit der Definition',...
				' der Normalverteilung übereinstimmt?\nWie muss das Argument der',...
				' Q-funktion normiert werden?\n'])
	else
		Pe2 = Ps1*qfunc(5/2*(gamma-1)) + Ps2*qfunc(5/2*(gamma+1))
		Pe2s = eval( Ps1*Q2(gamma-1) + Ps2*Q2(gamma+1) )
	end
end

fprintf(['Keine Ahnung, nochmal testen....\n'])
