% Galvo import
%

delete(findall(0,'type','line'));
% 
% handles = findall(0,'type','figure');
% fig1 = findobj(handles,'type','figure','Name','fig1'); % Find open figure handle
% fig2 = findobj(handles,'type','figure','Name','fig2'); % Find open figure handle
% fig2b = findobj(handles,'type','figure','Name','fig2b'); % Find open figure handle
% figBandpass = findobj(handles,'type','figure','Name','figBandpass'); % Find open figure handle
% figSpec = findobj(handles,'type','figure','Name',''); % Find open figure handle
% 
% if isempty(fig1)
%     fig1=figure('Name','fig1');
% end
% if isempty(fig2)
%     fig2=figure('Name','fig2');
% end
% if isempty(fig2b)
%     fig2b=figure('Name','fig2b');
% end
% if isempty(figBandpass)
%     figBandpass=figure('Name','figBandpass');
% end

rect=@(t) (0.5*sign(t)+0.5);

yGalvo=data([8200:8900]);
x=[1:length(yGalvo)];
jump=[1:ones(length(yGalvo))];

jump(1:186)=-20*rect([1:186]);
jump(187:length(yGalvo))=20*rect([187:length(yGalvo)]);

plot(x,yGalvo)
hold on
plot(x,jump*10,'r');
grid('on');
title('grid minor');
hold off