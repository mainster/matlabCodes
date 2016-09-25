function gaussverteilung_normalen()

height = normrnd(50,2,30,1);             % Simulate heights.
[mu,s,muci,sci] = normfit(height)

%%
hi=normrnd(0,1,[1,100]);
[mu,s,muci,sci] = normfit(hi)

end
% 
% clear lth
% 
% lt=@(STRING,ATX,ATY) [text(ATX,ATY,STRING,'Interpreter','tex','FontSize',20,'FontName','Arial')];
% 
% fo=listfonts;
% 
% figure(1);
% uicontrol('Style', 'pushbutton', 'String', 'Clear',...
%         'Position', [20 20 50 20],...
%         'Callback', 'runc=~runc');        % Pushbutton string callback
%                                    % that calls a MATLAB function
% 
% 
% 
% for k=1:length(fo)
%     h=lt('x^2+e^{\pi i}',0.5, 0.5);
%     set(h,'FontName',fo{k});
%     fn=lt(fo{k},0.1, 0.1);
%     disp(fo{k});
%     set(fn,'FontSize',8);
%     drawnow;
%     delayWait(1);
%     cla;
%     while runc == 0
%     end;
% end
% 
% end
% 
% function pause (hObj,event,ax)
% %     disp(hObj);
% %     disp(event);
% %     disp(ax);
%     runc=evalin('base','runc');
% 
%     evalin('base','runc=~runc;');
%     disp('');
% end
% 
% %Note that s^2 is the MVUE of the variance.s^2
% %%
% % 
% % $$e^{\pi i} + 1 = 0$$
% % 
% %%
% % $x^2+e^{\pi i}$ 
% 
% % $$y = f\(x|\mu,\sig\) $$