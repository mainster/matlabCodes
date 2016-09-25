function GalvoMatlab_cortex_Link()
% GalvoMatlab_cortex_Link  Link handling to cortex_m4 serial interface.
%
%   See also SUM, PLUS.
global s;
evalin('base','global s');

    uicontrol('Style', 'pushbutton', 'String', 'OpenPort',...
            'Position', [20 20 70 30],...
            'Callback', {@clf});  
    uicontrol('Style', 'pushbutton', 'String', 'OpenPort',...
            'Position', [120 120 70 30],...
            'Callback', {@MdbOpenPortSub});  
    
    s = MdbOpenPort();
    
    MdbSerialGets(s)
end
%%
function [varargout] = MdbDeleteAllPorts() 
    delete(instrfind);
    if (nargout > 0)
        varargout{1}=1;
    end
end
%% 

function MdbSerialGets (obj)
    while (1)
        if obj.BytesAvailable
            str = fscanf(obj);
            disp(str)
        end
        
    end
end

function [openPortHandle] = MdbOpenPort()
% [openPortHandle] = MdbOpenPort  Open a serial port.
%   MdbOpenPort() Error, senseless function call.
%   [openPortHandle] = MdbOpenPort returns a opened port object.
%
%   See also SUM, PLUS.

%% Read serial port objects from memory to MATLAB workspace
% out = instrfind
% out = instrfind('PropertyName',PropertyValue,...)
% out = instrfind(S)
% out = instrfind(obj,'PropertyName',PropertyValue,...)
%%

global obj;
evalin('base','global obj')
    spz=instrfind

    if ~isempty(spz)
        delete(spz);
        clear spz;
    end
%%
    availableDevices = ls('/dev/ttyUSB*') ;
    USBports = strsplit(availableDevices, ' ');
    
    USBport = USBports{1}
    obj=serial(USBport);

    obj.BaudRate=115200
    % Termination character for data sequences
    obj.Terminator='LF';
    % The byte order is important for interpreting binary data
    obj.ByteOrder='bigEndian';
    
    disp(obj.Status)

%%
    % The serial port object must be opened for communication
    try 
        if strcmp(obj.Status,'closed'), fopen(obj); end
        printf('opened');
    catch err
        if strcmp(obj.Status,'closed'), fopen(obj); end
    end
    
    if ~nargout
        warning('Too much Output, serial port object destroyed\n!')
    else
        disp(obj.Status)
        openPortHandle = obj;
    end
    
end
    
function MdbOpenPortSub()
    disp('Sub!!!\n');
end

% %%
% global in
% fd=fopen('/media/storage/kabelBW_longtimeSpeedtest/analysed'); 
% in=textscan(fd,'%f %s %s %s'); 
% fclose(fd); 
% f1=figure(1); clf; 
% ax=axes; 
% br=bar(in{1})
% %%
% startDate = datenum(in{3}(1));
% endDate = datenum(in{3}(end));
% xData = linspace(startDate,endDate,10);
% set(ax,'XTick',xData)
% 
% datetick(ax,'x','mm/dd','keepticks')
% 
% %%
% function GalvoMatlab_cortex_Link ()
% 
% MDBopenPort();
% 
% uicontrol('Style', 'pushbutton', 'String', 'OpenPort',...
%         'Position', [20 20 70 30],...
%         'Callback', @MDBopenPort);  
%     %%
% 
% % uicontrol('Style', 'slider',...
% %         'Min',1,'Max',50,'Value',41,...
% %         'Position', [400 20 120 20],...
% %         'Callback', {@surfzlim,hax});   
% % Uses cell array function handle callback
% % Implemented as a local function with an argument
% 
% uicontrol('Style','text',...
%         'Position',[400 45 120 20],...
%         'String','Vertical Exaggeration')
% return 
% 