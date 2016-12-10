function disploto(xachse1,data1,spec)

%

% DIPLOTO beruht auf der unten beschriebenen Funktion DISPLOT.

%         Die Funktion zeichnet diskrete Linien mit kleinen

%         Kreisen an den Stellen der Y-Werte.

%         Fuer spec darf nur eine Farbe eingegeben werden.

%         (Abaenderungen: D.von Gruenigen, Mai 1993)

%

% DISPLOT    Plot a vector. DISPLOT(X,Y,'line-type') plots vector X versus

%            vector Y with discret lines. In all uses of DISPLOT, the 

%            imaginary parts of X or Y are ignored.

%            The vectors must have the same lengths.

%            Line-Type has the same specification as in plot

%             

%      Verfasser: Raimund Meyer, LNT

%      letzte Žnderung: 04.02.88

%

sn(1)='o';

if exist('spec')==0

elseif length(spec)==1 sn(2)=spec;

elseif length(spec)==2 sn(2:3)=spec;

else sn(2:4)=spec; end

plot(xachse1,data1,sn);hold on;

dims = size(xachse1);

if dims(1) > dims(2) xachse1 = xachse1'; end; 

xwerte = real(xachse1);

xwerte = [xwerte;xwerte;xwerte];

xwerte = xwerte(:);



dims = size(data1);

if dims(1) > dims(2) data1 = data1';end;



ywerte = [zeros(1,length(xachse1));real(data1);zeros(1,length(xachse1))];

ywerte = ywerte(:);

%keyboard

if exist('spec') == 0

   plot(xwerte,ywerte);

else   

   plot(xwerte,ywerte,spec);

end;

clear xwerte,ywerte;

hold off


