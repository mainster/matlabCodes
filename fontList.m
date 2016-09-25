%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot all available Fonts on a figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('f99','var')==1;
    if ishghandle(f99');
        close(f99)
    end
    clear f99;
end
% 
% global th
% evalin('base','global th');
f99=figure('Name','myName','NumberTitle','off',...
    'units','normalized','outerposition',[0 0 1 1]);
clf

%% 
fontListv=listfonts;

text(0.25,0.25,'test');
delete(findall(f99,'type','text'));
childH=get(f99,'Children')
set(childH,'Visible','Off');
%%
xp=0;
yp=1;
for i=1:length(fontListv)
    yp=yp-1/30;
    th(i)=text(xp,yp,char(fontListv(i)));
    set(th(i),'FontSize',14,'FontName',char(fontListv(i)))
    if yp<=0
        yp=1;
        xp=xp+1/5;
    end
    
    if ~mod(i,10)
       if ~strcmpi(questdlg('Weiter?'),'yes')
          return;
       end
    end
end

