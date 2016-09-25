function GalvoMatlab_cortex_Link


uicontrol('Style', 'pushbutton', 'String', 'OpenPort',...
        'Position', [20 20 70 30],...
        'Callback', @MDBopenPort);  
    %%

uicontrol('Style', 'slider',...
        'Min',1,'Max',50,'Value',41,...
        'Position', [400 20 120 20],...
        'Callback', {@surfzlim,hax});   
% Uses cell array function handle callback
% Implemented as a local function with an argument

uicontrol('Style','text',...
        'Position',[400 45 120 20],...
        'String','Vertical Exaggeration')
return 


function MDBopenPort()
    availableDevices = ls('/dev/ttyUSB*') 

    USBport = availableDevices;
    USBport = '/dev/ttyUSB0';
    obj=serial(USBport);

    obj.BaudRate=115200;
    % Termination character for data sequences
    obj.Terminator='CR';
    % The byte order is important for interpreting binary data
    obj.ByteOrder='bigEndian';

    %
    % The serial port object must be opened for communication
    try 
        if strcmp(obj.Status,'closed'), fopen(obj); end
    catch err
        s = instrfind;
        delete(s);
        if strcmp(obj.Status,'closed'), fopen(obj); end
    end

return



function dummy ()            
%% 1. Identify the serial port

availableDevices = ls('/dev/ttyUSB*') 

USBport = availableDevices;
USBport = '/dev/ttyUSB0';
obj=serial(USBport);

obj.BaudRate=115200;
% Termination character for data sequences
obj.Terminator='CR';
% The byte order is important for interpreting binary data
obj.ByteOrder='bigEndian';

%
% The serial port object must be opened for communication
try 
    if strcmp(obj.Status,'closed'), fopen(obj); end
catch err
    s = instrfind;
    delete(s);
    if strcmp(obj.Status,'closed'), fopen(obj); end
end
%%
% Send a command. The terminator character set above will be appended.
for k=1:25
    str = input('$:','s');
    fprintf(obj, [str '\r\n']);
    flushoutput(obj)
    flushoutput(obj)
end

%%
fclose(obj);
delete(obj);

%%
    zo=instrfind;
    delete(zo)
%%
%% Read serial port objects from memory to MATLAB workspace
% out = instrfind
% out = instrfind('PropertyName',PropertyValue,...)
% out = instrfind(S)
% out = instrfind(obj,'PropertyName',PropertyValue,...)
%%
spz=instrfind
%%
% clear (serial)
% Remove serial port object from MATLAB workspace
% s = serial('COM1');
% scopy = s;
% clear s
% s = instrfind;
% isequal(scopy,s)

s = serial('/dev/ttyUSB1');
scopy = s;
clear s
s = instrfind
isequal(scopy,s)
%%
obj.InputBufferSize=2^18; % in bytes



% The serial port object must be opened for communication
if strcmp(obj.Status,'closed'), fopen(obj); end

response = fscanf(obj)


prompt = {'Enter matrix size:','Enter colormap name:'};
dlg_title = 'Input';
num_lines = 1;
def = {'20','hsv'};


% Send a command. The terminator character set above will be appended.
for k=1:5
    str = input('$:','s');
    fprintf(obj, str);
end    


% Read the response
response = fscanf(obj);

%% 2. Create the serial object
% The serial port object represents the connection to the device. In the
%  MATLB documentation, this variable is typically called "obj". You will
%  read and write data from your USB device through the serial port object.


% You will have to set the serial port settings according to your device
%  requirements. Some common settings are shown here. See the MATLAB
%  Documentation for all possibilities for your device.
%
% The baudrate is the data transmission rate in bytes per second
% Most USB devices can support a baudrate of up to 1.5e6, but some
%  operating systems do not support "nonstandard" baudrates for serial ports.
% "standard" baud rates include:
% 300, 600, 1200, 2400, 4800, 9600, 14400, 19200, 28800, 38400, 57600, 115200, 128000, 230400, 460800, 921600



%% 3. Setup your device
% Your USB device may require some setup through interface commands. To
% send and receive commands, use fprintf(obj) and fscanf(obj).

% obj=s1;

obj.InputBufferSize=2^18; % in bytes



% The serial port object must be opened for communication
if strcmp(obj.Status,'closed'), fopen(obj); end

response = fscanf(obj)


prompt = {'Enter matrix size:','Enter colormap name:'};
dlg_title = 'Input';
num_lines = 1;
def = {'20','hsv'};


% Send a command. The terminator character set above will be appended.
for k=1:5
    fprintf(obj,'!EnableBeam~~~~~~~~~~~~');
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    fprintf(obj,'!DisableBeam~~~~~~~~~~~');
    answer = inputdlg(prompt,dlg_title,num_lines,def);
end    


% Read the response
response = fscanf(obj);


%% 4. Prepare for the data stream
% The data arriving from the USB device will be handled by a serial port
%  function which is called automatically when a certain number of bytes
%  have been received in the
input buffer. Your serial port function will
%  remove the data from the buffer and process it. Adjust the buffer size
%  and the function byte count to suit your application.

% The input buffer must be large enough to accomodate the amount of data
%  that will be received while your program is busy processing previously
%  received chunks of data. Having a buffer that is too large is not a
%  problem for most modern computers.
% The "BytesAvailableFcn" function will be called whenever
%  BytesAvailableFcnCount number of bytes have been received from the USB
%  device.
obj.BytesAvailableFcnMode='byte';
obj.BytesAvailableFcnCount=2^10; % 1 kB of data
% The name of the BytesAvailableFcn function in this example is
%  "getNewData", and it has one additional input argument ("arg1").
obj.BytesAvailableFcn = {@getNewData,arg1};


% Use the serial port object to pass data between your main function
%  and the serial port function ("getNewData").
% You could include things like total number of data points read,
%  timestamps, etc, here as well.
obj.UserData.newData=[];
obj.UserData.isNew=0;


%% 5. Process the incoming data
% In this example, we use a loop to plot the data stream that is sent by
% the USB device.

% A global variable is used to exit the loop
global PLOTLOOP; PLOTLOOP=1;
% Initialize data for plotting. "plotWindow" will be the length of the
%  x-axis in the data plot.
plotData=zeros(plotWindow);
newData=[];
% Create figure for plotting
pfig = figure;
% This allows us to stop the test by pressing a key
set(pfig,'KeyPressFcn', @stopStream); 


% Send commands to the device to start the data stream.
fprintf(obj,'START');


while PLOTLOOP
    
    % wait until we have new data
    if obj.UserData.isNew==1
        
        % get the data from serial port object (data will be row-oriented)    
        newData=mr.UserData.newData';
        
        % indicate that data has been read
        mr.UserData.isNew=0;
        
        % concatenate new data for plotting
        plotData=[plotData(size(newData,1)+1:end,:); newData];
        
        % plot the data
        plot(pfig,plotData);
        
        drawnow;
    end
    
    % The loop will exit when the user presses return, using the
    %  KeyPressFcn of the plot window
    
end

%% 6. Finish & Cleanup
% Add whatever commands are required for closing your device.

% Send commands to the device stop the data transmission
fprintf(obj,'STOP');

% flush the input buffer
ba=get(obj,'BytesAvailable');
if ba > 0, fread(mr,ba); end

% Close the serial port
fclose(obj);
delete(obj);


return



%% Data Processing Function
function getNewData(obj,event,arg1)
% GETNEWDATA processes data that arrives at the serial port.
%  GETNEWDATA is the "BytesAvailableFcn" for the serial port object, so it
%  is called automatically when BytesAvailableFcnCount bytes of data have
%  been received at the serial port.

% Read the data from the port.
% For binary data, use fread. You will have to supply the number of bytes
%  to read and the format for the data. See the MATLAB documentation.
% For ASCII data, you might still use fread with format of 'char', so that
%  you do not have to handle the termination characters.
[Dnew, Dcount, Dmsg]=fread(obj);

% You can do some initial processing of the data here in this function. 
%  However, I recommend keeping  processing here to a minimum and doing
%  most of the work in the main loop for best performance.

% Return the data to the main loop for plotting/processing
if obj.UserData.isNew==0
    % indicate that we have new data
    obj.UserData.isNew=1; 
    obj.UserData.newData=Dnew;
else
    % If the main loop has not had a chance to process the previous batch
    % of data, then append this new data to the previous "new" data
    obj.UserData.newData=[obj.UserData.newData Dnew];
end


return


%% Loop Control Function
function [] = stopStream(src,evnt)
% STOPSTREAM is a local function that stops the main loop by setting the
%  global variable to 0 when the user presses return.
global PLOTLOOP;

if strcmp(evnt.Key,'return')
    PLOTLOOP = 0;
    fprintf(1,'Return key pressed.');
end


return

% % % %