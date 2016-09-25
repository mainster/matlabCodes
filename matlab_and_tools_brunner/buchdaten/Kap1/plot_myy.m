function h = plot_myy(x1,y1,x_label1,y_label1,...
   x2,y2,x_label2,y_label2);
% Funktion (plot_myy.m) zur Darstellung zweier Funktionen 
% mit eigenen Achsen (unten und links bzw. oben und rechts)
%
% x1,y1,x_label1,y_label1 = erste Darstellung
% x2,y2,x_label2,y_label2 = zweite Darstellung
%
% Testaufruf: x1 = 0:99;     y1 = 5*exp(-x1/20).*sin(2*pi*(x1)/10);
%             x_label1 = 'Zeit in s';   y_label1 = 'Volt';
%             x2 = 0:199;    y2 = sin(2*pi*(0:199)/20);
%             x_label2 = 'Zeit in ms';   y_label2 = 'mA';
% plot_myy(x1,y1,x_label1,y_label1,x2,y2,x_label2,y_label2);
%


%------ Normale Darstellung
%figure;           % Neues Bild
h = plot(x1,y1,'r');
xlabel(x_label1);     ylabel(y_label1);
ax1 = gca;
set(gca,'XColor','r','YColor','r');

%------ Die zweite Darstellung (gespiegelt)
ax2 = axes('Position',get(ax1,'Position'),...
   'XAxisLocation','top',...
   'YAxisLocation','right',...
   'Color','none',...
   'XColor','k','YColor','k');
hl2 = line(x2,y2,'Color','k','Parent',ax2);

%------ Gemeinsamen Gitter
ntickx = length(get(ax2,'XTick'))-1;
nticky = length(get(ax2,'YTick'))-1;

xlimits = get(ax1,'XLim');
ylimits = get(ax1,'YLim');
xinc = (xlimits(2)-xlimits(1))/ntickx;
yinc = (ylimits(2)-ylimits(1))/nticky;

set(ax1, 'XTick',[xlimits(1):xinc:xlimits(2)],...
   'YTick',[ylimits(1):yinc:ylimits(2)]);

grid on;

%------ Beschriftung der zweiten Darstellung
set(get(ax2,'Xlabel'),'String',x_label2);
set(get(ax2,'Ylabel'),'String',y_label2);
