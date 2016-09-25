% Experiment (my_text.m) zum Plazieren von Text 
% auﬂerhalb der Darstellung

h = axes('Position',[0 0 1 1],'Visible','off');

axes('Position',[0.35,0.1,0.6,0.8]);

t = 0:999;
plot(t, 0.5*exp(-0.005*t).*sin(2*pi*t/100));
grid;       xlabel('Zeit in s');

str(1) = {'Darstellung der Funktion:'};
str(2) = {'y = A{\ite}^{-\alpha{\itt}}sin(2{\pi{\itt}}/100) '};
str(3) = {'Mit A = 0,5'};    str(4) = {'\alpha = 0,005'};

set(gcf,'currentaxes',h);

text(0.025, 0.6, str, 'FontSize',10,'FontName','Helvetica',...
   'FontAngle','normal');
