function varargout = EMW_d(varargin) 
% EMW_D M-file for EMW_d.fig 
%      EMW_D, by itself, creates a new EMW_D or raises the existing 
%      singleton*. 
% 
%      H = EMW_D returns the handle to a new EMW_D or the handle to 
%      the existing singleton*. 
% 
%      EMW_D('CALLBACK',hObject,eventData,handles,...) calls the local 
%      function named CALLBACK in EMW_D.M with the given input arguments. 
% 
%      EMW_D('Property','Value',...) creates a new EMW_D or raises the 
%      existing singleton*.  Starting from the left, property value pairs are 
%      applied to the GUI before EMW_d_OpeningFcn gets called.  An 
%      unrecognized property name or invalid value makes property application 
%      stop.  All inputs are passed to EMW_d_OpeningFcn via varargin. 
% 
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one 
%      instance to run (singleton)". 
% 
% See also: GUIDE, GUIDATA, GUIHANDLES 

% Edit the above text to modify the response to help EMW_d 

% Wellengleichung, elektromagnetische welle 	05-11-2015  @@@MDB
%
% Begin initialization code - DO NOT EDIT 
gui_Singleton = 1; 
gui_State = struct('gui_Name',       mfilename, ... 
                   'gui_Singleton',  gui_Singleton, ... 
                   'gui_OpeningFcn', @EMW_d_OpeningFcn, ... 
                   'gui_OutputFcn',  @EMW_d_OutputFcn, ... 
                   'gui_LayoutFcn',  [] , ... 
                   'gui_Callback',   []); 
if nargin && ischar(varargin{1}) 
    gui_State.gui_Callback = str2func(varargin{1}); 
end 

if nargout 
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:}); 
else 
    gui_mainfcn(gui_State, varargin{:}); 
end 
% End initialization code - DO NOT EDIT 


% --- Executes just before EMW_d is made visible. 
function EMW_d_OpeningFcn(hObject, eventdata, handles, varargin) 
% This function has no output args, see OutputFcn. 
% hObject    handle to figure 
% eventdata  reserved - to be defined in a future version of MATLAB 
% handles    structure with handles and user data (see GUIDATA) 
% varargin   command line arguments to EMW_d (see VARARGIN) 

% Choose default command line output for EMW_d 
handles.output = hObject; 

% Update handles structure 
guidata(hObject, handles); 

% UIWAIT makes EMW_d wait for user response (see UIRESUME) 
% uiwait(handles.figure1); 


% --- Outputs from this function are returned to the command line. 
function varargout = EMW_d_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT); 
% hObject    handle to figure 
% eventdata  reserved - to be defined in a future version of MATLAB 
% handles    structure with handles and user data (see GUIDATA) 

% Get default command line output from handles structure 
varargout{1} = handles.output; 


% --- Executes on button press in pushbutton1. 
function pushbutton1_Callback(hObject, eventdata, handles) 
% hObject    handle to pushbutton1 (see GCBO) 
% eventdata  reserved - to be defined in a future version of MATLAB 
% handles    structure with handles and user data (see GUIDATA) 
x = -400:400; 
t = 0:10000; 
lambda =100; 

T = 50; 
w = 2*pi/T; 
k = 2*pi/lambda; 
c = lambda/T; 
phi0 = 180; 

for l = 1:length(t) 
 %   E(1:400) = sin(w*t(l) + k*x(1:400) + phi0); 
 %   E(401:801) = sin(w*t(l) - k*x(401:801) + phi0); 
 %   E = sin(w*t(l) - sign((1:801)-400.5).*k.*x + phi0); %Welle von Mitte 
    E1(1:801) = sin(w*t(l) - k*x(1:801) + phi0); %Welle nach rechts 
    E2(1:801) = sin(w*t(l) + k*x(1:801) + phi0); %Welle nach links 
    E3 = E1+ E2; 

%    plot(x,E3, 'b'); 
    plot(x, E1, 'g', x, E2, 'r',x,E3, 'b'); 
    
%    grid on 
    xlim([-400 400]) % Bereich für x Achse 
    set(gca, 'xtick', min(xlim):100:max(xlim)); % Bestimme die Einteilung der x Achse   
    ylim([-2.4 2.4]) % Bereich für y Achse     
    set(gca, 'ytick', min(xlim):0.5:max(xlim)); % Bestimme die Einteilung der y Achse 
%    xlabel('this goes across') 
%    ylabel('this goes up') 

    pause(0.1); 
end 

% --- Executes on button press in pushbutton2. 
function pushbutton2_Callback(hObject, eventdata, handles) 
% hObject    handle to pushbutton2 (see GCBO) 
% eventdata  reserved - to be defined in a future version of MATLAB 
% handles    structure with handles and user data (see GUIDATA) 
pause; 

% --- Executes on button press in pushbutton3. 
function pushbutton3_Callback(hObject, eventdata, handles) 
% hObject    handle to pushbutton3 (see GCBO) 
% eventdata  reserved - to be defined in a future version of MATLAB 
% handles    structure with handles and user data (see GUIDATA) 
exit; 


% --- Executes on slider movement. 
function slider1_Callback(hObject, eventdata, handles) 
% hObject    handle to slider1 (see GCBO) 
% eventdata  reserved - to be defined in a future version of MATLAB 
% handles    structure with handles and user data (see GUIDATA) 

% Hints: get(hObject,'Value') returns position of slider 
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider 


% --- Executes during object creation, after setting all properties. 
function slider1_CreateFcn(hObject, eventdata, handles) 
% hObject    handle to slider1 (see GCBO) 
% eventdata  reserved - to be defined in a future version of MATLAB 
% handles    empty - handles not created until after all CreateFcns called 

% Hint: slider controls usually have a light gray background. 
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor')) 
    set(hObject,'BackgroundColor',[.9 .9 .9]); 
end 