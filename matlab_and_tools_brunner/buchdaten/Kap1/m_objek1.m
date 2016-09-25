% Beispiel (m_objek1.m) zur Erzeugung von graphischen
% Objekten

%--------- 3D-Funktion
[x,y] = meshgrid([-2:0.4:2]);
Z = x.*exp(-x.^2 -y.^2);

%--------- Erzeugung eines neuen Bildes 
fh = figure('Position',[350,275,400,300],'Color',[0.8, 0.8, 0.8]);

pause;
%--------- Axes-Kind
ah = axes('Color',[0.6, 0.6, 0.6],'XTick',[-2,-1,0,1,2],...
   'YTick',[-2,-1,0,1,2]);

pause;
%--------- Surface-Kind
sh = surface('XData',x,'YData',y,'ZData',Z,...       
   'FaceColor', get(ah,'Color')+.1,...
   'EdgeColor','k','Marker','o',...
   'MarkerFaceColor',[0.5 1 0.85]);

pause;
%--------- Ausrichtung der Betrachtung
view([-50, 30]);