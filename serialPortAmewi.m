%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% C:\Users\mainster\Documents\Atmel_Studio\6.2\
% Amewi_heli_irTx_mega32_resurecti_06-01-2015\Amewi_heli_irTx_mega32_
% resurecti_06-01-2015\main.c
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function serialPortAmewi ()

if(0)
    %%
%---------------------------%
% Bei Lockproblemen hilft:  %
%---------------------------%
    instrfind               %
    clear s*
    newobjs = instrfind     %
    fclose(newobjs)         %
%---------------------------%
%%
availableDevices = {ls('/dev/ttyUSB*'), ls('/dev/rfcomm*')} % Linux

if ~exist('obj','file')
    obj = serial( '/dev/ttyUSB1');
    obj.BaudRate = 38400
end
%%
if strcmp(obj.Status,'closed'), fopen(obj); end

flushinput(obj)
rx={};





%%
fprintf(obj,'u 33');
delayWait(2.5);
rx{1}=fscanf(obj)
%%
fprintf(obj,'f 66');
delayWait(2.5);
rx{2}=fscanf(obj)
%%
fprintf(obj,'l 999');
delayWait(0.5);
rx{3}=fscanf(obj)
%%


fprintf(obj,'L:33:66:999:');
%%
fscanf(obj,'%s',100)
%%
fscanf(obj,'%s',100)
fscanf(obj,'%s',100)

%%


fprintf(obj,'L');

%%
fprintf(obj,'u 33');
%delayWait(2.5);
%fscanf(obj,'%s',100)

fprintf(obj,'f 66');
%delayWait(2.5);
%fscanf(obj,'%s',100)

fprintf(obj,'l 999');
%delayWait(2.5);
%fscanf(obj,'%s',100)




%%
fprintf(obj,'u 33 f 66 l 999');
rx{4}=fscanf(obj)
%%






%%
fclose(obj)

rx{:}
end
%%
f1 = figure(1); clf
hax = gca;

sl(1)=uicontrol('Style', 'slider',...
                'TooltipString','Left <--> Right',...
                'Min',1,'Max',50,'Value',25,...
                'Position', [250 100 450 25],...
                'Callback', {@surfcall, hax});   
sl(2)=uicontrol('Style', 'slider',...
                'TooltipString','Front <--> Rearw',...
                'Min',1,'Max',50,'Value',25,...
                'Position', [450 150 25 400],...
                'Callback', {@surfzlim, hax});   
% Uses cell array function handle callback
% Implemented as a local function with an argument
%%

uicontrol('Style', 'pushbutton', 'String', 'Clear',...
        'Position', [20 20 50 20],...
        'Callback', 'cla');        % Pushbutton string callback
                                   % that calls a MATLAB function
%%
end

function surfcall (hObj,event,ax)
    disp 'hallo'
end
                                   
function surfzlim(hObj,event,ax) %#ok<INUSL>
    % Called to set zlim of surface in figure axes
    % when user moves the slider control
    val = 51 - get(hObj,'Value');
    zlim(ax,[-val val]);
end


