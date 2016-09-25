figure('Position',[560 528 350 250]);
% Make a text uicontrol to wrap in Units of Pixels
% Create it in Units of Pixels, 100 wide, 10 high
pos = [10 100 100 10];   
ht = uicontrol('Style','Text','Position',pos);
string = {'This is a string for the left text uicontrol.',...
          'to be wrapped in Units of Pixels,',...
          'with a position determined by TEXTWRAP.'};
% Wrap string, also returning a new position for ht
[outstring,newpos] = textwrap(ht,string) 



%f = figure;
%h
i = uicontrol('Position',[20 20 200 40],'String','Continue',...
              'Callback','uiresume(gcbf)');
disp('This will print immediately');
uiwait(gcf); 
disp('This will print after you click Continue');
%close(f);


set(ht,'String',outstring,'Position',newpos)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% How do I force my GUI to give focus to a specific UICONTROL?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This feature has been added in MATLAB 7.0 (R14) which has the UICONTROL function that can give focus to a uicontrol object. The following code can serve as an example of this:

% create some uicontrols
u(1) = uicontrol('Style','edit');
u(2) = uicontrol('Style','pushbutton','Position',[20 60 60 20]);
% set focus to the edit text box
uicontrol(u(1))
%If you are using UIWAIT or WAITFOR, you need to ensure that the figure has focus before setting the UICONTROL:

%set(gcf,'Visible','on');
%drawnow;
%uicontrol(u(1))