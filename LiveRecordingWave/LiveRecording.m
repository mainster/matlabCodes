function LiveRecording
%Syntax: LiveRecording
% Run LiveRecording by typing "LiveRecording" in your command line
%
% Marcus Vollmer
% alpha 13.06.2014

% Initialize and hide the GUI as it is being constructed.
aud = audiodevinfo;
if isempty(ver('Signal'))
	errordlg('Signal Processing Toolbox required','!! Error !!')
elseif isempty(aud.input)
    errordlg('No input device found for audio recording. After plugged in you have to restart Matlab.' ,'!! Error !!')
else

f=figure('Visible','off','Position',[0,0,900,600],'Units','normalized','Toolbar','figure');%,'PaperSize',[20,13]

hp1 = uipanel('Title','Length of record','FontSize',14,'BackgroundColor','white','Units','normalized','Position',[0.1 0.5 .6 .2],'FontUnits','normalized','visible','on');
hp2 = uipanel('Title','Display length','FontSize',14,'BackgroundColor','white','Units','normalized','Position',[0.1 0.25 .6 .2],'FontUnits','normalized','visible','on');
hp3 = uipanel('Title','Frequency window','FontSize',14,'BackgroundColor','white','Units','normalized','Position',[0.1 0.1 .25 .1],'FontUnits','normalized','visible','on');


% Construct the components.
%Text
htext=uicontrol('Parent',hp3,'Style','text','String','-','FontSize',10,'Units','normalized','Position',[.4,.1,.1,.6],'FontUnits','normalized','HorizontalAlignment','center');
htextHz=uicontrol('Parent',hp3,'Style','text','String','Hz','FontSize',10,'Units','normalized','Position',[.9,.1,.1,.6],'FontUnits','normalized','HorizontalAlignment','center');

%Button
hbuttonStart = uicontrol('String','Start recording','FontSize',14,'Units','normalized','Position',[.75,.25,.2,.2],'FontUnits','normalized','Callback', @buttonStart_Callback);
hbuttonStartAgain = uicontrol('String','new record','FontSize',10,'Units','normalized','Position',[.85,.01,.125,.05],'FontUnits','normalized','visible','off','Callback', @buttonStartAgain_Callback);
hbuttonSave = uicontrol('String','save','FontSize',10,'Units','normalized','Position',[.65,.01,.1,.05],'FontUnits','normalized','visible','off','Callback', @buttonSave_Callback);
hbuttonSaveAs = uicontrol('String','save as','FontSize',10,'Units','normalized','Position',[.75,.01,.1,.05],'FontUnits','normalized','visible','off','Callback', @buttonSaveAs_Callback);
hbuttonPlay = uicontrol('String','play','FontSize',10,'Units','normalized','Position',[.05,.01,.1,.05],'FontUnits','normalized','visible','off','Callback', @buttonPlay_Callback);
hbuttonPlayAll = uicontrol('String','play all','FontSize',10,'Units','normalized','Position',[.15,.01,.1,.05],'FontUnits','normalized','visible','off','Callback', @buttonPlayAll_Callback);
hbuttonShowFigures = uicontrol('String','open figures','FontSize',10,'Units','normalized','Position',[.3,.01,.125,.05],'FontUnits','normalized','visible','off','Callback', @buttonShowFigures_Callback);


%Slider
hsliderRecordLength = uicontrol('Parent',hp1,'Style','slider','Min',1,'Max',30,'SliderStep',[1 1]./29,'Value',10,'Units','normalized','Position',[.1 .5 .8 .3],'FontUnits','normalized','Callback',@sliderRecordLength_Callback);  
hsliderShowLength = uicontrol('Parent',hp2,'Style','slider','Min',1,'Max',30,'SliderStep',[1 1]./29,'Value',5,'Units','normalized','Position',[.1 .5 .8 .3],'FontUnits','normalized','Callback',@sliderShowLength_Callback);  

%Edit fields
heditRecordLength=uicontrol('Parent',hp1,'Style','edit','String',10,'Units','normalized','Position',[.5 .2 .4 .3],'FontUnits','normalized','Callback',@editRecordLength_Callback);  
heditShowLength=uicontrol('Parent',hp2,'Style','edit','String',5,'Units','normalized','Position',[.5 .2 .4 .3],'FontUnits','normalized','Callback',@editShowLength_Callback);  
heditFrequencyWindow1=uicontrol('Parent',hp3,'Style','edit','String',0,'Units','normalized','Position',[.1 .1 .3 .8],'FontUnits','normalized','Callback',@editFrequencyWindow1_Callback);  
heditFrequencyWindow2=uicontrol('Parent',hp3,'Style','edit','String',3000,'Units','normalized','Position',[.5 .1 .4 .8],'FontUnits','normalized','Callback',@editFrequencyWindow2_Callback);  


ha1=axes('Units','Pixels','Position',[100,300,750,250],'Units','normalized','FontUnits','normalized','Layer','top','visible','off'); 
ha2=axes('Units','Pixels','Position',[100,50,750,200],'Units','normalized','FontUnits','normalized','Layer','top','visible','off'); 


% Global variables
global RecordLength ShowLength FrequencyWindow1 FrequencyWindow2 myRecording fs mag;

%Initialisation
RecordLength = str2double(get(heditRecordLength,'String'));
ShowLength = str2double(get(heditShowLength,'String'));
FrequencyWindow1 = str2double(get(heditFrequencyWindow1,'String'));
FrequencyWindow2 = str2double(get(heditFrequencyWindow2,'String'));

% Initialize the GUI.
set(f,'Name','Audio recording and live visualisation')  % Assign the GUI a name to appear in the window title.
movegui(f,'center')     % Move the GUI to the center of the screen.
set(f,'Visible','on');	% Make the GUI visible.

end

%% BUTTONS
% Push button callbacks. Each callback plots current_data in the
% specified plot type.
function buttonStart_Callback(~,~)

    RecordLength = str2double(get(heditRecordLength,'String'));
    ShowLength = str2double(get(heditShowLength,'String'));
    FrequencyWindow1 = str2double(get(heditFrequencyWindow1,'String'));
    FrequencyWindow2 = str2double(get(heditFrequencyWindow2,'String'));
    
    set(hp1,'visible','off');    
    set(hp2,'visible','off');
    set(hp3,'visible','off');
    
    set(ha1,'visible','on');    
    set(ha2,'visible','on');

    set(hbuttonStart,'visible','off') 
    set(hbuttonPlay,'visible','off') 
    set(hbuttonPlayAll,'visible','off') 
    set(hbuttonShowFigures,'visible','off') 
    set(hbuttonSave,'visible','off') 
    set(hbuttonSaveAs,'visible','off')   
    
    set(hbuttonStartAgain,'visible','on')

    liverecording
end

function buttonStartAgain_Callback(~,~)

    set(ha1,'visible','off');    
    set(ha2,'visible','off');
    cla(ha1)
    cla(ha2)

    set(hp1,'visible','on');    
    set(hp2,'visible','on');
    set(hp3,'visible','on');
    

    set(hbuttonStart,'visible','on') 
    
    set(hbuttonPlay,'visible','off') 
    set(hbuttonPlayAll,'visible','off') 
    set(hbuttonShowFigures,'visible','off') 
    set(hbuttonSave,'visible','off') 
    set(hbuttonSaveAs,'visible','off')    
    set(hbuttonStartAgain,'visible','off')

end

function buttonSave_Callback(~,~)   
    [y,m,d,h,min,sec]=datevec(now);
    audiowrite([num2str(y,'%04.0f') num2str(m,'%02.0f') num2str(d,'%02.0f') '-' num2str(h,'%02.0f') ''''  num2str(min,'%02.0f') '''''' num2str(floor(sec),'%02.0f') '.wav'],myRecording,fs);
end

function buttonSaveAs_Callback(~,~) 
    [y,m,d,h,min,sec]=datevec(now);    
    [file,path] = uiputfile([num2str(y,'%04.0f') num2str(m,'%02.0f') num2str(d,'%02.0f') '-' num2str(h,'%02.0f') ''''  num2str(min,'%02.0f') '''''' num2str(floor(sec),'%02.0f') '.wav'],'Save record');
    audiowrite([path file],myRecording,fs);
end

function buttonPlay_Callback(~,~)   
    xx = round(get(ha1,'Xlim')*fs);
    sound(myRecording(max(1,xx(1)):min(xx(2),size(myRecording,1))), fs);   
end

function buttonPlayAll_Callback(~,~)   
    sound(myRecording, fs);
end

function buttonShowFigures_Callback(~,~)   
    figure    
    plot((1:size(myRecording,1))./fs,myRecording)
    ylim([-1.2 1.2]*mag)
    xlim([0 max(size(myRecording,1)/fs,ShowLength)])

    figure
    spectrogram(myRecording,2^9,2^7,2^12,fs)
    xlim([FrequencyWindow1 FrequencyWindow2])
    view(-90,90) 
    set(gca,'ydir','reverse')       
    set(gca, 'YTick', []);    
    ylim([0 max(size(myRecording,1)/fs,ShowLength)])
end

%% EDITFIELDS
function editRecordLength_Callback(~,~)
      RecordLength = str2double(get(heditRecordLength,'String'));
      set(hsliderRecordLength,'value',RecordLength);
end

function editShowLength_Callback(~,~)
      ShowLength = str2double(get(heditShowLength,'String'));
      set(hsliderShowLength,'value',ShowLength);
end

function editFrequencyWindow1_Callback(~,~)
      FrequencyWindow1 = str2double(get(heditFrequencyWindow1,'String'));
end
function editFrequencyWindow2_Callback(~,~)
      FrequencyWindow2 = str2double(get(heditFrequencyWindow2,'String'));
end

%% SLIDER
function sliderRecordLength_Callback(~,~)
      RecordLength = round(get(hsliderRecordLength,'value'));
      set(heditRecordLength,'string',num2str(RecordLength));
end

function sliderShowLength_Callback(~,~)
      ShowLength = round(get(hsliderShowLength,'value'));
      set(heditShowLength,'string',num2str(ShowLength));
end


%% GENERAL FUNCTIONS
function liverecording
    
    fs = 44100;
    nBits = 16;
    mag = 1.05;

    plot(ha1,0,0);
    ylim(ha1,[-mag mag])
    xlim(ha1,[0 RecordLength])
    xlabel(ha1,'Time [s]')
    idx_last = 1;

    recObj = audiorecorder(fs,nBits,1);
    
    record(recObj,RecordLength);
    tic
    while toc<.1
    end
    tic
    bit = 2;
    while toc<RecordLength
        myRecording = getaudiodata(recObj);
        idx = round(toc*fs);
        while idx-idx_last<.1*fs
            idx = round(toc*fs);
        end

        plot(ha1,(max(1,size(myRecording,1)-fs*ShowLength):(2^bit):size(myRecording,1))./fs,myRecording(max(1,size(myRecording,1)-fs*ShowLength):(2^bit):end))
        mag = max(abs(myRecording));
        ylim(ha1,[-1.2 1.2]*mag)
        xlim(ha1,[max(0,size(myRecording,1)/fs-ShowLength) max(size(myRecording,1)/fs,ShowLength)])
        
    spectrogram(myRecording(max(1,size(myRecording,1)-fs*ShowLength):(2^bit):end),2^9/(2^bit),2^7/(2^bit),2^12/(2^bit),fs/(2^bit))
    xlim(ha2,[FrequencyWindow1 FrequencyWindow2])
    ylim(ha2,[0 ShowLength])
    view(ha2,-90,90) 
    set(gca,'ydir','reverse')       
    set(gca, 'YTick', []);
    
        drawnow
        idx_last = idx;
        
    end

    endrecording
end


function endrecording
    set(hbuttonPlay,'visible','on')
    set(hbuttonPlayAll,'visible','on') 
    set(hbuttonShowFigures,'visible','on') 
    set(hbuttonSave,'visible','on')
    set(hbuttonSaveAs,'visible','on')
    
end


end