%f3=figure('Position',[560 528 350 250]);
%clear all;
close all;


scrsz = get(0,'ScreenSize');
scr0=struct('x0',1,'y0',1,'x1',scrsz(3)-1440,'y1',scrsz(4));
scr1=struct('x0',scrsz(3)-1440,'y0',scrsz(4)-900,'x1',scrsz(3),'y1',scrsz(4));

f4=figure('Position',[1950 840 350 170]);
% Make a text uicontrol to wrap in Units of Pixels
% Create it in Units of Pixels, 100 wide, 10 high
pos = [20 170-20-100 300 100];   
ht = uicontrol('Style','Text','Position',pos);

NN=3;
msg={};
for i=1:NN
   msg=[msg, strcat('outTs1.nSamp(',num2str(i),') = ',num2str(outTs1.nSamp(NN)))];
end
% string = {'This is a string for the left text uicontrol.',...
%           'to be wrapped in Units of Pixels,',...
%           'with a position determined by TEXTWRAP.'};

% Wrap string, also returning a new position for ht
%[outstring,newpos] = textwrap(ht,msg) 
set(ht,'String',msg,'Position',pos)

